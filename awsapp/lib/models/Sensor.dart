/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs

import 'ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Sensor type in your schema. */
@immutable
class Sensor extends Model {
  static const classType = const _SensorModelType();
  final String id;
  final String? _title;
  final SensorStatus? _status;
  final int? _rating;
  final String? _content;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String get title {
    try {
      return _title!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  SensorStatus get status {
    try {
      return _status!;
    } catch(e) {
      throw new DataStoreException(DataStoreExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage, recoverySuggestion: DataStoreExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion, underlyingException: e.toString());
    }
  }
  
  int? get rating {
    return _rating;
  }
  
  String? get content {
    return _content;
  }
  
  const Sensor._internal({required this.id, required title, required status, rating, content}): _title = title, _status = status, _rating = rating, _content = content;
  
  factory Sensor({String? id, required String title, required SensorStatus status, int? rating, String? content}) {
    return Sensor._internal(
      id: id == null ? UUID.getUUID() : id,
      title: title,
      status: status,
      rating: rating,
      content: content);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Sensor &&
      id == other.id &&
      _title == other._title &&
      _status == other._status &&
      _rating == other._rating &&
      _content == other._content;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Sensor {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("status=" + (_status != null ? enumToString(_status)! : "null") + ", ");
    buffer.write("rating=" + (_rating != null ? _rating!.toString() : "null") + ", ");
    buffer.write("content=" + "$_content");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Sensor copyWith({String? id, String? title, SensorStatus? status, int? rating, String? content}) {
    return Sensor(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      content: content ?? this.content);
  }
  
  Sensor.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _status = enumFromString<SensorStatus>(json['status'], SensorStatus.values),
      _rating = json['rating'],
      _content = json['content'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'status': enumToString(_status), 'rating': _rating, 'content': _content
  };

  static final QueryField ID = QueryField(fieldName: "sensor.id");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField STATUS = QueryField(fieldName: "status");
  static final QueryField RATING = QueryField(fieldName: "rating");
  static final QueryField CONTENT = QueryField(fieldName: "content");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Sensor";
    modelSchemaDefinition.pluralName = "Sensors";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sensor.TITLE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sensor.STATUS,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sensor.RATING,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Sensor.CONTENT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _SensorModelType extends ModelType<Sensor> {
  const _SensorModelType();
  
  @override
  Sensor fromJson(Map<String, dynamic> jsonData) {
    return Sensor.fromJson(jsonData);
  }
}