Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C408FBCAD
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 00:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfKMXmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 18:42:51 -0500
Received: from mail-eopbgr740084.outbound.protection.outlook.com ([40.107.74.84]:47147
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbfKMXmu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 18:42:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itc99We3O/ml99poxuMj+K7i5sdet47rXPrVk35IgLqG9NtYs5m2r8On0YATROh7sfPeWCqHV5gx7IxGCHeePyXiopKC7ptaQ9Od4qHA/6AMvGnbMkBzqBPoydQGPAeAHjfgLlH17k5DrrgkdMoCZY4/rPzauSv229R5unAnnIi9rf5mkwQSfLQSMn/YpQdRbpHTT98IkRuKp9HHQs9nLUUgbLX1kARjTO5hwJKWIBq1GzD+Oo3CHXhzZqQv8gF5lM3z5cMP6+AnK8iw9giq9sTyXxZbyQ8YoN9/Z5Nx7oE1LT3VockXKDwgpVEpNYMCqvOC8YtNCQR7qbkeJ6BjjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5mTq40tK3hIETFRPibTldfx1EB4USpuGTvC7EE+new=;
 b=DCoqpJpXnb+OkZ84yc4y6zsSaReazCmnd3+BZ8Dn9+eQ7R3y/FhIwf6B2P8XSKzAc3uMIXFKdvOepjDp2gzrZ1dASyyjQiyjiNsof0CfiOse8Pug8Ub0i/qY2rwSnrjB5iRaj9z1ksxfu6Bg711iYqCDTinLn7x1YBzjPUauQmny/7O2TPrf/ogMgO87bx1UZfu3L8qXo5mLYM9L9gvzcXrBO9OwJhV2NCAtjo87Ah7y9isT/4rFf1pxlGUTY4TrDatZMPJk9MRObjTmQm0+rUcDWFpQtPaXqAVAFaglG7ng4afU/um5iaMcJQYk0R9J3CuC2TvF3Ycme9tRJ0caIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5mTq40tK3hIETFRPibTldfx1EB4USpuGTvC7EE+new=;
 b=QirLNOIIs2Irl9Gd+PKER6+hj8hq1uqE44UAsQQfMnFKIVN8Y18uZXSH4+Cg3YH3anPM5x2Q9YnySkDVcZNNvWU2T9j1Yst7y8ItZgEMCWvN/kUHOcadYuQJQVGQd0+8Hs+BNX2RZc+9sBjaWgMIHOVg3ZclvY9KuE9AVtzteRQ=
Received: from CH2PR15MB3575.namprd15.prod.outlook.com (10.255.156.17) by
 CH2PR15MB3606.namprd15.prod.outlook.com (10.255.156.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 13 Nov 2019 23:42:47 +0000
Received: from CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::a0a2:ffd4:4a7f:7a63]) by CH2PR15MB3575.namprd15.prod.outlook.com
 ([fe80::a0a2:ffd4:4a7f:7a63%7]) with mapi id 15.20.2451.023; Wed, 13 Nov 2019
 23:42:47 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     Matt Bennett <matt.bennett@alliedtelesis.co.nz>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] tipc: add back tipc prefix to log messages
