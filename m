Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2341A4B4
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 23:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfEJVqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 17:46:16 -0400
Received: from mail-eopbgr750090.outbound.protection.outlook.com ([40.107.75.90]:47617
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728134AbfEJVqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 17:46:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TdGq82LWgJMSd6hNJI73J/lqVpYY2+DVyjyLywOSb+U=;
 b=X8uQMquvonRvE5lr5DQIzg0V4RurPPOpnkeC4K16sWIFHDSZ4M1nzyA9+CSVur4PA8PtbL8Qc2Sk2/y046Nj6av6nmf4tNgIjMb4zZf5PusGmBnypMR8/xuCYeD0TDhSLavwZQT3JShzcApsMC98I9xq/ugqLS0MmgQi+D+ZhBs=
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3612.namprd06.prod.outlook.com (10.167.236.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Fri, 10 May 2019 21:46:10 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876%2]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 21:46:10 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Trent Piepho <tpiepho@impinj.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/5] dt-bindings: phy: dp83867: Describe how driver behaves
 w.r.t rgmii delay
Thread-Topic: [PATCH 1/5] dt-bindings: phy: dp83867: Describe how driver
 behaves w.r.t rgmii delay
Thread-Index: AQHVB3nHwZh1qZVxh0+UE9aTi40vPg==
Date:   Fri, 10 May 2019 21:46:10 +0000
Message-ID: <20190510214550.18657-1-tpiepho@impinj.com>
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
x-ms-office365-filtering-correlation-id: b4afe427-ec73-4877-0257-08d6d590e9f2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3612;
x-ms-traffictypediagnostic: MWHPR0601MB3612:
x-microsoft-antispam-prvs: <MWHPR0601MB3612CC94D9DC29D6E20C2266D30C0@MWHPR0601MB3612.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39840400004)(136003)(189003)(199004)(316002)(3846002)(6116002)(86362001)(8676002)(81166006)(99286004)(66066001)(81156014)(478600001)(102836004)(25786009)(73956011)(476003)(2616005)(68736007)(66946007)(66476007)(66556008)(66446008)(64756008)(14454004)(50226002)(6506007)(486006)(8936002)(26005)(386003)(186003)(4326008)(52116002)(256004)(36756003)(305945005)(2906002)(1076003)(110136005)(6436002)(6486002)(6512007)(54906003)(71190400001)(2501003)(5660300002)(71200400001)(53936002)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3612;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: impinj.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: loumK/tN23wNF3LNjFhIjSdku94ymTu55mv5rvRUwAKcHXT/6K0IIGVvj8TwtHcV//R9un5T8gCPWif5ta+fIBHjK1/eS9eqt1KhweYksQ+7lzezNim5Epmlo8vXiEzAJF6kvhVD71eXHJSrQa4VPJoGUYgckbzHnl16mJMZjRU7jDMJJhpOEJxCeywwe7MfoiV8ufP+Ecmw3bzcPflAsWjSFLwqmqLguDOmNYs/JLrS5CDnrWpKw7nF+wHJrSSItvhH44Op1u7f4XVpW7b2B5ER3N1y6D+L3TC7II5ta3O6wvRultVnAbJisL1YGatWJ6WSm2A/9x/lqC6+UCw07v5oqLo+Ft5fVmK3Ss3y1ANHjM3awbLGm/2Hy5wVA97dKvHBBg+plWFnNcgQJ5a7fqeIesK/EsK7Z1Oopl2KWig=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4afe427-ec73-4877-0257-08d6d590e9f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 21:46:10.2426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3612
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWRkIGEgbm90ZSB0byBtYWtlIGl0IG1vcmUgY2xlYXIgaG93IHRoZSBkcml2ZXIgYmVoYXZlcyB3
aGVuICJyZ21paSIgdnMKInJnbWlpLWlkIiwgInJnbWlpLWlkcngiLCBvciAicmdtaWktaWR0eCIg
aW50ZXJmYWNlIG1vZGVzIGFyZSBzZWxlY3RlZC4KCkNjOiBSb2IgSGVycmluZyA8cm9iaCtkdEBr
ZXJuZWwub3JnPgpDYzogTWFyayBSdXRsYW5kIDxtYXJrLnJ1dGxhbmRAYXJtLmNvbT4KU2lnbmVk
LW9mZi1ieTogVHJlbnQgUGllcGhvIDx0cGllcGhvQGltcGluai5jb20+Ci0tLQogRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC90aSxkcDgzODY3LnR4dCB8IDYgKysrKysrCiAx
IGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlv
bi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC90aSxkcDgzODY3LnR4dCBiL0RvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvdGksZHA4Mzg2Ny50eHQKaW5kZXggOWVmOTMzOGFhZWUx
Li5lOTdmNTRhZWFjNzcgMTAwNjQ0Ci0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy9uZXQvdGksZHA4Mzg2Ny50eHQKKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2Jp
bmRpbmdzL25ldC90aSxkcDgzODY3LnR4dApAQCAtMTEsNiArMTEsMTIgQEAgUmVxdWlyZWQgcHJv
cGVydGllczoKIAktIHRpLGZpZm8tZGVwdGggLSBUcmFuc21pdHQgRklGTyBkZXB0aC0gc2VlIGR0
LWJpbmRpbmdzL25ldC90aS1kcDgzODY3LmgKIAkJZm9yIGFwcGxpY2FibGUgdmFsdWVzCiAKK05v
dGU6IElmIHRoZSBpbnRlcmZhY2UgdHlwZSBpcyBQSFlfSU5URVJGQUNFX01PREVfUkdNSUkgdGhl
IFRYL1JYIGNsb2NrIGRlbGF5cworICAgICAgd2lsbCBiZSBsZWZ0IGF0IHRoZWlyIGRlZmF1bHQg
dmFsdWVzLCBhcyBzZXQgYnkgdGhlIFBIWSdzIHBpbiBzdHJhcHBpbmcuCisgICAgICBUaGUgZGVm
YXVsdCBzdHJhcHBpbmcgd2lsbCB1c2UgYSBkZWxheSBvZiAyLjAwIG5zLiAgVGh1cworICAgICAg
UEhZX0lOVEVSRkFDRV9NT0RFX1JHTUlJIGJ5IGRlZmF1bHQgZG9lcyBub3QgYmVoYXZlIGFzIFJH
TUlJIHdpdGggbm8KKyAgICAgIGludGVybmFsIGRlbGF5LCBidXQgYXMgUEhZX0lOVEVSRkFDRV9N
T0RFX1JHTUlJX0lELgorCiBPcHRpb25hbCBwcm9wZXJ0eToKIAktIHRpLG1pbi1vdXRwdXQtaW1w
ZWRhbmNlIC0gTUFDIEludGVyZmFjZSBJbXBlZGFuY2UgY29udHJvbCB0byBzZXQKIAkJCQkgICAg
dGhlIHByb2dyYW1tYWJsZSBvdXRwdXQgaW1wZWRhbmNlIHRvCi0tIAoyLjE0LjUKCg==
