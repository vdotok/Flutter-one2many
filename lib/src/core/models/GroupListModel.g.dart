// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupListModel _$GroupListModelFromJson(Map<String, dynamic> json) =>
    GroupListModel(
      groups: (json['groups'] as List<dynamic>)
          .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupListModelToJson(GroupListModel instance) =>
    <String, dynamic>{
      'groups': instance.groups,
    };
