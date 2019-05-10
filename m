Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3531A4AF
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 23:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbfEJVqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 17:46:25 -0400
Received: from mail-eopbgr750132.outbound.protection.outlook.com ([40.107.75.132]:30426
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728160AbfEJVqX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 17:46:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFVtRO8FWTbDZualdbJeHyfovV7M1dlu4nGNifM/wZM=;
 b=HS666DuQUXyd86l0M6O1CpT1Vyz1OjWJrPOqaNiSIV1b2kGm2ZsAb+/FqEFNqLxoLGuY3+UUUa56NY8olk10vDBgeEnC0m9hzMA/4DE1r9LtJXoLMHEvFNFF0lNqkV7nnjrJkJz1XRgoFCQ8abDNb+ulWj/nDsyTiwIWqWGxu3w=
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3612.namprd06.prod.outlook.com (10.167.236.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Fri, 10 May 2019 21:46:12 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876%2]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 21:46:12 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Trent Piepho <tpiepho@impinj.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 3/5] net: phy: dp83867: Add ability to disable output clock
Thread-Topic: [PATCH 3/5] net: phy: dp83867: Add ability to disable output
 clock
Thread-Index: AQHVB3nIIyUkBzLWD0GI+/+3LNDYHg==
Date:   Fri, 10 May 2019 21:46:11 +0000
Message-ID: <20190510214550.18657-3-tpiepho@impinj.com>
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
x-ms-office365-filtering-correlation-id: c5b533a6-917b-470b-8954-08d6d590eafd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3612;
x-ms-traffictypediagnostic: MWHPR0601MB3612:
x-microsoft-antispam-prvs: <MWHPR0601MB361289CBFE989A3BC1646D17D30C0@MWHPR0601MB3612.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39840400004)(136003)(189003)(199004)(316002)(3846002)(6116002)(86362001)(8676002)(81166006)(99286004)(66066001)(81156014)(478600001)(102836004)(25786009)(73956011)(76176011)(476003)(2616005)(68736007)(11346002)(66946007)(66476007)(66556008)(66446008)(64756008)(14454004)(50226002)(6506007)(446003)(486006)(8936002)(26005)(386003)(186003)(4326008)(52116002)(256004)(36756003)(305945005)(2906002)(1076003)(110136005)(6436002)(6486002)(6512007)(54906003)(71190400001)(2501003)(5660300002)(71200400001)(53936002)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3612;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: impinj.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j0kfich/NQ8NZuCEjZYgmpAvIdR2dKcHOkYv2kqileAhEzAfJOBpeb3lEVxveDJ5uC6wrlm4LJz8tUijk1rX6wOAFgperwzcwyrKcSlCNht/p1M7Dnp8XVAJBT1IbiD8kiALQMl8ktOZSSAx2y5rC81RRgb8KYL3md0FeUOt2F7+hVkRtFWV1m2b54Aj8eResCjWpV1Fj77WWO7x86q5eHQ5by+7I3jTRBzW8t6ibsPkL+r9/FAhl8GSEmOYBygfwc+sQnNYHY2fP64KtL38QeCFE4gS34wF9EJrQAtcrknEMl8mVvrzL+y9mn7ZDK9f8mHW3LJ8i4ZpSzMvlpw1kZuH9EtGEdBDQ4vEaUMzwOulUu1b+sgDfJVPnsv6IjzN59ai1KBOPzG1aOcz3D9sonh6fL1mdARitI5x1AymKts=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b533a6-917b-470b-8954-08d6d590eafd
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 21:46:12.0069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3612
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R2VuZXJhbGx5LCB0aGUgb3V0cHV0IGNsb2NrIHBpbiBpcyBvbmx5IHVzZWQgZm9yIHRlc3Rpbmcg
YW5kIG9ubHkgc2VydmVzCmFzIGEgc291cmNlIG9mIFJGIG5vaXNlIGFmdGVyIHRoaXMuICBJdCBj
b3VsZCBiZSB1c2VkIHRvIGRhaXN5LWNoYWluClBIWXMsIGJ1dCB0aGlzIGlzIHVuY29tbW9uLiAg
U2luY2UgdGhlIFBIWSBjYW4gZGlzYWJsZSB0aGUgb3V0cHV0LCBtYWtlCmRvaW5nIHNvIGFuIG9w
dGlvbi4gIEkgZG8gdGhpcyBieSBhZGRpbmcgYW5vdGhlciBlbnVtZXJhdGlvbiB0byB0aGUKYWxs
b3dlZCB2YWx1ZXMgb2YgdGksY2xrLW91dHB1dC1zZWwuCgpUaGUgY29kZSB3YXMgbm90IHVzaW5n
IHRoZSB2YWx1ZSBEUDgzODY3X0NMS19PX1NFTF9SRUZfQ0xLIGFzIG9uZSBtaWdodApleHBlY3Q6
IHRvIHNlbGVjdCB0aGUgUkVGX0NMSyBhcyB0aGUgb3V0cHV0LiAgUmF0aGVyIGl0IG1lYW50ICJr
ZWVwCmNsb2NrIG91dHB1dCBzZXR0aW5nIGFzIGlzIiwgd2hpY2gsIGRlcGVuZGluZyBvbiBQSFkg
c3RyYXBwaW5nLCBtaWdodApub3QgYmUgb3V0cHV0dGluZyBSRUZfQ0xLLgoKQ2hhbmdlIHRoaXMg
c28gRFA4Mzg2N19DTEtfT19TRUxfUkVGX0NMSyBtZWFucyBlbmFibGUgUkVGX0NMSyBvdXRwdXQu
Ck9taXR0aW5nIHRoZSBwcm9wZXJ0eSB3aWxsIGxlYXZlIHRoZSBzZXR0aW5nIGFzIGlzICh3aGlj
aCB3YXMgdGhlCnByZXZpb3VzIGJlaGF2aW9yIGluIHRoaXMgY2FzZSkuCgpPdXQgb2YgcmFuZ2Ug
dmFsdWVzIHdlcmUgc2lsZW50bHkgY29udmVydGVkIGludG8KRFA4Mzg2N19DTEtfT19TRUxfUkVG
X0NMSy4gIENoYW5nZSB0aGlzIHNvIHRoZXkgZ2VuZXJhdGUgYW4gZXJyb3IuCgpDYzogQW5kcmV3
IEx1bm4gPGFuZHJld0BsdW5uLmNoPgpDYzogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBn
bWFpbC5jb20+CkNjOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPgpTaWdu
ZWQtb2ZmLWJ5OiBUcmVudCBQaWVwaG8gPHRwaWVwaG9AaW1waW5qLmNvbT4KLS0tCiBkcml2ZXJz
L25ldC9waHkvZHA4Mzg2Ny5jIHwgMzYgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0t
LS0tCiAxIGZpbGUgY2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L2RwODM4NjcuYyBiL2RyaXZlcnMvbmV0L3BoeS9k
cDgzODY3LmMKaW5kZXggZmQzNTEzMWEwYzM5Li40MjA3MjljZDYwMjUgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvbmV0L3BoeS9kcDgzODY3LmMKKysrIGIvZHJpdmVycy9uZXQvcGh5L2RwODM4NjcuYwpA
QCAtNjgsNiArNjgsNyBAQAogCiAjZGVmaW5lIERQODM4NjdfSU9fTVVYX0NGR19JT19JTVBFREFO
Q0VfTUFYCTB4MAogI2RlZmluZSBEUDgzODY3X0lPX01VWF9DRkdfSU9fSU1QRURBTkNFX01JTgkw
eDFmCisjZGVmaW5lIERQODM4NjdfSU9fTVVYX0NGR19DTEtfT19ESVNBQkxFCUJJVCg2KQogI2Rl
ZmluZSBEUDgzODY3X0lPX01VWF9DRkdfQ0xLX09fU0VMX01BU0sJKDB4MWYgPDwgOCkKICNkZWZp
bmUgRFA4Mzg2N19JT19NVVhfQ0ZHX0NMS19PX1NFTF9TSElGVAk4CiAKQEAgLTg3LDcgKzg4LDgg
QEAgc3RydWN0IGRwODM4NjdfcHJpdmF0ZSB7CiAJaW50IGlvX2ltcGVkYW5jZTsKIAlpbnQgcG9y
dF9taXJyb3Jpbmc7CiAJYm9vbCByeGN0cmxfc3RyYXBfcXVpcms7Ci0JaW50IGNsa19vdXRwdXRf
c2VsOworCWJvb2wgc2V0X2Nsa19vdXRwdXQ7CisJdTMyIGNsa19vdXRwdXRfc2VsOwogfTsKIAog
c3RhdGljIGludCBkcDgzODY3X2Fja19pbnRlcnJ1cHQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRl
dikKQEAgLTE1NCwxMSArMTU2LDE2IEBAIHN0YXRpYyBpbnQgZHA4Mzg2N19vZl9pbml0KHN0cnVj
dCBwaHlfZGV2aWNlICpwaHlkZXYpCiAJLyogT3B0aW9uYWwgY29uZmlndXJhdGlvbiAqLwogCXJl
dCA9IG9mX3Byb3BlcnR5X3JlYWRfdTMyKG9mX25vZGUsICJ0aSxjbGstb3V0cHV0LXNlbCIsCiAJ
CQkJICAgJmRwODM4NjctPmNsa19vdXRwdXRfc2VsKTsKLQlpZiAocmV0IHx8IGRwODM4NjctPmNs
a19vdXRwdXRfc2VsID4gRFA4Mzg2N19DTEtfT19TRUxfUkVGX0NMSykKLQkJLyogS2VlcCB0aGUg
ZGVmYXVsdCB2YWx1ZSBpZiB0aSxjbGstb3V0cHV0LXNlbCBpcyBub3Qgc2V0Ci0JCSAqIG9yIHRv
byBoaWdoCi0JCSAqLwotCQlkcDgzODY3LT5jbGtfb3V0cHV0X3NlbCA9IERQODM4NjdfQ0xLX09f
U0VMX1JFRl9DTEs7CisJLyogSWYgbm90IHNldCwga2VlcCBkZWZhdWx0ICovCisJaWYgKCFyZXQp
IHsKKwkJZHA4Mzg2Ny0+c2V0X2Nsa19vdXRwdXQgPSB0cnVlOworCQlpZiAoZHA4Mzg2Ny0+Y2xr
X291dHB1dF9zZWwgPiBEUDgzODY3X0NMS19PX1NFTF9SRUZfQ0xLICYmCisJCSAgICBkcDgzODY3
LT5jbGtfb3V0cHV0X3NlbCAhPSBEUDgzODY3X0NMS19PX1NFTF9PRkYpIHsKKwkJCXBoeWRldl9l
cnIocGh5ZGV2LCAidGksY2xrLW91dHB1dC1zZWwgdmFsdWUgJXUgb3V0IG9mIHJhbmdlXG4iLAor
CQkJCSAgIGRwODM4NjctPmNsa19vdXRwdXRfc2VsKTsKKwkJCXJldHVybiAtRUlOVkFMOworCQl9
CisJfQogCiAJaWYgKG9mX3Byb3BlcnR5X3JlYWRfYm9vbChvZl9ub2RlLCAidGksbWF4LW91dHB1
dC1pbXBlZGFuY2UiKSkKIAkJZHA4Mzg2Ny0+aW9faW1wZWRhbmNlID0gRFA4Mzg2N19JT19NVVhf
Q0ZHX0lPX0lNUEVEQU5DRV9NQVg7CkBAIC0yODgsMTEgKzI5NSwyMCBAQCBzdGF0aWMgaW50IGRw
ODM4NjdfY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikKIAkJZHA4Mzg2N19j
b25maWdfcG9ydF9taXJyb3JpbmcocGh5ZGV2KTsKIAogCS8qIENsb2NrIG91dHB1dCBzZWxlY3Rp
b24gaWYgbXV4aW5nIHByb3BlcnR5IGlzIHNldCAqLwotCWlmIChkcDgzODY3LT5jbGtfb3V0cHV0
X3NlbCAhPSBEUDgzODY3X0NMS19PX1NFTF9SRUZfQ0xLKQorCWlmIChkcDgzODY3LT5zZXRfY2xr
X291dHB1dCkgeworCQl1MTYgbWFzayA9IERQODM4NjdfSU9fTVVYX0NGR19DTEtfT19ESVNBQkxF
OworCisJCWlmIChkcDgzODY3LT5jbGtfb3V0cHV0X3NlbCA9PSBEUDgzODY3X0NMS19PX1NFTF9P
RkYpIHsKKwkJCXZhbCA9IERQODM4NjdfSU9fTVVYX0NGR19DTEtfT19ESVNBQkxFOworCQl9IGVs
c2UgeworCQkJbWFzayB8PSBEUDgzODY3X0lPX01VWF9DRkdfQ0xLX09fU0VMX01BU0s7CisJCQl2
YWwgPSBkcDgzODY3LT5jbGtfb3V0cHV0X3NlbCA8PAorCQkJICAgICAgRFA4Mzg2N19JT19NVVhf
Q0ZHX0NMS19PX1NFTF9TSElGVDsKKwkJfQorCiAJCXBoeV9tb2RpZnlfbW1kKHBoeWRldiwgRFA4
Mzg2N19ERVZBRERSLCBEUDgzODY3X0lPX01VWF9DRkcsCi0JCQkgICAgICAgRFA4Mzg2N19JT19N
VVhfQ0ZHX0NMS19PX1NFTF9NQVNLLAotCQkJICAgICAgIGRwODM4NjctPmNsa19vdXRwdXRfc2Vs
IDw8Ci0JCQkgICAgICAgRFA4Mzg2N19JT19NVVhfQ0ZHX0NMS19PX1NFTF9TSElGVCk7CisJCQkg
ICAgICAgbWFzaywgdmFsKTsKKwl9CiAKIAlyZXR1cm4gMDsKIH0KLS0gCjIuMTQuNQoK
