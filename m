Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48681231D0
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbfLQQRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:17:39 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:6496
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729004AbfLQQP6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gC545bVdgq9SuPEUe/m8h/QniYh7FeciN3ko3gli6ZftD1IYggek7zR1p1QU0sgiYTOxrht5wEp0RGI91HKv/p7zzFl3VA9rFD0EUjPnCEzCfk6lQn+pOReeXVMTI8xmGPJTVJacNs7D0MKYf0k1XSY6qu2pNymZwiewGk8XJJ2TQJ76ih7cGuqBlY51gziGfDYs2zUujIpkhnlaRfk4YcWiFCEcaiLvpFsHV9el/NMYiaT2FxsppRpxsT2fJk7faxwj74l82zWUjXqvEGGva/tLNHCz/yb5wbh8dphYHbyEQrQR6qREGlVyIz5TU3zRqcv4GYXv0THxN7EWhkg5Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZ+/IhbadXELF0xffX7LphSKuGR1MBVq/x6o+jcQSlY=;
 b=QuL5LobGa5ABEY6xTmyPxGow4hH2Lxdg0hoFTSF3tXmHuQhkNyd4VWiGfH44ukKRJaEX65ymg4gnzblgChI39TGvmrAEP9Du8s5r3CtnnL2puv2FH8sPWJG9JJEWdDWy+DU1uGy2ZwNCuBWcGMeKO8+PtSjDEPmK6Ejm3UcFhpWm+CoysBYd97sbgAFlYHcPTlMwlQU03aIt26Xm4DK1cOCZHKRJL3XOtspwoJSp3Pv0nDZgIh3jyuITHb8ZTHTQpt/wAd9+6LJJErDSxiO+R/2MA9zvo1Or32Sx5wyWYjYoahtxeYlE7PSFAy9kH7duMV/zbKc9WQuTOO6sFrkOAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZ+/IhbadXELF0xffX7LphSKuGR1MBVq/x6o+jcQSlY=;
 b=XzR/bIzEDptyAGTEdDJNxpBu1JSnRw2Y1aZ/Y5DagTMs5aHbhgOFw1A1MzXMiiQXy2hqZpOEn0FiFOB6dqDGhr40fXXEVDf9pVsfPvTthLofZm+MDUWKRIjSL1LotdPgQlzBN1ZiY2BSGILatooTzmopxM7M8+4sysfwTACFwE0=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:45 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:45 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 40/55] staging: wfx: simplify hif_set_pm() usage
