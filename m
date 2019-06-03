Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA45332A59
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 10:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfFCIEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 04:04:13 -0400
Received: from mail-eopbgr80094.outbound.protection.outlook.com ([40.107.8.94]:20974
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfFCIEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 04:04:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0EI1mCB1KYrocYqIE5bdD3myKTeyCjqok9MCtjZwkw=;
 b=KjNPLVHkTD9/7sUsvgfiWkS97vzc040gDvRfuqftPp/2jpPr56baoTD7ZrqGlh0FbNwvGr4nmlcucapTtHaJvGBhPjP6/DnaiNW4gZVTShf9qm7iIHYe1G8prccrEJqHTmhgAsMOZH2n59nmfmt5wG4DgiabJCRcw+MtiwKgD1o=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2783.EURPRD10.PROD.OUTLOOK.COM (20.178.204.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 08:04:09 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 08:04:09 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: dsa: mv88e6xxx: make mv88e6xxx_g1_stats_wait static
Thread-Topic: [PATCH] net: dsa: mv88e6xxx: make mv88e6xxx_g1_stats_wait static
Thread-Index: AQHVGeLstGN9HejI90yCwDmeLZ5eTg==
Date:   Mon, 3 Jun 2019 08:04:09 +0000
Message-ID: <20190603080353.18957-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P190CA0020.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:bc::30)
 To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2b0d3a3-5e12-4c5b-ea7a-08d6e7fa0ecb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2783;
x-ms-traffictypediagnostic: VI1PR10MB2783:
x-microsoft-antispam-prvs: <VI1PR10MB2783CB85B72F2B85808D74EA8A140@VI1PR10MB2783.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:449;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(39850400004)(346002)(376002)(189003)(199004)(52116002)(8936002)(99286004)(8976002)(50226002)(6116002)(72206003)(3846002)(256004)(478600001)(386003)(1076003)(6506007)(25786009)(102836004)(4326008)(81156014)(81166006)(5660300002)(8676002)(6512007)(53936002)(2906002)(74482002)(14454004)(68736007)(36756003)(44832011)(66476007)(54906003)(486006)(476003)(6436002)(73956011)(66946007)(66446008)(64756008)(66556008)(110136005)(66066001)(316002)(71190400001)(71200400001)(305945005)(7736002)(26005)(2616005)(6486002)(42882007)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2783;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hin0lT+nBTC6DVNPuiXpQT09v6zTXMS+bt5H6DsmVeDkHwc8GCtWalHQ03Nlw1RBejZ2//gFtcoJpLgfB3JiL4b8u8XdYxz7H7eshS3t+Ze3dnPAaqVZEi6trJDHuo8I80hD3qYmv1chqDv91rOEtF9+ftTcKtJJNlWUxIrCOQYki71DqJJBIK5d81HXKBgGNIobj9IiDxGWPhEh8RgcZz2B+lA1LZ+lw6k0Kr4h7A0qurauwt/NY6YEALCmB1MS6IsMFIty5JAbl7pHZbm/g1eynm9RLVv0X6IaTPOufkuehNuVde5gNSyZsh5+7vlTCLXEmetS+zqEP8qPGuWFG+LEx9JugwZHmLXQ5KUEfzlV8kUQJycpPZpT1PtVgIiynm1pOW2uoHvoPp1uP0wjsZnZX5yrflXT6LDem8qb5uE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b0d3a3-5e12-4c5b-ea7a-08d6e7fa0ecb
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 08:04:09.8417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2783
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bXY4OGU2eHh4X2cxX3N0YXRzX3dhaXQgaGFzIG5vIHVzZXJzIG91dHNpZGUgZ2xvYmFsMS5jLCBz
byBtYWtlIGl0DQpzdGF0aWMuDQoNClNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxsZW1vZXMgPHJh
c211cy52aWxsZW1vZXNAcHJldmFzLmRrPg0KLS0tDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4
eC9nbG9iYWwxLmMgfCAyICstDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmgg
fCAxIC0NCiAyIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygtKQ0K
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmMgYi9kcml2
ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEuYw0KaW5kZXggYjVjZWZmMjk0NmZlLi43NzBj
MDM0MDYwMzMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEu
Yw0KKysrIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmMNCkBAIC00NjUsNyAr
NDY1LDcgQEAgaW50IG12ODhlNnh4eF9nMV9zZXRfZGV2aWNlX251bWJlcihzdHJ1Y3QgbXY4OGU2
eHh4X2NoaXAgKmNoaXAsIGludCBpbmRleCkNCiANCiAvKiBPZmZzZXQgMHgxZDogU3RhdGlzdGlj
cyBPcGVyYXRpb24gMiAqLw0KIA0KLWludCBtdjg4ZTZ4eHhfZzFfc3RhdHNfd2FpdChzdHJ1Y3Qg
bXY4OGU2eHh4X2NoaXAgKmNoaXApDQorc3RhdGljIGludCBtdjg4ZTZ4eHhfZzFfc3RhdHNfd2Fp
dChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXApDQogew0KIAlyZXR1cm4gbXY4OGU2eHh4X2cx
X3dhaXQoY2hpcCwgTVY4OEU2WFhYX0cxX1NUQVRTX09QLA0KIAkJCQkgTVY4OEU2WFhYX0cxX1NU
QVRTX09QX0JVU1kpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xv
YmFsMS5oIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmgNCmluZGV4IDJmMTk1
YTBiZDg5MS4uYmI5MmExMzBjYmVmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhl
Nnh4eC9nbG9iYWwxLmgNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5o
DQpAQCAtMjYzLDcgKzI2Myw2IEBAIGludCBtdjg4ZTYzNTJfZzFfcmVzZXQoc3RydWN0IG12ODhl
Nnh4eF9jaGlwICpjaGlwKTsNCiBpbnQgbXY4OGU2MTg1X2cxX3BwdV9lbmFibGUoc3RydWN0IG12
ODhlNnh4eF9jaGlwICpjaGlwKTsNCiBpbnQgbXY4OGU2MTg1X2cxX3BwdV9kaXNhYmxlKHN0cnVj
dCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCk7DQogDQotaW50IG12ODhlNnh4eF9nMV9zdGF0c193YWl0
KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCk7DQogaW50IG12ODhlNnh4eF9nMV9zdGF0c19z
bmFwc2hvdChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsIGludCBwb3J0KTsNCiBpbnQgbXY4
OGU2MzIwX2cxX3N0YXRzX3NuYXBzaG90KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwgaW50
IHBvcnQpOw0KIGludCBtdjg4ZTYzOTBfZzFfc3RhdHNfc25hcHNob3Qoc3RydWN0IG12ODhlNnh4
eF9jaGlwICpjaGlwLCBpbnQgcG9ydCk7DQotLSANCjIuMjAuMQ0KDQo=
