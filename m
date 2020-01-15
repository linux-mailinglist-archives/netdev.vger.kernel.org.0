Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6FD13C08A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731616AbgAOMT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:19:29 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730472AbgAOMMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AivXb5v0EMcBrB4VV1/F39gVKJSsmR5F357bGI02YMNEs+cnNyxqqhnHq1NELDAB69hGSknxaNtDHIeMnevZWseYQanuWQN/6E07IwTP+Gc+xWLCV+XwEqotw8d5BF0/xQCeGFwr9X130Sftu/FMscBuo0h+n2l3S50CU4mjGGowsNARAPS7FXE7gFa5IYvVt8JYArI+1zYJyM6WeaUX++FG/KUZxk0zeKFjfKawwRsy7+TLD6Vni06rOWkx/5YLITSb9PmGSV7wAVCnKheezOPqQdTrOjTgKW3xI+alHxtEts4Qo5xRYJ5+aZNRYlJ+14IeSGrXezLFZ8XKSYeODw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUo8LwBo1qK4cZ/ojBZuyySQUx8sEw77KK5ENOyqfFo=;
 b=WDt0KtFsaWkUYn/2+g1wlyQ0nEM4GJpVXrqQIr52jZfHgRkNj0JLJEIUZ84Xe2SOUk0akCQVONr0vAvvyzRLYtct8TSuefm64rarbV3urv2bvZ8POldhJ3HcVjN8YDQECNpgFpMnp7v5hDxFXhhZwggqlTuiTPCA3p0FP8uhKPvpht696g/NNsy1uaqViFkwRRf+rHIz0JMH8QxalhCMtYFXns9vpfegAMDgUuRULWk31LRddtfTAvN1y/NiG6Ab5QqBbzisj+thHEu3JnbAFzD8V++unVX/fxziZiKOjprd2tfSUsb1rBHfH2Oift7KYq9YOuVk3dtJB3JeCHX1vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUo8LwBo1qK4cZ/ojBZuyySQUx8sEw77KK5ENOyqfFo=;
 b=jPQIsgyh9vyzHt9IaYQCttd4MbAaQz7RlYWqZVrMtoDXiDWh5xh7nihuu14Zip3KNitns/PGRInGjwO81mlXpj0DWMKB11iMLKI8LR4qOSfybRYwIxsMgr43INtzmU7DQ3Lh96QwdhToci4EOqnOr7rEN5Iwq1X9EzAdBgdAkd8=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:16 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:16 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:15 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 06/65] staging: wfx: simplify hif_set_output_power() usage
Thread-Topic: [PATCH 06/65] staging: wfx: simplify hif_set_output_power()
 usage
