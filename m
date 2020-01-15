Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A36813BFC0
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731705AbgAOMQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:16:07 -0500
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:6101
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731168AbgAOMNi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7zwm7eFkgO3XERSpK/QlGem8Icioxr/YAQVxQHXF2HnhZVG2jHQHbCKfTKBeKnz8iLIbdqb+eVEVxvRDz2mGtFi2uyhNhA3Th2QjWBJ3shCBB7dX/cnc21F5QsKeCSOUevO8veqyYCjH6sk+7eJc3FjGWqVwXdqmnXyzQZA9YwWq8b3ykW25jIYko4MymSYvJTvOQ9N+3rE8RAd1U1a4QVx1vhdYvyeti09QX3phGpYaD6wheM+PKaJWhgBwD6pV168sb6k1+Zjupg3ng8t2+wWI8ECxF20earnZsVVpyZFVtUpvvZxmcU3BEAjw1hmg877nrMbXcCrVVXUljRKrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OQhlUt+sYJ/eiAbIL8ycTks4MYvs5U6ohNWOamkvK4=;
 b=oC6GJiv0PUH0ElrVkAh4cDlpd7iK4dJjcDkheTvoWBu38wpkkqzTmviXs3UC9DJmHKvSSVZStUz0h/CM2jsBjINuAQOHAauCWTX0v87PUCta3RybC8ZkRflaUTp9rbIKazMNY+NjGINFnZwn2lkq6FXObJH2jJ+fGHf6tgyyFODp+OE+ipH9D3AAiu92Vu6xccQv9rGzok89pHERw72mvyF4z7i+MPhKs4Ezm+ml4PjO5IBsWmD0xi6siPnMPwUHTUCJl0OCV4j+BVTLOPQk7sWnb2z8/2duVgv0SNzVveEX0R2niClD14zE2+9nV+78/hHE9zxIICAW4qO+bvjPRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OQhlUt+sYJ/eiAbIL8ycTks4MYvs5U6ohNWOamkvK4=;
 b=oNzguT8Qsew5bl8ZR/kr+tXVTKA0hzlpKdUZebiGediLq9tsk0I2vRcdALuareXxy43KUUkokafKcrOoI1fq0ohJDYgq7ThnhoNI/kyOsSsjFq0tNcWSd3PIbu/0ce6wkH+WT8f4+vZQFQcIeSWeVNEZ3C3q0YpeAr2WpB7DrdE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:28 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:28 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:06 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 44/65] staging: wfx: fix possible overflow on jiffies
 comparaison
Thread-Topic: [PATCH 44/65] staging: wfx: fix possible overflow on jiffies
 comparaison
