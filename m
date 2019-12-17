Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA0A12320A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbfLQQTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:19:40 -0500
Received: from mail-bn7nam10on2056.outbound.protection.outlook.com ([40.107.92.56]:15713
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728759AbfLQQPJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7LRk8W/M4fmWwCjqyS1EP18y03zqreH0HASNo/Hmu8RDYTLgAMyPn4MTOIfuTuGsYi31mKzqMRBDv3LbHCQbOXggUltXGbqU+HXFk/4sswTOCO7BWGvR01bdhjcRRZe3wWq2s9pJkg4bYiFsXmWHucoTN6r/VHPB8v753Wah6xYi8PIPCs1O2wCzkxeeAelBVZBBt1sWBzfMGzCmk7LWPhTOCt+h8CtaVZr4Y2PQcuwpPLfNiEhsXSjvPtLiet0PGMMHWTXa9EP1L6Z/fY7/UM+IWlPN/htcfTJY07WUS/5XOplUFaahK6YmUv3djKzEZVSGUKmVD6sWfILOka57A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oa3K0+KcAZHPdI+ay+5/VdEt2ZmkPyQAY8/yohGyoSc=;
 b=Gu37BTIWXYHJQ8pDk0qtNJtPfHb4hV2yN5GGzL8qEfb11A5dMY14eoDvQa0CYs7Wx4Pqs7/VsilotzMRoPy00HbNoekTQx9X5mh8hJtaEuAmM74mdpbw7xy25JKUAYvAyps4fDkH7siqE8xc3b54N7u5vPSNFiEvdK0eNY44SHBHfLwIaDEr6g29S7esFOEhtae3W4ICl4cCOb3Pe2LSk4jHlrLoIR9pQ8ne0ivGk5Efi5dYmom8ty3EUjBdbJ6STfGuV0LuKQ5yDDDXdm75u5ZkSvBhyioOjXaC3LnA2fe6gg0mjNZ9v1BrFdS/a4YJr+0CXUULfpcuacIb7QJ8GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oa3K0+KcAZHPdI+ay+5/VdEt2ZmkPyQAY8/yohGyoSc=;
 b=b9IZ2uHoWngk0FoUHLGQQ6I00FX5UBP2KQdDWszQAvaahUhVtE/Ft48toOL8LSk5K5kr/BJGwUYa8+MZ62wO3ZO4a1OOowk5HhkaT6bxNhQFglmC3RZ36e6UhlTaigC54lhuafrBJ235M8ZoCc/bTE92nRFMjlU0KalG+ctB1Xg=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:00 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:00 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 23/55] staging: wfx: fix typo in "num_of_ssi_ds"
