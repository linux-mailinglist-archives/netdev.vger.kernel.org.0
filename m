Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694791231E1
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbfLQQSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:18:09 -0500
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:33729
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729013AbfLQQPy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9fymUrmZlaRhDthp6CRECFfOpT22K5ON5Mtda0sgr8oaIfIswnaGUYerPSDcm3GYbN7ck3LTStG0durbPt5FOZeHp2ZzHCN/RGIzNR6qnRrMO8t9UCcPiu8Jv3F09FeeJ/qIPz5FVTJi9tCtQkW3T3F6a19ccIHWrpy6RDgQxADCBHwvtDwMeEG6ACiu7sRiUPHwaxNyK15GupzmFvy78Xn5dpYv4d6R2apsc5MuVQ4GWSRaNpG6Te0+mm2zpKBy+FXckt8PmKtpOYfaHzsWBEVPbKSN1PD11FCGtLo4qVa2zWu/WjHIgYOxW3lN+SaLKWuWZhFZ+dLgx5DrO6bJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Me8/rbIanGxpbYOTeZgvzL3WSGozBd3Rm0cYjOm2ft0=;
 b=H5kweVL8y1gsvAjwqRWBwtyFoqq/LjRNJzfI0fejaCvOfkiH8e3jDxsNN0CpVchWl8AWyeXW1ySZ4ndP+03wwkIsOABLbKn9t6Rtx+iUUQ2AxPtNdeBNR7U5uN1bXA22RFUAhAw5WPY7Dj9e0yHQIB8Gyw3UkP5QKgWZvArsC7G6WTZ0vctdYqKIZ5O6hR/u25Fas5BsBM5KIkUvIO1qbZMv7TFbY0LQtJuDAx+JWvwrXSEe4OvuDKyg8QrB5f2nENQ9cZHA8kBRpjq7ryl7cw38iuharf0TQJ7yP2fsxL0c3V3uaVft2V9gkmx3pdtzcjPjreXmqIng0KPAiLkBAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Me8/rbIanGxpbYOTeZgvzL3WSGozBd3Rm0cYjOm2ft0=;
 b=Mq++CyPpBSPdRhLNSyVR70Pm0Md7AO4FM6bKa4ATzgjnyg/Qnf5nQY3fU5rMJi1+WUSNou/BpOCTtE6K4WOnJ1ZnYE5QRNi9qVyIjPiWaP4Q1vgLGdTlxBMqYBpw/UXblZpq8GORTrjVkXyZ/3+W+djod6rAPl8+PpfPqJ/Rmmk=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4477.namprd11.prod.outlook.com (52.135.36.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Tue, 17 Dec 2019 16:15:48 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:48 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 44/55] staging: wfx: hif_scan() never fails
