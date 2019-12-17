Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6941231B2
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbfLQQQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:16:46 -0500
Received: from mail-eopbgr680042.outbound.protection.outlook.com ([40.107.68.42]:26848
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729156AbfLQQQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:16:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUJ1+GyR4vJ4S5c+7XVOKWz5AEACpK5VXnXpkQ7w+NqEu1BWvUuQLNrpooQv54Cro4uMhbSHNkZpSRweyjkxFXfp/mMbNqiGe5gHBdC2x+qJ6JSVU54sYNC8T9zRIIEarKFe5YsjcfedvRU7gI3catoSALPZPA5Q3KGi25xd2jfhJktamENfp2WxIS3iOVwuO7iT3MeN/QWPGaeuP1KfswaOUBLRrbjHkgEKt7eNzuzPTz68t9G75aOca5J96GdLmNCUGoatAhL25xIhaTqKHKjHcqYoEYmvhMK7jjVzXyjQywlJJR9DV4Io61NzUOoPwvUTDunuqjHmmbSQMqy24A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lrvld7QLg+34BaehMcizNTeqjcM2jdt+MzrGluOpN+U=;
 b=aaUuYsHVHOZWX2VR+PrWHsUjj0RqC17wp1EBKQzEyfb7ywN08WC44jW3glGzNS/RKciWIT5pUcSGMijeJZVjrbLb6VFkm0Gu1cFcvfVpLphAdvpfK0AW1OiyfIUA2au2z69pgY5oK9w2HOwPzbNVSMiDX4sjCr0DTALd6S0uAJ88JQf+TYYGQXnGXjDcdvNO5rF3v/VDae2SUgypwPmT2bMzuJRrzAcPP7PETjFFJrNYatmqmZpwJVS6FXlQSA62UzGWrfHI9eu/Hcv0e1240LJ6QMOOC4XCiikc6BKdrfxuT7dYA8vNwBRaoKzR+08CFYPQ72/nzPzLncHi4764ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lrvld7QLg+34BaehMcizNTeqjcM2jdt+MzrGluOpN+U=;
 b=WSx9dI7yw84xtUHr/o5t34R1DDnQLavKk3hobBKr+2DrhQRwZ6H7f+IjCrijdpmqX5U9MJsAV0lsd1iPiOES3plqiwVi/sOp7dSquzUK4mT//yGK3SGBeswujqM+YGSdGSdXHPyrpk9XAiHsA2nItvs8C5Ox7hLyrpH4lfzGrMY=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3791.namprd11.prod.outlook.com (20.178.254.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:16:06 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:16:06 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 55/55] staging: wfx: update TODO
Thread-Topic: [PATCH v2 55/55] staging: wfx: update TODO
Thread-Index: AQHVtPU6C/GkqvVkY0OgUfqfRu8C9A==
Date:   Tue, 17 Dec 2019 16:15:42 +0000
Message-ID: <20191217161318.31402-56-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: a35cfc4f-93d0-454e-028c-08d7830c5d36
x-ms-traffictypediagnostic: MN2PR11MB3791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB379156DCBCC6BF72096C75FD93500@MN2PR11MB3791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(346002)(136003)(39860400002)(189003)(199004)(2906002)(52116002)(107886003)(2616005)(86362001)(478600001)(6486002)(15650500001)(4326008)(64756008)(66556008)(66476007)(81156014)(966005)(66946007)(6506007)(1076003)(316002)(66446008)(8936002)(71200400001)(81166006)(5660300002)(36756003)(26005)(186003)(8676002)(85202003)(6666004)(66574012)(85182001)(110136005)(54906003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3791;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D0d0TNcCV9I6VzbCVelZGhwjwy7eHP2uCXgmE09912exIvcLfSBjr+oChgIyxBj4OiVhhg95m8dxZhpkHZiVMk+KeokTTFSj8XmQ/b2Ww8kuWG1WRjHS9gt6A9QMurjgUVVTuiSq40UfQbhrJpLWBnoADXXo2G7QbLU6S7MKXgDqHFj+iUlIf4uo2orCY5BenYgwJJMhiQZbStlUlB6Xv2KT9Wk232Yxo6h4mnYdFd+ZaF0AJRFYtlaYsA61CWC4Ffm0OC2xxt4TutsgbsUF44a8sTtlSqi55MWk85gJgbI/bQpCRhuext67KRIdwl7LnUe4ObAEF+2VfLpnvzcdCxHhE26ABpQ1ieAG8VkAsQ11GKsmUHbvIgYmu8rqD3oc/dJcIkQgPNCTjL0IIh3Jn9cgRNxrHRX5oi7TIPTx1YLYTE2OGNXcVIXnMyxKEIEWYtMMvTIB3hbK0A8XR1vpo8PxK6SW2nKmB0scR8P7Ck0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59C5E5F22469AC4DB54424F3CB45A775@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a35cfc4f-93d0-454e-028c-08d7830c5d36
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:42.4340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PCGzH/MkwkBvlFG1OBMlxUMz3Hk5XlxT95YXGwUqxnvXENO/McgQuUne1+ogFzp8pu2wj7nLrm0lup71GcZtlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVXBk
YXRlIHRoZSBUT0RPIGxpc3Qgb2Ygd2Z4IGRyaXZlciB3aXRoIGEgbW9yZSBwcmVjaXNlIGxpc3Qg
b2YgaXRlbXMuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWls
bGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPIHwgODEgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDY3IGlu
c2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvVE9ETyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvVE9ETwppbmRleCBlNDQ3NzIyODlhZjgu
LjZiMWNkZDI0YWZjOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvVE9ETwpAQCAtMSwxNyArMSw3MCBAQAogVGhpcyBpcyBhIGxp
c3Qgb2YgdGhpbmdzIHRoYXQgbmVlZCB0byBiZSBkb25lIHRvIGdldCB0aGlzIGRyaXZlciBvdXQg
b2YgdGhlCiBzdGFnaW5nIGRpcmVjdG9yeS4KIAotICAtIEkgaGF2ZSB0byB0YWtlIGEgZGVjaXNp
b24gYWJvdXQgc2VjdXJlIGxpbmsgc3VwcG9ydC4gSSBjYW46Ci0gICAgICAtIGRyb3AgY29tcGxl
dGVseQotICAgICAgLSBrZWVwIGl0IGluIGFuIGV4dGVybmFsIHBhdGNoIChteSBwcmVmZXJyZWQg
b3B0aW9uKQotICAgICAgLSByZXBsYWNlIGNhbGwgdG8gbWJlZHRscyB3aXRoIGtlcm5lbCBjcnlw
dG8gQVBJIChuZWNlc3NpdGF0ZSBhCi0gICAgICAgIGJ1bmNoIG9mIHdvcmspCi0gICAgICAtIHB1
bGwgbWJlZHRscyBpbiBrZXJuZWwgKG5vbi1yZWFsaXN0aWMpCi0KLSAgLSBtYWM4MDIxMSBpbnRl
cmZhY2UgZG9lcyBub3QgKHlldCkgaGF2ZSBleHBlY3RlZCBxdWFsaXR5IHRvIGJlIHBsYWNlZAot
ICAgIG91dHNpZGUgb2Ygc3RhZ2luZzoKLSAgICAgIC0gU29tZSBwcm9jZXNzaW5ncyBhcmUgcmVk
dW5kYW50IHdpdGggbWFjODAyMTEgb25lcwotICAgICAgLSBNYW55IG1lbWJlcnMgZnJvbSB3Znhf
ZGV2L3dmeF92aWYgY2FuIGJlIHJldHJpZXZlZCBmcm9tIG1hYzgwMjExCi0gICAgICAgIHN0cnVj
dHVyZXMKLSAgICAgIC0gU29tZSBmdW5jdGlvbnMgYXJlIHRvbyBjb21wbGV4Ci0gICAgICAtIC4u
LgorICAtIEFsbG9jYXRpb24gb2YgImxpbmsgaWRzIiBpcyB0b28gY29tcGxleC4gQWxsb2NhdGlv
bi9yZWxlYXNlIG9mIGxpbmsgaWRzIGZyb20KKyAgICBzdGFfYWRkKCkvc3RhX3JlbW92ZSgpIHNo
b3VsZCBiZSBzdWZmaWNpZW50LgorCisgIC0gVGhlIHBhdGggZm9yIHBhY2tldHMgd2l0aCBJRUVF
ODAyMTFfVFhfQ1RMX1NFTkRfQUZURVJfRFRJTSBmbGFncyBzaG91bGQgYmUKKyAgICBjbGVhbmVk
IHVwLiBDdXJyZW50bHksIHRoZSBwcm9jZXNzIGludm9sdmUgbXVsdGlwbGUgd29yayBzdHJ1Y3Rz
IGFuZCBhCisgICAgdGltZXIuIEl0IGNvdWxkIGJlIHNpbXBsaWZlZC4gSW4gYWRkLCB0aGUgcmVx
dWV1ZSBtZWNoYW5pc20gdHJpZ2dlcnMgbW9yZQorICAgIGZyZXF1ZW50bHkgdGhhbiBpdCBzaG91
bGQuCisKKyAgLSBBbGwgc3RydWN0dXJlcyBkZWZpbmVkIGluIGhpZl9hcGlfKi5oIGFyZSBpbnRl
bmRlZCB0byBzZW50L3JlY2VpdmVkIHRvL2Zyb20KKyAgICBoYXJkd2FyZS4gQWxsIHRoZWlyIG1l
bWJlcnMgd2hvdWxkIGJlIGRlY2xhcmVkIF9fbGUzMiBvciBfX2xlMTYuIFRoZXNlCisgICAgc3Ry
dWN0cyBzaG91bGQgb25seSBiZWVuIHVzZWQgaW4gZmlsZXMgbmFtZWQgaGlmXyogKGFuZCBtYXli
ZSBpbiBkYXRhXyouYykuCisgICAgVGhlIHVwcGVyIGxheWVycyAoc3RhLmMsIHNjYW4uYyBldGMu
Li4pIHNob3VsZCBtYW5hZ2UgbWFjODAyMTEgc3RydWN0dXJlcy4KKyAgICBTZWU6CisgICAgICAg
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDE5MTExMTIwMjg1Mi5HWDI2NTMwQFplbklW
LmxpbnV4Lm9yZy51aworCisgIC0gT25jZSBwcmV2aW91cyBpdGVtIGRvbmUsIGl0IHdpbGwgYmUg
cG9zc2libGUgdG8gYXVkaXQgdGhlIGRyaXZlciB3aXRoCisgICAgYHNwYXJzZScuIEl0IHdpbGwg
cHJvYmFibHkgZmluZCB0b25zIG9mIHByb2JsZW1zIHdpdGggYmlnIGVuZGlhbgorICAgIGFyY2hp
dGVjdHVyZXMuCisKKyAgLSBoaWZfYXBpXyouaCB3aGF2ZSBiZWVuIGltcG9ydGVkIGZyb20gZmly
bXdhcmUgY29kZS4gU29tZSBvZiB0aGUgc3RydWN0dXJlcworICAgIGFyZSBuZXZlciB1c2VkIGlu
IGRyaXZlci4KKworICAtIERyaXZlciB0cnkgdG8gbWFpbnRhaW5zIHBvd2VyIHNhdmUgc3RhdHVz
IG9mIHRoZSBzdGF0aW9ucy4gSG93ZXZlciwgdGhpcworICAgIHdvcmsgaXMgYWxyZWFkeSBkb25l
IGJ5IG1hYzgwMjExLiBzdGFfYXNsZWVwX21hc2sgYW5kIHBzcG9sbF9tYXNrIHNob3VsZCBiZQor
ICAgIGRyb3BwZWQuCisKKyAgLSB3ZnhfdHhfcXVldWVzX2dldCgpIHNob3VsZCBiZSByZXdvcmtl
ZC4gSXQgY3VycmVudGx5IHRyeSBjb21wdXRlIGl0c2VsZiB0aGUKKyAgICBRb1MgcG9saWN5LiBI
b3dldmVyLCBmaXJtd2FyZSBhbHJlYWR5IGRvIHRoZSBqb2IuIEZpcm13YXJlIHdvdWxkIHByZWZl
ciB0bworICAgIGhhdmUgYSBmZXcgcGFja2V0cyBpbiBlYWNoIHF1ZXVlIGFuZCBiZSBhYmxlIHRv
IGNob29zZSBpdHNlbGYgd2hpY2ggcXVldWUgdG8KKyAgICB1c2UuCisKKyAgLSBBcyBzdWdnZXN0
ZWQgYnkgRmVsaXgsIHJhdGUgY29udHJvbCBjb3VsZCBiZSBpbXByb3ZlZCBmb2xsb3dpbmcgdGhp
cyBpZGVhOgorICAgICAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzMwOTk1NTkuZ3Yz
UTc1S25OMUBwYy00Mi8KKworICAtIFdoZW4gZHJpdmVyIGlzIGFib3V0IHRvIGxvb3NlIEJTUywg
aXQgZm9yZ2UgaXRzIG93biBOdWxsIEZ1bmMgcmVxdWVzdCAoc2VlCisgICAgd2Z4X2NxbV9ic3Ns
b3NzX3NtKCkpLiBJdCBzaG91bGQgdXNlIG1lY2hhbmlzbSBwcm92aWRlZCBieSBtYWM4MDIxMS4K
KworICAtIEFQIGlzIGFjdHVhbGx5IGlzIHNldHVwIGFmdGVyIGEgY2FsbCB0byB3ZnhfYnNzX2lu
Zm9fY2hhbmdlZCgpLiBZZXQsCisgICAgaWVlZTgwMjExX29wcyBwcm92aWRlIGNhbGxiYWNrIHN0
YXJ0X2FwKCkuCisKKyAgLSBUaGUgY3VycmVudCBwcm9jZXNzIGZvciBqb2luaW5nIGEgbmV0d29y
ayBpcyBpbmNyZWRpYmx5IGNvbXBsZXguIFNob3VsZCBiZQorICAgIHJld29ya2VkLgorCisgIC0g
TW9uaXRvcmluZyBtb2RlIGlzIG5vdCBpbXBsZW1lbnRlZCBkZXNwaXRlIGJlaW5nIG1hbmRhdG9y
eSBieSBtYWM4MDIxMS4KKworICAtICJjb21wYXRpYmxlIiB2YWx1ZSBhcmUgbm90IGNvcnJlY3Qu
IFRoZXkgc2hvdWxkIGJlICJ2ZW5kb3IsY2hpcCIuIFNlZToKKyAgICAgICBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9kcml2ZXJkZXYtZGV2ZWwvNTIyNjU3MC5DTUg1aFZsWmNJQHBjLTQyCisKKyAg
LSBUaGUgInN0YXRlIiBmaWVsZCBmcm9tIHdmeF92aWYgc2hvdWxkIGJlIHJlcGxhY2VkIGJ5ICJ2
aWYtPnR5cGUiLgorCisgIC0gSXQgc2VlbXMgdGhhdCB3ZnhfdXBsb2FkX2tleXMoKSBpcyB1c2Vs
ZXNzLgorCisgIC0gImV2ZW50X3F1ZXVlIiBmcm9tIHdmeF92aWYgc2VlbXMgb3ZlcmtpbGwuIFRo
ZXNlIGV2ZW50IGFyZSByYXJlIGFuZCB0aGV5CisgICAgIHByb2JhYmx5IGNvdWxkIGJlIGhhbmRs
ZWQgaW4gYSBzaW1wbGVyIGZhc2hpb24uCisKKyAgLSBGZWF0dXJlIGNhbGxlZCAic2VjdXJlIGxp
bmsiIHNob3VsZCBiZSBlaXRoZXIgZGV2ZWxvcGVkICh1c2luZyBrZXJuZWwKKyAgICBjcnlwdG8g
QVBJKSBvciBkcm9wcGVkLgorCisgIC0gSW4gd2Z4X2NtZF9zZW5kKCksICJhc3luYyIgYWxsb3cg
dG8gc2VuZCBjb21tYW5kIHdpdGhvdXQgd2FpdGluZyB0aGUgcmVwbHkuCisgICAgSXQgbWF5IGhl
bHAgaW4gc29tZSBzaXR1YXRpb24sIGJ1dCBpdCBpcyBub3QgeWV0IHVzZWQuIEluIGFkZCwgaXQg
bWF5IGNhdXNlCisgICAgc29tZSB0cm91YmxlOgorICAgICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvZHJpdmVyZGV2LWRldmVsL2FscGluZS5ERUIuMi4yMS4xOTEwMDQxMzE3MzgxLjI5OTJAaGFk
cmllbi8KKyAgICBTbywgZml4IGl0IChieSByZXBsYWNpbmcgdGhlIG11dGV4IHdpdGggYSBzZW1h
cGhvcmUpIG9yIGRyb3AgaXQuCisKKyAgLSBDaGlwIHN1cHBvcnQgUDJQLCBidXQgZHJpdmVyIGRv
ZXMgbm90IGltcGxlbWVudCBpdC4KKworICAtIENoaXAgc3VwcG9ydCBraW5kIG9mIE1lc2gsIGJ1
dCBkcml2ZXIgZG9lcyBub3QgaW1wbGVtZW50IGl0LgotLSAKMi4yNC4wCgo=
