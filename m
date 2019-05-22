Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17BE426A13
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfEVStg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:49:36 -0400
Received: from us-smtp-delivery-213.mimecast.com ([216.205.24.213]:50602 "EHLO
        us-smtp-delivery-213.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729559AbfEVStg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:49:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
        s=mimecast20190405; t=1558550974;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:autocrypt;
        bh=0FsGudI2o4nkzR1twSPrONvktGyJRFZtHP/CnAxn2Lg=;
        b=Wl7RZ1rJ8l2XFaKMmubdGtWuLGyYlGZe84VJZNIqERoj8MCXfgf+br9qTeEq4eg9uNH7bQ
        DfUcG5UpGRSQ1nCWLk7yu8+EwkekKCr9zfpJu4VWTjveCLYHJxC1jbd6UNHf5ddFEmBFzY
        4KsMDhYeRb5MV1Ff5cUH0J9bKBvErnM=
Received: from NAM05-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam05lp2056.outbound.protection.outlook.com [104.47.49.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-LSTAva_tPU-i5W-jCf0pzA-1; Wed, 22 May 2019 14:43:26 -0400
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3787.namprd06.prod.outlook.com (10.167.236.156) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Wed, 22 May 2019 18:43:22 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::88d1:40e0:d1be:1daf]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::88d1:40e0:d1be:1daf%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 18:43:22 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC:     Trent Piepho <tpiepho@impinj.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH net-next v2 2/8] dt-bindings: phy: dp83867: Add documentation
 for disabling clock output
Thread-Topic: [PATCH net-next v2 2/8] dt-bindings: phy: dp83867: Add
 documentation for disabling clock output