Thread-Topic: [PATCH v2 44/55] staging: wfx: hif_scan() never fails
Thread-Index: AQHVtPUyvEYYGiAvQkWgAuq5fP/76Q==
Date:   Tue, 17 Dec 2019 16:15:28 +0000
Message-ID: <20191217161318.31402-45-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: e69c46a4-94cd-44f1-5385-08d7830c54c7
x-ms-traffictypediagnostic: MN2PR11MB4477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4477695E9FCC6CD8BCAB303393500@MN2PR11MB4477.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(1076003)(186003)(107886003)(8676002)(6506007)(86362001)(478600001)(85182001)(5660300002)(81156014)(26005)(4326008)(6486002)(8936002)(316002)(110136005)(54906003)(64756008)(66446008)(66946007)(2616005)(66556008)(66476007)(85202003)(36756003)(6512007)(2906002)(52116002)(6666004)(71200400001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4477;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0eIBLABmbMQrdiVPf3o/CLEvTVYUhBW35a0h0GKqbyd43sNGJ8j3yV4Fa9k9sIqHrJnbDuFiKCnGBpWXedDAXEqgF7f2Ikm59nuTzMQJMUM8O0hBgbsnUGvZ6ZbnZqdDXfa611gJRrfQiVRLcJoLHC6Kv/KlnfwqOG8yJLTnL14EBV6MK5kjoafOD4U4VmkvTrAjgE4xU65hVST/MT3PxwG6Lo3CZwUVjkYsd1s4ocEU4vNBFW34LAjGaUsWRJ5NVnobclj7wNX8U/cN1a8ZEGUbAMymsyds6KEjQ3hir2q00OuNA9AkCTVk+2nmo1DwFHe1aPR0hG68Z4yVkp2ApevTQhYXP0m0hSmYWjJ3pRwJaCsl+ss4udFHx/JlgX73suiW0nxeEvkN4IDEy9+nbbYKdYkToko/RgWvq4oqTPFgXsfxDGpqvWlXjupwc/qj
Content-Type: text/plain; charset="utf-8"
Content-ID: <E27986E50A648F4A8B158C4A5FA24D6D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e69c46a4-94cd-44f1-5385-08d7830c54c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:28.2919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3UHIqdDLykm3GyqZmhRKhFyGBpw2mVA8i3TQ+Fcu3MgqjP6/vXd3Xq+cla6c2ZnC2kmlQj8jYxS8qMBeGLlS7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4477
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSWYg
c2NhbiBmYWlscywgc3RhdHVzIGlzIHJldHVybmVkIGluIGhpZl9pbmRfc2Nhbl9jbXBsLiBoaWZf
c2NhbgphbHdheXMgcmV0dXJuIGEgc3VjY2Vzcy4gU28sIHdlIGNhbiBzaW1wbGlmeSB0aGUgY29k
ZS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyB8IDIwICsrLS0tLS0tLS0t
LS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaCB8ICAxIC0KIDIgZmlsZXMgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAxOSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCmluZGV4
IDRiOTVlNmE5N2RmNy4uY2RjY2I2N2NiMzBlIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3NjYW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwpAQCAtMzYsNyArMzYs
NiBAQCBzdGF0aWMgdm9pZCB3Znhfc2Nhbl9yZXN0YXJ0X2RlbGF5ZWQoc3RydWN0IHdmeF92aWYg
Knd2aWYpCiAKIHN0YXRpYyBpbnQgd2Z4X3NjYW5fc3RhcnQoc3RydWN0IHdmeF92aWYgKnd2aWYs
IHN0cnVjdCB3Znhfc2Nhbl9wYXJhbXMgKnNjYW4pCiB7Ci0JaW50IHJldDsKIAlpbnQgdG1vID0g
NTAwOwogCiAJaWYgKHd2aWYtPnN0YXRlID09IFdGWF9TVEFURV9QUkVfU1RBKQpAQCAtNDgsMTUg
KzQ3LDggQEAgc3RhdGljIGludCB3Znhfc2Nhbl9zdGFydChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwg
c3RydWN0IHdmeF9zY2FuX3BhcmFtcyAqc2NhbikKIAlhdG9taWNfc2V0KCZ3dmlmLT53ZGV2LT5z
Y2FuX2luX3Byb2dyZXNzLCAxKTsKIAogCXNjaGVkdWxlX2RlbGF5ZWRfd29yaygmd3ZpZi0+c2Nh
bi50aW1lb3V0LCBtc2Vjc190b19qaWZmaWVzKHRtbykpOwotCXJldCA9IGhpZl9zY2FuKHd2aWYs
IHNjYW4pOwotCWlmIChyZXQpIHsKLQkJd2Z4X3NjYW5fZmFpbGVkX2NiKHd2aWYpOwotCQlhdG9t
aWNfc2V0KCZ3dmlmLT5zY2FuLmluX3Byb2dyZXNzLCAwKTsKLQkJYXRvbWljX3NldCgmd3ZpZi0+
d2Rldi0+c2Nhbl9pbl9wcm9ncmVzcywgMCk7Ci0JCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygm
d3ZpZi0+c2Nhbi50aW1lb3V0KTsKLQkJd2Z4X3NjYW5fcmVzdGFydF9kZWxheWVkKHd2aWYpOwot
CX0KLQlyZXR1cm4gcmV0OworCWhpZl9zY2FuKHd2aWYsIHNjYW4pOworCXJldHVybiAwOwogfQog
CiBpbnQgd2Z4X2h3X3NjYW4oc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCkBAIC0yNDUsMTQgKzIz
Nyw2IEBAIHN0YXRpYyB2b2lkIHdmeF9zY2FuX2NvbXBsZXRlKHN0cnVjdCB3ZnhfdmlmICp3dmlm
KQogCXdmeF9zY2FuX3dvcmsoJnd2aWYtPnNjYW4ud29yayk7CiB9CiAKLXZvaWQgd2Z4X3NjYW5f
ZmFpbGVkX2NiKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQotewotCWlmIChjYW5jZWxfZGVsYXllZF93
b3JrX3N5bmMoJnd2aWYtPnNjYW4udGltZW91dCkgPiAwKSB7Ci0JCXd2aWYtPnNjYW4uc3RhdHVz
ID0gLUVJTzsKLQkJc2NoZWR1bGVfd29yaygmd3ZpZi0+c2Nhbi50aW1lb3V0LndvcmspOwotCX0K
LX0KLQogdm9pZCB3Znhfc2Nhbl9jb21wbGV0ZV9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAkJ
CSAgY29uc3Qgc3RydWN0IGhpZl9pbmRfc2Nhbl9jbXBsICphcmcpCiB7CmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5oCmlu
ZGV4IGM3YzBhYjE3OGM4Ny4uZTcxZTVmMGY1MjJlIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3NjYW4uaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaApAQCAtMzgsNiAr
MzgsNSBAQCB2b2lkIHdmeF9zY2FuX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsKIHZv
aWQgd2Z4X3NjYW5fdGltZW91dChzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOwogdm9pZCB3Znhf
c2Nhbl9jb21wbGV0ZV9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAkJCSAgY29uc3Qgc3RydWN0
IGhpZl9pbmRfc2Nhbl9jbXBsICphcmcpOwotdm9pZCB3Znhfc2Nhbl9mYWlsZWRfY2Ioc3RydWN0
IHdmeF92aWYgKnd2aWYpOwogCiAjZW5kaWYgLyogV0ZYX1NDQU5fSCAqLwotLSAKMi4yNC4wCgo=
