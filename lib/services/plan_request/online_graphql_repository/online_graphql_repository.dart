import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:trufi_core/blocs/payload_data_plan/payload_data_plan_cubit.dart';
import 'package:trufi_core/entities/ad_entity/ad_entity.dart';
import 'package:trufi_core/entities/plan_entity/plan_entity.dart';
import 'package:trufi_core/models/enums/enums_plan/enums_plan.dart';
import 'package:trufi_core/services/models_otp/enums/mode.dart';
import 'package:trufi_core/services/models_otp/plan.dart';

import '../../../models/trufi_place.dart';
import '../request_manager.dart';
import 'graphql_plan_repository.dart';
import 'modes_transport.dart';

class OnlineGraphQLRepository implements RequestManager {
  final String graphQLEndPoint;
  final GraphQLPlanRepository _graphQLPlanRepository;

  OnlineGraphQLRepository({
    @required this.graphQLEndPoint,
  }) : _graphQLPlanRepository = GraphQLPlanRepository(graphQLEndPoint);

  @override
  Future<PlanEntity> fetchAdvancedPlan({
    @required TrufiLocation from,
    @required TrufiLocation to,
    @required String correlationId,
    PayloadDataPlanState advancedOptions,
  }) async {
    if (advancedOptions == null) {
      return _fetchPlan(from, to, [TransportMode.transit, TransportMode.walk]);
    } else {
      return _fetchPlanAdvanced(
        from: from,
        to: to,
        advancedOptions: advancedOptions,
      );
    }
  }

  @override
  Future<ModesTransportEntity> fetchTransportModePlan({
    TrufiLocation from,
    TrufiLocation to,
    String correlationId,
    PayloadDataPlanState advancedOptions,
  }) {
    return _fetchTransportModePlan(
      from: from,
      to: to,
      advancedOptions: advancedOptions,
    );
  }

  @override
  Future<PlanEntity> fetchCarPlan(
    TrufiLocation from,
    TrufiLocation to,
    String correlationId,
  ) {
    return _fetchPlan(from, to, [TransportMode.car, TransportMode.walk]);
  }

  @override
  Future<AdEntity> fetchAd(TrufiLocation to, String correlationId) {
    // TODO: implement fetchAd
    throw UnimplementedError();
  }

  Future<PlanEntity> _fetchPlan(
    TrufiLocation from,
    TrufiLocation to,
    List<TransportMode> transportModes,
  ) async {
    final planEntityData = await _graphQLPlanRepository.fetchPlanSimple(
      fromLocation: from,
      toLocation: to,
      transportsMode: transportModes,
    );
    return planEntityData.toPlan();
  }

  Future<PlanEntity> _fetchPlanAdvanced({
    @required TrufiLocation from,
    @required TrufiLocation to,
    @required PayloadDataPlanState advancedOptions,
  }) async {
    Plan planData = await _graphQLPlanRepository.fetchPlanAdvanced(
      fromLocation: from,
      toLocation: to,
      advancedOptions: advancedOptions,
    );
    planData = planData.copyWith(
      itineraries: planData.itineraries
          .where(
            (itinerary) =>
                !itinerary.legs.every((leg) => leg.mode == Mode.walk),
          )
          .toList(),
    );
    if (planData.itineraries.isEmpty) {
      planData = await _graphQLPlanRepository.fetchPlanAdvanced(
        fromLocation: from,
        toLocation: to,
        advancedOptions: advancedOptions,
        defaultFecth: true,
      );
    }
    final planEntity = planData.toPlan();
    final itinerariesTrasnport = planEntity.itineraries
        .where(
          (itinerary) => !itinerary.legs
              .every((leg) => leg.transportMode == TransportMode.walk),
        )
        .toList();

    return planEntity.copyWith(
      itineraries: itinerariesTrasnport,
      error: itinerariesTrasnport.isEmpty
          ? PlanError(404, "Not found routes")
          : null,
    );
  }

  Future<ModesTransportEntity> _fetchTransportModePlan({
    @required TrufiLocation from,
    @required TrufiLocation to,
    @required PayloadDataPlanState advancedOptions,
  }) async {
    final ModesTransport planEntityData =
        await _graphQLPlanRepository.fetchWalkBikePlanQuery(
      fromLocation: from,
      toLocation: to,
      advancedOptions: advancedOptions,
    );
    return planEntityData.toModesTransport();
  }
}
