Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B3B119F20
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 00:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfLJXMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 18:12:43 -0500
Received: from mail-eopbgr10063.outbound.protection.outlook.com ([40.107.1.63]:47031
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbfLJXMm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 18:12:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBJRg9AE7TD3M8BzOwaiPu8y523ZCHco6dq1RrCdUxRbCMYU3kcVf1uZeT17lvWUkB8/99Ff7Tmf3EI43HLvcMdCEi7AnqXSMYezYF5N3za1+wEKCJmZruBU2cioDKa2tdhbkN6efyd/yKcTkrIUigP+dU/YvTCxujhCd1vfnhTbOLCed9WVJnaP64w66oU8DXXIPnfTS1HWmEx/iXEM/iU20go/tABLvY13He5cg296X6/ZBvXDAiGk/iVZARhvWXHWbHVrTBeTMXn5pG32WURe/bU8ILQpa/A0ewW6tLvprILv5NNMWNFEVQNChcXz35E+8rkH/wd2o8wVbqxu5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCYReYaWPdMvWdZeRfiXVD0JVlXnRJkEsOCnKDkxChY=;
 b=hJ9rx+qTnHftz6CD/Spq/3S19i0i70ologjH8R8WyAmlFn0vY4GdQqCNLxBF71KNT0PK39lT9J3anSbszrCraes0CH/6C+cTNZYVTU6BvKr6lK6S99fxHY/TPL1AoJuv2+hfB2kBwjx785CAYKQ2BU9LP7iE9VXSP7WU08Jt1jFC/ZT/QSiLcCzcKSL+yxE0wAzFiyqlpB5AghCaY7seojX9bDbZl5Lkpq6UL6fbrMG6q+TCW4ebfW91a9plbmlOVWQketTV22/Y/UX0UtnxfhwlKaMtHUFOFNuc10narPSzBBz/Y8wN5Rj+A52l1zFis3r3NdizidOOmOoUzeOQkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCYReYaWPdMvWdZeRfiXVD0JVlXnRJkEsOCnKDkxChY=;
 b=aFbWfevfqJimlZ73Ih1Fk/H638F6C1UZKSDEeVijO1SYqRyJgN4cxyQpKkap1/H27kDF+Dk8Ss+eDt4HNV19lMQv5a2VzLWdC8Ro3udpmNcNOmw2SdhjB0GuiU8IAqGB7aSWbSvAx9iAk1ztHc1r5g9BL7VLCg+C4GDhgDpNQ2E=
Received: from VI1PR05MB3342.eurprd05.prod.outlook.com (10.170.238.143) by
 VI1PR05MB4494.eurprd05.prod.outlook.com (52.133.13.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Tue, 10 Dec 2019 23:11:56 +0000
Received: from VI1PR05MB3342.eurprd05.prod.outlook.com
 ([fe80::40d4:350c:cce1:6224]) by VI1PR05MB3342.eurprd05.prod.outlook.com
 ([fe80::40d4:350c:cce1:6224%5]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 23:11:56 +0000
From:   Mark Bloch <markb@mellanox.com>
To:     "xiangxia.m.yue@gmail.com" <xiangxia.m.yue@gmail.com>,
        "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        Roi Dayan <roid@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Support accept action on nic table
Thread-Topic: [PATCH net-next] net/mlx5e: Support accept action on nic table
Thread-Index: AQHVr2kpWJ3c+JpWHkSL2rAzjAgzVqez/5IA
Date:   Tue, 10 Dec 2019 23:11:56 +0000
Message-ID: <3bd7e8f0-a024-9252-470c-b197daf7bd75@mellanox.com>
References: <1575989382-7195-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1575989382-7195-1-git-send-email-xiangxia.m.yue@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0049.namprd22.prod.outlook.com
 (2603:10b6:300:12a::11) To VI1PR05MB3342.eurprd05.prod.outlook.com
 (2603:10a6:802:1d::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=markb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [208.186.24.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 57434fe6-551b-42bb-2f37-08d77dc65a1f
x-ms-traffictypediagnostic: VI1PR05MB4494:|VI1PR05MB4494:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB44944C7E88680CFEBD1D429ED25B0@VI1PR05MB4494.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:397;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(189003)(199004)(66946007)(36756003)(81166006)(6636002)(6486002)(66446008)(66556008)(66476007)(186003)(64756008)(26005)(71200400001)(110136005)(6506007)(2906002)(55236004)(478600001)(6512007)(52116002)(31696002)(31686004)(5660300002)(8676002)(53546011)(2616005)(86362001)(8936002)(81156014)(4326008)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4494;H:VI1PR05MB3342.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A9Jpv1FTwxOeOk2q0KDbMxkmuwcAqi7TfTm4HDSvpxXLTIA3qXN9oHFG8KKQn2Wd7MIsqriaVudvQZBMoDCbaIENLSzadJFiB+Dcl49LkwqV2ib45AeQF+3AnowYMhun4lwi57ZJwaHM7oznv775esO6feedBF9juhlhThtefOXoW5VALGpZATfMfAb1yd1NBFNMmNQpHIsakh7c7jh33gl7OGAWOl1j+VR4o8Y+60j0RT+3b5RDrFNXmsrB9qtBqVFFByEpThAD1BlzmjJceaM8cdAY2sBywLycchWRyq6+OG4oaAsCHPhr1mHguVaByYgN12pBQrFIrGiBwcoGCd5649eMgoW2r4s/1HlTYwqNdIBc1P4vST2ZKO5/XVYgp5/rqPdWM/zrbZazFGQWn30nHxs2SaHaIo9+Q1hJxRS+tucMbbBh6muzwBco1PFp
Content-Type: text/plain; charset="utf-8"
Content-ID: <583D8D99C5B2EC40813A8E123E5AC482@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57434fe6-551b-42bb-2f37-08d77dc65a1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 23:11:56.7033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PdV1qGyxrGBg0bkvTT8vZ5aX1qdVUGzjiTmolB0Bew0ZeOtDUXDxV1vo0zKZTRXGFtAzGR5JEypji9z099Z/oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4494
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEwLzE5IDY6NDkgQU0sIHhpYW5neGlhLm0ueXVlQGdtYWlsLmNvbSB3cm90ZToN
Cj4gRnJvbTogVG9uZ2hhbyBaaGFuZyA8eGlhbmd4aWEubS55dWVAZ21haWwuY29tPg0KPiANCj4g
SW4gb25lIGNhc2UsIHdlIG1heSBmb3J3YXJkIHBhY2tldHMgZnJvbSBvbmUgdnBvcnQNCj4gdG8g
b3RoZXJzLCBidXQgb25seSBvbmUgcGFja2V0cyBmbG93IHdpbGwgYmUgYWNjZXB0ZWQsDQo+IHdo
aWNoIGRlc3RpbmF0aW9uIGlwIHdhcyBhc3NpZ24gdG8gVkYuDQo+IA0KPiArLS0tLS0rICAgICAr
LS0tLS0rICAgICAgICAgICAgKy0tLS0tKw0KPiB8IFZGbiB8ICAgICB8IFZGMSB8ICAgICAgICAg
ICAgfCBWRjAgfCBhY2NlcHQNCj4gKy0tKy0tKyAgICAgKy0tKy0tKyAgaGFpcnBpbiAgICstLV4t
LSsNCj4gICAgfCAgICAgICAgICAgfCA8LS0tLS0tLS0tLS0tLS0tIHwNCj4gICAgfCAgICAgICAg
ICAgfCAgICAgICAgICAgICAgICAgIHwNCj4gKy0tKy0tLS0tLS0tLS0tdi0rICAgICAgICAgICAg
ICstLSstLS0tLS0tLS0tLS0tKw0KPiB8ICAgZXN3aXRjaCBQRjEgIHwgICAgICAgICAgICAgfCAg
IGVzd2l0Y2ggUEYwICB8DQo+ICstLS0tLS0tLS0tLS0tLS0tKyAgICAgICAgICAgICArLS0tLS0t
LS0tLS0tLS0tLSsNCj4gDQo+IHRjIGZpbHRlciBhZGQgZGV2ICRQRjAgcHJvdG9jb2wgYWxsIHBh
cmVudCBmZmZmOiBwcmlvIDEgaGFuZGxlIDEgXA0KPiAJZmxvd2VyIHNraXBfc3cgYWN0aW9uIG1p
cnJlZCBlZ3Jlc3MgcmVkaXJlY3QgZGV2ICRWRjBfUkVQDQo+IHRjIGZpbHRlciBhZGQgZGV2ICRW
RjAgcHJvdG9jb2wgaXAgIHBhcmVudCBmZmZmOiBwcmlvIDEgaGFuZGxlIDEgXA0KPiAJZmxvd2Vy
IHNraXBfc3cgZHN0X2lwICRWRjBfSVAgYWN0aW9uIHBhc3MNCj4gdGMgZmlsdGVyIGFkZCBkZXYg
JFZGMCBwcm90b2NvbCBhbGwgcGFyZW50IGZmZmY6IHByaW8gMiBoYW5kbGUgMiBcDQo+IAlmbG93
ZXIgc2tpcF9zdyBhY3Rpb24gbWlycmVkIGVncmVzcyByZWRpcmVjdCBkZXYgJFZGMQ0KPiANCj4g
U2lnbmVkLW9mZi1ieTogVG9uZ2hhbyBaaGFuZyA8eGlhbmd4aWEubS55dWVAZ21haWwuY29tPg0K
PiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5j
IHwgNCArKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KPiBpbmRl
eCAwZDVkODRiLi5mOTFlMDU3ZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCj4gQEAgLTI4MzksNiArMjgzOSwxMCBAQCBzdGF0
aWMgaW50IHBhcnNlX3RjX25pY19hY3Rpb25zKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LA0KPiAg
DQo+ICAJZmxvd19hY3Rpb25fZm9yX2VhY2goaSwgYWN0LCBmbG93X2FjdGlvbikgew0KPiAgCQlz
d2l0Y2ggKGFjdC0+aWQpIHsNCj4gKwkJY2FzZSBGTE9XX0FDVElPTl9BQ0NFUFQ6DQo+ICsJCQlh
Y3Rpb24gfD0gTUxYNV9GTE9XX0NPTlRFWFRfQUNUSU9OX0ZXRF9ERVNUIHwNCj4gKwkJCQkgIE1M
WDVfRkxPV19DT05URVhUX0FDVElPTl9DT1VOVDsNCj4gKwkJCWJyZWFrOw0KPiAgCQljYXNlIEZM
T1dfQUNUSU9OX0RST1A6DQo+ICAJCQlhY3Rpb24gfD0gTUxYNV9GTE9XX0NPTlRFWFRfQUNUSU9O
X0RST1A7DQo+ICAJCQlpZiAoTUxYNV9DQVBfRkxPV1RBQkxFKHByaXYtPm1kZXYsDQo+IA0KDQpS
b2kgb25jZSBTYWVlZCB0YWtlcyBpdCwgY2FuIHlvdSBwbGVhc2UgbWFrZSBzdXJlIHdlIGFyZSBh
ZGRpbmcgYSB0ZXN0IGZvciB0aGlzIGZsb3c/DQphICh2ZXJ5KSBzaW1wbGUgKGJhc2ljKSB3YXkg
dG8gdmVyaWZ5IHRoaXMgZmxvdyBpcyB0byBkbyBzb21ldGhpbmcgbGlrZSB0aGlzOg0KDQoxKSBt
b3ZlIGJvdGggUEZzIGludG8gc3dpdGNoZGV2DQoNClZGMF9QRjA9ZW5zNGYyDQpWRjBfUEYwX1JF
UD1lbnM0ZjBfMA0KVkYwX1BGMT1lbnM0ZjUNClZGMF9QRjFfUkVQPWVuczRmMV8wDQoNCmV0aHRv
b2wgLUsgVkYwX1BGMCBody10Yy1vZmZsb2FkIG9uDQp0YyBmaWx0ZXIgYWRkIGRldiBWRjBfUEYw
IHByb3RvY29sIGlwIHBhcmVudCBmZmZmOiBwcmlvIDEgaGFuZGxlIDEgZmxvd2VyIHNraXBfc3cg
ZHN0X2lwIDEuMS4xLjEgYWN0aW9uIHBhc3MNCnRjIGZpbHRlciBhZGQgZGV2IFZGMF9QRjAgcHJv
dG9jb2wgaXAgcGFyZW50IGZmZmY6IHByaW8gMiBoYW5kbGUgMiBmbG93ZXIgc2tpcF9zdyBhY3Rp
b24gbWlycmVkIGVncmVzcyByZWRpcmVjdCBkZXYgVkYwX1BGMQ0KaWZjb25maWcgVkYwX1BGMF9S
RVAgMS4xLjEuMg0KYXJwIC1zIDEuMS4xLjEgZWM6MGQ6OWE6ZDQ6MmU6MTQNCmFycCAtcyAxLjEu
MS4zIGVjOjBkOjlhOmQ0OjJlOjI0DQoNCk5vdyBpZiB5b3UgdHJ5IHRvIHBpbmcgMS4xLjEuMSB5
b3Ugc2hvdWxkIHNlZSBwYWNrZXRzIG9uIFZGMF9QRjANCmlmIHlvdSB0cnkgdG8gcGluZyAxLjEu
MS4zIHlvdSBzaG91bGQgc2VlIHBhY2tldHMgb24gVkYwX1BGMV9SRVANCg0KUmV2aWV3ZWQtYnk6
IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxhbm94LmNvbT4NCg0KTWFyaw0K
