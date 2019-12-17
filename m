Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4ACE1231F6
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbfLQQS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:18:58 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:6496
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728958AbfLQQPq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L83fGUrgq1dsjFLLLKJF0H9R2xcaw7j34SYlv0o48YqpVy0k09N8Zr9LoR1frUVCboJS7MNeLzdoO+H1RbJZL/eARy0JE1cU/tD3eJSahLI7s87F+g37EQElOoJTasE8Yw+B3/HnbUDttr9gdmR38Ed9aQT6QxQkN/+NAjBJfOBZJFxdwMXCRL2D4+Hf7HmoqfgWe4YyoP+XyG4ZJ5LaNGWZmFYwQZHNImDnKd3lK1CRq84Jwm0VSmxVkozQjO9O7qLHfxWV6qbJuWTsz3gW9JvfWLqK0sWONXN3iHW/cTLPb+vtD9THXjALV3UyGT2rGAfi2UdimSyvQ4fzL84yGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2XACO0dpTiYEzM0HmaENcUMzlW+3tomdmhqT6ZUZlA=;
 b=ls913lfEcKqK+y50hTa+8fs0SwWodOljr5Tx0UcUuNX91ciDQv+lWN0ev3CAM57do0Cno8TkOz7JF9K7SvY6QydHKYp9I0c83wDt5stquDIVE1VXrhNyg+s8h1fRIErXIzvF26KBmrJsHu/zsPB4G9VdJ5q/9cWlTFpU025nvcxB6yJYyDbJSNkNsUdvNBA8aiN8Se609LzJVSnvRnXY+8LwO1BjLTIq64HGbXKe+bbvbua3GjGDwzXIyjBiCNLe+HP7ua971Tk92K0TUscNTVrJ2b51eUpjFU22P+A0G/bceY6q4HChH7bSLP0S3xKwJckJRcpxkZQ1n8G9OdpWlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2XACO0dpTiYEzM0HmaENcUMzlW+3tomdmhqT6ZUZlA=;
 b=OTnAvgH58dNq/CI+qhTaM7B8/DtkxE3wYY8AiHElb6pJhIWyOJdkjEqveF+SE/Qohb8TS5Ej17zGQdSN3lUNitOhxeYX3D0OPO0KGFg+wD48QumRjnG5NW+ZvzPp48S41gjVAfTdQpXrPcK1HFtkOWfaXwcaohyDLjKGcmOgAbw=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:41 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:41 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 32/55] staging: wfx: drop useless argument from
 wfx_set_pm()
Thread-Topic: [PATCH v2 32/55] staging: wfx: drop useless argument from
 wfx_set_pm()
