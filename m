Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 275AC20306
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 11:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfEPJ7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 05:59:22 -0400
Received: from mail-eopbgr50067.outbound.protection.outlook.com ([40.107.5.67]:6097
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726374AbfEPJ7U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 05:59:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oqcAU1kVA1ub98bL2yBCizXoCsaLON2Rz+UkYSGjL8=;
 b=QknrASxbeZdxd3FgSNZglSe32RRmKlVb+V1bq5twq+V5mhSmJu6wy6AT+sX98W2/qgGwCo6aUGw+OD4rvz6WdowF4lpVcrw6keTAiCyTtNXSqsHK8VPzf9Z2SeIg8nBjl12rI+azo90CwpXiWkwQSgK7f9UYe/vSAR2BgSkIhIo=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2445.eurprd04.prod.outlook.com (10.168.64.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.24; Thu, 16 May 2019 09:59:17 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1900.010; Thu, 16 May 2019
 09:59:17 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>
Subject: [PATCH 3/3] arm64: dts: fsl: ls1028a: add ENETC 1588 timer node
Thread-Topic: [PATCH 3/3] arm64: dts: fsl: ls1028a: add ENETC 1588 timer node
Thread-Index: AQHVC84G1nIRmQ4iwECD7FOpa1iiEg==
Date:   Thu, 16 May 2019 09:59:17 +0000
Message-ID: <20190516100028.48256-4-yangbo.lu@nxp.com>
References: <20190516100028.48256-1-yangbo.lu@nxp.com>
In-Reply-To: <20190516100028.48256-1-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HK2PR0302CA0017.apcprd03.prod.outlook.com
 (2603:1096:202::27) To VI1PR0401MB2237.eurprd04.prod.outlook.com
 (2603:10a6:800:27::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f54b599-2ff1-481c-9f10-08d6d9e5283b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2445;
x-ms-traffictypediagnostic: VI1PR0401MB2445:
x-microsoft-antispam-prvs: <VI1PR0401MB244504AE692A8FD3A97135EEF80A0@VI1PR0401MB2445.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:296;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(376002)(136003)(396003)(346002)(199004)(189003)(6506007)(99286004)(386003)(14454004)(76176011)(52116002)(5660300002)(54906003)(4326008)(478600001)(316002)(102836004)(66066001)(6116002)(3846002)(2906002)(68736007)(36756003)(71200400001)(4744005)(8936002)(53936002)(256004)(64756008)(66556008)(66476007)(73956011)(66446008)(66946007)(486006)(6512007)(7736002)(446003)(8676002)(186003)(11346002)(476003)(2616005)(71190400001)(305945005)(2501003)(25786009)(26005)(86362001)(6436002)(6486002)(110136005)(81156014)(81166006)(50226002)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2445;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cADOvOveZ3jcgAiJerPAVu0cApHIkVtVzvjaB334UfTrzf6WkT+xTXO0VEPTcFE+9BkZt2LqxkdWga7LC4aEzHm8FgvlG4okrcTBtkBB2+JmexGaVjIpHgdcWdGbKKyI7L3VsjY93/K7X+s0yJ+nCkaJhVXeYIy0CEV2232BxHvxjnah+B9aigLAUN2b9XBpkMDMtHkOw4hV50URxe3cg6tSm7Up+W3m5M37cTwO4JZGNwY4+AVtjTzQcZVTTgn40DlJugwFKWBmWeMtRaJPkZ/LjAqdBXTh4V6xbzQSPekDUf/z1dfBC5eMnfFw9T0Q8kDL+ijKhf02IboTExGKM8EeXRj3WbpwSlKxH1dcCRKS4Q6m9zeWyBODA9++um+3YsqtpaWmNRsUOaFSqQPmGPDs/vmbCeZTWcl+BYdCujo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f54b599-2ff1-481c-9f10-08d6d9e5283b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 09:59:17.0972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWRkIEVORVRDIDE1ODggdGltZXIgbm9kZSB3aGljaCBpcyBFTkVUQyBQRiA0IChQaHlzaXNjYWwg
RnVuY3Rpb24gNCkuDQoNClNpZ25lZC1vZmYtYnk6IFlhbmdibyBMdSA8eWFuZ2JvLmx1QG54cC5j
b20+DQotLS0NCiBhcmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9mc2wtbHMxMDI4YS5kdHNp
IHwgNSArKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdp
dCBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2ZzbC1sczEwMjhhLmR0c2kgYi9hcmNo
L2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9mc2wtbHMxMDI4YS5kdHNpDQppbmRleCAyODk2YmJj
ZmEzYmIuLmQ3MzJhNjM3NTRmYiAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvZnJl
ZXNjYWxlL2ZzbC1sczEwMjhhLmR0c2kNCisrKyBiL2FyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNj
YWxlL2ZzbC1sczEwMjhhLmR0c2kNCkBAIC0zNjksNiArMzY5LDExIEBADQogCQkJCWNvbXBhdGli
bGUgPSAiZnNsLGVuZXRjIjsNCiAJCQkJcmVnID0gPDB4MDAwMTAwIDAgMCAwIDA+Ow0KIAkJCX07
DQorCQkJZXRoZXJuZXRAMCw0IHsgLyogUFRQIGNsb2NrICovDQorCQkJCXJlZyA9IDwweDAwMDQw
MCAwIDAgMCAwPjsNCisJCQkJY2xvY2tzID0gPCZjbG9ja2dlbiA0IDA+Ow0KKwkJCQlsaXR0bGUt
ZW5kaWFuOw0KKwkJCX07DQogCQl9Ow0KIAl9Ow0KIH07DQotLSANCjIuMTcuMQ0KDQo=
