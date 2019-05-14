Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A365B1C7CC
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 13:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfENL2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 07:28:45 -0400
Received: from mail-eopbgr10055.outbound.protection.outlook.com ([40.107.1.55]:38348
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbfENL2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 07:28:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vshpto2hufvQXaWIe+iXjaoAAOPZQ0pLLHslaRYs/Yw=;
 b=rQzKq18wAzbqTzG+/jWko72E4TjhpC0/4YSzMZEgp4shJNf0Ta3+YlySnMw/8ZdSEQyCx/Mvl6JRcMHB0k/E00dfApG+aT0atTSk89zRcIvBC/fV4IqdYMn7Ffq2DZ3paBQBJfi93Rli4FkOaL0y3OQZR51sDs22IvE7k1Rll0k=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6586.eurprd05.prod.outlook.com (20.179.44.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Tue, 14 May 2019 11:28:41 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::41c9:f567:314b:c042]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::41c9:f567:314b:c042%4]) with mapi id 15.20.1900.010; Tue, 14 May 2019
 11:28:41 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     wangyunjian <wangyunjian@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Tariq Toukan <tariqt@mellanox.com>,
        "xudingke@huawei.com" <xudingke@huawei.com>
Subject: Re: [PATCH net] net/mlx4_core: Change the error print to info print
Thread-Topic: [PATCH net] net/mlx4_core: Change the error print to info print
Thread-Index: AQHVCkS1h3DH9LtXmkOvosoY4d4dWaZqe86A
Date:   Tue, 14 May 2019 11:28:41 +0000
Message-ID: <e68afdbd-49eb-f75a-a6a2-177e873217ab@mellanox.com>
References: <1557831799-15220-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1557831799-15220-1-git-send-email-wangyunjian@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P194CA0090.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::31) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 268b9930-b323-43f8-5eea-08d6d85f50d4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6586;
x-ms-traffictypediagnostic: DBBPR05MB6586:
x-microsoft-antispam-prvs: <DBBPR05MB6586859C3D499AD4C3CD25C3AE080@DBBPR05MB6586.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:590;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(39860400002)(136003)(376002)(199004)(189003)(25786009)(4326008)(71200400001)(99286004)(2501003)(478600001)(52116002)(54906003)(110136005)(71190400001)(53936002)(4744005)(86362001)(14454004)(76176011)(5660300002)(6512007)(8936002)(8676002)(81166006)(81156014)(6246003)(7736002)(6436002)(5024004)(6486002)(305945005)(2906002)(31696002)(6116002)(36756003)(66066001)(31686004)(316002)(229853002)(3846002)(26005)(386003)(53546011)(102836004)(66446008)(486006)(186003)(66946007)(66476007)(73956011)(14444005)(68736007)(66556008)(64756008)(6506007)(11346002)(2616005)(476003)(256004)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6586;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CNEV5+dpTSk/6a+/aN7boXr76JvuaUWmJoaez2Jk6OPsAQxHWM+q01La/IWpz6fHSrCl/Dt+/bw/IE8PyRLTr5q6HALv7QycqA8WprD7xFlqZmCKptJ0mMy/VSciGZscP6B8c4RBXZqeNt45e+YaAU8oft+usuzSmovJ7zG1OzUwdFA/RvgzF4btHLlNQn5n57k9jhPNadoo9enIHtG9XgUmzR9zugvh5DWRE6smBSoI5TvWuEvYQRMVUewtxNvEpb8n7RqPDzM29j+WssPsRqjwA+yU+P9CfA0U+bMx4rbFzIYXQmEguKftvkUjAw8WbVcL5WYqLmdgaZc1q1gUp+TIT5iyykrWv/MvAQYLYHAKBoqirM8ZkyWgvRrnWpKfHz3c1ikBlPnLeLDfXXTfQD8vwrnoKyzaXYzzNMnWCtY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF266BCC3F93874A8AF085DB12B5914D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 268b9930-b323-43f8-5eea-08d6d85f50d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 11:28:41.1213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6586
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMTQvMjAxOSAyOjAzIFBNLCB3YW5neXVuamlhbiB3cm90ZToNCj4gRnJvbTogWXVu
amlhbiBXYW5nIDx3YW5neXVuamlhbkBodWF3ZWkuY29tPg0KPiANCj4gVGhlIGVycm9yIHByaW50
IHdpdGhpbiBtbHg0X2Zsb3dfc3RlZXJfcHJvbWlzY19hZGQoKSBzaG91bGQNCj4gYmUgYSBpbmZv
IHByaW50Lg0KPiANCj4gRml4ZXM6IDU5MmU0OWRkYTgxMiAoJ25ldC9tbHg0OiBJbXBsZW1lbnQg
cHJvbWlzY3VvdXMgbW9kZSB3aXRoIGRldmljZSBtYW5hZ2VkIGZsb3ctc3RlZXJpbmcnKQ0KPiBT
aWduZWQtb2ZmLWJ5OiBZdW5qaWFuIFdhbmcgPHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+DQo+IC0t
LQ0KPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvbWNnLmMgfCAyICstDQo+
ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NC9tY2cuYyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvbWNnLmMNCj4gaW5kZXggZmZlZDJkNC4u
OWM0ODE4MiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NC9tY2cuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L21jZy5j
DQo+IEBAIC0xNDkyLDcgKzE0OTIsNyBAQCBpbnQgbWx4NF9mbG93X3N0ZWVyX3Byb21pc2NfYWRk
KHN0cnVjdCBtbHg0X2RldiAqZGV2LCB1OCBwb3J0LA0KPiAgIAlydWxlLnBvcnQgPSBwb3J0Ow0K
PiAgIAlydWxlLnFwbiA9IHFwbjsNCj4gICAJSU5JVF9MSVNUX0hFQUQoJnJ1bGUubGlzdCk7DQo+
IC0JbWx4NF9lcnIoZGV2LCAiZ29pbmcgcHJvbWlzYyBvbiAleFxuIiwgcG9ydCk7DQo+ICsJbWx4
NF9pbmZvKGRldiwgImdvaW5nIHByb21pc2Mgb24gJXhcbiIsIHBvcnQpOw0KPiAgIA0KPiAgIAly
ZXR1cm4gIG1seDRfZmxvd19hdHRhY2goZGV2LCAmcnVsZSwgcmVnaWRfcCk7DQo+ICAgfQ0KPiAN
Cg0KTEdUTS4NClJldmlld2VkLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5veC5jb20+
DQoNClRoYW5rcywNClRhcmlxDQo=
