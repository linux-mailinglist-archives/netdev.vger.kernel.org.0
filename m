Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE56FF8A3
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 10:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfKQJK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 04:10:58 -0500
Received: from mail-eopbgr40051.outbound.protection.outlook.com ([40.107.4.51]:36046
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726020AbfKQJK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Nov 2019 04:10:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpBlQf6SoyBaibTOOOl2Ryl5KvbuFdQGJurXvwIwRsYtQXj3lS9ajBYC4WXYyjwCeSOwYD+zPB3qvPML0PUboD1yYIOfIKjKqewiSt8INiUzZxzzyCFOSWWKjIGGe5ZJTADGz2P9ZcGv2omygRwqqHEgZ8jxgf75LqythYHtxL69O9+YSgGL/e0JsmecqtKrlxH3GgZ3yJ+cabbKnzeCjpx7UJATdU2PaRtABRKEnZx9nDI39vbQZCY3TY6g7i8HiBu7ys16mtptjNnBCLo3D+gNlKQswoZyZZGZuCnyDt8TnQjYnjIVyR4J2FN6bbIK7W4mDwXtV1fAwBTecXmXpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+WtvLePHdLpsip5I/mt6s4bJhPD+x3GM4jGd1LWl0k=;
 b=lE1xX8X1f8r40HK17UIhySBvmHjP+UKvgkOizWoLgfVLVKxqv7xXn1nmtKMqlhCLosHvWYvZPbLb2Hb5b4C/qnMc9O9zrTbIKYxAG65a3aTwBbKzq1wFG128sNpd2YNcwvdoQ70NbHAD3mUrX4d+TKkmVehumxPNtAQWxopuraizTPm3xf/+zwF6/Q28gdAeQDULIgNZkrDR5SecZDxTV/AfAg3LSM21bJinaxOkz0c3W2Ofmq+Pq4/h0P0oUj21D3fHLjlyNg8+ZaUpRmEcmAn1+Ibbih7fnOhxsDwSPz1j+KaIV40+dbHiubgPeYUCWkyF6O4Sm1jRh1PFyw+Slw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+WtvLePHdLpsip5I/mt6s4bJhPD+x3GM4jGd1LWl0k=;
 b=YfWOWWrU/AdFMBPkzBrsPlh3qEujdARflWeE4c2HS+sjJQi7pvLxJTVgQra0nEw/w2O3bHkZy5DP/6SMiJbi7wkg4EONF+W2kFh+EJU5B18m7p7JYdFrlSwAnyTileVNMroBmtxeJdtimaC0ryyo8q9PValLQAt1UbxRWpTleLw=
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com (52.135.161.31) by
 AM6PR05MB4808.eurprd05.prod.outlook.com (20.177.35.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Sun, 17 Nov 2019 09:10:54 +0000
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::8435:9f63:f8da:650e]) by AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::8435:9f63:f8da:650e%7]) with mapi id 15.20.2451.029; Sun, 17 Nov 2019
 09:10:54 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
Subject: Re: [PATCH iproute2 v2 1/5] tc_util: introduce a function to print
 JSON/non-JSON masked numbers
Thread-Topic: [PATCH iproute2 v2 1/5] tc_util: introduce a function to print
 JSON/non-JSON masked numbers
Thread-Index: AQHVmulYZj4sP5iXt06hRmIbzuX7rKeLTHSAgAPLioA=
Date:   Sun, 17 Nov 2019 09:10:54 +0000
Message-ID: <925c9c76-22c3-a585-548c-7baa20fcdf3c@mellanox.com>
References: <20191114124441.2261-1-roid@mellanox.com>
 <20191114124441.2261-2-roid@mellanox.com>
 <20191114151335.45fe076e@hermes.lan>
In-Reply-To: <20191114151335.45fe076e@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
x-clientproxiedby: AM4PR0701CA0012.eurprd07.prod.outlook.com
 (2603:10a6:200:42::22) To AM6PR05MB4198.eurprd05.prod.outlook.com
 (2603:10a6:209:40::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f2d28561-408c-49c3-d3de-08d76b3e0cca
x-ms-traffictypediagnostic: AM6PR05MB4808:|AM6PR05MB4808:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB4808C0C6AB3D12CF74B2C366B5720@AM6PR05MB4808.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 02243C58C6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39850400004)(346002)(366004)(376002)(199004)(189003)(11346002)(6486002)(5660300002)(8676002)(81156014)(81166006)(31686004)(478600001)(36756003)(8936002)(14454004)(4001150100001)(6116002)(186003)(7736002)(66446008)(66946007)(66476007)(66556008)(64756008)(102836004)(53546011)(6506007)(386003)(2906002)(26005)(54906003)(58126008)(256004)(76176011)(52116002)(25786009)(6916009)(316002)(305945005)(3846002)(558084003)(2616005)(446003)(476003)(486006)(71200400001)(66066001)(86362001)(6512007)(4326008)(229853002)(31696002)(6246003)(107886003)(6436002)(65956001)(99286004)(65806001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4808;H:AM6PR05MB4198.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HY1cMGa/1WKrk/gNgSCHJW+M3ihORgMfDnoiwzvHPpVCjrHoM7M92YGQ2YwaEG+fo5pCtN/GJfilTN2IDGD/Ku7JolwlUCzCXSHdN2oozba77ZHeGRKUGz4f391E+U3CaZYhylIKCZEz5F79Rw+KRVPBLWmqbQTS2ypfok8f15j7vggLDUwq3Ghrko7ypJzr8COVuU2/Hjz+p6zAfPyqKAyq9Lc7kOm/UCwW9hxoGub6Ar2HzB49nIuTViXpXN4+IM6Tj231CpfTHOdb35aydL2JXVRtNJKJ1QgoCCTFVhTax0+cTi6cxVX8yXRJK2x6ISgi9JVLH8KOTrDvFjLAOCkTC24VDEeCIJo21yVK4bo+9JZ0JacWiGkb4gr7N5f2Y0FfU2mCdkg6Qk0YrarkyNIaTHYDvG2bJLZV3Xkj7OJleFuH1n0oLJdrDMbT4p/a
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC3C925034A5604EAD18D6FFD896E7E6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d28561-408c-49c3-d3de-08d76b3e0cca
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2019 09:10:54.4966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5zkAMkAGV+wWTB6UvWYRSKGKmUz/5EmTlt99UlXaxPBYRmZW/OfFhGxsO81SeWCMzX6cwVk8NX6Zu6i9aKwBzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4808
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMTktMTEtMTUgMToxMyBBTSwgU3RlcGhlbiBIZW1taW5nZXIgd3JvdGU6DQo+IE9u
IFRodSwgMTQgTm92IDIwMTkgMTQ6NDQ6MzcgKzAyMDANCj4gUm9pIERheWFuIDxyb2lkQG1lbGxh
bm94LmNvbT4gd3JvdGU6DQo+IA0KPj4gKwkJCXByaW50X3N0cmluZyhQUklOVF9GUCwgTlVMTCwg
IiVzICAiLCBfU0xfKTsNCj4gDQo+IE1heWJlIHVzZSBwcmludF9ubCgpIGJ1dCB5b3UgZG9uJ3Qg
aGF2ZSB0by4NCj4gDQoNCkkgYWxzbyBuZWVkIHRoZSAyIHNwYWNlcyBmb3IgaW5kZW50YXRpb24g
aGVyZS4NCg==