Thread-Topic: [PATCH v2 40/55] staging: wfx: simplify hif_set_pm() usage
Thread-Index: AQHVtPUvEUamb7q6X02OnND4ftWuCw==
Date:   Tue, 17 Dec 2019 16:15:23 +0000
Message-ID: <20191217161318.31402-41-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 88c2fab3-f616-4839-7186-08d7830c51b0
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB42088003BD918ADF7318D4DD93500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(6666004)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MwzzO59ORnjWkAZwlrN2PioEJY8SkxeScTYJCHeOuHHdLtPgxF34eAr7MBcg6lhNNDD+/YlHkuq6y3c+fx9X1IEuXiqPKdIklsOlZK8aCYyqcTJrVJPxgikiyry/s/kh0ZPTBKWUvi5HHCPleWLz1JwBnZNMKNHzijMClWeAsZrB339p2RSjZt1tvaoftba7KUf/ggEXZH4t7EN8tx1wZ++acGu1lgInsewmDFUXjCgvPM/spdag0Ry2r33aloSZQHn0qajRMTY4P9d7sgGYY38/nAMgXP3LBllMvuMxVBqUbPXiBaFeE6FRIXN5cK3WGB6ZnKR2SwOR0b4zfgxiCPLlmFIat+uoTy+Gznc5W8aGtsOickxB8WvCWJcKBqHEsZ4xt5LYVawZHKORB3VmNK+xCl8vrsUUIV/ScwQs69AdPEZIf5qgkZYZ8oMFQDMv
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F331650ADDD674097206FC493A9F806@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c2fab3-f616-4839-7186-08d7830c51b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:23.1447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xiidfCcFSLF3x8pNe6y5CuqQ9JplV0Fx9UbOeDmr0r4EPHgUEE89fC+8nerx4E75bxPCoB6lJFowW75aJAupRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdCBoaWZfcmVxX3NldF9wbV9tb2RlIGNvbWVzIGZyb20gaGFyZHdhcmUgQVBJLiBJdCBp
cyBub3QKaW50ZW5kZWQgdG8gYmUgbWFuaXB1bGF0ZWQgaW4gdXBwZXIgbGF5ZXJzIG9mIHRoZSBk
cml2ZXIuIFNvLCB0aGlzIHBhdGNoCnJlbG9jYXRlIHRoZSBoYW5kbGluZyBvZiB0aGlzIHN0cnVj
dCB0byBoaWZfc2V0X3BtKCkgKHRoZSBsb3cgbGV2ZWwKZnVuY3Rpb24pLgoKU2lnbmVkLW9mZi1i
eTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRy
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgfCAxMCArKysrKysrKy0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eC5oIHwgIDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgfCAy
NSArKysrKysrKystLS0tLS0tLS0tLS0tLS0tCiAzIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlv
bnMoKyksIDE5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IDZmYjk4ZGRiYzBl
Mi4uOWNiZjlkOTE2ZjVmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTM2MCwxMyArMzYwLDE5IEBA
IGludCBoaWZfc2V0X2VkY2FfcXVldWVfcGFyYW1zKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCXJl
dHVybiByZXQ7CiB9CiAKLWludCBoaWZfc2V0X3BtKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25z
dCBzdHJ1Y3QgaGlmX3JlcV9zZXRfcG1fbW9kZSAqYXJnKQoraW50IGhpZl9zZXRfcG0oc3RydWN0
IHdmeF92aWYgKnd2aWYsIGJvb2wgcHMsIGludCBkeW5hbWljX3BzX3RpbWVvdXQpCiB7CiAJaW50
IHJldDsKIAlzdHJ1Y3QgaGlmX21zZyAqaGlmOwogCXN0cnVjdCBoaWZfcmVxX3NldF9wbV9tb2Rl
ICpib2R5ID0gd2Z4X2FsbG9jX2hpZihzaXplb2YoKmJvZHkpLCAmaGlmKTsKIAotCW1lbWNweShi
b2R5LCBhcmcsIHNpemVvZigqYm9keSkpOworCWlmIChwcykgeworCQlib2R5LT5wbV9tb2RlLmVu
dGVyX3BzbSA9IDE7CisJCS8vIEZpcm13YXJlIGRvZXMgbm90IHN1cHBvcnQgbW9yZSB0aGFuIDEy
OG1zCisJCWJvZHktPmZhc3RfcHNtX2lkbGVfcGVyaW9kID0gbWluKGR5bmFtaWNfcHNfdGltZW91
dCAqIDIsIDI1NSk7CisJCWlmIChib2R5LT5mYXN0X3BzbV9pZGxlX3BlcmlvZCkKKwkJCWJvZHkt
PnBtX21vZGUuZmFzdF9wc20gPSAxOworCX0KIAl3ZnhfZmlsbF9oZWFkZXIoaGlmLCB3dmlmLT5p
ZCwgSElGX1JFUV9JRF9TRVRfUE1fTU9ERSwgc2l6ZW9mKCpib2R5KSk7CiAJcmV0ID0gd2Z4X2Nt
ZF9zZW5kKHd2aWYtPndkZXYsIGhpZiwgTlVMTCwgMCwgZmFsc2UpOwogCWtmcmVlKGhpZik7CmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfdHguaAppbmRleCBmNjFhZTdiMGQ0MWMuLmJiNTg2MGVlNjU0MiAxMDA2NDQKLS0t
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl90eC5oCkBAIC00Nyw3ICs0Nyw3IEBAIGludCBoaWZfd3JpdGVfbWliKHN0cnVjdCB3Znhf
ZGV2ICp3ZGV2LCBpbnQgdmlmX2lkLCB1MTYgbWliX2lkLAogaW50IGhpZl9zY2FuKHN0cnVjdCB3
ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3Qgd2Z4X3NjYW5fcGFyYW1zICphcmcpOwogaW50IGhp
Zl9zdG9wX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYpOwogaW50IGhpZl9qb2luKHN0cnVjdCB3
ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaGlmX3JlcV9qb2luICphcmcpOwotaW50IGhpZl9z
ZXRfcG0oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBoaWZfcmVxX3NldF9wbV9t
b2RlICphcmcpOworaW50IGhpZl9zZXRfcG0oc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgcHMs
IGludCBkeW5hbWljX3BzX3RpbWVvdXQpOwogaW50IGhpZl9zZXRfYnNzX3BhcmFtcyhzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZiwKIAkJICAgICAgIGNvbnN0IHN0cnVjdCBoaWZfcmVxX3NldF9ic3NfcGFy
YW1zICphcmcpOwogaW50IGhpZl9hZGRfa2V5KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBjb25zdCBz
dHJ1Y3QgaGlmX3JlcV9hZGRfa2V5ICphcmcpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggOWVjYTM1ZDkxYWQz
Li5iNDAwN2FmY2QwYzYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysr
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtMjkxLDM3ICsyOTEsMzAgQEAgdm9pZCB3
ZnhfY29uZmlndXJlX2ZpbHRlcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIHN0YXRpYyBpbnQg
d2Z4X3VwZGF0ZV9wbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIHsKIAlzdHJ1Y3QgaWVlZTgwMjEx
X2NvbmYgKmNvbmYgPSAmd3ZpZi0+d2Rldi0+aHctPmNvbmY7Ci0Jc3RydWN0IGhpZl9yZXFfc2V0
X3BtX21vZGUgcG07CisJYm9vbCBwcyA9IGNvbmYtPmZsYWdzICYgSUVFRTgwMjExX0NPTkZfUFM7
CisJaW50IHBzX3RpbWVvdXQgPSBjb25mLT5keW5hbWljX3BzX3RpbWVvdXQ7CiAKKwlXQVJOX09O
KGNvbmYtPmR5bmFtaWNfcHNfdGltZW91dCA8IDApOwogCWlmICh3dmlmLT5zdGF0ZSAhPSBXRlhf
U1RBVEVfU1RBIHx8ICF3dmlmLT5ic3NfcGFyYW1zLmFpZCkKIAkJcmV0dXJuIDA7Ci0KLQltZW1z
ZXQoJnBtLCAwLCBzaXplb2YocG0pKTsKLQlpZiAoY29uZi0+ZmxhZ3MgJiBJRUVFODAyMTFfQ09O
Rl9QUykgewotCQlwbS5wbV9tb2RlLmVudGVyX3BzbSA9IDE7Ci0JCS8vIEZpcm13YXJlIGRvZXMg
bm90IHN1cHBvcnQgbW9yZSB0aGFuIDEyOG1zCi0JCXBtLmZhc3RfcHNtX2lkbGVfcGVyaW9kID0K
LQkJCW1pbihjb25mLT5keW5hbWljX3BzX3RpbWVvdXQgKiAyLCAyNTUpOwotCQlpZiAocG0uZmFz
dF9wc21faWRsZV9wZXJpb2QpCi0JCQlwbS5wbV9tb2RlLmZhc3RfcHNtID0gMTsKLQl9Ci0KKwlp
ZiAoIXBzKQorCQlwc190aW1lb3V0ID0gMDsKIAlpZiAod3ZpZi0+ZWRjYS51YXBzZF9tYXNrKQot
CQlwbS5wbV9tb2RlLmZhc3RfcHNtID0gMDsKKwkJcHNfdGltZW91dCA9IDA7CiAKIAkvLyBLZXJu
ZWwgZGlzYWJsZSBQb3dlclNhdmUgd2hlbiBtdWx0aXBsZSB2aWZzIGFyZSBpbiB1c2UuIEluIGNv
bnRyYXJ5LAogCS8vIGl0IGlzIGFic29sdXRseSBuZWNlc3NhcnkgdG8gZW5hYmxlIFBvd2VyU2F2
ZSBmb3IgV0YyMDAKIAkvLyBGSVhNRTogb25seSBpZiBjaGFubmVsIHZpZjAgIT0gY2hhbm5lbCB2
aWYxCiAJaWYgKHd2aWZfY291bnQod3ZpZi0+d2RldikgPiAxKSB7Ci0JCXBtLnBtX21vZGUuZW50
ZXJfcHNtID0gMTsKLQkJcG0ucG1fbW9kZS5mYXN0X3BzbSA9IDA7CisJCXBzID0gdHJ1ZTsKKwkJ
cHNfdGltZW91dCA9IDA7CiAJfQogCiAJaWYgKCF3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVvdXQo
Jnd2aWYtPnNldF9wbV9tb2RlX2NvbXBsZXRlLAogCQkJCQkgVFVfVE9fSklGRklFUyg1MTIpKSkK
IAkJZGV2X3dhcm4od3ZpZi0+d2Rldi0+ZGV2LAogCQkJICJ0aW1lb3V0IHdoaWxlIHdhaXRpbmcg
b2Ygc2V0X3BtX21vZGVfY29tcGxldGVcbiIpOwotCXJldHVybiBoaWZfc2V0X3BtKHd2aWYsICZw
bSk7CisJcmV0dXJuIGhpZl9zZXRfcG0od3ZpZiwgcHMsIHBzX3RpbWVvdXQpOwogfQogCiBpbnQg
d2Z4X2NvbmZfdHgoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlm
ICp2aWYsCi0tIAoyLjI0LjAKCg==