Thread-Topic: [PATCH v2 23/55] staging: wfx: fix typo in "num_of_ssi_ds"
Thread-Index: AQHVtPUh240qq8pZ3EWniO+vtyJKrg==
Date:   Tue, 17 Dec 2019 16:15:00 +0000
Message-ID: <20191217161318.31402-24-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 39501991-a0ca-4a45-424a-08d7830c4464
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4208AB22BE0A4972C7F2F5BD93500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(4326008)(8676002)(86362001)(6486002)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0FMM12lLEnFzcCLcDC8YqfDQgLsnPFr4FbuPUS2O/AiM0MEtFFlhNbdZDHfNpjCdbtIaGeY81iLsmcGc5oKWYKG6z2hgcPuQBXN+DP5SdsbMhE1N0aH+EN2C3NorrhiHdxCQjLzGqmZWsus5gaMHYCqRso2LCxsjqMbKju911/6AjqvnDuJePRka1d4Q4uQQXO8E2hZFXbEfQzcnGHngdjxUdScKq+1qz9kp452vtc42vaZcjg3pc4aN1+a7FL6UCfPpSdsFVIQeOnVcj5ohajo2JCUMsLv4Ne70Mz/6r5D/viMuoyaBkLp/yPRVL0AlixmKQud7j4W8SBeOG7wwyY/hCu6PRr0yWRV6Sscva6JT7hnSiPZFgHp89j6a07NOFT8djvNERYWkTms+g16ro+wcUbfS4MtYYCBE7ZObqGxgvK0x69/ZiwKM2clFxqO0
Content-Type: text/plain; charset="utf-8"
Content-ID: <E196C90CD79C3E4A83F4E874ECE83C1D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39501991-a0ca-4a45-424a-08d7830c4464
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:00.7811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +lSuPib34f7tX4vZbCheyhvrd8XHSBC+L0JmrCXwh+iypOkTNJ+eoL9VYN9IYWr37HuFBvT9Zodwn4/VRXOywg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHNjcmlwdCB0aGF0IGhhcyBpbXBvcnRlZCBBUEkgaGVhZGVycyBoYXMgbWFkZSBhIG1pc3Rha2Ug
aW4KIm51bV9vZl9zc2lfZHMiLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGpl
cm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2Fw
aV9jbWQuaCB8ICA0ICsrLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgICAgICB8IDEw
ICsrKysrLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jICAgICAgICB8ICAyICstCiAz
IGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl9hcGlfY21kLmgKaW5kZXggYzE1ODMxZGU0ZmY0Li45MGJhNmU5YjgyZWEgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaAorKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKQEAgLTE4MCw3ICsxODAsNyBAQCBzdHJ1Y3QgaGlmX3Jl
cV9zdGFydF9zY2FuIHsKIAlzdHJ1Y3QgaGlmX2F1dG9fc2Nhbl9wYXJhbSBhdXRvX3NjYW5fcGFy
YW07CiAJdTggICAgbnVtX29mX3Byb2JlX3JlcXVlc3RzOwogCXU4ICAgIHByb2JlX2RlbGF5Owot
CXU4ICAgIG51bV9vZl9zc2lfZHM7CisJdTggICAgbnVtX29mX3NzaWRzOwogCXU4ICAgIG51bV9v
Zl9jaGFubmVsczsKIAl1MzIgICBtaW5fY2hhbm5lbF90aW1lOwogCXUzMiAgIG1heF9jaGFubmVs
X3RpbWU7CkBAIC0xOTYsNyArMTk2LDcgQEAgc3RydWN0IGhpZl9zdGFydF9zY2FuX3JlcV9jc3Ru
YnNzaWRfYm9keSB7CiAJc3RydWN0IGhpZl9hdXRvX3NjYW5fcGFyYW0gYXV0b19zY2FuX3BhcmFt
OwogCXU4ICAgIG51bV9vZl9wcm9iZV9yZXF1ZXN0czsKIAl1OCAgICBwcm9iZV9kZWxheTsKLQl1
OCAgICBudW1fb2Zfc3NpX2RzOworCXU4ICAgIG51bV9vZl9zc2lkczsKIAl1OCAgICBudW1fb2Zf
Y2hhbm5lbHM7CiAJdTMyICAgbWluX2NoYW5uZWxfdGltZTsKIAl1MzIgICBtYXhfY2hhbm5lbF90
aW1lOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX3R4LmMKaW5kZXggZThjMmJkMWVmYmFjLi4yZjc0YWJjYTJiNjAgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfdHguYwpAQCAtMjI3LDEyICsyMjcsMTIgQEAgaW50IGhpZl9zY2FuKHN0cnVj
dCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3Qgd2Z4X3NjYW5fcGFyYW1zICphcmcpCiAJc3Ry
dWN0IGhpZl9zc2lkX2RlZiAqc3NpZHM7CiAJc2l6ZV90IGJ1Zl9sZW4gPSBzaXplb2Yoc3RydWN0
IGhpZl9yZXFfc3RhcnRfc2NhbikgKwogCQlhcmctPnNjYW5fcmVxLm51bV9vZl9jaGFubmVscyAq
IHNpemVvZih1OCkgKwotCQlhcmctPnNjYW5fcmVxLm51bV9vZl9zc2lfZHMgKiBzaXplb2Yoc3Ry
dWN0IGhpZl9zc2lkX2RlZik7CisJCWFyZy0+c2Nhbl9yZXEubnVtX29mX3NzaWRzICogc2l6ZW9m
KHN0cnVjdCBoaWZfc3NpZF9kZWYpOwogCXN0cnVjdCBoaWZfcmVxX3N0YXJ0X3NjYW4gKmJvZHkg
PSB3ZnhfYWxsb2NfaGlmKGJ1Zl9sZW4sICZoaWYpOwogCXU4ICpwdHIgPSAodTggKikgYm9keSAr
IHNpemVvZigqYm9keSk7CiAKIAlXQVJOKGFyZy0+c2Nhbl9yZXEubnVtX29mX2NoYW5uZWxzID4g
SElGX0FQSV9NQVhfTkJfQ0hBTk5FTFMsICJpbnZhbGlkIHBhcmFtcyIpOwotCVdBUk4oYXJnLT5z
Y2FuX3JlcS5udW1fb2Zfc3NpX2RzID4gMiwgImludmFsaWQgcGFyYW1zIik7CisJV0FSTihhcmct
PnNjYW5fcmVxLm51bV9vZl9zc2lkcyA+IDIsICJpbnZhbGlkIHBhcmFtcyIpOwogCVdBUk4oYXJn
LT5zY2FuX3JlcS5iYW5kID4gMSwgImludmFsaWQgcGFyYW1zIik7CiAKIAkvLyBGSVhNRTogVGhp
cyBBUEkgaXMgdW5uZWNlc3NhcnkgY29tcGxleCwgZml4aW5nIE51bU9mQ2hhbm5lbHMgYW5kCkBA
IC0yNDMsMTEgKzI0MywxMSBAQCBpbnQgaGlmX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNv
bnN0IHN0cnVjdCB3Znhfc2Nhbl9wYXJhbXMgKmFyZykKIAljcHVfdG9fbGUzMnMoJmJvZHktPm1h
eF9jaGFubmVsX3RpbWUpOwogCWNwdV90b19sZTMycygmYm9keS0+dHhfcG93ZXJfbGV2ZWwpOwog
CW1lbWNweShwdHIsIGFyZy0+c3NpZHMsCi0JICAgICAgIGFyZy0+c2Nhbl9yZXEubnVtX29mX3Nz
aV9kcyAqIHNpemVvZihzdHJ1Y3QgaGlmX3NzaWRfZGVmKSk7CisJICAgICAgIGFyZy0+c2Nhbl9y
ZXEubnVtX29mX3NzaWRzICogc2l6ZW9mKHN0cnVjdCBoaWZfc3NpZF9kZWYpKTsKIAlzc2lkcyA9
IChzdHJ1Y3QgaGlmX3NzaWRfZGVmICopIHB0cjsKLQlmb3IgKGkgPSAwOyBpIDwgYm9keS0+bnVt
X29mX3NzaV9kczsgKytpKQorCWZvciAoaSA9IDA7IGkgPCBib2R5LT5udW1fb2Zfc3NpZHM7ICsr
aSkKIAkJY3B1X3RvX2xlMzJzKCZzc2lkc1tpXS5zc2lkX2xlbmd0aCk7Ci0JcHRyICs9IGFyZy0+
c2Nhbl9yZXEubnVtX29mX3NzaV9kcyAqIHNpemVvZihzdHJ1Y3QgaGlmX3NzaWRfZGVmKTsKKwlw
dHIgKz0gYXJnLT5zY2FuX3JlcS5udW1fb2Zfc3NpZHMgKiBzaXplb2Yoc3RydWN0IGhpZl9zc2lk
X2RlZik7CiAJbWVtY3B5KHB0ciwgYXJnLT5jaCwgYXJnLT5zY2FuX3JlcS5udW1fb2ZfY2hhbm5l
bHMgKiBzaXplb2YodTgpKTsKIAlwdHIgKz0gYXJnLT5zY2FuX3JlcS5udW1fb2ZfY2hhbm5lbHMg
KiBzaXplb2YodTgpOwogCVdBUk4oYnVmX2xlbiAhPSBwdHIgLSAodTggKikgYm9keSwgImFsbG9j
YXRpb24gc2l6ZSBtaXNtYXRjaCIpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9z
Y2FuLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwppbmRleCA0NWU3OGM1NzIyZmYuLmNi
N2ExZmRkMDAwMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKQEAgLTIwNCw3ICsyMDQsNyBAQCB2b2lkIHdmeF9z
Y2FuX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCQlzY2FuLnNjYW5fcmVxLm1heF90
cmFuc21pdF9yYXRlID0gQVBJX1JBVEVfSU5ERVhfQl8xTUJQUzsKIAlzY2FuLnNjYW5fcmVxLm51
bV9vZl9wcm9iZV9yZXF1ZXN0cyA9CiAJCShmaXJzdC0+ZmxhZ3MgJiBJRUVFODAyMTFfQ0hBTl9O
T19JUikgPyAwIDogMjsKLQlzY2FuLnNjYW5fcmVxLm51bV9vZl9zc2lfZHMgPSB3dmlmLT5zY2Fu
Lm5fc3NpZHM7CisJc2Nhbi5zY2FuX3JlcS5udW1fb2Zfc3NpZHMgPSB3dmlmLT5zY2FuLm5fc3Np
ZHM7CiAJc2Nhbi5zc2lkcyA9ICZ3dmlmLT5zY2FuLnNzaWRzWzBdOwogCXNjYW4uc2Nhbl9yZXEu
bnVtX29mX2NoYW5uZWxzID0gaXQgLSB3dmlmLT5zY2FuLmN1cnI7CiAJc2Nhbi5zY2FuX3JlcS5w
cm9iZV9kZWxheSA9IDEwMDsKLS0gCjIuMjQuMAoK