Thread-Index: AQHVy50lOqVR9Z75Hk21qa/iiiYguA==
Date:   Wed, 15 Jan 2020 12:13:07 +0000
Message-ID: <20200115121041.10863-45-Jerome.Pouiller@silabs.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bd844c3-9b9d-4720-09ca-08d799b447e6
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB393459FCCC78F64AC413677A93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003)(16251815004);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OhKTix534WezpdaMRbyppCSpogpSaK2XZVORUMKyyVbfhIcC7Q57vkdKhlw7TIRU4th+1dv+uAgJK+5Cf0J4QXijSmGeKtuQjQxsK/JcIOXzovt/Nk9j7YaUqpRUxMAtrYFjVxqAApw5Q3VexlRpSfigWt5rIxHXinlDUJNwIhzPVnEqXcvTKjwUuk5YEXc4I9YcHOYMsAiAm+xR2+a2Dp3weaUtX8kyj+5OwFgIPvOlJSYo9on6Yf+DIymgQZy64Oi3mJMmnvvn15tbPZ7PjJH382Sx8QpsyYwL97dkVPLRdJza84xfQosSKEBqfeygY6NA60HSDqSBybZGZZWUb86aNnPDXkIC5TqyAwM7iFr5n5BhvimgQDVeb9NxBekOAKBujH2AYf2MbrSCRmyoRbzwkG35s5R/vxy63yk28V7kweRaYcOzIdMMFfIXZG3cxG1cSTVNROKjYVf1eTeLnrwkvuBnnM6j+CBSCLx94Kd0d/H3n5BsVpgsjOT65PlB
Content-Type: text/plain; charset="utf-8"
Content-ID: <7636D479EFCB0D499131B2314C6A38A6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd844c3-9b9d-4720-09ca-08d799b447e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:07.7394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BT6hC5vIs5lGVeFmKMRapth2Lw0PbLGZiVX0hnRjv8yNJosCuQfLSr4M7JENI+PeFa+IHLBCGRK9VkFpmMnRpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKTUlN
RS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PVVURi04CkNv
bnRlbnQtVHJhbnNmZXItRW5jb2Rpbmc6IDhiaXQKCkl0IGlzIHJlY29tbWVuZGVkIHRvIHVzZSBm
dW5jdGlvbiB0aW1lXyooKSB0byBjb21wYXJlIGppZmZpZXMuCgpTaWduZWQtb2ZmLWJ5OiBKw6ly
w7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9kYXRhX3R4LmMgfCAxNCArKysrKy0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQs
IDUgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2RhdGFfdHguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCmluZGV4
IDYwNDU5Mjk5YTNhOS4uNzA0ZWJmZTFjZDA1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2RhdGFfdHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwpAQCAtMjcw
LDggKzI3MCw3IEBAIHZvaWQgd2Z4X3R4X3BvbGljeV9pbml0KHN0cnVjdCB3ZnhfdmlmICp3dmlm
KQogc3RhdGljIGludCB3ZnhfYWxsb2NfbGlua19pZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29u
c3QgdTggKm1hYykKIHsKIAlpbnQgaSwgcmV0ID0gMDsKLQl1bnNpZ25lZCBsb25nIG1heF9pbmFj
dGl2aXR5ID0gMDsKLQl1bnNpZ25lZCBsb25nIG5vdyA9IGppZmZpZXM7CisJdW5zaWduZWQgbG9u
ZyBvbGRlc3Q7CiAKIAlzcGluX2xvY2tfYmgoJnd2aWYtPnBzX3N0YXRlX2xvY2spOwogCWZvciAo
aSA9IDA7IGkgPCBXRlhfTUFYX1NUQV9JTl9BUF9NT0RFOyArK2kpIHsKQEAgLTI4MCwxMyArMjc5
LDEwIEBAIHN0YXRpYyBpbnQgd2Z4X2FsbG9jX2xpbmtfaWQoc3RydWN0IHdmeF92aWYgKnd2aWYs
IGNvbnN0IHU4ICptYWMpCiAJCQlicmVhazsKIAkJfSBlbHNlIGlmICh3dmlmLT5saW5rX2lkX2Ri
W2ldLnN0YXR1cyAhPSBXRlhfTElOS19IQVJEICYmCiAJCQkgICAhd3ZpZi0+d2Rldi0+dHhfcXVl
dWVfc3RhdHMubGlua19tYXBfY2FjaGVbaSArIDFdKSB7Ci0JCQl1bnNpZ25lZCBsb25nIGluYWN0
aXZpdHkgPQotCQkJCW5vdyAtIHd2aWYtPmxpbmtfaWRfZGJbaV0udGltZXN0YW1wOwotCi0JCQlp
ZiAoaW5hY3Rpdml0eSA8IG1heF9pbmFjdGl2aXR5KQotCQkJCWNvbnRpbnVlOwotCQkJbWF4X2lu
YWN0aXZpdHkgPSBpbmFjdGl2aXR5OwotCQkJcmV0ID0gaSArIDE7CisJCQlpZiAoIXJldCB8fCB0
aW1lX2FmdGVyKG9sZGVzdCwgd3ZpZi0+bGlua19pZF9kYltpXS50aW1lc3RhbXApKSB7CisJCQkJ
b2xkZXN0ID0gd3ZpZi0+bGlua19pZF9kYltpXS50aW1lc3RhbXA7CisJCQkJcmV0ID0gaSArIDE7
CisJCQl9CiAJCX0KIAl9CiAKLS0gCjIuMjUuMAoK
