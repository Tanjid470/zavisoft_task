part of 'user_model.dart';


UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] == null ? 0 : (json['id'] as num).toInt(),
  username: (json['username'] as String?) ?? '',
  email: (json['email'] as String?) ?? '',
  firstName: (json['firstName'] as String?) ?? '',
  lastName: (json['lastName'] as String?) ?? '',
  phone: (json['phone'] as String?) ?? '',
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phone': instance.phone,
};
