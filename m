Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E742123226
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbfLQQOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:14:45 -0500
Received: from mail-eopbgr770072.outbound.protection.outlook.com ([40.107.77.72]:46565
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728120AbfLQQOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:14:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9pgFKdNoHYXGWr0EVLAx0SztIwhP3vFiBVoc1sttZIsL29QlLX1lRzBrPkUj+HSdCR2Mwgxb+fzvgSV36jP4ZR9rlnitMAheRMY1wQ4mrL6SrUdoeS1Ohtvj9GBeiqop2XuGpndiGhB7uR6+zVLB8ZB3nsCvfC222SGM3FJUNdDRJV5PjTVxZuqP4NjvNDqQCsUoLpFvhxitvM122Vru4h2IlWY1kow/KC9z3ffcRM8QRZ4kKM6mGXF9QLwwoTncQKHHE7Czt/PuutGaAUvX9D00Kmqmb2svsuo6bDMlBRVv2cOM2ScJ+FJETEZnxvQbfUqkkFAL6Ids/xvdGwtsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nc9K3j/CNlVDo001+UrNKBkibFPlvivaSl3q5jhndzM=;
 b=fcXb6//Mne9hkIaeC9mtOJcWbp7qzM9aK90dVDkRHVdpxZZYfx9FIvKIe0bR446NL82V9hd1t9lgl2wDmW8CBAiGEhEYvek2jN9FX5PmnFmkys2n8rYGl2uzPkJnQb/HCJfWDv6ztxfC/pXLRxsq0vnDrSNv1iP8kXgYUTB9Y0t0z9bgmrXrWarKf0ra5TNwV8UP9zuBgmc/78RsnO5uvCpUe7DtrCCVRo1ex1y41pZi6jS0dBDvqouDgeg+YSCQAz4o5g9D2yJ9bdxrrWk5TDl3fx84ppwcSrxI2DgNCcwmv1W6iUb9bTYhZsKuJJLuks9VF/mRGiJsgSG2cU/0QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nc9K3j/CNlVDo001+UrNKBkibFPlvivaSl3q5jhndzM=;
 b=p8nNXClCois/pXPiAYyaJRUv8IbIls+uFU4v2EVbxkoy7HpIR4+FdL+Z+wWh7QzETJuoNh9XiE6l9WEn4l/ibbhe2BF2JQH2Si1UGK9Uq6t6bK8Q1VaAJFyzkMzoz8aIbWTNuPKGPVaKKnAHozScBVcThnhbb4onjEB4aildplc=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3678.namprd11.prod.outlook.com (20.178.254.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 16:14:42 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:42 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 12/55] staging: wfx: don't print useless error messages
Thread-Topic: [PATCH v2 12/55] staging: wfx: don't print useless error
 messages
Thread-Index: AQHVtPUXXn3HquIu9U2QGPrXCg+47g==
Date:   Tue, 17 Dec 2019 16:14:42 +0000
Message-ID: <20191217161318.31402-13-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11b05e8a-e8a7-492f-13bc-08d7830c3995
x-ms-traffictypediagnostic: MN2PR11MB3678:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3678BC7D200870797D7BCFE793500@MN2PR11MB3678.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(39840400004)(366004)(136003)(199004)(189003)(6512007)(66574012)(1076003)(478600001)(86362001)(8936002)(110136005)(316002)(2616005)(26005)(6506007)(5660300002)(36756003)(6486002)(66946007)(66476007)(66556008)(64756008)(66446008)(71200400001)(52116002)(85182001)(81166006)(81156014)(8676002)(54906003)(107886003)(15650500001)(2906002)(4326008)(186003)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3678;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sEOWjkteBovVlwF4FGytumDfIl/5nZTwJ9AYSkwXAZA+0Eg8tVX75a+4Iv/s5Jw2wEmJAa+G16fWXdr0AGpH11b47pxsO+1SwX/EGGAunvi49p32cwnN9a6Z4cmFDfaJWItOPYYyCr5Xcjs/iPKc5awlFX4VEopk495Pq1LzBDZU6DvBIWUNBl5Ji8QHyl/22QSaW0lTga1JwsBozReb1RZP6nLlM5QpTccgMXk1ERPkGM75Hr7TMZJxthyzj/Yn5MhitEbl0s4aAjjJCVLZBqPD4oxBKBPkAuNS/KEE12ZAtaAcy+1CloCoq+yru9CktgxB4NPDIkPdIRbuzFjc2LPavDNppPwhAYv0CB5PchvAS6VzGrXP+2o5wY2OOAx6AMtiiQrd/OOwoqxeLEnbg+dMHrlc1Gn/ath2/RAnarctWL/SWy/uZKYCPfgWFZXy
Content-Type: text/plain; charset="utf-8"
Content-ID: <70F12EFE96451F4FB2BDF3ABECBBC9C2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b05e8a-e8a7-492f-13bc-08d7830c3995
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:42.6721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S2mwGQk8DqiQ0SKm5sKcO6+A9PkgGSuJ/8zTxtDy8bvsqrs9PixeKfWJm5rW1FBGC/6LkFED+DghOsuz1UMDXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3678
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRHVy
aW5nIGNoaXAgcHJvYmluZywgaWYgZXJyb3IgZG9lcyBub3QgY29tZSBmcm9tIHNlY3VyZSBib290
IChmb3IKZXhlbXBsZSB3aGVuIGZpcm13YXJlIGhhcyBiZWVuIGZvdW5kKSwgb3RoZXJzIGVycm9y
cyBwcm9iYWJseSBhcHBlYXJzLgoKSXQgaXMgbm90IG5lY2Vzc2FyeSB0byBzYXkgdG8gdXNlciB0
aGF0IHRoZSBlcnJvciBkb2VzIG5vdCBjb21lIGZyb20Kc2VjdXJlIGJvb3QuIFNvLCBkcm9wIHRo
ZSBtZXNzYWdlIHNheWluZyAibm8gZXJyb3IgcmVwb3J0ZWQgYnkgc2VjdXJlCmJvb3QiLgoKQlRX
LCB3ZSB0YWtlIHRoZSBvcHBvcnR1bml0eSB0byBzaW1wbGlmeSBwcmludF9ib290X3N0YXR1cygp
LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxh
YnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZndpby5jIHwgMjYgKysrKysrKysrKy0t
LS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAxNiBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYyBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvZndpby5jCmluZGV4IGRiZjhiZGE3MWZmNy4uNDdlNjI3YmYwZjhlIDEw
MDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYworKysgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2Z3aW8uYwpAQCAtNjEsNyArNjEsNyBAQAogI2RlZmluZSBEQ0FfVElNRU9VVCAgNTAg
Ly8gbWlsbGlzZWNvbmRzCiAjZGVmaW5lIFdBS0VVUF9USU1FT1VUIDIwMCAvLyBtaWxsaXNlY29u
ZHMKIAotc3RhdGljIGNvbnN0IGNoYXIgKiBjb25zdCBmd2lvX2Vycm9yX3N0cmluZ3NbXSA9IHsK
K3N0YXRpYyBjb25zdCBjaGFyICogY29uc3QgZndpb19lcnJvcnNbXSA9IHsKIAlbRVJSX0lOVkFM
SURfU0VDX1RZUEVdID0gIkludmFsaWQgc2VjdGlvbiB0eXBlIG9yIHdyb25nIGVuY3J5cHRpb24i
LAogCVtFUlJfU0lHX1ZFUklGX0ZBSUxFRF0gPSAiU2lnbmF0dXJlIHZlcmlmaWNhdGlvbiBmYWls
ZWQiLAogCVtFUlJfQUVTX0NUUkxfS0VZXSA9ICJBRVMgY29udHJvbCBrZXkgbm90IGluaXRpYWxp
emVkIiwKQEAgLTIyMCwyMiArMjIwLDE2IEBAIHN0YXRpYyBpbnQgdXBsb2FkX2Zpcm13YXJlKHN0
cnVjdCB3ZnhfZGV2ICp3ZGV2LCBjb25zdCB1OCAqZGF0YSwgc2l6ZV90IGxlbikKIAogc3RhdGlj
IHZvaWQgcHJpbnRfYm9vdF9zdGF0dXMoc3RydWN0IHdmeF9kZXYgKndkZXYpCiB7Ci0JdTMyIHZh
bDMyOworCXUzMiByZWc7CiAKLQlzcmFtX3JlZ19yZWFkKHdkZXYsIFdGWF9TVEFUVVNfSU5GTywg
JnZhbDMyKTsKLQlpZiAodmFsMzIgPT0gMHgxMjM0NTY3OCkgewotCQlkZXZfaW5mbyh3ZGV2LT5k
ZXYsICJubyBlcnJvciByZXBvcnRlZCBieSBzZWN1cmUgYm9vdFxuIik7Ci0JfSBlbHNlIHsKLQkJ
c3JhbV9yZWdfcmVhZCh3ZGV2LCBXRlhfRVJSX0lORk8sICZ2YWwzMik7Ci0JCWlmICh2YWwzMiA8
IEFSUkFZX1NJWkUoZndpb19lcnJvcl9zdHJpbmdzKSAmJgotCQkgICAgZndpb19lcnJvcl9zdHJp
bmdzW3ZhbDMyXSkKLQkJCWRldl9pbmZvKHdkZXYtPmRldiwgInNlY3VyZSBib290IGVycm9yOiAl
c1xuIiwKLQkJCQkgZndpb19lcnJvcl9zdHJpbmdzW3ZhbDMyXSk7Ci0JCWVsc2UKLQkJCWRldl9p
bmZvKHdkZXYtPmRldiwKLQkJCQkgInNlY3VyZSBib290IGVycm9yOiBVbmtub3duICgweCUwMngp
XG4iLAotCQkJCSB2YWwzMik7Ci0JfQorCXNyYW1fcmVnX3JlYWQod2RldiwgV0ZYX1NUQVRVU19J
TkZPLCAmcmVnKTsKKwlpZiAocmVnID09IDB4MTIzNDU2NzgpCisJCXJldHVybjsKKwlzcmFtX3Jl
Z19yZWFkKHdkZXYsIFdGWF9FUlJfSU5GTywgJnJlZyk7CisJaWYgKHJlZyA8IEFSUkFZX1NJWkUo
Zndpb19lcnJvcnMpICYmIGZ3aW9fZXJyb3JzW3JlZ10pCisJCWRldl9pbmZvKHdkZXYtPmRldiwg
InNlY3VyZSBib290OiAlc1xuIiwgZndpb19lcnJvcnNbcmVnXSk7CisJZWxzZQorCQlkZXZfaW5m
byh3ZGV2LT5kZXYsICJzZWN1cmUgYm9vdDogRXJyb3IgJSMwMnhcbiIsIHJlZyk7CiB9CiAKIHN0
YXRpYyBpbnQgbG9hZF9maXJtd2FyZV9zZWN1cmUoc3RydWN0IHdmeF9kZXYgKndkZXYpCi0tIAoy
LjI0LjAKCg==
