Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35EBD115830
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 21:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfLFU27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 15:28:59 -0500
Received: from mail-eopbgr10089.outbound.protection.outlook.com ([40.107.1.89]:8190
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726332AbfLFU27 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 15:28:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZJAvazrPy4t3IcnAXHLvtUZYBaeFcd+6xdTIdmjJB6MU//j5Paj0s9Kq+as0ZyqhKKtScZuRpZI4Qrenc0GHkx1d3TqXVBW6dtg6/JjuzVWQHwkSUNviveRAE1C5JJnbZ8VybOi6LWYqdAwd4wFNzztyESYic9W5qx6U+1KMm0RiA6mcZInQYKGjKZcIqxewNzTvuDOYGu0skIq3v5x9j76iG7djd1aRV1afH6wckHtmy/C3I8sr1Awqb723eaP/2bspmGp+6Rus2kFEcVVDFjhK9MBOr1TIdcyjdQ+kvDKDzGe1vBax7JqjDA/qWutucaMysL8wQ32j9TMDTHk2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCunSC8UNT+PTvNGbFKwskV/iXiKGaO18jhgkrsKWu0=;
 b=LPMavgNiJTzs/+mfEjeUChQtNEeOaQpnMLzl3KS4noL9ax614ZPlmbBpjlxtZCq9ViwEVTCxQMXXjot0QvDjiYU6GN3WIeb/kpDKuXrsiGMRnAjq2CLgQ3AOcO+4VUP5luXEPy3e6r+2TIYCIeEV/jUr0X4FBRGu2YyG4axR1UcxIOnH/cRuEuD3PSdhPDMJjTj4YcRO98idSnXueA2CSiClHLZXEzEuwpD57aaL48H/MQWn4RmH8oIl+bej2PjNw/+3NmtZDZNHvzoZJIpCziOJhVpjfgj6lOiYUJAMs0ndJPPySmZ5cL91N8+KRkFV75ELXa+72j0SueOmxHyXig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCunSC8UNT+PTvNGbFKwskV/iXiKGaO18jhgkrsKWu0=;
 b=rh89ieB5B505hBTL4hVsU4ZW9pyJupb6vBpMs4ZF59loTDUtu/9EZ0tf58CTaZl0gXwvx7l29TixKN/gq9Cm7PJMy6yuSe5bAPl/ZprruXFIeICqlIcKi7n6grbqfSdoyFW1h09Q6DsdPzhVJnLNMhdD60fnr6hkU3J31oeDv+o=
Received: from VI1PR05MB3342.eurprd05.prod.outlook.com (10.170.238.143) by
 VI1PR05MB4863.eurprd05.prod.outlook.com (20.177.48.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Fri, 6 Dec 2019 20:28:10 +0000
Received: from VI1PR05MB3342.eurprd05.prod.outlook.com
 ([fe80::40d4:350c:cce1:6224]) by VI1PR05MB3342.eurprd05.prod.outlook.com
 ([fe80::40d4:350c:cce1:6224%5]) with mapi id 15.20.2516.017; Fri, 6 Dec 2019
 20:28:10 +0000
From:   Mark Bloch <markb@mellanox.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Saeed Mahameed <saeedm@dev.mellanox.co.il>
CC:     Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: mlx5 support tc accept action
Thread-Topic: mlx5 support tc accept action
Thread-Index: AQHVqzcQ8CXkvWMO3kyn/TgzzK1xkqesD/4AgACtZICAANN9AA==
Date:   Fri, 6 Dec 2019 20:28:10 +0000
Message-ID: <0d2335a2-5472-c3ea-d4a7-eb99bbb0116d@mellanox.com>
References: <CAMDZJNXcya=6VsXitukS5MmZ36oPCUVNMncBJKrWmzwK62LeUg@mail.gmail.com>
 <CALzJLG-z18R+uPi2W3Wam7GKkxzayJDfyDyTmO+_W7Z1V0CaQg@mail.gmail.com>
 <CAMDZJNU0TD+ckuf9XnoRAq3mKjLARYbq8CCgCUM4BfRY33pEmw@mail.gmail.com>
In-Reply-To: <CAMDZJNU0TD+ckuf9XnoRAq3mKjLARYbq8CCgCUM4BfRY33pEmw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR21CA0010.namprd21.prod.outlook.com
 (2603:10b6:a03:114::20) To VI1PR05MB3342.eurprd05.prod.outlook.com
 (2603:10a6:802:1d::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=markb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [104.156.100.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cb22a28a-08b3-4686-0eb0-08d77a8acf8a
x-ms-traffictypediagnostic: VI1PR05MB4863:|VI1PR05MB4863:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4863C2F7775B338F1C77667CD25F0@VI1PR05MB4863.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0243E5FD68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(189003)(199004)(6506007)(6512007)(2906002)(53546011)(229853002)(305945005)(31686004)(36756003)(81156014)(8676002)(2616005)(81166006)(110136005)(54906003)(478600001)(8936002)(4326008)(66556008)(66446008)(71200400001)(99286004)(316002)(66476007)(102836004)(5660300002)(66946007)(26005)(86362001)(64756008)(52116002)(186003)(6486002)(31696002)(76176011)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4863;H:VI1PR05MB3342.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m3H/gSPYpKysAtzjMK4jC65dNM+AqpFA3cBcfylO6aDCpRbyovPxFFPrwiDkDT2S0IWMLeanKN73NNJw/JHX8ENvuDjt0XUiLJE1I+46uX/cB9iytXarMyUKxUFCasqzHn+orSFdY8ahiIP2DJmhvVkHIuDdXvKE6VTfcS9eqkQxTYcQP+xWhKHO6iNrRs4qh2w0b9XaDW40qJsDbs2kocq8gOJnK+g62D9d7eXwnQP0E2GKR25Vpx9m2RaNGF7jvztZl1gwka91VWiCq1Z3KIlsbaZFzXyCL9z5ud0So6omXcatcQwAQd2bzw9pZlXXDIOhj2n7fobBYGPtcriB4AhV/lFQ13uWxEdqMaXORPHcRbb33Apho6Nrub3W4OcUFF2hU9W02Ga3/wGOyUwjvjk+HClz0nEImMlITpuVRU+m5n5+6G/qpEeYwoqY4ZGv
Content-Type: text/plain; charset="utf-8"
Content-ID: <599728D69F754F4EA5D5BA75E1C56A62@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb22a28a-08b3-4686-0eb0-08d77a8acf8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2019 20:28:10.5229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ik7AVpvgMacI8m60ThLAw/fh6xxP6eTYsPSA8HcmfkvQTmZEdoneV/IMKdh48AY9nzVkvr2oz+rBr8eMU5eN1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4863
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzUvMjAxOSAyMzo1MSwgVG9uZ2hhbyBaaGFuZyB3cm90ZToNCj4gT24gRnJpLCBE
ZWMgNiwgMjAxOSBhdCA1OjMwIEFNIFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AZGV2Lm1lbGxhbm94
LmNvLmlsPiB3cm90ZToNCj4+DQo+PiBPbiBXZWQsIERlYyA0LCAyMDE5IGF0IDEwOjQxIFBNIFRv
bmdoYW8gWmhhbmcgPHhpYW5neGlhLm0ueXVlQGdtYWlsLmNvbT4gd3JvdGU6DQo+Pj4NCj4+PiBI
aSBSb2ksIFNhZWVkDQo+Pj4gSW4gb25lIGNhdXNlLCB3ZSB3YW50IHRoZSAiYWNjZXB0IiBhY3Rp
b246IHRoZSBJUCBvZiBWRiB3aWxsIGJlDQo+Pj4gImFjY2VwdCIsIGFuZCBvdGhlcnMNCj4+PiBw
YWNrZXRzIHdpbGwgYmUgZG9uZSB3aXRoIG90aGVyIGFjdGlvbnMoZS5nLiBoYWlycGluIHJ1bGUg
dG8gb3RoZXIgVkYpLg0KPj4+DQo+Pj4gRm9yIGV4YW1wbGU6DQo+Pj4NCj4+PiBQRjA9ZW5wMTMw
czBmMA0KPj4+IFZGMF9SRVA9ZW5wMTMwczBmMF8wDQo+Pj4gVkYwPXA0cDFfMA0KPj4+IFZGMT1w
NHAyXzAgIyBiZWxvbmcgdG8gUEYxDQo+Pj4gVkYwX0lQPTMuMy4zLjIwMA0KPj4+DQo+Pj4gZXRo
dG9vbCAtSyAkUEYwIGh3LXRjLW9mZmxvYWQgb24NCj4+PiBldGh0b29sIC1LICRWRjAgaHctdGMt
b2ZmbG9hZCBvbg0KPj4+IHRjIHFkaXNjIGFkZCBkZXYgJFBGMCBpbmdyZXNzDQo+Pj4gdGMgcWRp
c2MgYWRkIGRldiAkVkYwIGluZ3Jlc3MNCj4+PiB0YyBmaWx0ZXIgYWRkIGRldiAkUEYwIHByb3Rv
Y29sIGFsbCBwYXJlbnQgZmZmZjogcHJpbyAxMCBoYW5kbGUgMQ0KPj4+IGZsb3dlciBza2lwX3N3
IGFjdGlvbiBtaXJyZWQgZWdyZXNzIHJlZGlyZWN0IGRldiAkVkYwX1JFUA0KPj4+IHRjIGZpbHRl
ciBhZGQgZGV2ICRWRjAgcHJvdG9jb2wgaXAgcGFyZW50IGZmZmY6IHByaW8gMSBoYW5kbGUgMyBm
bG93ZXINCj4+PiBza2lwX3N3IGRzdF9pcCAkVkYwX0lQIGFjdGlvbiBwYXNzDQo+Pj4gdGMgZmls
dGVyIGFkZCBkZXYgJFZGMCBwcm90b2NvbCBhbGwgcGFyZW50IGZmZmY6IHByaW8gMTAgaGFuZGxl
IDINCj4+PiBmbG93ZXIgc2tpcF9zdyBhY3Rpb24gbWlycmVkIGVncmVzcyByZWRpcmVjdCBkZXYg
JFZGMQ0KPj4+DQo+Pj4gV2hlbiBJIGNoYW5nZSB0aGUgZHJpdmVyLCB0aGUgcnVsZSB3aGljaCBh
Y3Rpb24gImFjdGlvbiBwYXNzIiwgY2FuIGJlDQo+Pj4gb2ZmbG9hZGVkLCBidXQgaXQgZGlkbid0
IHdvcmsuDQo+Pj4gKyAgICAgICAgICAgICAgIGNhc2UgRkxPV19BQ1RJT05fQUNDRVBUOg0KPj4+
ICsgICAgICAgICAgICAgICAgICAgYWN0aW9uIHw9IE1MWDVfRkxPV19DT05URVhUX0FDVElPTl9B
TExPVzsNCj4+PiArICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPj4+DQo+Pj4NCj4+PiBIb3cg
Y2FuIHdlIHN1cHBvcnQgaXQsIHRoaXMgZnVuY3Rpb24gaXMgaW1wb3J0IGZvciB1cy4NCj4+DQo+
PiBIaSBUb25naGFvLA0KPj4gd2hlcmUgZGlkIHlvdSBhZGQgdGhlIGFib3ZlIGNvZGUgdG8gPw0K
Pj4gcGFyc2VfdGNfZmRiX2FjdGlvbnMoKSA/IG9yIHBhcnNlX3RjX25pY19hY3Rpb25zKCkgPw0K
Pj4gaW4geW91ciB1c2UgY2FzZSB5b3UgbmVlZCB0byBhZGQgaXQgdG8gcGFyc2VfdGNfbmljX2Fj
dGlvbnMoKSwNCj4+DQo+PiBjdXJyZW50bHkgaW4gbWx4NSB3ZSBkb24ndCBzdXBwb3J0IEFMTE9X
L3Bhc3MgYWN0aW9ucy4NCj4+IGl0IG1pZ2h0IGJlIGEgbGl0dGxlIG1vcmUgY29tcGxpY2F0ZWQg
dGhhbiB3aGF0IHlvdSBkaWQgaW4gb3JkZXIgdG8NCj4+IHN1cHBvcnQgdGhpcywNCg0KWWVwLCBm
cm9tIGEgcXVpY2sgbG9vayBhdCB0aGUgY29kZSB3ZSBkb24ndCBzdXBwb3J0IEFMTE9XICsgY291
bnRlciBzbyBhIGNoYW5nZQ0Kd2lsbCBiZSBoYXZlIHRvIG1hZGUgaW4gY291bnRlcl9pc192YWxp
ZCgpIGFuZCB0aGVuIGFjY291bnQgZm9yIHRoYXQgb24gZGVsZXRpb24gaW4NCmRlbF9zd19od19y
dWxlKCkuDQoNCkRvZXNuJ3QgbG9vayB0b28gY29tcGxpY2F0ZWQgdG8gYWRkIGlmIG5lZWRlZCAo
SXQgd2FzIGp1c3QgbmV2ZXIgcmVxdWVzdGVkL25lZWRlZCkuDQoNCj4+IGFzIGEgd29yayBhcm91
bmQgeW91IGNhbiB1c2UgYWN0aW9uOiBGTE9XX0FDVElPTl9NQVJLIGluIHRoZSB0Yw0KPj4gY29t
bWFuZCBsaW5lIHJ1bGUgd2l0aG91dCBhbnkgY2hhbmdlIGluIHRoZSBkcml2ZXIuDQo+PiBvciBj
aGFuZ2UgeW91ciBjb2RlIHRvIGRvIE1MWDVfRkxPV19DT05URVhUX0FDVElPTl9GV0RfREVTVCBp
bnN0ZWFkIG9mDQo+PiBNTFg1X0ZMT1dfQ09OVEVYVF9BQ1RJT05fQUxMT1cNCj4gSGkgU2FlZWQs
IEZMT1dfQUNUSU9OX01BUksgd29ya3MgZmluZSBmb3IgdXMuIFRoYW5rcy4NCg0KR3JlYXQuDQoN
Ck1hcmsNCg0KPiANCj4+IEFkZGluZyBNYXJrIGFuZCBBcmllbCwgdGhleSBtaWdodCBoYXZlIGJl
dHRlciBmZWVkYmFjayB0aGFuIG1pbmUNCj4+DQo+PiBUaGFua3MsDQo+PiBTYWVlZC8NCg==
