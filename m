Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B985E27471
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfEWCdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:33:45 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:31959
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729758AbfEWCdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 22:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b//ZxvIhXEez1zzSZxCUcYIrQDYbYlc30WtJRLcUERU=;
 b=qgq5SILzIokVnyrrljdAetkV5KaiqMsLl0JNpR1di0itL+BeKgFWZrKwHtzpRnuup6YHfcx6eNlxG33hd7Q6NffmoK86boipboHfoQ6bkzUl+mTOPAd6dakoZmqbFwKY/RLbf7fCxY2/U/cv0lVT1MyrhMpk7EH6gUlsD4qIt7c=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2494.eurprd04.prod.outlook.com (10.168.65.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 23 May 2019 02:33:41 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1922.016; Thu, 23 May 2019
 02:33:41 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>
Subject: [PATCH net-next v2, 4/4] arm64: dts: fsl: ls1028a: add ENETC 1588
 timer node
Thread-Topic: [PATCH net-next v2, 4/4] arm64: dts: fsl: ls1028a: add ENETC
 1588 timer node
Thread-Index: AQHVEQ/vPTs5mfNGK0egcnpKtIEjVA==
Date:   Thu, 23 May 2019 02:33:41 +0000
Message-ID: <20190523023451.2933-5-yangbo.lu@nxp.com>
References: <20190523023451.2933-1-yangbo.lu@nxp.com>
In-Reply-To: <20190523023451.2933-1-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HK2PR04CA0053.apcprd04.prod.outlook.com
 (2603:1096:202:14::21) To VI1PR0401MB2237.eurprd04.prod.outlook.com
 (2603:10a6:800:27::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b900c2f2-f138-4b41-fc08-08d6df2711a8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2494;
x-ms-traffictypediagnostic: VI1PR0401MB2494:
x-microsoft-antispam-prvs: <VI1PR0401MB24941CD3ACE777C886CF456DF8010@VI1PR0401MB2494.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(189003)(199004)(2616005)(54906003)(66066001)(86362001)(478600001)(110136005)(26005)(476003)(52116002)(486006)(76176011)(8676002)(66476007)(25786009)(81166006)(81156014)(186003)(66946007)(66556008)(64756008)(66446008)(99286004)(73956011)(2906002)(102836004)(3846002)(6116002)(6512007)(386003)(53936002)(2501003)(6506007)(256004)(36756003)(68736007)(50226002)(305945005)(6486002)(7736002)(8936002)(71200400001)(71190400001)(6636002)(5660300002)(316002)(1076003)(4744005)(14454004)(446003)(4326008)(11346002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2494;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RzUDCbv37KKgNMSS57JeXEGOKzis74x3gW+e4IsK718FidOaRYmDUdGvqaH6zyFbtWVr35E01SQvWbyfWn2kRXMyOkPWAYkZ+ZX0G//vVOZUhFiNS/yytCwyy5uDnyUGLFi7YRl23tXR0v5/33zvPhhRj1a94y64KhsjzTJUY1SZroxE+6Rcw5INI3fEMFz3dJWjdwlEXpbsL2tN+FMrdwPCJiUWMyJlp7kWOLEhsTnqWITxGCgqIlnJsduoxnfCk7WwPEWV8maNJDNQ0jd+M5XIakrL1+ug2yB3PVJMYJLDRDI34VSNoY2BF7677WFkA10+zQR4c8A/f1qovGxrq6m6QGucmGUJZndzPn2yhFpAI0KUkKEoTklW/qDi2yo2i1bsQL4YQ+DDDqLouUMjSXZ9RfmgxCUiKspDicQrqqs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b900c2f2-f138-4b41-fc08-08d6df2711a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 02:33:41.7183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yangbo.lu@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2494
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWRkIEVORVRDIDE1ODggdGltZXIgbm9kZSB3aGljaCBpcyBFTkVUQyBQRiA0IChQaHlzaXNjYWwg
RnVuY3Rpb24gNCkuDQoNClNpZ25lZC1vZmYtYnk6IFlhbmdibyBMdSA8eWFuZ2JvLmx1QG54cC5j
b20+DQotLS0NCkNoYW5nZXMgZm9yIHYyOg0KCS0gQWRkZWQgY29tcGF0aWJsZS4NCi0tLQ0KIGFy
Y2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2ZzbC1sczEwMjhhLmR0c2kgfCA2ICsrKysrKw0K
IDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQvYm9vdC9kdHMvZnJlZXNjYWxlL2ZzbC1sczEwMjhhLmR0c2kgYi9hcmNoL2FybTY0L2Jvb3Qv
ZHRzL2ZyZWVzY2FsZS9mc2wtbHMxMDI4YS5kdHNpDQppbmRleCBiMDQ1ODEyNDlmMGIuLjRjZGY4
NGM2MzMyMCAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2ZzbC1s
czEwMjhhLmR0c2kNCisrKyBiL2FyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2ZzbC1sczEw
MjhhLmR0c2kNCkBAIC00MzEsNiArNDMxLDEyIEBADQogCQkJCWNvbXBhdGlibGUgPSAiZnNsLGVu
ZXRjIjsNCiAJCQkJcmVnID0gPDB4MDAwMTAwIDAgMCAwIDA+Ow0KIAkJCX07DQorCQkJZXRoZXJu
ZXRAMCw0IHsNCisJCQkJY29tcGF0aWJsZSA9ICJmc2wsZW5ldGMtcHRwIjsNCisJCQkJcmVnID0g
PDB4MDAwNDAwIDAgMCAwIDA+Ow0KKwkJCQljbG9ja3MgPSA8JmNsb2NrZ2VuIDQgMD47DQorCQkJ
CWxpdHRsZS1lbmRpYW47DQorCQkJfTsNCiAJCX07DQogCX07DQogfTsNCi0tIA0KMi4xNy4xDQoN
Cg==
