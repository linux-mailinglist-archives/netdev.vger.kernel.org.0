Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8291426A18
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbfEVStm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:49:42 -0400
Received: from us-smtp-delivery-213.mimecast.com ([63.128.21.213]:52816 "EHLO
        us-smtp-delivery-213.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729632AbfEVStl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:49:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
        s=mimecast20190405; t=1558550980;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:autocrypt;
        bh=0ZLEPCsHZOlqd0MTNFeoHRYioPQFwk+tksPWUzYwdn8=;
        b=jfZR81L4eX60nhB0Lrd6ncvJ7kniFkL29viqw1KVgzvbzoDrbhSUnNSJYqHVUGMQleGUKX
        7Gpn5fa8ySfvK34gh8cHjS6fU3egxTX2VLNXRaBH75q3gs4m8Zle8ckGGffqnHc8wTfUzM
        IfQsTWVo0z6HdupiNqHFsf/Ge3hmieA=
Received: from NAM04-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam04lp2053.outbound.protection.outlook.com [104.47.44.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-PigKMVWWPjuc5rJiUpPDMA-3; Wed, 22 May 2019 14:43:33 -0400
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3787.namprd06.prod.outlook.com (10.167.236.156) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Wed, 22 May 2019 18:43:28 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::88d1:40e0:d1be:1daf]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::88d1:40e0:d1be:1daf%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 18:43:28 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC:     Trent Piepho <tpiepho@impinj.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 5/8] net: phy: dp83867: Use unsigned variables to
 store unsigned properties
Thread-Topic: [PATCH net-next v2 5/8] net: phy: dp83867: Use unsigned
 variables to store unsigned properties
Thread-Index: AQHVEM48jdPRmW6n1kqwWTpoGXBdQg==
Date:   Wed, 22 May 2019 18:43:24 +0000
Message-ID: <20190522184255.16323-5-tpiepho@impinj.com>
References: <20190522184255.16323-1-tpiepho@impinj.com>
In-Reply-To: <20190522184255.16323-1-tpiepho@impinj.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To MWHPR0601MB3708.namprd06.prod.outlook.com
 (2603:10b6:301:7c::38)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.14.5
x-originating-ip: [216.207.205.253]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 526eae94-2f8b-4e5c-cf0d-08d6dee55f0d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3787;
x-ms-traffictypediagnostic: MWHPR0601MB3787:
x-microsoft-antispam-prvs: <MWHPR0601MB37873F1CA4AB24D2F2301925D3000@MWHPR0601MB3787.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(396003)(39850400004)(136003)(199004)(189003)(26005)(25786009)(66066001)(52116002)(446003)(11346002)(476003)(2616005)(486006)(110136005)(54906003)(99286004)(76176011)(186003)(86362001)(256004)(6666004)(6436002)(71190400001)(71200400001)(316002)(6486002)(6512007)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(3846002)(6116002)(2906002)(68736007)(81166006)(81156014)(7736002)(386003)(6506007)(305945005)(8676002)(8936002)(50226002)(102836004)(2501003)(36756003)(4744005)(478600001)(53936002)(4326008)(5660300002)(14454004)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3787;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fzNpwj0POKrijb1nRXMZXXIMMPPvQJGjRAPTgakWrkZ2wDabPjwr/0BeeeXslnaHRxNQQ62p3kTGQWd1j7kzcMj+iXysEgWqR4+uYTB/gVRljUL81r79lQ8Bfga+1zXGrYndsYneVPYyJCctgVC5MNuAeH4PTkpiY0S5TIKXvhmsvHSiVf5fpRpYcXGit9AVGl8alBMtvtjumf/wZiFKweT7JVinsREkBpvQ9fX6/8KpUy2mLCwDUhQkYl6N6U/WQyoXHMPa3osi3QsUdS353r3k6Mu32wNfBMcghlA3XL81VsFXbC4ikQP736CAMJWayQbkFBxylNjStPkqdNUMDISMTvCjdPw3cylCOGsQB7HGrv4EsqDtn9tQlVS9BC4OQPBQNsulhCJataseYLmSAi4Co43mLg+0DbWrxbBeyVk=
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 526eae94-2f8b-4e5c-cf0d-08d6dee55f0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 18:43:24.7668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3787
X-MC-Unique: PigKMVWWPjuc5rJiUpPDMA-3
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
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
YwppbmRleCBmYzViYWE1ZDE0ZDAuLjU5MDUxYjBmNWJlOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9u
ZXQvcGh5L2RwODM4NjcuYworKysgYi9kcml2ZXJzL25ldC9waHkvZHA4Mzg2Ny5jCkBAIC05Myw5
ICs5Myw5IEBAIGVudW0gewogfTsKIAogc3RydWN0IGRwODM4NjdfcHJpdmF0ZSB7Ci0JaW50IHJ4
X2lkX2RlbGF5OwotCWludCB0eF9pZF9kZWxheTsKLQlpbnQgZmlmb19kZXB0aDsKKwl1MzIgcnhf
aWRfZGVsYXk7CisJdTMyIHR4X2lkX2RlbGF5OworCXUzMiBmaWZvX2RlcHRoOwogCWludCBpb19p
bXBlZGFuY2U7CiAJaW50IHBvcnRfbWlycm9yaW5nOwogCWJvb2wgcnhjdHJsX3N0cmFwX3F1aXJr
OwotLSAKMi4xNC41Cgo=