Thread-Topic: [PATCH] tipc: add back tipc prefix to log messages
Thread-Index: AQHVmnj4WEVyPCPLjU+4VjtSx5PZ1aeJwvzQ
Date:   Wed, 13 Nov 2019 23:42:47 +0000
Message-ID: <CH2PR15MB3575FD6D67A24195E1229F1E9A760@CH2PR15MB3575.namprd15.prod.outlook.com>
References: <20191113232003.29436-1-matt.bennett@alliedtelesis.co.nz>
In-Reply-To: <20191113232003.29436-1-matt.bennett@alliedtelesis.co.nz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [24.225.233.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9dade5ac-d972-4b21-e9a6-08d768933040
x-ms-traffictypediagnostic: CH2PR15MB3606:
x-microsoft-antispam-prvs: <CH2PR15MB36068A607CF6A525CAD55AAF9A760@CH2PR15MB3606.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:199;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(199004)(189003)(13464003)(64756008)(76116006)(66446008)(486006)(55016002)(256004)(66066001)(33656002)(66556008)(6506007)(4326008)(11346002)(446003)(15650500001)(476003)(26005)(76176011)(66476007)(44832011)(6246003)(53546011)(66946007)(102836004)(186003)(71200400001)(71190400001)(9686003)(74316002)(81166006)(2906002)(8676002)(14454004)(2501003)(7696005)(6436002)(229853002)(110136005)(478600001)(81156014)(305945005)(7736002)(316002)(99286004)(25786009)(86362001)(52536014)(2201001)(8936002)(5660300002)(6116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR15MB3606;H:CH2PR15MB3575.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zd8ll4eISzCXZ5ltWM3RE94c4to+21NT/qWBaQwzlROGps5Ps1ENN+jE2LB1m4aTvnt+vypJs7gI2wPseWXmIxbQuj7aP6snsBsv+Yt7Z+Bw+BvCmUHIkUaZen/mRO1IrdMxlJv2Nxd6WXnKTaliJan4nMs4RVOUCrlKdMWlnePT2IWEdUGIG84HEszuaYl9qLDDsyrgroJTmkihCoX+J/JGNNoEAwWf3/5MVUfdtOfv3l8vz3T9W0XOpUNLKMSa4sRndefVwDAdXfd9KLKGvqAGa5sRu4nhpRKFQp21NfNOHhJuvSijFw3tI2YdwbjbrcxPxRnd1BOOHiLHTlujTAwgR7tOjh6S4EJrYo4sxr5/vK0XEK6TP1wKQv42Jzq0NmqCTFqm+BEbWRAv1R8v76xH/WS7b/XqD9c4NuwYt8PbgLV5wJL34bizJmFWodBK
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dade5ac-d972-4b21-e9a6-08d768933040
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 23:42:47.3767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EaOedeA6AyzyO9lekAcpPHGZlCA+VvKgu8hUPFupXb7ivg/HThxChOtZNRNOujO7MJzw9YOOQQCTv8LuzW6aRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWNrZWQtYnk6IEpvbiBNYWxveSA8am9uLm1hbG95QGVyaWNzc29uLmNvbT4NCg0KPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBuZXRkZXYtb3duZXJAdmdlci5rZXJuZWwub3Jn
IDxuZXRkZXYtb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbiBCZWhhbGYgT2YgTWF0dCBCZW5uZXR0
DQo+IFNlbnQ6IDEzLU5vdi0xOSAxODoyMA0KPiBUbzogSm9uIE1hbG95IDxqb24ubWFsb3lAZXJp
Y3Nzb24uY29tPjsgeWluZy54dWVAd2luZHJpdmVyLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsN
Cj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgdGlwYy1kaXNjdXNzaW9uQGxpc3RzLnNvdXJjZWZv
cmdlLm5ldA0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgTWF0dCBCZW5uZXR0
IDxtYXR0LmJlbm5ldHRAYWxsaWVkdGVsZXNpcy5jby5uej4NCj4gU3ViamVjdDogW1BBVENIXSB0
aXBjOiBhZGQgYmFjayB0aXBjIHByZWZpeCB0byBsb2cgbWVzc2FnZXMNCj4gDQo+IFRoZSB0aXBj
IHByZWZpeCBmb3IgbG9nIG1lc3NhZ2VzIGdlbmVyYXRlZCBieSB0aXBjIHdhcw0KPiByZW1vdmVk
IGluIGNvbW1pdCAwN2Y2YzRiYzA0OGEgKCJ0aXBjOiBjb252ZXJ0IHRpcGMgcmVmZXJlbmNlDQo+
IHRhYmxlIHRvIHVzZSBnZW5lcmljIHJoYXNodGFibGUiKS4NCj4gDQo+IFRoaXMgaXMgc3RpbGwg
YSB1c2VmdWwgcHJlZml4IHNvIGFkZCBpdCBiYWNrLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWF0
dCBCZW5uZXR0IDxtYXR0LmJlbm5ldHRAYWxsaWVkdGVsZXNpcy5jby5uej4NCj4gLS0tDQo+ICBu
ZXQvdGlwYy9jb3JlLmMgfCAyIC0tDQo+ICBuZXQvdGlwYy9jb3JlLmggfCA2ICsrKysrKw0KPiAg
MiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvbmV0L3RpcGMvY29yZS5jIGIvbmV0L3RpcGMvY29yZS5jDQo+IGluZGV4IDIz
Y2IzNzlhOTNkNi4uOGYzNTA2MGEyNGUxIDEwMDY0NA0KPiAtLS0gYS9uZXQvdGlwYy9jb3JlLmMN
Cj4gKysrIGIvbmV0L3RpcGMvY29yZS5jDQo+IEBAIC0zNCw4ICszNCw2IEBADQo+ICAgKiBQT1NT
SUJJTElUWSBPRiBTVUNIIERBTUFHRS4NCj4gICAqLw0KPiANCj4gLSNkZWZpbmUgcHJfZm10KGZt
dCkgS0JVSUxEX01PRE5BTUUgIjogIiBmbXQNCj4gLQ0KPiAgI2luY2x1ZGUgImNvcmUuaCINCj4g
ICNpbmNsdWRlICJuYW1lX3RhYmxlLmgiDQo+ICAjaW5jbHVkZSAic3Vic2NyLmgiDQo+IGRpZmYg
LS1naXQgYS9uZXQvdGlwYy9jb3JlLmggYi9uZXQvdGlwYy9jb3JlLmgNCj4gaW5kZXggNjBkODI5
NTgxMDY4Li4zMDQyZjY1NGUwYWYgMTAwNjQ0DQo+IC0tLSBhL25ldC90aXBjL2NvcmUuaA0KPiAr
KysgYi9uZXQvdGlwYy9jb3JlLmgNCj4gQEAgLTYwLDYgKzYwLDEyIEBADQo+ICAjaW5jbHVkZSA8
bGludXgvcmhhc2h0YWJsZS5oPg0KPiAgI2luY2x1ZGUgPG5ldC9nZW5ldGxpbmsuaD4NCj4gDQo+
ICsjaWZkZWYgcHJfZm10DQo+ICsjdW5kZWYgcHJfZm10DQo+ICsjZW5kaWYNCj4gKw0KPiArI2Rl
ZmluZSBwcl9mbXQoZm10KSBLQlVJTERfTU9ETkFNRSAiOiAiIGZtdA0KPiArDQo+ICBzdHJ1Y3Qg
dGlwY19ub2RlOw0KPiAgc3RydWN0IHRpcGNfYmVhcmVyOw0KPiAgc3RydWN0IHRpcGNfYmNfYmFz
ZTsNCj4gLS0NCj4gMi4yNC4wDQoNCg==
