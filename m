Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B4219998
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 10:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfEJIYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 04:24:04 -0400
Received: from mail-eopbgr10057.outbound.protection.outlook.com ([40.107.1.57]:25819
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727333AbfEJIYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 04:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2T/gqJEq1Jk6HRcPvm8YrwqABCoUoiWI0UA0eRQbyf0=;
 b=k7DqQwL5m700FoRDzmMM46lIfmRpzZCUtvP0teYxX5weJSkc+0JeJXtWtGYoEQ1PZCEgL7WY0vWy9JfuBt9DAsYipR3QcrjJRyfWnMHQvpf/B79E/Wo+ShlvKqWT+VIAD03Qf78B5n73jAEQKDw7vJbC9fFirYxtysRsQ7K6fUg=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB2815.eurprd04.prod.outlook.com (10.172.255.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Fri, 10 May 2019 08:23:58 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df%6]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 08:23:58 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Andy Duan <fugang.duan@nxp.com>
Subject: [PATCH net 0/3] add property "nvmem_macaddr_swap" to swap macaddr
 bytes order
Thread-Topic: [PATCH net 0/3] add property "nvmem_macaddr_swap" to swap
 macaddr bytes order
Thread-Index: AQHVBwm3nO3Cplg0XkCqCd45vbl9wg==
Date:   Fri, 10 May 2019 08:23:58 +0000
Message-ID: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: HK2PR02CA0212.apcprd02.prod.outlook.com
 (2603:1096:201:20::24) To VI1PR0402MB3600.eurprd04.prod.outlook.com
 (2603:10a6:803:a::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cccc70e6-b071-482e-10a0-08d6d520d935
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2815;
x-ms-traffictypediagnostic: VI1PR0402MB2815:
x-microsoft-antispam-prvs: <VI1PR0402MB2815A9199272191A2D0E36A1FF0C0@VI1PR0402MB2815.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(396003)(366004)(39860400002)(189003)(199004)(486006)(26005)(6436002)(305945005)(2616005)(6116002)(3846002)(68736007)(316002)(7736002)(386003)(6506007)(6486002)(102836004)(186003)(2906002)(6916009)(50226002)(54906003)(1730700003)(66066001)(66556008)(36756003)(8676002)(66946007)(66476007)(64756008)(2351001)(81156014)(476003)(5660300002)(73956011)(86362001)(66446008)(81166006)(14454004)(478600001)(8936002)(25786009)(5640700003)(256004)(14444005)(6512007)(52116002)(71190400001)(71200400001)(2501003)(53936002)(4326008)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2815;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: k1BOJxoeUc/lfxr3Gv4s474i/eo/lyojMrDwIgXlbRjcT4YLAvkkckkI/g4NDdbeYDVuIcyWCrtkikpC6LJycgHNC6hbcTM+Wjif7+8ldDWGGGi0cZUZ4f9AKPlVcEtmDa3ECqgdV6BUQTVpJPvHg6BoNXbz5o369iUPcPNW3eZWoMX3kq+eezHi5Ex3UsrrYzbWK2g5KCLIkHS//kjiPdyzUFdu5Byjx4CQbFGC/FuL5FV/tzVbaXSg8DTboHm3vvENyqh151IuHkMrz0YBUwqrUoChd4pZrwYtatSipMLaxODSe3pLQfcVbucWUOaEjaoof9PJ/0OIPq3hCGCq7EHQ406Mg4XfJtfrQnLHibYYOXo2mAdhnYaN/9aHHwIJE/ZpPFAijCru4c3wTmtodxA8uEzdl01lFVRc5dDBPzM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cccc70e6-b071-482e-10a0-08d6d520d935
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 08:23:58.4681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2815
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ZXRoZXJuZXQgY29udHJvbGxlciBkcml2ZXIgY2FsbCAub2ZfZ2V0X21hY19hZGRyZXNzKCkgdG8g
Z2V0DQp0aGUgbWFjIGFkZHJlc3MgZnJvbSBkZXZpY3RyZWUgdHJlZSwgaWYgdGhlc2UgcHJvcGVy
dGllcyBhcmUNCm5vdCBwcmVzZW50LCB0aGVuIHRyeSB0byByZWFkIGZyb20gbnZtZW0uIGkuTVg2
eC83RC84TVEvOE1NDQpwbGF0Zm9ybXMgZXRoZXJuZXQgTUFDIGFkZHJlc3MgcmVhZCBmcm9tIG52
bWVtIG9jb3RwIGVGdXNlcywNCmJ1dCBpdCByZXF1aXJlcyB0byBzd2FwIHRoZSBzaXggYnl0ZXMg
b3JkZXIuDQoNClRoZSBwYXRjaCBzZXQgaXMgdG8gYWRkIHByb3BlcnR5ICJudm1lbV9tYWNhZGRy
X3N3YXAiIHRvIHN3YXANCm1hY2FkZHIgYnl0ZXMgb3JkZXIuIElmIE1BQyBhZGRyZXNzIHJlYWQg
ZnJvbSBudm1lbSBjZWxsIGFuZA0KaXQgaXMgdmFsaWQgbWFjIGFkZHJlc3MsIC5vZl9nZXRfbWFj
X2FkZHJfbnZtZW0oKSBhZGQgbmV3IHByb3BlcnR5DQoibnZtZW0tbWFjLWFkZHJlc3MiIGluIGV0
aGVybmV0IG5vZGUuIExhdGVyIHVzZXIgY2FsbA0KLm9mX2dldF9tYWNfYWRkcmVzcygpIHRvIGdl
dCBNQUMgYWRkcmVzcyBhZ2FpbiwgaXQgY2FuIHJlYWQNCnZhbGlkIE1BQyBhZGRyZXNzIGZyb20g
ZGV2aWNlIHRyZWUgaW4gZGlyZWN0bHkuDQoNClVwZGF0ZSB0aGVzZSB0d28gcHJvcGVydGllcyBm
b3IgYmluZGluZyBkb2N1bWVudGF0aW9uLg0KDQoNCkZ1Z2FuZyBEdWFuICgzKToNCiAgbmV0OiBl
dGhlcm5ldDogYWRkIHByb3BlcnR5ICJudm1lbV9tYWNhZGRyX3N3YXAiIHRvIHN3YXAgbWFjYWRk
ciBieXRlcw0KICAgIG9yZGVyDQogIG9mX25ldDogYWRkIHByb3BlcnR5ICJudm1lbS1tYWMtYWRk
cmVzcyIgZm9yIG9mX2dldF9tYWNfYWRkcigpDQogIGR0LWJpbmRpbmdzOiBkb2M6IGFkZCBuZXcg
cHJvcGVydGllcyBmb3Igb2ZfZ2V0X21hY19hZGRyZXNzIGZyb20gbnZtZW0NCg0KIERvY3VtZW50
YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZXRoZXJuZXQudHh0IHwgIDMgKysrDQogZHJp
dmVycy9vZi9vZl9uZXQuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgNCArKysr
DQogbmV0L2V0aGVybmV0L2V0aC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAy
NSArKysrKysrKysrKysrKysrKy0tLS0tDQogMyBmaWxlcyBjaGFuZ2VkLCAyNyBpbnNlcnRpb25z
KCspLCA1IGRlbGV0aW9ucygtKQ0KDQotLSANCjIuNy40DQoNCg==
