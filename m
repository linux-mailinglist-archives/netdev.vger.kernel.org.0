Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 594EB19BEC
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 12:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfEJKuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 06:50:20 -0400
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:55334
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727306AbfEJKuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 06:50:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9s1k83tfSSXrfmaFecURrw9Z9ao8eKIpTq1P6iK+EeM=;
 b=JjC85dB/nD2PVi7hVUkEuEJrQSV/lbEw2bTdQPJb17lU+40uAnLxcZ/bvReuwlB9+ea0b3Blpgv4HKk/+ekm2SrONC9Q02emmD3gHEMV7eolBqGFON7vaA4j/OiZmO/Al+2mT89L7zxG/nIhBmYEHKPEC+kA1c3BbqI8ZEf2nFI=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB5994.eurprd04.prod.outlook.com (20.178.107.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Fri, 10 May 2019 10:50:14 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81%5]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 10:50:14 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan-gabriel Mirea <stefan-gabriel.mirea@nxp.com>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 7/7] can: flexcan: add imx8qm support
Thread-Topic: [PATCH V3 7/7] can: flexcan: add imx8qm support
Thread-Index: AQHVBx4lLqfA1CIa+0OOGVBloa2eDQ==
Date:   Fri, 10 May 2019 10:50:14 +0000
Message-ID: <20190510104639.15170-8-qiangqing.zhang@nxp.com>
References: <20190510104639.15170-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190510104639.15170-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR01CA0105.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::31) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9edfefb0-aae3-4ef1-6dad-08d6d5354810
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5994;
x-ms-traffictypediagnostic: DB7PR04MB5994:
x-microsoft-antispam-prvs: <DB7PR04MB5994AD44C57995ABD41AE283E60C0@DB7PR04MB5994.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:205;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(136003)(376002)(366004)(189003)(199004)(54534003)(14454004)(11346002)(478600001)(66066001)(4326008)(66556008)(64756008)(66446008)(53936002)(66476007)(8936002)(81166006)(6436002)(81156014)(25786009)(8676002)(1076003)(6486002)(2501003)(6116002)(3846002)(186003)(2906002)(50226002)(305945005)(73956011)(71190400001)(6512007)(71200400001)(446003)(66946007)(5660300002)(54906003)(2616005)(476003)(36756003)(86362001)(26005)(110136005)(7736002)(76176011)(102836004)(386003)(68736007)(99286004)(52116002)(6506007)(486006)(256004)(316002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5994;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZAue1AKki2npEIAKZ2Fh1J6r92ik6bZPK0fTEA1445Mk1MboQaR1mpEWYExsK/92YEoAVaVM2ycm/TYzbQ/eRp2mAUEhrInNvngHOCou8wOVyrzyy/2QdjHAx0/cCquTAaPfkc1qdAfgBggRxtnY2XWZG7Sn/bnNMKbSX8W4R4uEVVVyE2iz4YmDM19W/dT7HSmFV7Akgi6Rvu6/7KPTl2rDG23nQ5X1/77exagYpYILyxU3hHUvo2U4KvpqwbdhrwITn3BThkzHgESwRvY9L+ftjrBvOATAX18JAplTKrhrojV1ZZPDs1Wpr2KB1dc0c3opU0fzNPXBTEFNgzLgEDwuJw8+GwR/wJTBm/75EDKTE4sTlEIOQ6kNb5IjKfyZnEUkUWO9mLSbZVj+tY6xLpLCfCcXAbWP5sB62d/3TPI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9edfefb0-aae3-4ef1-6dad-08d6d5354810
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 10:50:14.1475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5994
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRG9uZyBBaXNoZW5nIDxhaXNoZW5nLmRvbmdAbnhwLmNvbT4NCg0KVGhlIEZsZXhjYW4g
b24gaS5NWDhRTSBzdXBwb3J0cyBDQU4gRkQgcHJvdG9jb2wuDQoNClNpZ25lZC1vZmYtYnk6IERv
bmcgQWlzaGVuZyA8YWlzaGVuZy5kb25nQG54cC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBKb2FraW0g
WmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KDQpDaGFuZ2VMb2c6DQotLS0tLS0tLS0t
DQpWMS0+VjI6DQoJKk5vbmUNClYyLT5WMzoNCgkqTm9uZQ0KLS0tDQogZHJpdmVycy9uZXQvY2Fu
L2ZsZXhjYW4uYyB8IDcgKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKykN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgYi9kcml2ZXJzL25ldC9j
YW4vZmxleGNhbi5jDQppbmRleCBlZDM0NjM1ODJkYzEuLmZiMGNhOTIxYWY0MSAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCisrKyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4
Y2FuLmMNCkBAIC0zNDYsNiArMzQ2LDEyIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmxleGNhbl9k
ZXZ0eXBlX2RhdGEgZnNsX2lteDZxX2RldnR5cGVfZGF0YSA9IHsNCiAJCUZMRVhDQU5fUVVJUktf
U0VUVVBfU1RPUF9NT0RFLA0KIH07DQogDQorc3RhdGljIHN0cnVjdCBmbGV4Y2FuX2RldnR5cGVf
ZGF0YSBmc2xfaW14OHFtX2RldnR5cGVfZGF0YSA9IHsNCisJLnF1aXJrcyA9IEZMRVhDQU5fUVVJ
UktfRElTQUJMRV9SWEZHIHwgRkxFWENBTl9RVUlSS19FTkFCTEVfRUFDRU5fUlJTIHwNCisJCUZM
RVhDQU5fUVVJUktfVVNFX09GRl9USU1FU1RBTVAgfCBGTEVYQ0FOX1FVSVJLX0JST0tFTl9QRVJS
X1NUQVRFIHwNCisJCUZMRVhDQU5fUVVJUktfVElNRVNUQU1QX1NVUFBPUlRfRkQsDQorfTsNCisN
CiBzdGF0aWMgY29uc3Qgc3RydWN0IGZsZXhjYW5fZGV2dHlwZV9kYXRhIGZzbF92ZjYxMF9kZXZ0
eXBlX2RhdGEgPSB7DQogCS5xdWlya3MgPSBGTEVYQ0FOX1FVSVJLX0RJU0FCTEVfUlhGRyB8IEZM
RVhDQU5fUVVJUktfRU5BQkxFX0VBQ0VOX1JSUyB8DQogCQlGTEVYQ0FOX1FVSVJLX0RJU0FCTEVf
TUVDUiB8IEZMRVhDQU5fUVVJUktfVVNFX09GRl9USU1FU1RBTVAgfA0KQEAgLTE2NjcsNiArMTY3
Myw3IEBAIHN0YXRpYyBpbnQgZmxleGNhbl9zZXR1cF9zdG9wX21vZGUoc3RydWN0IHBsYXRmb3Jt
X2RldmljZSAqcGRldikNCiB9DQogDQogc3RhdGljIGNvbnN0IHN0cnVjdCBvZl9kZXZpY2VfaWQg
ZmxleGNhbl9vZl9tYXRjaFtdID0gew0KKwl7IC5jb21wYXRpYmxlID0gImZzbCxpbXg4cW0tZmxl
eGNhbiIsIC5kYXRhID0gJmZzbF9pbXg4cW1fZGV2dHlwZV9kYXRhLCB9LA0KIAl7IC5jb21wYXRp
YmxlID0gImZzbCxpbXg2cS1mbGV4Y2FuIiwgLmRhdGEgPSAmZnNsX2lteDZxX2RldnR5cGVfZGF0
YSwgfSwNCiAJeyAuY29tcGF0aWJsZSA9ICJmc2wsaW14MjgtZmxleGNhbiIsIC5kYXRhID0gJmZz
bF9pbXgyOF9kZXZ0eXBlX2RhdGEsIH0sDQogCXsgLmNvbXBhdGlibGUgPSAiZnNsLGlteDUzLWZs
ZXhjYW4iLCAuZGF0YSA9ICZmc2xfaW14MjVfZGV2dHlwZV9kYXRhLCB9LA0KLS0gDQoyLjE3LjEN
Cg0K