Thread-Index: AQHVtPUpo7oG/S2dEEeGnUWnLCzT5g==
Date:   Tue, 17 Dec 2019 16:15:12 +0000
Message-ID: <20191217161318.31402-33-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: f34e4e10-12fd-4e6e-c618-08d7830c4b54
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4208FD53BD5B8A40E62E9E5893500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(6666004)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 08CT7vNgjEZs3BM0DuHb6N1veMpXsUs7++94t5RcQtjpnAOUOUCgiVXnysM8a+tdNucdcSQX9pa8yY74OLRjUgK3O32gAnVN82Y0F9ilbTsdrj5CiA9W9b50Mbp6nTvXPD2S/LXPoxRaWoJUgX8S8QptQiifVXYAThnlTG3GNAMHwlgK3Nu47Zvbt5rtw/B1/Dkz9syBL6r3doTiHo0JDj0jAFiyitFNNN/8u3+iH8kwdBFGnh6JXQ551vnqruv6TERlLoSd9IBphyQYrfgfPIoZZHhJRzgYmCR4eeb8SxM8hw/G4KVS7bC9LqECrBFi6P/ESHMuL0MDR9eAZJ0LD7od8LjHJ1+H6Zat5Xmpm5IMOxm0nro7rxm6xKPhhjENMKiM6O+V5G80YiwKdttFGlzHjpWrhWcg4V5hkNdBeFX3JO0/lUnyxPfFiedztwzn
Content-Type: text/plain; charset="utf-8"
Content-ID: <B5DB3455A9FCC74DAC977B557346428D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f34e4e10-12fd-4e6e-c618-08d7830c4b54
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:12.5756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J8+/7z0f2ZknzlPAwxcygyXz559gwUieRGTsSc0hPzQ9nN7dOZZ5DOqm0irO7lXsSoIfoReq1G/Se/mUGCmB8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQXJn
dW1lbnQgdG8gd2Z4X3NldF9wbSgpIGlzIGFsd2F5cyB3dmlmLT5wb3dlcnNhdmVfbW9kZS4gU28s
IHdlIGNhbgpzaW1wbGlmeSBpdC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxq
ZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
IHwgMTYgKysrKysrKy0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwg
OSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBlYjA4N2I5YzgwOTcuLmVlMWIxNTk1MDM4
OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jCkBAIC0zMjYsMTIgKzMyNiwxMCBAQCB2b2lkIHdmeF9jb25maWd1cmVf
ZmlsdGVyKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCX0KIH0KIAotc3RhdGljIGludCB3Znhf
c2V0X3BtKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAotCQkgICAgICBjb25zdCBzdHJ1Y3QgaGlmX3Jl
cV9zZXRfcG1fbW9kZSAqYXJnKQorc3RhdGljIGludCB3ZnhfdXBkYXRlX3BtKHN0cnVjdCB3Znhf
dmlmICp3dmlmKQogewotCXN0cnVjdCBoaWZfcmVxX3NldF9wbV9tb2RlIHBtID0gKmFyZzsKKwlz
dHJ1Y3QgaGlmX3JlcV9zZXRfcG1fbW9kZSBwbSA9IHd2aWYtPnBvd2Vyc2F2ZV9tb2RlOwogCXUx
NiB1YXBzZF9mbGFnczsKLQlpbnQgcmV0OwogCiAJaWYgKHd2aWYtPnN0YXRlICE9IFdGWF9TVEFU
RV9TVEEgfHwgIXd2aWYtPmJzc19wYXJhbXMuYWlkKQogCQlyZXR1cm4gMDsKQEAgLTM5MCw3ICsz
ODgsNyBAQCBpbnQgd2Z4X2NvbmZfdHgoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBp
ZWVlODAyMTFfdmlmICp2aWYsCiAJCQlpZiAoIXJldCAmJiB3dmlmLT5zZXRic3NwYXJhbXNfZG9u
ZSAmJgogCQkJICAgIHd2aWYtPnN0YXRlID09IFdGWF9TVEFURV9TVEEgJiYKIAkJCSAgICBvbGRf
dWFwc2RfZmxhZ3MgIT0gbmV3X3VhcHNkX2ZsYWdzKQotCQkJCXJldCA9IHdmeF9zZXRfcG0od3Zp
ZiwgJnd2aWYtPnBvd2Vyc2F2ZV9tb2RlKTsKKwkJCQlyZXQgPSB3ZnhfdXBkYXRlX3BtKHd2aWYp
OwogCQl9CiAJfSBlbHNlIHsKIAkJcmV0ID0gLUVJTlZBTDsKQEAgLTEwMTQsNyArMTAxMiw3IEBA
IHN0YXRpYyB2b2lkIHdmeF9qb2luX2ZpbmFsaXplKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCQlo
aWZfc2V0X2Jzc19wYXJhbXMod3ZpZiwgJnd2aWYtPmJzc19wYXJhbXMpOwogCQl3dmlmLT5zZXRi
c3NwYXJhbXNfZG9uZSA9IHRydWU7CiAJCXdmeF9zZXRfYmVhY29uX3dha2V1cF9wZXJpb2Rfd29y
aygmd3ZpZi0+c2V0X2JlYWNvbl93YWtldXBfcGVyaW9kX3dvcmspOwotCQl3Znhfc2V0X3BtKHd2
aWYsICZ3dmlmLT5wb3dlcnNhdmVfbW9kZSk7CisJCXdmeF91cGRhdGVfcG0od3ZpZik7CiAJfQog
fQogCkBAIC0xNDUxLDcgKzE0NDksNyBAQCBpbnQgd2Z4X2NvbmZpZyhzdHJ1Y3QgaWVlZTgwMjEx
X2h3ICpodywgdTMyIGNoYW5nZWQpCiAJCQkJfQogCQkJfQogCQkJaWYgKHd2aWYtPnN0YXRlID09
IFdGWF9TVEFURV9TVEEgJiYgd3ZpZi0+YnNzX3BhcmFtcy5haWQpCi0JCQkJd2Z4X3NldF9wbSh3
dmlmLCAmd3ZpZi0+cG93ZXJzYXZlX21vZGUpOworCQkJCXdmeF91cGRhdGVfcG0od3ZpZik7CiAJ
CX0KIAkJd3ZpZiA9IHdkZXZfdG9fd3ZpZih3ZGV2LCAwKTsKIAl9CkBAIC0xNTkxLDcgKzE1ODks
NyBAQCBpbnQgd2Z4X2FkZF9pbnRlcmZhY2Uoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVj
dCBpZWVlODAyMTFfdmlmICp2aWYpCiAJCWVsc2UKIAkJCWhpZl9zZXRfYmxvY2tfYWNrX3BvbGlj
eSh3dmlmLCAweDAwLCAweDAwKTsKIAkJLy8gQ29tYm8gZm9yY2UgcG93ZXJzYXZlIG1vZGUuIFdl
IGNhbiByZS1lbmFibGUgaXQgbm93Ci0JCXdmeF9zZXRfcG0od3ZpZiwgJnd2aWYtPnBvd2Vyc2F2
ZV9tb2RlKTsKKwkJd2Z4X3VwZGF0ZV9wbSh3dmlmKTsKIAl9CiAJcmV0dXJuIDA7CiB9CkBAIC0x
NjY2LDcgKzE2NjQsNyBAQCB2b2lkIHdmeF9yZW1vdmVfaW50ZXJmYWNlKHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LAogCQllbHNlCiAJCQloaWZfc2V0X2Jsb2NrX2Fja19wb2xpY3kod3ZpZiwgMHgw
MCwgMHgwMCk7CiAJCS8vIENvbWJvIGZvcmNlIHBvd2Vyc2F2ZSBtb2RlLiBXZSBjYW4gcmUtZW5h
YmxlIGl0IG5vdwotCQl3Znhfc2V0X3BtKHd2aWYsICZ3dmlmLT5wb3dlcnNhdmVfbW9kZSk7CisJ
CXdmeF91cGRhdGVfcG0od3ZpZik7CiAJfQogfQogCi0tIAoyLjI0LjAKCg==
