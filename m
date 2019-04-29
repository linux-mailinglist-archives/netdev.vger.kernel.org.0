Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A6EDD18
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 09:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbfD2HsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 03:48:06 -0400
Received: from mail-eopbgr40046.outbound.protection.outlook.com ([40.107.4.46]:20662
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727362AbfD2HsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 03:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1t0nk+yAaqtWSDf2o19gpVNIlCBzzUmQbvHjaWwO71w=;
 b=a8NO5AH1+T96N2II5MppCIQs8zmydg1t3cM5ToOiI71ZHIPWVnj+BB6HE1hc442jWTlKjkffRKVWpb5GaZzJjD1uOl1dfvJl/m8jpR3xpBkVAGHUERZmtxxI7eHkdTZiaS10cj4mOBwcQRWZoU7jgIYP7Rz5SBb9vjWZhOvL8ZI=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB4202.eurprd04.prod.outlook.com (52.135.131.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Mon, 29 Apr 2019 07:48:00 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81%4]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 07:48:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH] can: flexcan: change .tseg1_min value to 2 in bittiming const
Thread-Topic: [PATCH] can: flexcan: change .tseg1_min value to 2 in bittiming
 const
Thread-Index: AQHU/l/eGgL8EWD7kUani7YEBLcwpw==
Date:   Mon, 29 Apr 2019 07:48:00 +0000
Message-ID: <20190429074551.25754-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR06CA0161.apcprd06.prod.outlook.com
 (2603:1096:1:1e::15) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccc99050-644c-4e96-b572-08d6cc77007f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4202;
x-ms-traffictypediagnostic: DB7PR04MB4202:
x-microsoft-antispam-prvs: <DB7PR04MB42023B651A0EFD68575A1911E6390@DB7PR04MB4202.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(346002)(366004)(199004)(189003)(316002)(54906003)(71200400001)(478600001)(1076003)(110136005)(71190400001)(25786009)(6506007)(81156014)(81166006)(99286004)(8676002)(386003)(2906002)(5660300002)(52116002)(86362001)(2201001)(486006)(4744005)(8936002)(50226002)(97736004)(2501003)(66066001)(64756008)(186003)(66446008)(66946007)(66476007)(73956011)(66556008)(3846002)(36756003)(68736007)(6116002)(14454004)(305945005)(53936002)(4326008)(476003)(14444005)(256004)(2616005)(26005)(6512007)(7736002)(6436002)(102836004)(6486002)(142923001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4202;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gdYCxlYrDMhJSofg/qXKFMb4qqiyl3zIAn6/gbFTXiCqzTqNWB6gb5HDN3C+hwMG06WAdVniAJa47bWqYmATK6UtBZTu7PW8MzV7D3tGQ0A3ph7AmCUBeJUmXmkLWyfRoVhOo71yPcmeZ6kBGPzh5PpdxHafvIoYPj2Lj4bCzX58vbAhmxE65weVm5ojBuVWqpCt08KgoxXUVWbI4JskxKuWve+Nvu0bt+Tz6BT9VxwnahXwVCACH1cYgEYKLga9lIFCV+Yxpi9FcRU4zGqZ2rk5qUub38lQqvZeX2AkbH/ixG/Ru4xscafFTbECBil5ONvtl+lL2sltG/h2xM9Uy8xwd16D9ioBMOJCYWHz4IhqwKP8K/mKRnNZTlQV/S+i33eeIUX9VkFJNOkoRTeMYVBxeatct6wCX/r1H/Q74wk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc99050-644c-4e96-b572-08d6cc77007f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 07:48:00.6251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4202
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGltZSBTZWdtZW50MSh0c2VnMSkgaXMgY29tcG9zZWQgb2YgUHJvcGFnYXRlIFNlZ21lbnQocHJv
cF9zZWcpIGFuZA0KUGhhc2UgU2VnbWVuZzEocGhhc2Vfc2VnMSkuIFRoZSByYW5nZSBvZiBUaW1l
IFNlZ21lbnQxKHBsdXMgMikgaXMgMg0KdXAgdG8gMTYgYWNjb3JkaW5nIHRvIGxhdGVzdCByZWZl
cmVuY2UgbWFudWFsLiBUaGF0IG1lYW5zIHRoZSBtaW5pbXVtDQp2YWx1ZSBvZiBQUk9QU0VHIGFu
ZCBQU0VHMSBiaXQgZmllbGQgaXMgMC4gU28gY2hhbmdlIC50c2VnMSBtaW4gdmFsdWUNCnRvIDIu
DQoNClNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+
DQotLS0NCiBkcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvY2FuL2ZsZXhjYW4uYyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCmluZGV4IGUzNTA4
M2ZmMzFlZS4uMmVhMzVlZjRhYTI3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhj
YW4uYw0KKysrIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KQEAgLTMyNyw3ICszMjcsNyBA
QCBzdGF0aWMgY29uc3Qgc3RydWN0IGZsZXhjYW5fZGV2dHlwZV9kYXRhIGZzbF9sczEwMjFhX3Iy
X2RldnR5cGVfZGF0YSA9IHsNCiANCiBzdGF0aWMgY29uc3Qgc3RydWN0IGNhbl9iaXR0aW1pbmdf
Y29uc3QgZmxleGNhbl9iaXR0aW1pbmdfY29uc3QgPSB7DQogCS5uYW1lID0gRFJWX05BTUUsDQot
CS50c2VnMV9taW4gPSA0LA0KKwkudHNlZzFfbWluID0gMiwNCiAJLnRzZWcxX21heCA9IDE2LA0K
IAkudHNlZzJfbWluID0gMiwNCiAJLnRzZWcyX21heCA9IDgsDQotLSANCjIuMTcuMQ0KDQo=
