Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 707F726A12
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbfEVStg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:49:36 -0400
Received: from us-smtp-delivery-213.mimecast.com ([63.128.21.213]:60513 "EHLO
        us-smtp-delivery-213.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729538AbfEVStf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:49:35 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 May 2019 14:49:34 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
        s=mimecast20190405; t=1558550974;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references:openpgp:autocrypt; bh=50ym4gNo4KsOAc/i9tEFA9JrWKrWXI25B1sR3bTGOCE=;
        b=hwGu00KxzV+xQWzK83zcWve9Yh5xIkZ1KELO/dgQVMod3jCHp2CCrtE648ZpOQycwjaNhB
        +U2XslA+fqT8qf2T+utwrl/b4AdU9i/F1Fgx9ERHJSt8HBG+grqRyAra5r7CvYdkMCihYb
        D9WPE2Eod+96uCf+sf01w60NM9vtlxw=
Received: from NAM05-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam05lp2052.outbound.protection.outlook.com [104.47.50.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-oDt9bvAnMbKVRmx8_UopWw-1; Wed, 22 May 2019 14:43:26 -0400
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3627.namprd06.prod.outlook.com (10.167.236.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Wed, 22 May 2019 18:43:20 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::88d1:40e0:d1be:1daf]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::88d1:40e0:d1be:1daf%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 18:43:20 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC:     Trent Piepho <tpiepho@impinj.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH net-next v2 1/8] dt-bindings: phy: dp83867: Describe how
 driver behaves w.r.t rgmii delay
Thread-Topic: [PATCH net-next v2 1/8] dt-bindings: phy: dp83867: Describe how
 driver behaves w.r.t rgmii delay
Thread-Index: AQHVEM45yXbzkDzkREabh22/y4lJIQ==
Date:   Wed, 22 May 2019 18:43:19 +0000
Message-ID: <20190522184255.16323-1-tpiepho@impinj.com>
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
x-ms-office365-filtering-correlation-id: 9b14d342-a48c-4512-1a69-08d6dee55c32
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3627;
x-ms-traffictypediagnostic: MWHPR0601MB3627:
x-microsoft-antispam-prvs: <MWHPR0601MB36274C62A39DE9F54721E36BD3000@MWHPR0601MB3627.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(346002)(376002)(396003)(136003)(189003)(199004)(6486002)(6436002)(66476007)(14454004)(66556008)(66446008)(256004)(64756008)(6506007)(8936002)(386003)(73956011)(102836004)(66946007)(71190400001)(50226002)(71200400001)(6116002)(3846002)(2906002)(478600001)(6512007)(4326008)(305945005)(7736002)(316002)(26005)(186003)(36756003)(2501003)(66066001)(5660300002)(25786009)(53936002)(86362001)(110136005)(54906003)(52116002)(1076003)(81156014)(81166006)(8676002)(99286004)(2616005)(476003)(68736007)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3627;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BAjrFVqvayezmV/AVGzvW9sOIfXPOpkg9DtO8uREkXjQCM0NGV6EGwQAGN1/cWUegUZrLE2tEjz2VdIaO7PEm73EusZ5J4HXMHClmTWjc1sSDdFkeJalGyiYkI7f42XhCo2Tqqp+XgOLTguDkiU09WEuwSISq8dlvIuqVdChY0LdWWCsI/uGEC0ECF3mIKG3FP9ePqdMBEotfmfT+90D3BqiuUOm/V8Me+AiAUkneqIcw6gX0DGPbDjMBvU5a/6b1XgLRpeNX6pTofk6L1PnG5XkU45fAP277kTsKDdkXXpPTqHs0LL7HwO+fehJVu4NPe8Y5eX3dL1PkMmorswpQDNDyL8wP3sedAWr3+tkBiEEUjTXsO1tJmHZXTcpI0Uxn+BF/9hqgZsWQU1vDlOlPNY0drwLirNiDHskojL/ZzU=
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b14d342-a48c-4512-1a69-08d6dee55c32
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 18:43:20.5392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3627
X-MC-Unique: oDt9bvAnMbKVRmx8_UopWw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWRkIGEgbm90ZSB0byBtYWtlIGl0IG1vcmUgY2xlYXIgaG93IHRoZSBkcml2ZXIgYmVoYXZlcyB3
aGVuICJyZ21paSIgdnMKInJnbWlpLWlkIiwgInJnbWlpLWlkcngiLCBvciAicmdtaWktaWR0eCIg
aW50ZXJmYWNlIG1vZGVzIGFyZSBzZWxlY3RlZC4KCkNjOiBSb2IgSGVycmluZyA8cm9iaCtkdEBr
ZXJuZWwub3JnPgpDYzogTWFyayBSdXRsYW5kIDxtYXJrLnJ1dGxhbmRAYXJtLmNvbT4KU2lnbmVk
LW9mZi1ieTogVHJlbnQgUGllcGhvIDx0cGllcGhvQGltcGluai5jb20+Ci0tLQoKTm90ZXM6CiAg
ICBDaGFuZ2VzIGZyb20gdjE6CiAgICAgIENsYXJpZnkgYmVoYXZpb3IgbWF5IGNoYW5nZSB0byBl
bmZvcmNlIG5vIGRlbGF5IGluICJyZ21paSIgbW9kZQoKIERvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9uZXQvdGksZHA4Mzg2Ny50eHQgfCA4ICsrKysrKysrCiAxIGZpbGUgY2hhbmdl
ZCwgOCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVl
L2JpbmRpbmdzL25ldC90aSxkcDgzODY3LnR4dCBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9uZXQvdGksZHA4Mzg2Ny50eHQKaW5kZXggOWVmOTMzOGFhZWUxLi45OWI4NjgxYmRl
NDkgMTAwNjQ0Ci0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvdGks
ZHA4Mzg2Ny50eHQKKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC90
aSxkcDgzODY3LnR4dApAQCAtMTEsNiArMTEsMTQgQEAgUmVxdWlyZWQgcHJvcGVydGllczoKIAkt
IHRpLGZpZm8tZGVwdGggLSBUcmFuc21pdHQgRklGTyBkZXB0aC0gc2VlIGR0LWJpbmRpbmdzL25l
dC90aS1kcDgzODY3LmgKIAkJZm9yIGFwcGxpY2FibGUgdmFsdWVzCiAKK05vdGU6IElmIHRoZSBp
bnRlcmZhY2UgdHlwZSBpcyBQSFlfSU5URVJGQUNFX01PREVfUkdNSUkgdGhlIFRYL1JYIGNsb2Nr
IGRlbGF5cworICAgICAgd2lsbCBiZSBsZWZ0IGF0IHRoZWlyIGRlZmF1bHQgdmFsdWVzLCBhcyBz
ZXQgYnkgdGhlIFBIWSdzIHBpbiBzdHJhcHBpbmcuCisgICAgICBUaGUgZGVmYXVsdCBzdHJhcHBp
bmcgd2lsbCB1c2UgYSBkZWxheSBvZiAyLjAwIG5zLiAgVGh1cworICAgICAgUEhZX0lOVEVSRkFD
RV9NT0RFX1JHTUlJLCBieSBkZWZhdWx0LCBkb2VzIG5vdCBiZWhhdmUgYXMgUkdNSUkgd2l0aCBu
bworICAgICAgaW50ZXJuYWwgZGVsYXksIGJ1dCBhcyBQSFlfSU5URVJGQUNFX01PREVfUkdNSUlf
SUQuICBUaGUgZGV2aWNlIHRyZWUKKyAgICAgIHNob3VsZCB1c2UgInJnbWlpLWlkIiBpZiBpbnRl
cm5hbCBkZWxheXMgYXJlIGRlc2lyZWQgYXMgdGhpcyBtYXkgYmUKKyAgICAgIGNoYW5nZWQgaW4g
ZnV0dXJlIHRvIGNhdXNlICJyZ21paSIgbW9kZSB0byBkaXNhYmxlIGRlbGF5cy4KKwogT3B0aW9u
YWwgcHJvcGVydHk6CiAJLSB0aSxtaW4tb3V0cHV0LWltcGVkYW5jZSAtIE1BQyBJbnRlcmZhY2Ug
SW1wZWRhbmNlIGNvbnRyb2wgdG8gc2V0CiAJCQkJICAgIHRoZSBwcm9ncmFtbWFibGUgb3V0cHV0
IGltcGVkYW5jZSB0bwotLSAKMi4xNC41Cgo=

