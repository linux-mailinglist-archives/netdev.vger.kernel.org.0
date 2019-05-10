Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701A91A4AD
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 23:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfEJVqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 17:46:19 -0400
Received: from mail-eopbgr750090.outbound.protection.outlook.com ([40.107.75.90]:47617
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728160AbfEJVqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 17:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pg26f0uU6vsUJMyGKfLFkrw9B5aACGM9iLn00EkTwBQ=;
 b=UjDZXruP9ZvG7PqspoMAdzgWHYR3OcJhvqmYyYYGNHNOKTmNstjuyAd+SbzgFYXvpznKBrc6xmT7661lMrApfaRT3J/MltS7Zzqcy/+lJe+0Jyq/SzNB7poSKpqXJL2NsBphKNVukR2t1IyWFwR93/znqPRpbA5AKGMe2e1gX/Y=
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3612.namprd06.prod.outlook.com (10.167.236.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Fri, 10 May 2019 21:46:11 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876%2]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 21:46:11 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Trent Piepho <tpiepho@impinj.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 2/5] dt-bindings: phy: dp83867: Add documentation for
 disabling clock output
Thread-Topic: [PATCH 2/5] dt-bindings: phy: dp83867: Add documentation for
 disabling clock output
Thread-Index: AQHVB3nIExiPI9xW3ES4t20u+YrTOA==
Date:   Fri, 10 May 2019 21:46:10 +0000
Message-ID: <20190510214550.18657-2-tpiepho@impinj.com>
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
x-ms-office365-filtering-correlation-id: d84d00b2-834e-4d4f-a374-08d6d590ea89
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3612;
x-ms-traffictypediagnostic: MWHPR0601MB3612:
x-microsoft-antispam-prvs: <MWHPR0601MB36128FEBACADFC78DCA0A7E4D30C0@MWHPR0601MB3612.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39840400004)(136003)(189003)(199004)(316002)(3846002)(6116002)(86362001)(8676002)(81166006)(99286004)(66066001)(81156014)(478600001)(102836004)(25786009)(73956011)(76176011)(476003)(2616005)(68736007)(11346002)(66946007)(66476007)(66556008)(66446008)(64756008)(14454004)(50226002)(6506007)(446003)(486006)(8936002)(26005)(386003)(186003)(4326008)(52116002)(256004)(14444005)(36756003)(305945005)(2906002)(1076003)(110136005)(6436002)(6486002)(6512007)(54906003)(71190400001)(2501003)(5660300002)(71200400001)(53936002)(7736002)(154233001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3612;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: impinj.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Lh+fs7ehUVZnV+zIsirKg+GLjGxMphL5ybVnNBRNRqeB+cOKK4xMqJP2CsephHKOMrS0kAod0oAJb+uQlB8tHuumP7Jx+1evKy+blbDS6/Xh6rSDsEZdAQ3UUnz2dZASMJ1SICxt5IRWYpMFKSZ38VXvWjlaBngocOrz/xvVsb8VnENOlt4RVYDEwHEvUREpzdgwEM2op0XVZUlV6zIEdtetwHvxTI/od3sAFRwjst0vT6BTtw/8KvI0O6lrkXs/+egvK6KkGmAt4+kief+f148nu6OzxTm4hPe1I/4JgXwwKo/i85ONOk1G09Y7ZE63gRbEZBtm8KGGE5H69VKeTpNzOZvnZdik9MmkpL7Nut8fEo3IkycrlHXYMWJEobTsEWjEvX/3Nzd0p8nGlu/wdCjSxZPtrl3ePYDLrbVFiHE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d84d00b2-834e-4d4f-a374-08d6d590ea89
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 21:46:10.9591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3612
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
bmV0L3RpLGRwODM4NjcudHh0CmluZGV4IGU5N2Y1NGFlYWM3Ny4uOTVlY2RjMzM1ZTYzIDEwMDY0
NAotLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3RpLGRwODM4Njcu
dHh0CisrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvdGksZHA4Mzg2
Ny50eHQKQEAgLTMxLDggKzMxLDEwIEBAIE9wdGlvbmFsIHByb3BlcnR5OgogCQkJCSAgICBzb2Z0
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