Thread-Index: AQHVEM46ED5u1e15d0axnur34NT/cA==
Date:   Wed, 22 May 2019 18:43:21 +0000
Message-ID: <20190522184255.16323-2-tpiepho@impinj.com>
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
x-ms-office365-filtering-correlation-id: 4e5af976-9c52-4ee3-dfbe-08d6dee55d14
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3787;
x-ms-traffictypediagnostic: MWHPR0601MB3787:
x-microsoft-antispam-prvs: <MWHPR0601MB37874156EE3B2376446DB09CD3000@MWHPR0601MB3787.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(396003)(39850400004)(136003)(199004)(189003)(26005)(25786009)(66066001)(52116002)(446003)(11346002)(476003)(2616005)(486006)(110136005)(54906003)(99286004)(76176011)(186003)(86362001)(14444005)(256004)(6436002)(71190400001)(71200400001)(316002)(6486002)(6512007)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(3846002)(6116002)(2906002)(68736007)(81166006)(81156014)(7736002)(386003)(6506007)(305945005)(8676002)(8936002)(50226002)(102836004)(2501003)(36756003)(478600001)(53936002)(4326008)(5660300002)(14454004)(1076003)(154233001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3787;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DuJEIsmzN65CbBNmamKsky4X5tZO50wk52Z2Hm3vF2sV/AirgotTWfyxmGuNA9fCDdT9ESkcwR4ocGgaaKCB6LEItKHLtouc5LsfK+s0YmyWzQFNyi98CSTZlknLU3uMrRwvvjrKYy6gRR60XzALtuyNSVKfPbkbm9jMHnGRHlYucyakdpwjCdOX03N7aG85ZleFVKXySNFW+OcTi6VCwQWGCUNFIb82GxUPNKsIUlrjPnADPfF/talkYo0aKfos+BX0nWeC/I9+b5GrGwXKdlKEqMuEmaheXbPcha+l8hIYWKw2dr9M5ZujGIV+Fh2PiV/JWZsYaMhaFfz5aq2lAfqZZLJGPBgvGPNf+0zLIdInViUW9eozj2o8CCzxv02T3XbYYVB2iWNDwHBFcHSAPmL6Qbhg86h5Wn/jqeDj5bg=
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e5af976-9c52-4ee3-dfbe-08d6dee55d14
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 18:43:21.4717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3787
X-MC-Unique: LSTAva_tPU-i5W-jCf0pzA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIGNsb2NrIG91dHB1dCBpcyBnZW5lcmFsbHkgb25seSB1c2VkIGZvciB0ZXN0aW5nIGFuZCBk
ZXZlbG9wbWVudCBhbmQKbm90IHVzZWQgdG8gZGFpc3ktY2hhaW4gUEhZcy4gIEl0J3MganVzdCBh
IHNvdXJjZSBvZiBSRiBub2lzZSBhZnRlcndhcmQuCgpBZGQgYSBtdXggdmFsdWUgZm9yICJvZmYi
LiAgSSd2ZSBhZGRlZCBpdCBhcyBhbm90aGVyIGVudW1lcmF0aW9uIHRvIHRoZQpvdXRwdXQgcHJv
cGVydHkuICBJbiB0aGUgYWN0dWFsIFBIWSwgdGhlIG11eCBhbmQgdGhlIG91dHB1dCBlbmFibGUg
YXJlCmluZGVwZW5kZW50bHkgY29udHJvbGxhYmxlLiAgSG93ZXZlciwgaXQgZG9lc24ndCBzZWVt
IHVzZWZ1bCB0byBiZSBhYmxlCnRvIGRlc2NyaWJlIHRoZSBtdXggc2V0dGluZyB3aGVuIHRoZSBv
dXRwdXQgaXMgZGlzYWJsZWQuCgpEb2N1bWVudCB0aGF0IFBIWSdzIGRlZmF1bHQgc2V0dGluZyB3
aWxsIGJlIGxlZnQgYXMgaXMgaWYgdGhlIHByb3BlcnR5CmlzIG9taXR0ZWQuCgpDYzogUm9iIEhl
cnJpbmcgPHJvYmgrZHRAa2VybmVsLm9yZz4KQ2M6IE1hcmsgUnV0bGFuZCA8bWFyay5ydXRsYW5k
QGFybS5jb20+ClNpZ25lZC1vZmYtYnk6IFRyZW50IFBpZXBobyA8dHBpZXBob0BpbXBpbmouY29t
PgotLS0KIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvdGksZHA4Mzg2Ny50
eHQgfCA2ICsrKystLQogaW5jbHVkZS9kdC1iaW5kaW5ncy9uZXQvdGktZHA4Mzg2Ny5oICAgICAg
ICAgICAgICAgICB8IDIgKysKIDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQvdGksZHA4Mzg2Ny50eHQgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
bmV0L3RpLGRwODM4NjcudHh0CmluZGV4IDk5Yjg2ODFiZGU0OS4uZGI2YWEzZjIyMTViIDEwMDY0
NAotLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3RpLGRwODM4Njcu
dHh0CisrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvdGksZHA4Mzg2
Ny50eHQKQEAgLTMzLDggKzMzLDEwIEBAIE9wdGlvbmFsIHByb3BlcnR5OgogCQkJCSAgICBzb2Z0
d2FyZSBuZWVkcyB0byB0YWtlIHdoZW4gdGhpcyBwaW4gaXMKIAkJCQkgICAgc3RyYXBwZWQgaW4g
dGhlc2UgbW9kZXMuIFNlZSBkYXRhIG1hbnVhbAogCQkJCSAgICBmb3IgZGV0YWlscy4KLQktIHRp
LGNsay1vdXRwdXQtc2VsIC0gTXV4aW5nIG9wdGlvbiBmb3IgQ0xLX09VVCBwaW4gLSBzZWUgZHQt
YmluZGluZ3MvbmV0L3RpLWRwODM4NjcuaAotCQkJCSAgICBmb3IgYXBwbGljYWJsZSB2YWx1ZXMu
CisJLSB0aSxjbGstb3V0cHV0LXNlbCAtIE11eGluZyBvcHRpb24gZm9yIENMS19PVVQgcGluLiAg
U2VlIGR0LWJpbmRpbmdzL25ldC90aS1kcDgzODY3LmgKKwkJCSAgICAgIGZvciBhcHBsaWNhYmxl
IHZhbHVlcy4gIFRoZSBDTEtfT1VUIHBpbiBjYW4gYWxzbworCQkJICAgICAgYmUgZGlzYWJsZWQg
YnkgdGhpcyBwcm9wZXJ0eS4gIFdoZW4gb21pdHRlZCwgdGhlCisJCQkgICAgICBQSFkncyBkZWZh
dWx0IHdpbGwgYmUgbGVmdCBhcyBpcy4KIAogTm90ZTogdGksbWluLW91dHB1dC1pbXBlZGFuY2Ug
YW5kIHRpLG1heC1vdXRwdXQtaW1wZWRhbmNlIGFyZSBtdXR1YWxseQogICAgICAgZXhjbHVzaXZl
LiBXaGVuIGJvdGggcHJvcGVydGllcyBhcmUgcHJlc2VudCB0aSxtYXgtb3V0cHV0LWltcGVkYW5j
ZQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9kdC1iaW5kaW5ncy9uZXQvdGktZHA4Mzg2Ny5oIGIvaW5j
bHVkZS9kdC1iaW5kaW5ncy9uZXQvdGktZHA4Mzg2Ny5oCmluZGV4IDdiMTY1NjQyN2NiZS4uMTky
Yjc5NDM5ZWI3IDEwMDY0NAotLS0gYS9pbmNsdWRlL2R0LWJpbmRpbmdzL25ldC90aS1kcDgzODY3
LmgKKysrIGIvaW5jbHVkZS9kdC1iaW5kaW5ncy9uZXQvdGktZHA4Mzg2Ny5oCkBAIC01Niw0ICs1
Niw2IEBACiAjZGVmaW5lIERQODM4NjdfQ0xLX09fU0VMX0NITl9DX1RDTEsJCTB4QQogI2RlZmlu
ZSBEUDgzODY3X0NMS19PX1NFTF9DSE5fRF9UQ0xLCQkweEIKICNkZWZpbmUgRFA4Mzg2N19DTEtf
T19TRUxfUkVGX0NMSwkJMHhDCisvKiBTcGVjaWFsIGZsYWcgdG8gaW5kaWNhdGUgY2xvY2sgc2hv
dWxkIGJlIG9mZiAqLworI2RlZmluZSBEUDgzODY3X0NMS19PX1NFTF9PRkYJCQkweEZGRkZGRkZG
CiAjZW5kaWYKLS0gCjIuMTQuNQoK

