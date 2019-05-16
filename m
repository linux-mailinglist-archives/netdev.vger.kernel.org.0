Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E9F202FD
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 11:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfEPJ7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 05:59:08 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:5201
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbfEPJ7I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 05:59:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQye0XYGDhY/V2eNEpm+XUPUaowSGWduKigo6cr4DVE=;
 b=oLi3RECuuykNEG7GrQNE8dfq672wfCjFT9mm+urW3oXwBtMTL5htgclT4CVmcDDbiusz/R30nrYsdhfyiEphh+KKMBcfch9B901JfaQwLN7vkOcuRaWMdEicfH+vbmSK/xIPtNJawz+rY3eldfcakvn0UgF6xvXweQ135Ym+BX8=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2637.eurprd04.prod.outlook.com (10.168.61.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.24; Thu, 16 May 2019 09:59:04 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1900.010; Thu, 16 May 2019
 09:59:04 +0000
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
Subject: [PATCH 0/3] ENETC: support hardware timestamping
Thread-Topic: [PATCH 0/3] ENETC: support hardware timestamping
Thread-Index: AQHVC83+OKxQcRjJ5kqAZ0JrDGOFvA==
Date:   Thu, 16 May 2019 09:59:04 +0000
Message-ID: <20190516100028.48256-1-yangbo.lu@nxp.com>
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
x-ms-office365-filtering-correlation-id: 86b880af-a1be-4ed7-bbf8-08d6d9e520a6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2637;
x-ms-traffictypediagnostic: VI1PR0401MB2637:
x-microsoft-antispam-prvs: <VI1PR0401MB2637642DB7DD1BD6F083FE43F80A0@VI1PR0401MB2637.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(39860400002)(136003)(366004)(346002)(189003)(199004)(52116002)(7736002)(3846002)(6116002)(14454004)(8936002)(81166006)(305945005)(81156014)(8676002)(36756003)(5660300002)(316002)(2616005)(476003)(6486002)(68736007)(6512007)(6436002)(486006)(25786009)(66066001)(66476007)(1076003)(66446008)(66556008)(64756008)(2906002)(386003)(6506007)(71190400001)(71200400001)(256004)(86362001)(4326008)(186003)(53936002)(50226002)(99286004)(110136005)(54906003)(66946007)(26005)(102836004)(478600001)(2501003)(73956011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2637;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JB4b/oQQo4TS1EChMl+ObEXbjX7Z18ddJ+oWSZCh9DQmZO633ORHyryCYIP5XLgom9AwDV41IRJ8YD8U09vbN1sMPLq/XbRo2/3cqXGu8fYB+YwVI83CRoSXZoKMsEyXQwla12S46bE7mrOrcpLyvYuPEI/WvLHj9DywSgcXnn/D7cgkZQDK08rLtj6pKmMGABXkITtVMU63G2l7EgDWXGl0RSXZenF2slLRX1npgF3MrCQSswVKHIKSeyy9+I6RN90exAKZSE5NToBzPXUo20fPZ8+mgSMygUNFf+D/rDRdmvsAfT781vQ6/H/rMPcG/8hycAyegeRqyhpVj8DKwOC7pJs1RyZFVJAv+TJSnpZxJlReFFkXNyK2tkyLnLzi+SOem9s6Rbp0NubQmwOcluMkt+MG+PBL1zsGiCqSv4A=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86b880af-a1be-4ed7-bbf8-08d6d9e520a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 09:59:04.3364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2637
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaC1zZXQgaXMgdG8gc3VwcG9ydCBoYXJkd2FyZSB0aW1lc3RhbXBpbmcgZm9yIEVO
RVRDDQphbmQgYWxzbyB0byBhZGQgMTU4OCB0aW1lciBkZXZpY2UgdHJlZSBub2RlIGZvciBsczEw
MjhhLg0KDQpCZWNhdXNlIEVORVRDIFJYIEJEIHJpbmcgZHluYW1pYyBhbGxvY2F0aW9uIGhhc24n
dCBiZWVuDQpzdXBwb3J0ZWQgYW5kIGl0J3MgdG9vIGV4cGVuc2l2ZSB0byB1c2UgZXh0ZW5kZWQg
UlggQkRzDQppZiB0aW1lc3RhbXBpbmcgaXNuJ3QgdXNlZCwgd2UgaGF2ZSB0byB1c2UgYSBLY29u
ZmlnDQpvcHRpb24gdG8gZW5hYmxlL2Rpc2FibGUgdGltZXN0YW1waW5nIGZvciBub3cuIFRoaXMN
Cktjb25maWcgb3B0aW9uIHdpbGwgYmUgcmVtb3ZlZCBvbmNlIFJYIEJEIHJpbmcgZHluYW1pYw0K
YWxsb2NhdGlvbiBpcyBpbXBsZW1lbnRlZC4NCg0KWWFuZ2JvIEx1ICgzKToNCiAgZW5ldGM6IGFk
ZCBoYXJkd2FyZSB0aW1lc3RhbXBpbmcgc3VwcG9ydA0KICBlbmV0YzogYWRkIGdldF90c19pbmZv
IGludGVyZmFjZSBmb3IgZXRodG9vbA0KICBhcm02NDogZHRzOiBmc2w6IGxzMTAyOGE6IGFkZCBF
TkVUQyAxNTg4IHRpbWVyIG5vZGUNCg0KIC4uLi9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvZnNs
LWxzMTAyOGEuZHRzaSB8ICAgNSArDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2Vu
ZXRjL0tjb25maWcgIHwgIDExICsrDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2Vu
ZXRjL2VuZXRjLmMgIHwgMTU2ICsrKysrKysrKysrKysrKysrLQ0KIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Yy5oICB8ICAxNCArLQ0KIC4uLi9ldGhlcm5ldC9mcmVl
c2NhbGUvZW5ldGMvZW5ldGNfZXRodG9vbC5jICB8ICAzMSArKysrDQogLi4uL25ldC9ldGhlcm5l
dC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfaHcuaCAgIHwgIDEzICsrDQogLi4uL25ldC9ldGhlcm5l
dC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcGYuYyAgIHwgICAxICsNCiAuLi4vbmV0L2V0aGVybmV0
L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19wdHAuYyAgfCAgIDUgKw0KIC4uLi9uZXQvZXRoZXJuZXQv
ZnJlZXNjYWxlL2VuZXRjL2VuZXRjX3ZmLmMgICB8ICAgMSArDQogOSBmaWxlcyBjaGFuZ2VkLCAy
MzEgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE3LjENCg0K
