Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 001BD1A4BA
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 23:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfEJVqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 17:46:44 -0400
Received: from mail-eopbgr750132.outbound.protection.outlook.com ([40.107.75.132]:30426
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728334AbfEJVql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 17:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjdmfY60dehYc54IaSB/mYOsRDkVbiibmDFu3cfNOLQ=;
 b=jh7GXP40IYEvq8UUo0WK+O4G32DiQFRrLvjBqgUh5sB9V69afzhBVEpvE6/f65LX6QqeLBy/lFkpRUVN7zvXGJ1wn1guEejpRVsgV3Gc0+sMJ96EFcOvFnGFZ54BHNoRnADjUUW3fWnjK6xO3xIQePKBaHrTk17nv0ixH7j8MTw=
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3612.namprd06.prod.outlook.com (10.167.236.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Fri, 10 May 2019 21:46:21 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876%2]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 21:46:21 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Trent Piepho <tpiepho@impinj.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
Thread-Topic: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
Thread-Index: AQHVB3nKLczzbyv1Ekyx8+zOFp2aoA==
Date:   Fri, 10 May 2019 21:46:13 +0000
Message-ID: <20190510214550.18657-5-tpiepho@impinj.com>
References: <20190510214550.18657-1-tpiepho@impinj.com>
In-Reply-To: <20190510214550.18657-1-tpiepho@impinj.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:74::21) To MWHPR0601MB3708.namprd06.prod.outlook.com
 (2603:10b6:301:7c::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tpiepho@impinj.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.14.5
x-originating-ip: [216.207.205.253]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 753524a0-763b-4553-3017-08d6d590ec40
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3612;
x-ms-traffictypediagnostic: MWHPR0601MB3612:
x-microsoft-antispam-prvs: <MWHPR0601MB361253D160F8D5098A194F37D30C0@MWHPR0601MB3612.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39840400004)(136003)(189003)(199004)(316002)(3846002)(6116002)(86362001)(8676002)(81166006)(99286004)(66066001)(81156014)(478600001)(102836004)(25786009)(73956011)(76176011)(476003)(2616005)(68736007)(11346002)(66946007)(66476007)(66556008)(66446008)(64756008)(14454004)(50226002)(6506007)(446003)(486006)(8936002)(26005)(386003)(6666004)(186003)(4326008)(52116002)(256004)(36756003)(305945005)(2906002)(1076003)(110136005)(6436002)(6486002)(6512007)(54906003)(71190400001)(2501003)(5660300002)(71200400001)(53936002)(7736002)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3612;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: impinj.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7Zy2MtzkM/p7p3p6CSygGDj3AiIrzSfrze58eqM+iW48FIogJRuXPLMxVrMctw9Y6rORLp7XsafOkPnbtq6ciRRhUEr0VjN9vywrC9ncW9UfmK/fjL9DeZkkasGr7EA98oTlD4Gsd3+N6r1HHjSzBWQ9Akmvj3AHiYwyyT9N7IM3WAKl6kCRUBDrwmwKVygGCqXU44mGkCrlPJDCNAluaTUr0y7e7pLx38Glxuz7VQt+qQpf7wvlLztm/J6PeobqKxTYjSNA2vX/UKQruuN7tuep7AgbiJEEz9J1sYKlfX5YBwlg7X9OmEk8br4XprfTkUviO3KCylemglkX/5elIhWHF6W0njyLRETPPbDr1GWZHn5vN6J5YKAvaRiFopZ/4yS1uylfpssi2q35N/0k6+TibyAR2PDgbnZUSqJoS5o=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 753524a0-763b-4553-3017-08d6d590ec40
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 21:46:13.9923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3612
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIHZhcmlhYmxlcyB1c2VkIHRvIHN0b3JlIHUzMiBEVCBwcm9wZXJ0aWVzIHdlcmUgc2lnbmVk
IGludHMuICBUaGlzCmRvZXNuJ3Qgd29yayBwcm9wZXJseSBpZiB0aGUgdmFsdWUgb2YgdGhlIHBy
b3BlcnR5IHdlcmUgdG8gb3ZlcmZsb3cuClVzZSB1bnNpZ25lZCB2YXJpYWJsZXMgc28gdGhpcyBk
b2Vzbid0IGhhcHBlbi4KCkNjOiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+CkNjOiBGbG9y
aWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4KQ2M6IEhlaW5lciBLYWxsd2VpdCA8
aGthbGx3ZWl0MUBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IFRyZW50IFBpZXBobyA8dHBpZXBo
b0BpbXBpbmouY29tPgotLS0KIGRyaXZlcnMvbmV0L3BoeS9kcDgzODY3LmMgfCA2ICsrKy0tLQog
MSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9waHkvZHA4Mzg2Ny5jIGIvZHJpdmVycy9uZXQvcGh5L2RwODM4Njcu
YwppbmRleCBhNDZjYzk0MjdmYjMuLmVkZDllMjc0MjVlOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9u
ZXQvcGh5L2RwODM4NjcuYworKysgYi9kcml2ZXJzL25ldC9waHkvZHA4Mzg2Ny5jCkBAIC04Miw5
ICs4Miw5IEBAIGVudW0gewogfTsKIAogc3RydWN0IGRwODM4NjdfcHJpdmF0ZSB7Ci0JaW50IHJ4
X2lkX2RlbGF5OwotCWludCB0eF9pZF9kZWxheTsKLQlpbnQgZmlmb19kZXB0aDsKKwl1MzIgcnhf
aWRfZGVsYXk7CisJdTMyIHR4X2lkX2RlbGF5OworCXUzMiBmaWZvX2RlcHRoOwogCWludCBpb19p
bXBlZGFuY2U7CiAJaW50IHBvcnRfbWlycm9yaW5nOwogCWJvb2wgcnhjdHJsX3N0cmFwX3F1aXJr
OwotLSAKMi4xNC41Cgo=
