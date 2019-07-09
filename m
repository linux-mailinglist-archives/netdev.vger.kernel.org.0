Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6863A0E
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 19:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfGIRVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 13:21:43 -0400
Received: from mail-eopbgr130073.outbound.protection.outlook.com ([40.107.13.73]:33857
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725816AbfGIRVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 13:21:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FSoZZcdi+olkLnqobU/fZm/FQJkMbSzb+aNWmAfsLo=;
 b=Hc45kGz6VuymhUrmM+AF7fUjsHlH5Scwc/QevlgkqOgKwXJDPl80KgdR/EyHj5jZYBlKHUSMgQtExFO1xH1Dz+8olzSgia/3PHgpH7qJmT/f0uOG7gV3yHf24TElskRqkUVhdk5r9FnJMYMkWVFql2Ch8m4P2ro6JizmwRpLGCg=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 17:21:39 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 17:21:39 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>
Subject: RE: [PATCH net-next iproute2] devlink: Show devlink port number
Thread-Topic: [PATCH net-next iproute2] devlink: Show devlink port number
Thread-Index: AQHVNnQdITqFw1v4qkaEEAxKZ4YH3abChcMAgAACH1A=
Date:   Tue, 9 Jul 2019 17:21:38 +0000
Message-ID: <AM0PR05MB48666D79F40F82A934438DF2D1F10@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190709163352.20371-1-parav@mellanox.com>
 <cb5ec628-9274-5c09-1412-2c80b12890e2@gmail.com>
In-Reply-To: <cb5ec628-9274-5c09-1412-2c80b12890e2@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [49.207.52.95]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef571682-af52-421b-e8e2-08d70491e719
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4866;
x-ms-traffictypediagnostic: AM0PR05MB4866:
x-microsoft-antispam-prvs: <AM0PR05MB4866A20EAE860D3E7CAE2345D1F10@AM0PR05MB4866.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(199004)(13464003)(189003)(76176011)(71190400001)(11346002)(52536014)(476003)(446003)(26005)(76116006)(66946007)(73956011)(66556008)(71200400001)(66066001)(256004)(8936002)(7696005)(54906003)(6116002)(99286004)(33656002)(6246003)(305945005)(102836004)(486006)(478600001)(66446008)(7736002)(186003)(64756008)(74316002)(2501003)(6436002)(229853002)(4326008)(55016002)(3846002)(68736007)(2906002)(86362001)(25786009)(53546011)(14454004)(6506007)(9686003)(5660300002)(81166006)(4744005)(53936002)(66476007)(8676002)(316002)(81156014)(110136005)(55236004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4866;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hmbfTGbtIctX7uYvqm5dtA7Fwph8YtFFoUZZMyNgBVe/VdgLOSH+dnxG6gGt97Xik04s/PC4uaXmPsd3TmcBCWo0nJX0lOWBdCSBKMU07Xccqg8R+jb2hiHg0dR4DTTBoUdKecxC7jodKb6a3rgDEj38lQysr5lgi4INrJNghukPyJZQGH/hJXQnkB88n/Rp+vb6VCX+ISGPp1lolPNcNP3tuRojeGBAgk2zoKlqh9pO18YFyZR8HpgJVnhTe8Qrs4XxG0VaLV++BGwgUYqdpFuyvDknbYU2/L0ESLSSv0WXllXZHolfKzIbhyeUkMZU1b4TDAMRvt3VkSTLVBLj7CHLqM79exImc6ZS6KrS44uCxk9KYo2UHPOxt35qo5zTMsX1YMYK/Kgv8lMINoFLSYbmkzekVwVcADaiXLSzZN8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef571682-af52-421b-e8e2-08d70491e719
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 17:21:38.9279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4866
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRz
YWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBKdWx5IDksIDIwMTkgMTA6NDEgUE0N
Cj4gVG86IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVsbGFub3guY29tPjsgbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZw0KPiBDYzogc3RlcGhlbkBuZXR3b3JrcGx1bWJlci5vcmc7IEppcmkgUGlya28gPGpp
cmlAbWVsbGFub3guY29tPjsNCj4gZHNhaGVybkBrZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggbmV0LW5leHQgaXByb3V0ZTJdIGRldmxpbms6IFNob3cgZGV2bGluayBwb3J0IG51bWJl
cg0KPiANCj4gT24gNy85LzE5IDEwOjMzIEFNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gQEAg
LTI4MDYsNiArMjgwNiwxMSBAQCBzdGF0aWMgdm9pZCBwcl9vdXRfcG9ydChzdHJ1Y3QgZGwgKmRs
LCBzdHJ1Y3QNCj4gPiBubGF0dHIgKip0YikNCj4gPg0KPiA+ICAJCXByX291dF9zdHIoZGwsICJm
bGF2b3VyIiwgcG9ydF9mbGF2b3VyX25hbWUocG9ydF9mbGF2b3VyKSk7DQo+ID4gIAl9DQo+ID4g
KwlpZiAodGJbREVWTElOS19BVFRSX1BPUlRfTlVNQkVSXSkgew0KPiA+ICsJCXVpbnQzMl90IHBv
cnRfbnVtYmVyID0NCj4gPiArDQo+IAltbmxfYXR0cl9nZXRfdTMyKHRiW0RFVkxJTktfQVRUUl9Q
T1JUX05VTUJFUl0pOw0KPiANCj4gZGVjbGFyZSBhbmQgYXNzaWduIHNlcGFyYXRlbHk7IG5vdGhp
bmcgaXMgZ2FpbmVkIHdoZW4gaXQgaXMgc3BsaXQgYWNyb3NzIGxpbmVzDQo+IGxpa2UgdGhhdC4N
Cj4NCk9rLiBJIHdhcyBtaXNsZWQgYnkgYW4gZXhhbXBsZSBvZiBwb3J0X2ZsYXZvdXIgd2hpY2gg
YXNzaWducyBhbmQgZGVjbGFyZSBpbiBzYW1lIGxpbmUuDQpTZW5kaW5nIHYxLg0KIA0KPiA+ICsJ
CXByX291dF91aW50KGRsLCAicG9ydCIsIHBvcnRfbnVtYmVyKTsNCj4gPiArCX0NCj4gPiAgCWlm
ICh0YltERVZMSU5LX0FUVFJfUE9SVF9TUExJVF9HUk9VUF0pDQo+ID4gIAkJcHJfb3V0X3VpbnQo
ZGwsICJzcGxpdF9ncm91cCIsDQo+ID4NCj4gbW5sX2F0dHJfZ2V0X3UzMih0YltERVZMSU5LX0FU
VFJfUE9SVF9TUExJVF9HUk9VUF0pKTsNCg0K
