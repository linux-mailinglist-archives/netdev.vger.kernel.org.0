Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E2D27467
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbfEWCda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:33:30 -0400
Received: from mail-eopbgr40063.outbound.protection.outlook.com ([40.107.4.63]:4985
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727305AbfEWCd3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 22:33:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2pK2nk+jKWXtZXdvMZZ3y8Ol+oaNT6tFDKhSdeVfHI=;
 b=k663+5f2Q231UU38NjSEWWeaDUivRdcGOt/PwSTQd/388AYdqJL+g5oHcYhExYIkAzR3q64G2IRs88pNBUfhxk4JXN/CD9rEv3FCm/zt4dGjK0HXKPPHyCLmLxHcmA1Km/pfaGvUFc3KYWLPM+kxCZZSnQU/Ssidh447Bsl2/BE=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2494.eurprd04.prod.outlook.com (10.168.65.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 23 May 2019 02:33:25 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1922.016; Thu, 23 May 2019
 02:33:25 +0000
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
Subject: [PATCH net-next v2, 0/4] ENETC: support hardware timestamping
Thread-Topic: [PATCH net-next v2, 0/4] ENETC: support hardware timestamping
Thread-Index: AQHVEQ/lOru7YbqaqUKfl9qTVlpeDA==
Date:   Thu, 23 May 2019 02:33:24 +0000
Message-ID: <20190523023451.2933-1-yangbo.lu@nxp.com>
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
x-ms-office365-filtering-correlation-id: c2e3befc-ba54-4aac-9fb5-08d6df27079a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2494;
x-ms-traffictypediagnostic: VI1PR0401MB2494:
x-microsoft-antispam-prvs: <VI1PR0401MB2494730BBFBD78B84F6D6792F8010@VI1PR0401MB2494.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(189003)(199004)(2616005)(54906003)(66066001)(86362001)(478600001)(110136005)(26005)(476003)(52116002)(486006)(8676002)(66476007)(25786009)(81166006)(81156014)(186003)(66946007)(66556008)(64756008)(66446008)(99286004)(73956011)(2906002)(102836004)(3846002)(6116002)(6512007)(386003)(53936002)(2501003)(6506007)(256004)(14444005)(36756003)(68736007)(50226002)(305945005)(6486002)(7736002)(8936002)(71200400001)(71190400001)(6636002)(5660300002)(316002)(1076003)(14454004)(4326008)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2494;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4UB/wrpE2ABEeUwvDWknJ5GvAcSjcW24nZjCDsO1kCOuY55Eg24gt9x/M34ZDJsen9JYNlacySmrSllk8Dq0oe+ZzWHLqILw5P+E14iZ6MACzuEvT4+xjhvVjJGMcED/jaRZ3scCj2L+XyQ78tSsN/VLiY8srgrBIGaZ+ZVA5SVH6iG4hOiQAg7fTszLMBxa8IiMbIxayKOyMcpucXxQ+Ch3NWRNF4j76PBEjfARupmHnVGQ15G3ptV65cUQzKtallGlHrYWdseX9O1AzEnb0ohdI/l7tbA3vslR41ICW9mzUvC5vThaZQ0dBdK61sttwZQ6B5WD0dnEl8s/5hyELJhSgi+L/M4fLEEVoqret13GsiqE0LdHFuj8izDqwVyw0MIgJ1fsh9U4p7pjKneAInBzjZyaGsG+R0DDQe3iW3o=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2e3befc-ba54-4aac-9fb5-08d6df27079a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 02:33:25.0872
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

VGhpcyBwYXRjaC1zZXQgaXMgdG8gc3VwcG9ydCBoYXJkd2FyZSB0aW1lc3RhbXBpbmcgZm9yIEVO
RVRDDQphbmQgYWxzbyB0byBhZGQgRU5FVEMgMTU4OCB0aW1lciBkZXZpY2UgdHJlZSBub2RlIGZv
ciBsczEwMjhhLg0KDQpCZWNhdXNlIHRoZSBFTkVUQyBSWCBCRCByaW5nIGR5bmFtaWMgYWxsb2Nh
dGlvbiBoYXMgbm90IGJlZW4NCnN1cHBvcnRlZCBhbmQgaXQgaXMgdG9vIGV4cGVuc2l2ZSB0byB1
c2UgZXh0ZW5kZWQgUlggQkRzDQppZiB0aW1lc3RhbXBpbmcgaXMgbm90IHVzZWQsIGEgS2NvbmZp
ZyBvcHRpb24gaXMgdXNlZCB0bw0KZW5hYmxlIGV4dGVuZGVkIFJYIEJEcyBpbiBvcmRlciB0byBz
dXBwb3J0IGhhcmR3YXJlDQp0aW1lc3RhbXBpbmcuIFRoaXMgb3B0aW9uIHdpbGwgYmUgcmVtb3Zl
ZCBvbmNlIFJYIEJEDQpyaW5nIGR5bmFtaWMgYWxsb2NhdGlvbiBpcyBpbXBsZW1lbnRlZC4NCg0K
WWFuZ2JvIEx1ICg0KToNCiAgZW5ldGM6IGFkZCBoYXJkd2FyZSB0aW1lc3RhbXBpbmcgc3VwcG9y
dA0KICBlbmV0YzogYWRkIGdldF90c19pbmZvIGludGVyZmFjZSBmb3IgZXRodG9vbA0KICBkdC1i
aW5kaW5nOiBwdHBfcW9yaXE6IHN1cHBvcnQgRU5FVEMgUFRQIGNvbXBhdGlibGUNCiAgYXJtNjQ6
IGR0czogZnNsOiBsczEwMjhhOiBhZGQgRU5FVEMgMTU4OCB0aW1lciBub2RlDQoNCiAuLi4vZGV2
aWNldHJlZS9iaW5kaW5ncy9wdHAvcHRwLXFvcmlxLnR4dCAgICAgfCAgIDEgKw0KIC4uLi9hcm02
NC9ib290L2R0cy9mcmVlc2NhbGUvZnNsLWxzMTAyOGEuZHRzaSB8ICAgNiArDQogZHJpdmVycy9u
ZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL0tjb25maWcgIHwgIDEwICsrDQogZHJpdmVycy9u
ZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjLmMgIHwgMTU4ICsrKysrKysrKysrKysr
KysrLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Yy5oICB8ICAx
NSArLQ0KIC4uLi9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfZXRodG9vbC5jICB8ICAz
MSArKysrDQogLi4uL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfaHcuaCAgIHwg
IDEzICsrDQogLi4uL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcGYuYyAgIHwg
ICAxICsNCiAuLi4vbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19wdHAuYyAgfCAg
IDUgKw0KIC4uLi9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX3ZmLmMgICB8ICAg
MSArDQogMTAgZmlsZXMgY2hhbmdlZCwgMjM1IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0p
DQoNCi0tIA0KMi4xNy4xDQoNCg==
