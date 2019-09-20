Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9CDB9623
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 19:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405296AbfITRCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 13:02:15 -0400
Received: from mail-eopbgr40049.outbound.protection.outlook.com ([40.107.4.49]:19870
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391920AbfITRCO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 13:02:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q21T6wzkeofIUW2bmPxqfTkgrunswYGsR63CEzj/YRW73xR9wKPUsHgdfwF2NRunttrnv+4iQjPYlVHpSrGZwvATGp9M8hMePvMmiwdNJM58EVkiqeBLpxKO0BPMoEEz0Q1U+Pry3dnEOhyx1x7wHOOwGydhsdypmTif482E4ERU1UR/bgcFOq2R8kZCWI58hosNs6SYIDVVYTubrh55omJem1DUnhgdiiza85l0IGzHvD4WEfDJjcQuhNi2ERDLx3EzMAz0Oi+1XQ3IyDKNLc1D9zBdbgKZBrftLtLpbq2/3kk3ZNJ3+BHNyBLY+u+7UA3wYTU7flcwzSuqddYaDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VH/aYCDUWGXe5dkFsWpbZr/Y8E9XJis+iFN4JZgOwo4=;
 b=eyxFYm8B7VgaKIs+f6m0pIPW0Xy4SKdKVHmpXNv5z/IqIHYzLrZuRI20bEBBd+bT/yd29IMThZnQqr783/ljBqfDnDAg5T1J9rae4bbWy4XnIkxRoe5sVKC7X+LYyLEqAMfn8BiZF+mOQBqCuxR3cvFyM+b3ll1T7dxdOZmsrC8tHo9dNiah/9tFiSdyK6IejQAKz8pC4wYeALNKrAUSexKG02IuE5rhjX0WR4lstHSLTXxWPOchB/gLZaS+wWKRAG9RQhld211PFhEuUR2KKnIBWqqcfRZbef1sW3OHKEAwp7m6xJbGL8naSUz4TDfSyJ5s5JdWVc1PAYQvoYWiIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VH/aYCDUWGXe5dkFsWpbZr/Y8E9XJis+iFN4JZgOwo4=;
 b=NlRij032XuSvl+pU5X8dhd41XW3nL+JqN7iX/+ixYIctc4Opeq/xIgzYSNSom9h0Ut6s0v3+aK2hjRBPw7XXyQokbBWw3OUAzRfl/8AzKEaAu1QEcz2xG4x40Btwep+WP9R0iPEyi6pde9J154QLpN7guwO0dgc7lHz6pMv2j4E=
Received: from AM6PR05MB5288.eurprd05.prod.outlook.com (20.177.198.151) by
 AM6PR05MB6614.eurprd05.prod.outlook.com (20.179.3.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Fri, 20 Sep 2019 17:02:11 +0000
Received: from AM6PR05MB5288.eurprd05.prod.outlook.com
 ([fe80::255f:e232:1ad8:65fb]) by AM6PR05MB5288.eurprd05.prod.outlook.com
 ([fe80::255f:e232:1ad8:65fb%5]) with mapi id 15.20.2284.023; Fri, 20 Sep 2019
 17:02:11 +0000
From:   Tal Gilboa <talgi@mellanox.com>
To:     =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <uwe@kleine-koenig.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Arthur Kiyanovski <akiyano@amazon.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] dimlib: make DIMLIB a hidden symbol
Thread-Topic: [PATCH] dimlib: make DIMLIB a hidden symbol
Thread-Index: AQHVb7e0M+d87C6r+0SKPdjxpO2J/ac0ytMA
Date:   Fri, 20 Sep 2019 17:02:10 +0000
Message-ID: <670cc72f-fef0-a8cf-eb03-25fdb608eea8@mellanox.com>
References: <20190920133115.12802-1-uwe@kleine-koenig.org>
In-Reply-To: <20190920133115.12802-1-uwe@kleine-koenig.org>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [89.139.148.16]
x-clientproxiedby: PR0P264CA0162.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::30) To AM6PR05MB5288.eurprd05.prod.outlook.com
 (2603:10a6:20b:6b::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=talgi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9b0a4b7-d0f6-4842-80ad-08d73dec46d9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6614;
x-ms-traffictypediagnostic: AM6PR05MB6614:|AM6PR05MB6614:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB6614CF21D10A3E78D27AA749D2880@AM6PR05MB6614.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(189003)(199004)(6436002)(305945005)(14454004)(256004)(14444005)(31686004)(8936002)(81156014)(81166006)(110136005)(316002)(54906003)(66946007)(66446008)(64756008)(66556008)(66476007)(446003)(7736002)(25786009)(476003)(6512007)(4744005)(4326008)(66574012)(6116002)(71190400001)(8676002)(36756003)(66066001)(11346002)(5660300002)(76176011)(386003)(2906002)(966005)(229853002)(486006)(3846002)(6246003)(2616005)(99286004)(53546011)(52116002)(6506007)(6486002)(186003)(478600001)(6306002)(86362001)(102836004)(26005)(71200400001)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6614;H:AM6PR05MB5288.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yfl3fIWirQiU9NAY4xSQwq9rUYprpsEbSibnO7R8RfAyWgdM6RTUdsnZrg8ZDTcf6oU0wqgyzHxpsEJkn3O6qkSIMnsNBeKHhj5G2UDFkmT+ALcOpCUzO6DFsCElacu+bY0yykh+Rnfs9kqnIbYtaUc8GX3VPOMUQknrEp8EG0Ajo72+CU5SfuEP9g4ChwDtqYsznMM+myTOOUiBV4M1IXwZbwybW+1NriOCyNCm1XzQdO2s7QbXZ4DAyOwigahh8M9tRg+Ddu6TQpZr/zo85ham3ciAnyMAU0TaK24GPZbgEb+tn7U6436faHJhDTOGspFekJLHDIbpw3DTR7Hinz8kwdAw2/zEw5KJFaCHIk6hoLhL5bn8VMGuC0uNI8wILzuA6/tdZRFH0K6Jklj8QH3yjbu1v5JatIrXtxS8Iwc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <287F364375C271469755202CCF2BD768@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b0a4b7-d0f6-4842-80ad-08d73dec46d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 17:02:11.0417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mXhBa14e5VZOh8aPvXfnmWAoNwoctDAWLciGlIB3e8iVWvvhUCKDqewjU+TYpVEbjZpTom9nS7uQu0/lXFwDnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6614
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8yMC8yMDE5IDQ6MzEgUE0sIFV3ZSBLbGVpbmUtS8O2bmlnIHdyb3RlOg0KPiBBY2NvcmRp
bmcgdG8gVGFsIEdpbGJvYSB0aGUgb25seSBiZW5lZml0IGZyb20gRElNIGNvbWVzIGZyb20gYSBk
cml2ZXINCj4gdGhhdCB1c2VzIGl0LiBTbyBpdCBkb2Vzbid0IG1ha2Ugc2Vuc2UgdG8gbWFrZSB0
aGlzIHN5bWJvbCB1c2VyIHZpc2libGUsDQo+IGluc3RlYWQgYWxsIGRyaXZlcnMgdGhhdCB1c2Ug
aXQgc2hvdWxkIHNlbGVjdCBpdCAoYXMgaXMgYWxyZWFkeSB0aGUgY2FzZQ0KPiBBRkFJQ1QpLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogVXdlIEtsZWluZS1Lw7ZuaWcgPHV3ZUBrbGVpbmUta29lbmln
Lm9yZz4NCj4gLS0tDQo+ICAgbGliL0tjb25maWcgfCAzICstLQ0KPiAgIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9saWIv
S2NvbmZpZyBiL2xpYi9LY29uZmlnDQo+IGluZGV4IGNjMDQxMjRlZDhmNy4uOWZlOGEyMWZkMTgz
IDEwMDY0NA0KPiAtLS0gYS9saWIvS2NvbmZpZw0KPiArKysgYi9saWIvS2NvbmZpZw0KPiBAQCAt
NTU1LDggKzU1NSw3IEBAIGNvbmZpZyBTSUdOQVRVUkUNCj4gICAJICBJbXBsZW1lbnRhdGlvbiBp
cyBkb25lIHVzaW5nIEdudVBHIE1QSSBsaWJyYXJ5DQo+ICAgDQo+ICAgY29uZmlnIERJTUxJQg0K
PiAtCWJvb2wgIkRJTSBsaWJyYXJ5Ig0KPiAtCWRlZmF1bHQgeQ0KPiArCWJvb2wNCj4gICAJaGVs
cA0KPiAgIAkgIER5bmFtaWMgSW50ZXJydXB0IE1vZGVyYXRpb24gbGlicmFyeS4NCj4gICAJICBJ
bXBsZW1lbnRzIGFuIGFsZ29yaXRobSBmb3IgZHluYW1pY2FsbHkgY2hhbmdlIENRIG1vZGVyYXRp
b24gdmFsdWVzDQo+DQpUaGVyZSdzIGEgcGVuZGluZyBzZXJpZXMgdXNpbmcgRElNIHdoaWNoIGRp
ZG4ndCBhZGQgdGhlIHNlbGVjdCBjbGF1c2UgDQpbMV0uIEFydGh1ciwgRllJLiBPdGhlciB0aGFu
IHRoYXQgTEdUTS4NCg0KWzFdIGh0dHBzOi8vd3d3Lm1haWwtYXJjaGl2ZS5jb20vbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZy9tc2czMTQzMDQuaHRtbA0KDQo=