Thread-Index: AQHVy50H/O483S9OBU2uPei1KFhd3g==
Date:   Wed, 15 Jan 2020 12:12:16 +0000
Message-ID: <20200115121041.10863-7-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 318814c5-b1ee-4d00-5c7c-08d799b42964
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934431A46B59AA99DB62ED093370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lDHhnp3Erxe9yb7GForCB+M0qOK5KWJsIqVe0zBEEtmnpIlImywMOiHThbJLbvw3Z9+Lc+0a/xIsLBJZOXBJ9mwgEXUjcb2p9UDXXJqYicr8q6Yrr/e27Z3kytVidKkBqv8uy4Jjh8Ollt/xdA1xYHh0msLBlbbKQfKPBZ2RCjIltYLmk8e73E7mZRvznnQnLIY7rJZNBJHPhklDlyu69GMPpJk4FvN2ew5uC7aKfeUnpiOg0KExZEOuuzoOjxr2ZNRlQ6p27vH5SKYbBa38T6C64SLYrlII2X6aBztRipjGghYxkBc5DlgOBtgWHkeVo9rlY1WbzR11oRS5QqflkRP1lrNoPwe5gZ4L7rn0DYXaUBlOH72AMsXQktWBEz3MdR3nTBLPqZBrCo33yC53GMOvNju05rABZ6pmwcp5LXXcwsC9jRybZvbXN6okbKC9
Content-Type: text/plain; charset="utf-8"
Content-ID: <B68C1A1A817CB34FBC57D59CD1B759BA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318814c5-b1ee-4d00-5c7c-08d799b42964
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:16.5529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /kJWNwCHR5ViGsi6cIn2VofKs1esCVsWY6YzYRP7tvlE3mBejXgKlO9aGJU6m6y19GIAkE8FW7A7soDA1GKZZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGFy
ZHdhcmUgQVBJIHVzZSAxMHRoIG9mIGRCbSBmb3Igb3V0cHV0IHBvd2VyIHVuaXQuIFVwcGVyIGxh
eWVycyBzaG91bGQKdXNlIHNhbWUgdW5pdHMgdGhhbiBtYWM4MDIxMSBhbmQgdGhlIGNvbnZlcnNp
b24gc2hvdWxkIGJlIGRvbmUgYnkgbG93CmxldmVsIGxheWVyIG9mIHRoZSBkcml2ZXIgKGhpZl9z
ZXRfb3V0cHV0X3Bvd2VyKCkpCgpJbiBhZGQsIGN1cnJlbnQgY29kZSBvZiBoaWZfc2V0X291dHB1
dF9wb3dlcigpIHVzZSBhIF9fbGUzMiB3aGlsZSB0aGUKZGV2aWNlIEFQSSBzcGVjaWZ5IGEgc3Bl
Y2lmaWMgc3RydWN0dXJlIGZvciB0aGlzLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4X21pYi5oIHwgOCArKysrKy0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgICAg
ICAgfCAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICB8IDYgKysrLS0tCiAz
IGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4X21pYi5oCmluZGV4IGVmMDMzYTQwOTM4MS4uNzQ5ZGY2NzEzMWMzIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaAorKysgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eF9taWIuaApAQCAtMTUsMTMgKzE1LDE1IEBACiAjaW5jbHVkZSAiaGlmX3R4
LmgiCiAjaW5jbHVkZSAiaGlmX2FwaV9taWIuaCIKIAotc3RhdGljIGlubGluZSBpbnQgaGlmX3Nl
dF9vdXRwdXRfcG93ZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsIGludCBwb3dlcl9sZXZlbCkKK3N0
YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfb3V0cHV0X3Bvd2VyKHN0cnVjdCB3ZnhfdmlmICp3dmlm
LCBpbnQgdmFsKQogewotCV9fbGUzMiB2YWwgPSBjcHVfdG9fbGUzMihwb3dlcl9sZXZlbCk7CisJ
c3RydWN0IGhpZl9taWJfY3VycmVudF90eF9wb3dlcl9sZXZlbCBhcmcgPSB7CisJCS5wb3dlcl9s
ZXZlbCA9IGNwdV90b19sZTMyKHZhbCAqIDEwKSwKKwl9OwogCiAJcmV0dXJuIGhpZl93cml0ZV9t
aWIod3ZpZi0+d2Rldiwgd3ZpZi0+aWQsCiAJCQkgICAgIEhJRl9NSUJfSURfQ1VSUkVOVF9UWF9Q
T1dFUl9MRVZFTCwKLQkJCSAgICAgJnZhbCwgc2l6ZW9mKHZhbCkpOworCQkJICAgICAmYXJnLCBz
aXplb2YoYXJnKSk7CiB9CiAKIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfYmVhY29uX3dha2V1
cF9wZXJpb2Qoc3RydWN0IHdmeF92aWYgKnd2aWYsCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3NjYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCmluZGV4IDliMzY3NGIz
MjI2YS4uOGUwYWM4OWZkMjhmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4u
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwpAQCAtNjEsNyArNjEsNyBAQCBzdGF0
aWMgaW50IHNlbmRfc2Nhbl9yZXEoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCXJldHVybiB0aW1l
b3V0OwogCXJldCA9IHdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmd3ZpZi0+c2Nhbl9jb21w
bGV0ZSwgdGltZW91dCk7CiAJaWYgKHJlcS0+Y2hhbm5lbHNbc3RhcnRfaWR4XS0+bWF4X3Bvd2Vy
ICE9IHd2aWYtPndkZXYtPm91dHB1dF9wb3dlcikKLQkJaGlmX3NldF9vdXRwdXRfcG93ZXIod3Zp
Ziwgd3ZpZi0+d2Rldi0+b3V0cHV0X3Bvd2VyICogMTApOworCQloaWZfc2V0X291dHB1dF9wb3dl
cih3dmlmLCB3dmlmLT53ZGV2LT5vdXRwdXRfcG93ZXIpOwogCXdmeF90eF91bmxvY2sod3ZpZi0+
d2Rldik7CiAJaWYgKCFyZXQpIHsKIAkJZGV2X25vdGljZSh3dmlmLT53ZGV2LT5kZXYsICJzY2Fu
IHRpbWVvdXRcbiIpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggOGY1M2E3OGQ3MjE1Li4xMWUzM2E2ZDViYjUg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYwpAQCAtNTAzLDcgKzUwMyw3IEBAIHN0YXRpYyB2b2lkIHdmeF9kb191bmpv
aW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJaGlmX2tlZXBfYWxpdmVfcGVyaW9kKHd2aWYsIDAp
OwogCWhpZl9yZXNldCh3dmlmLCBmYWxzZSk7CiAJd2Z4X3R4X3BvbGljeV9pbml0KHd2aWYpOwot
CWhpZl9zZXRfb3V0cHV0X3Bvd2VyKHd2aWYsIHd2aWYtPndkZXYtPm91dHB1dF9wb3dlciAqIDEw
KTsKKwloaWZfc2V0X291dHB1dF9wb3dlcih3dmlmLCB3dmlmLT53ZGV2LT5vdXRwdXRfcG93ZXIp
OwogCXd2aWYtPmR0aW1fcGVyaW9kID0gMDsKIAloaWZfc2V0X21hY2FkZHIod3ZpZiwgd3ZpZi0+
dmlmLT5hZGRyKTsKIAl3ZnhfZnJlZV9ldmVudF9xdWV1ZSh3dmlmKTsKQEAgLTEwNjMsNyArMTA2
Myw3IEBAIHZvaWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcs
CiAJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9UWFBPV0VSICYmCiAJICAgIGluZm8tPnR4cG93
ZXIgIT0gd2Rldi0+b3V0cHV0X3Bvd2VyKSB7CiAJCXdkZXYtPm91dHB1dF9wb3dlciA9IGluZm8t
PnR4cG93ZXI7Ci0JCWhpZl9zZXRfb3V0cHV0X3Bvd2VyKHd2aWYsIHdkZXYtPm91dHB1dF9wb3dl
ciAqIDEwKTsKKwkJaGlmX3NldF9vdXRwdXRfcG93ZXIod3ZpZiwgd2Rldi0+b3V0cHV0X3Bvd2Vy
KTsKIAl9CiAJbXV0ZXhfdW5sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKIApAQCAtMTMxNyw3ICsx
MzE3LDcgQEAgaW50IHdmeF9jb25maWcoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHUzMiBjaGFu
Z2VkKQogCW11dGV4X2xvY2soJndkZXYtPmNvbmZfbXV0ZXgpOwogCWlmIChjaGFuZ2VkICYgSUVF
RTgwMjExX0NPTkZfQ0hBTkdFX1BPV0VSKSB7CiAJCXdkZXYtPm91dHB1dF9wb3dlciA9IGNvbmYt
PnBvd2VyX2xldmVsOwotCQloaWZfc2V0X291dHB1dF9wb3dlcih3dmlmLCB3ZGV2LT5vdXRwdXRf
cG93ZXIgKiAxMCk7CisJCWhpZl9zZXRfb3V0cHV0X3Bvd2VyKHd2aWYsIHdkZXYtPm91dHB1dF9w
b3dlcik7CiAJfQogCiAJaWYgKGNoYW5nZWQgJiBJRUVFODAyMTFfQ09ORl9DSEFOR0VfUFMpIHsK
LS0gCjIuMjUuMAoK
