Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45EAD27470
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbfEWCdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:33:42 -0400
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:48628
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729758AbfEWCdk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 22:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSCRX/iWQWoOywrl507vvHpJX9P3wtsR2zPZRa9GvKs=;
 b=Q0WO4E8A/WftNn5jUu7E0qnZgpirSjyiBoGuAtjOpmqh98PQ2OLRS0XiHbFs64aTcodfFvSliBFG+i+wTqJXCBkvV2V5Tzn5+9/LtrnOLZNm0T4j0i7WzKZVdvkGlQSp3kZMeuj1BmoFwj5PgEGG1cSvCLwc8NjhzYC+1biqn5Q=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2494.eurprd04.prod.outlook.com (10.168.65.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 23 May 2019 02:33:37 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1922.016; Thu, 23 May 2019
 02:33:37 +0000
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
Subject: [PATCH net-next v2, 3/4] dt-binding: ptp_qoriq: support ENETC PTP
 compatible
Thread-Topic: [PATCH net-next v2, 3/4] dt-binding: ptp_qoriq: support ENETC
 PTP compatible
Thread-Index: AQHVEQ/sPIwjwaBKUU205KdojZp6zA==
Date:   Thu, 23 May 2019 02:33:37 +0000
Message-ID: <20190523023451.2933-4-yangbo.lu@nxp.com>
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
x-ms-office365-filtering-correlation-id: 59f168cd-61ff-4a74-1183-08d6df270f2d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2494;
x-ms-traffictypediagnostic: VI1PR0401MB2494:
x-microsoft-antispam-prvs: <VI1PR0401MB249421C30704457131B3C353F8010@VI1PR0401MB2494.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(189003)(199004)(2616005)(54906003)(66066001)(86362001)(478600001)(110136005)(26005)(476003)(52116002)(486006)(76176011)(8676002)(66476007)(25786009)(81166006)(81156014)(186003)(66946007)(66556008)(64756008)(66446008)(99286004)(73956011)(2906002)(102836004)(3846002)(6116002)(6512007)(386003)(53936002)(2501003)(6506007)(256004)(36756003)(68736007)(50226002)(305945005)(6486002)(7736002)(8936002)(71200400001)(71190400001)(6636002)(5660300002)(316002)(1076003)(4744005)(14454004)(446003)(4326008)(11346002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2494;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aPQx1Kau5uvciwrPimL69Lk17X8sFM9FOyDjdCtFHlyteQ526K2lkiMMFE1GOAdGnjYOnhulFHORaXxUehIH7YapDk8VSHzI5+yhfFti4cgGpT6h7mnS8p4TJ+9ZXj42XGXQpUQex3HkSp5hOUWN+Gh63rfL3RH4LQ4OuylF1zTyvom7aOIG5I9IpBUXG8u0NeP0Wvtn79H/6vLG7fC3b7ALhqUcOKgj4TeEcP60KJRHhs1PLLGz1tYE+Z7IMW+YwWYprUiRv5u1KYlTyV0idY8+nzrnuLKUetwhKG4M8ecLtzrdVcxEAQJapSojD2IDRzZlko6uuvaEeMcG1JrCKRVRN3EPJWSSHCYtqTjEQTAK43pctdiCa8gWcnkOrDMOVaNrTfHhMTL4uwu+PiCEtP7e+7pn/Qv2ukIHzYWrSBw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f168cd-61ff-4a74-1183-08d6df270f2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 02:33:37.5818
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

QWRkIGEgbmV3IGNvbXBhdGlibGUgZm9yIEVORVRDIFBUUC4NCg0KU2lnbmVkLW9mZi1ieTogWWFu
Z2JvIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCi0tLQ0KQ2hhbmdlcyBmb3IgdjI6DQoJLSBBZGRl
ZCB0aGlzIHBhdGNoLg0KLS0tDQogRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3B0
cC9wdHAtcW9yaXEudHh0IHwgMSArDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQoN
CmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvcHRwL3B0cC1x
b3JpcS50eHQgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvcHRwL3B0cC1xb3Jp
cS50eHQNCmluZGV4IDQ1NGM5MzcwNzZhMi4uNmVjMDUzNDQ5Mjc4IDEwMDY0NA0KLS0tIGEvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3B0cC9wdHAtcW9yaXEudHh0DQorKysgYi9E
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvcHRwL3B0cC1xb3JpcS50eHQNCkBAIC00
LDYgKzQsNyBAQCBHZW5lcmFsIFByb3BlcnRpZXM6DQogDQogICAtIGNvbXBhdGlibGUgICBTaG91
bGQgYmUgImZzbCxldHNlYy1wdHAiIGZvciBlVFNFQw0KICAgICAgICAgICAgICAgICAgU2hvdWxk
IGJlICJmc2wsZm1hbi1wdHAtdGltZXIiIGZvciBEUEFBIEZNYW4NCisJCSBTaG91bGQgYmUgImZz
bCxlbmV0Yy1wdHAiIGZvciBFTkVUQw0KICAgLSByZWcgICAgICAgICAgT2Zmc2V0IGFuZCBsZW5n
dGggb2YgdGhlIHJlZ2lzdGVyIHNldCBmb3IgdGhlIGRldmljZQ0KICAgLSBpbnRlcnJ1cHRzICAg
VGhlcmUgc2hvdWxkIGJlIGF0IGxlYXN0IHR3byBpbnRlcnJ1cHRzLiBTb21lIGRldmljZXMNCiAg
ICAgICAgICAgICAgICAgIGhhdmUgYXMgbWFueSBhcyBmb3VyIFBUUCByZWxhdGVkIGludGVycnVw
dHMuDQotLSANCjIuMTcuMQ0KDQo=
