Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5060D12320F
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbfLQQTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:19:52 -0500
Received: from mail-eopbgr680046.outbound.protection.outlook.com ([40.107.68.46]:59543
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728670AbfLQQPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVbpSH5CJ7CgEjElDC3ks94cOXYs+c5kYarbdyN1eYdCa1Q1DCDyM7b6XxFEW8d2CtSXaOHtj7Mn/NUq9GMhUlWDeT2d1m9MuNjOmq5a8hYdq7Loup1vNpToqfmHKpZvF/eaQjkjnoYs3A0N33F135/OXhK2fXnwvTJspj8RUY1oCPuo95P6sTk12dgglM35EMfvvuG8/H4Jj/pBsLp9cbCR3pfTzJhxMS+XCuuFjvAF2w87ZbdXqw82ON2UyWmknoQ1Y4ZlIwvNmDY7fFtbLEfHCfkfYgrm7hknnsH+sLfs7+JZLS9nuABj/enGc3/6Fc8RqkTL4ZS/Dm2doSyLlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4zmIWF1VEfiZFnDsG5urt00s1dOZma4jMG+tf8W3k4=;
 b=cia59cx1+YVCpiq5D/qiMsmb6XQFyMOt55eQblDnWlFWWE2HKMluAltv3p9x7FSGmfK74UHe84xGUxZMUJO2I3p1q1nkefTta3thSUUffhJVtWIfhr+WX4C4o9II3C43Jg2I3umdSvE2Ow0SCNjpEgt3xE3kPk7ssGQSlnSdIZ/a5FDrZZo6ZNLgQslz6OdShdti0Wb51nqNEZyjw1Z6aq4VzFuHHjFMR8pruUzikRQm+X83Mimdl8caso/ZIhLdSdwzEX4PHkpJEKsc3UVTVg6Sh0PZop5rxqjX6ADiIQSeEuca/vHHxSvtisENn7x+oyD9opCAv3oJixKdtDZpsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4zmIWF1VEfiZFnDsG5urt00s1dOZma4jMG+tf8W3k4=;
 b=f1TR4mFvqxdQQAPd1YpALE2lQZ5OTP5KsSHB7kBIwO7IdwtuV/XoUO+c1a1lA265IIQU72ctC9irJejXvq9alFDqwOMYxqZ3NiSfSWjJNGIRnhtXJSp6jxj/GOdIJGdA0bT5wy7ghpDvFZx0wY4tMyE3Bc/d4hhtDWqTijglr1Y=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3791.namprd11.prod.outlook.com (20.178.254.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:14:55 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:55 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 19/55] staging: wfx: simplify variable assignment
Thread-Topic: [PATCH v2 19/55] staging: wfx: simplify variable assignment
Thread-Index: AQHVtPUezJkUHDulLEKXzdmJ3J5fhA==
Date:   Tue, 17 Dec 2019 16:14:55 +0000
Message-ID: <20191217161318.31402-20-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: a46e1d4d-381f-4af0-0972-08d7830c4148
x-ms-traffictypediagnostic: MN2PR11MB3791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3791C87EEB35F7880E109D6593500@MN2PR11MB3791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:206;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(346002)(136003)(39860400002)(189003)(199004)(2906002)(52116002)(107886003)(2616005)(86362001)(478600001)(6486002)(4326008)(64756008)(66556008)(66476007)(81156014)(66946007)(6506007)(1076003)(316002)(66446008)(8936002)(71200400001)(81166006)(5660300002)(36756003)(26005)(186003)(8676002)(85202003)(4744005)(66574012)(85182001)(110136005)(54906003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3791;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wihv4HmF95XzUQwzVrXbcb2bQbIUrIYprEtSkGgmHYRh0+faNBVCaF9eaz5H+9YUpcv5d/iGXHmGeK8qttSYDpnvPj7eqb9dJkfRx6n7+UVNv1FPPWu3GBB6A6DXIAxrcmUH6fMIy9hVoYzAsl9DaWtfLskBI6wuz5sg3Gs1qryGsT0uMPy1ZVeiuiDrHO33+ezFgT8JZiAEG+rTNeS+48dz5WQUPDyCUfEPE5cQy+njHzRmmYynJZiqHEIpP0D1m5O7YjtOQ8Pu4Ay9y75j6DuAKZkD1Hft3JQdmS5wp3eJD/RmXsXvDsVwOTn2bzWp64nN7gmIN7RRMmVPTEA7B+m79BZ1y9TfneLGGBSgleI/3kBSe9Tar1dSJiQSe/kGQSX9mlUD2NEB1HeuBM0HR88gYI9QYcNuS42Fn/O1uZTJWL8+mtHMNZjmII2meGJh
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC6F4A7B0BB79A40852B84130C1262EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a46e1d4d-381f-4af0-0972-08d7830c4148
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:55.6829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U1e5Z1PtEHJeV8p0rie4LcJU0eSkDFO5BJc2VlRtu8STQUYveUo0u7Zmua5+W+Nca4XZ8xxZ3wtHJrs9MloVnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQXR0
cmlidXRlICJhYm9ydGVkIiBhbmQgYXJndW1lbnQgImFib3J0ZWQiIGFyZSBib3RoIGJvb2xlYW5z
LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxh
YnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIHwgMiArLQogMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwppbmRleCAz
NWZjZjkxMTlmOTYuLmE2YzkzNDAwYTdiYSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9zY2FuLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKQEAgLTE2LDcgKzE2LDcg
QEAgc3RhdGljIHZvaWQgX19pZWVlODAyMTFfc2Nhbl9jb21wbGV0ZWRfY29tcGF0KHN0cnVjdCBp
ZWVlODAyMTFfaHcgKmh3LAogCQkJCQkgICAgICBib29sIGFib3J0ZWQpCiB7CiAJc3RydWN0IGNm
ZzgwMjExX3NjYW5faW5mbyBpbmZvID0gewotCQkuYWJvcnRlZCA9IGFib3J0ZWQgPyAxIDogMCwK
KwkJLmFib3J0ZWQgPSBhYm9ydGVkLAogCX07CiAKIAlpZWVlODAyMTFfc2Nhbl9jb21wbGV0ZWQo
aHcsICZpbmZvKTsKLS0gCjIuMjQuMAoK
