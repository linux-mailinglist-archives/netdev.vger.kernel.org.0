Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2D0363A4
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFESzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:55:22 -0400
Received: from mail-eopbgr130073.outbound.protection.outlook.com ([40.107.13.73]:56543
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbfFESzV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 14:55:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OfL8cMTymzrQkqmwvCajCFSEmhmv7XuDtguuz7yDQj0=;
 b=RrjNJchAzqeIHCaUNq7GcI95TBkMKzWoPgH40UcYLBaHiq01Prnz1OpmWXIqrBu0BO0Sf673EZag0jDHwZUejs4ymlvZ4IvoymZhgICDvE8DGAtU2WNC7X7Fm37V2IjmyPZeSrmDNFCFz0VArUGE5zvhZmytefqUCluiFQALKAI=
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com (20.177.119.89) by
 AM6PR05MB5442.eurprd05.prod.outlook.com (20.177.118.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Wed, 5 Jun 2019 18:55:18 +0000
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae]) by AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae%5]) with mapi id 15.20.1965.011; Wed, 5 Jun 2019
 18:55:18 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 4/9] mlxsw: reg: Add Management UTC Register
Thread-Topic: [PATCH net-next 4/9] mlxsw: reg: Add Management UTC Register
Thread-Index: AQHVGgXQARZCv5VopEC1fl5DvasR4KaLjGoAgAFjk4CAAGLdAIAAGYUA
Date:   Wed, 5 Jun 2019 18:55:18 +0000
Message-ID: <78632a57-3dc7-f290-329b-b0ead767c750@mellanox.com>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-5-idosch@idosch.org>
 <20190604141724.rwzthxdrcnvjboen@localhost>
 <05498adb-364e-18c9-f1d1-bb32462e4036@mellanox.com>
 <20190605172354.gixuid7t72yoxjks@localhost>
In-Reply-To: <20190605172354.gixuid7t72yoxjks@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
x-clientproxiedby: LO2P265CA0454.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::34) To AM6PR05MB5524.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [84.108.45.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccebaf4e-5f9b-42ea-de28-08d6e9e75a22
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5442;
x-ms-traffictypediagnostic: AM6PR05MB5442:
x-microsoft-antispam-prvs: <AM6PR05MB5442DA4CC0494FA39F240A41C5160@AM6PR05MB5442.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(39860400002)(396003)(346002)(366004)(199004)(189003)(6512007)(476003)(53546011)(2616005)(68736007)(5660300002)(66066001)(305945005)(486006)(36756003)(64756008)(65826007)(102836004)(446003)(31686004)(2906002)(26005)(316002)(71200400001)(229853002)(6436002)(99286004)(25786009)(71190400001)(58126008)(11346002)(256004)(52116002)(65806001)(6506007)(65956001)(386003)(186003)(73956011)(7736002)(14454004)(6916009)(66476007)(107886003)(6486002)(66946007)(66556008)(66446008)(4326008)(3846002)(6116002)(478600001)(81156014)(53936002)(64126003)(81166006)(31696002)(8676002)(6246003)(8936002)(86362001)(1411001)(76176011)(4744005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5442;H:AM6PR05MB5524.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mAJ7LIGYpnKiiNvlCVj/+QqLEDPoV/UPb3R2ZoM33Qb7o4Lhim7NSNgw71D8QLQLWku96w3QyIOJWS+X+6cXEswJSns4IB9YD0Got9GdnDVseH4M4iYe1FFkxsKvglQkE5fPprSzLlOJFVcGYktK6OCB+gdQBp95uVX2ksaJcX8tE4Or1sLjtgarl8u37qkLuCZiYD0wdiGerdk3MX7m2fKFtFLR4rguEKSOw+y73ZvKZdAcHgPAXm/r22y9yEX55yb4bPbRpDSqDfVdI3i3BJfsnEbAcVv9QfSGLM1ukfp/ogic4z5rCrk5Z6NkkZ1GoD+ZbCfKJbFyiGEqGugQ5QqEAFOjFZp3r5IKl6nPyCzaQiQLvLTkZfYg++WgTtUF5ku2rqBif8ZyKi4QgJXpO072ek2uY/OYgRJWHiBH+4k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7340DC42B2A2754FABB0F25EAE70B997@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccebaf4e-5f9b-42ea-de28-08d6e9e75a22
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 18:55:18.1623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shalomt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5442
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDUvMDYvMjAxOSAyMDoyMywgUmljaGFyZCBDb2NocmFuIHdyb3RlOg0KPiBPbiBXZWQsIEp1
biAwNSwgMjAxOSBhdCAxMTozMDowNkFNICswMDAwLCBTaGFsb20gVG9sZWRvIHdyb3RlOg0KPj4g
T24gMDQvMDYvMjAxOSAxNzoxNywgUmljaGFyZCBDb2NocmFuIHdyb3RlOg0KPj4+IE9uIE1vbiwg
SnVuIDAzLCAyMDE5IGF0IDAzOjEyOjM5UE0gKzAzMDAsIElkbyBTY2hpbW1lbCB3cm90ZToNCj4+
Pj4gRnJvbTogU2hhbG9tIFRvbGVkbyA8c2hhbG9tdEBtZWxsYW5veC5jb20+DQo+Pj4+DQo+Pj4+
IFRoZSBNVFVUQyByZWdpc3RlciBjb25maWd1cmVzIHRoZSBIVyBVVEMgY291bnRlci4NCj4+Pg0K
Pj4+IFdoeSBpcyB0aGlzIGNhbGxlZCB0aGUgIlVUQyIgY291bnRlcj8NCj4+Pg0KPj4+IFRoZSBQ
VFAgdGltZSBzY2FsZSBpcyBUQUkuICBJcyB0aGlzIGNvdW50ZXIgaW50ZW5kZWQgdG8gcmVmbGVj
dCB0aGUNCj4+PiBMaW51eCBDTE9DS19SRUFMVElNRSBzeXN0ZW0gdGltZT8NCj4+DQo+PiBFeGFj
dGx5LiBUaGUgaGFyZHdhcmUgZG9lc24ndCBoYXZlIHRoZSBhYmlsaXR5IHRvIGNvbnZlcnQgdGhl
IEZSQyB0byBVVEMsIHNvDQo+PiB3ZSwgYXMgYSBkcml2ZXIsIG5lZWQgdG8gZG8gaXQgYW5kIGFs
aWduIHRoZSBoYXJkd2FyZSB3aXRoIHRoaXMgdmFsdWUuDQo+IA0KPiBXaGF0IGRvZXMgIkZSQyIg
bWVhbj8NCg0KRnJlZSBSdW5uaW5nIENvdW50ZXINCg0KPiANCj4gVGhhbmtzLA0KPiBSaWNoYXJk
DQo+IA0KDQo=
