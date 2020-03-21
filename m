Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC0718DDAE
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 03:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgCUCpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 22:45:24 -0400
Received: from mail-eopbgr70043.outbound.protection.outlook.com ([40.107.7.43]:1601
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbgCUCpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 22:45:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TaZMzMs7A3w3QWfrjLOQAj9MhMRUJgComXP+rms7sQXaOsOllZU3SjgwLEA6Q9opiW7wRk0WihnKzOJ/67QCtWuz4YXl421Y6F7OcejONLAxhXzfjqqLfvIXjaBs/ILy/Bia8FwEjmLr5JXw4hZZPZivAhZ4u+MGUhxQH36rnl5txdPdaZ8usJZ4AGJNaJi4gwQSSxadGyvqiLwLGuj8isZPh9IozFVBnbGKkv+HVk6RuSFoj8gh6G83iC8dnAfXmO5JiqfRm5ifbF1oUbwT6AwIAGpnxo70PnqJNPf6YryyNC1Hkpg80XPY8+mXqZ+hsmZZWfCILQINPXSm0rHOTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unTvlYuJMF+lnM+f0sBZXUboQHrQBzQ8vrxzBzCIaYs=;
 b=YiVgfyC9HefRmY6ehjVUVRNgbnjDTW2owg8Zw4guSVxCb5tZgu2eFizpNciAGH9LlZ77pu4gJvynUKkB3WlvEZRm7ittnrXm6VlEALlZReVzR7BV/oDTAQlapeMN6V6eLss4v5InZjut13sE/LR/VdtUBcDp4llS4zEi7brGqTV34HBc79wk9idrLeskyWWunCcVIzh0bOHpYIruv+1/K3rZSwjLRNnlB93pta8wo/77wQEOyEt7bA723uFm/mzks7y6jwB2saA55HMEaSReX7t5yAUvMoAyBk7f2PYnM3z5uRdJrtAcKw9GFFabYb5p+5LI2euZsXNAvQviOEaaiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unTvlYuJMF+lnM+f0sBZXUboQHrQBzQ8vrxzBzCIaYs=;
 b=Gpl6TH6r9WdzgV2otBeVznqfBhNo6LHjCb1syPcTNqdhgxQdA/pr3N1smCILC2A6okZBGEjrbLn1GOjuvyHAZ05tN6cKs3R/v0Ov/DW6WPzxfEYHLaXBC+MisM+Xdkm9P7gEQRtjIIYoUNQbF0O1gakkCNpFmvB/zZd1RVyyplk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6575.eurprd05.prod.outlook.com (20.179.27.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Sat, 21 Mar 2020 02:45:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.017; Sat, 21 Mar 2020
 02:45:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        Paul Blakey <paulb@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
Thread-Topic: [PATCH net-next v2 2/2] net/mlx5e: add
 mlx5e_rep_indr_setup_ft_cb support
Thread-Index: AQHV/QgwgOrElAyCe0CAEVpM3hrZJqhSW3AA
Date:   Sat, 21 Mar 2020 02:45:18 +0000
Message-ID: <0a74354f83b864501d708200f7d78085cca19fff.camel@mellanox.com>
References: <1584523959-6587-1-git-send-email-wenxu@ucloud.cn>
         <1584523959-6587-3-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1584523959-6587-3-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 44d9d726-8908-4621-4e2b-08d7cd41e4c1
x-ms-traffictypediagnostic: VI1PR05MB6575:|VI1PR05MB6575:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB65758CFEAA0DEFFBBA7BF35ABEF20@VI1PR05MB6575.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 034902F5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(199004)(6486002)(66946007)(71200400001)(316002)(6636002)(81166006)(26005)(478600001)(86362001)(76116006)(91956017)(81156014)(6512007)(8676002)(36756003)(8936002)(66556008)(2616005)(66446008)(110136005)(64756008)(66476007)(4326008)(5660300002)(6506007)(2906002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6575;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FhbsoAgEKhn+eZgkmcqWbHGV61kdsw4QVO3+2q7RsA3D4seN3V2p+rvBFMSZlra1EQq31OBqi2ByHrF0nfxXHDRJafKkkO62DBczxBRhKSg2rY4u1YYRe7m3v8+zM3elzVB1RT9Vhhbl0ESOIoUi1mSHXKkvFlcvZkzkpQjjY4KS8WZSnCH1hw2gdhPrwTo2SjacHGOMIWV9tNnwZ/r7NoD6qj452/BRwouNSWzB1+cQa0b6Eix3Iduwx9iBG7tDqd41PIo9RhHN15PRcyHG5Iqv/Dv++bwCyW59GuT4l0KPTjC9KgCsiI5TsiiW0UScYVAJQXXN+E/ky78n2h0ElTI7q6ztGbpPrwInPX9UKmKEbhb5PYjdZmrasSSogMFeynNP7vUpS4tOfSZffFt3zpTU0sDYHB4qRAVREr1fndTD+fH7YNBSrzUm89mGcoi/
x-ms-exchange-antispam-messagedata: giQtfs0h4dFNyQyWLql60S+uAG/kUPzWN4D+DCEAwF0ja+iGUyU1hxmGHIqn6D2o/ECxSfe/cFeOZn+++fUs/W1NvpVAWH0aFNGWwdH8Yt8rOAV0xNjPPOp/M/AlL6JV3oTCfgRErH+xZKAudZEG6g==
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EDEE9F224E58A42AB67BC68A4E3A687@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d9d726-8908-4621-4e2b-08d7cd41e4c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2020 02:45:18.9207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 84TkBfBqwSVsA/O9e07dSNA26EHjLIZUh4PqhW+iH2ldwv2uapnw+akh2vO/lUqIwfHhPw3S7sDwAlZc3xbF1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6575
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAzLTE4IGF0IDE3OjMyICswODAwLCB3ZW54dUB1Y2xvdWQuY24gd3JvdGU6
DQo+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+IA0KPiBBZGQgbWx4NWVfcmVwX2lu
ZHJfc2V0dXBfZnRfY2IgdG8gc3VwcG9ydCBpbmRyIGJsb2NrIHNldHVwDQo+IGluIEZUIG1vZGUu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiB3ZW54dSA8d2VueHVAdWNsb3VkLmNuPg0KPiAtLS0NCj4g
djI6IHJlYmFzZSB0byBtYXN0ZXINCj4gDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fcmVwLmMgfCA0OQ0KPiArKysrKysrKysrKysrKysrKysrKysrKysNCj4g
IDEgZmlsZSBjaGFuZ2VkLCA0OSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jDQo+IGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jDQo+IGluZGV4IDA1N2Y1
ZjkuLmE4OGM3MGIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl9yZXAuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4gQEAgLTczMiw2ICs3MzIsNTIgQEAgc3RhdGljIGludCBt
bHg1ZV9yZXBfaW5kcl9zZXR1cF90Y19jYihlbnVtDQo+IHRjX3NldHVwX3R5cGUgdHlwZSwNCj4g
IAl9DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBpbnQgbWx4NWVfcmVwX2luZHJfc2V0dXBfZnRfY2Io
ZW51bSB0Y19zZXR1cF90eXBlIHR5cGUsDQo+ICsJCQkJICAgICAgdm9pZCAqdHlwZV9kYXRhLCB2
b2lkICppbmRyX3ByaXYpDQo+ICt7DQo+ICsJc3RydWN0IG1seDVlX3JlcF9pbmRyX2Jsb2NrX3By
aXYgKnByaXYgPSBpbmRyX3ByaXY7DQo+ICsJc3RydWN0IG1seDVlX3ByaXYgKm1wcml2ID0gbmV0
ZGV2X3ByaXYocHJpdi0+cnByaXYtPm5ldGRldik7DQoNCkhpIFdlbnh1LA0KDQpsZXQncyBmaXgg
cmV2ZXJzZSB4bWFzIHRyZWUgc3R5bGUgaGVyZSwgd2hpbGUgdmxhZCBpcyBsb29raW5nIGF0IHRo
aXMuDQoNCj4gKwlzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3cgPSBtcHJpdi0+bWRldi0+cHJpdi5l
c3dpdGNoOw0KPiArCXN0cnVjdCBmbG93X2Nsc19vZmZsb2FkICpmID0gdHlwZV9kYXRhOw0KPiAr
CXN0cnVjdCBmbG93X2Nsc19vZmZsb2FkIHRtcDsNCj4gKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0K
PiArCWludCBlcnI7DQo+ICsNCj4gKwlmbGFncyA9IE1MWDVfVENfRkxBRyhFR1JFU1MpIHwNCj4g
KwkJTUxYNV9UQ19GTEFHKEVTV19PRkZMT0FEKSB8DQo+ICsJCU1MWDVfVENfRkxBRyhGVF9PRkZM
T0FEKTsNCj4gKw0KPiArCXN3aXRjaCAodHlwZSkgew0KPiArCWNhc2UgVENfU0VUVVBfQ0xTRkxP
V0VSOg0KPiArCQltZW1jcHkoJnRtcCwgZiwgc2l6ZW9mKCpmKSk7DQo+ICsNCj4gKwkJaWYgKCFt
bHg1X2Vzd19jaGFpbnNfcHJpb3Nfc3VwcG9ydGVkKGVzdykpDQo+ICsJCQlyZXR1cm4gLUVPUE5P
VFNVUFA7DQo+ICsNCj4gKwkJLyogUmUtdXNlIHRjIG9mZmxvYWQgcGF0aCBieSBtb3ZpbmcgdGhl
IGZ0IGZsb3cgdG8gdGhlDQo+ICsJCSAqIHJlc2VydmVkIGZ0IGNoYWluLg0KPiArCQkgKg0KPiAr
CQkgKiBGVCBvZmZsb2FkIGNhbiB1c2UgcHJpbyByYW5nZSBbMCwgSU5UX01BWF0sIHNvIHdlDQo+
IG5vcm1hbGl6ZQ0KPiArCQkgKiBpdCB0byByYW5nZSBbMSwgbWx4NV9lc3dfY2hhaW5zX2dldF9w
cmlvX3JhbmdlKGVzdyldDQo+ICsJCSAqIGFzIHdpdGggdGMsIHdoZXJlIHByaW8gMCBpc24ndCBz
dXBwb3J0ZWQuDQo+ICsJCSAqDQo+ICsJCSAqIFdlIG9ubHkgc3VwcG9ydCBjaGFpbiAwIG9mIEZU
IG9mZmxvYWQuDQo+ICsJCSAqLw0KPiArCQlpZiAodG1wLmNvbW1vbi5wcmlvID49DQo+IG1seDVf
ZXN3X2NoYWluc19nZXRfcHJpb19yYW5nZShlc3cpKQ0KPiArCQkJcmV0dXJuIC1FT1BOT1RTVVBQ
Ow0KPiArCQlpZiAodG1wLmNvbW1vbi5jaGFpbl9pbmRleCAhPSAwKQ0KPiArCQkJcmV0dXJuIC1F
T1BOT1RTVVBQOw0KPiArDQo+ICsJCXRtcC5jb21tb24uY2hhaW5faW5kZXggPQ0KPiBtbHg1X2Vz
d19jaGFpbnNfZ2V0X2Z0X2NoYWluKGVzdyk7DQo+ICsJCXRtcC5jb21tb24ucHJpbysrOw0KPiAr
CQllcnIgPSBtbHg1ZV9yZXBfaW5kcl9vZmZsb2FkKHByaXYtPm5ldGRldiwgJnRtcCwgcHJpdiwN
Cj4gZmxhZ3MpOw0KPiArCQltZW1jcHkoJmYtPnN0YXRzLCAmdG1wLnN0YXRzLCBzaXplb2YoZi0+
c3RhdHMpKTsNCj4gKwkJcmV0dXJuIGVycjsNCj4gKwlkZWZhdWx0Og0KPiArCQlyZXR1cm4gLUVP
UE5PVFNVUFA7DQo+ICsJfQ0KPiArfQ0KPiArDQo+ICBzdGF0aWMgdm9pZCBtbHg1ZV9yZXBfaW5k
cl9ibG9ja191bmJpbmQodm9pZCAqY2JfcHJpdikNCj4gIHsNCj4gIAlzdHJ1Y3QgbWx4NWVfcmVw
X2luZHJfYmxvY2tfcHJpdiAqaW5kcl9wcml2ID0gY2JfcHJpdjsNCj4gQEAgLTgwOSw2ICs4NTUs
OSBAQCBpbnQgbWx4NWVfcmVwX2luZHJfc2V0dXBfY2Ioc3RydWN0IG5ldF9kZXZpY2UNCj4gKm5l
dGRldiwgdm9pZCAqY2JfcHJpdiwNCj4gIAljYXNlIFRDX1NFVFVQX0JMT0NLOg0KPiAgCQlyZXR1
cm4gbWx4NWVfcmVwX2luZHJfc2V0dXBfYmxvY2sobmV0ZGV2LCBjYl9wcml2LA0KPiB0eXBlX2Rh
dGEsDQo+ICAJCQkJCQkgIG1seDVlX3JlcF9pbmRyX3NldHVwXw0KPiB0Y19jYik7DQo+ICsJY2Fz
ZSBUQ19TRVRVUF9GVDoNCj4gKwkJcmV0dXJuIG1seDVlX3JlcF9pbmRyX3NldHVwX2Jsb2NrKG5l
dGRldiwgY2JfcHJpdiwNCj4gdHlwZV9kYXRhLA0KPiArCQkJCQkJICBtbHg1ZV9yZXBfaW5kcl9z
ZXR1cF8NCj4gZnRfY2IpOw0KPiAgCWRlZmF1bHQ6DQo+ICAJCXJldHVybiAtRU9QTk9UU1VQUDsN
Cj4gIAl9DQo=
