Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DA2408701
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbhIMIgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:36:05 -0400
Received: from mail-mw2nam08on2066.outbound.protection.outlook.com ([40.107.101.66]:47168
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238163AbhIMIeW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyYaUarUF81lv3881U6RexRii6aPUjQRCKfwxjyPo0t0UEs36LoOiadmROECf6qATiasGFNkaoR1kHmNRUDunauNbwmQ11g0wVMaWfsx789qM1YP1VdvWpmXqRLvOLl9NzTYynTl4DGel1ijtrZ/i+1sHRXn4I5PHUl93XjnlN8Ac/PEoowmzb6TYhfWTXqJiSW5jVOLhSjnXm7iIPB8luHoVpFiDnkDibI5fdkS7mOzL6aoKBLtGoJlF5ASthft9hh1OSLE11ll1V6D+cvQWG/y9Ly8KUELvh9Gq6/b2fYJAoT9uRaU7vrYBAbavlXtbQj3LmNyjBw+LNvca72J3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cfofvTSkHjYDsU3jyU6ThliW4B7lrnRRP6krW+vV/8o=;
 b=ek6QrKdnWmtzkm1/IqQ//vMiDYIKm+ATpHzC3tvqJpxK2Gmyt3MY4cJEL5KfGxZlefGajc2++Af1t8Erjj5Rwf/DrWP7u8VWD+j4GBeR1VFrwUqigSNgwCzZYBwphgAHcnktU0z512/vhFjbshVow8DXpyRcfoqq27NcGcr70MnR7UkbDzxgRh2bnR92j34vd2PXGDPx09dn+v0NHpDw3XfN5NMXHA4ACEtTsoZYmibWcZt2HJLhssmwz/EZlKv7GKObo8YRvfG4MWbZnisN1XCyu7HiwRKwN588qfG1XzZl2ZA4gJOOIdxnLwPrwfQCeRUazaT+9rfqxAB3+MAjbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfofvTSkHjYDsU3jyU6ThliW4B7lrnRRP6krW+vV/8o=;
 b=UsnhylLmXxxfSxc7ER0IkVSfZgZrIj51eJ7Qg3eAxyR2AgtUzK3aY8ZiVD8A3VavBrsjcUrJA875TdL7EFSeffpxVBL68EZ9JcCDln3CxpDjllOnFjf2T6VL9q0Bbkbazv0i1EwyY+tDarJL0gMHVj9Mo2EKyKAVC4b0Q1PZ0v0=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2717.namprd11.prod.outlook.com (2603:10b6:805:60::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 08:32:01 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:32:01 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 29/33] staging: wfx: remove useless comments after #endif
Date:   Mon, 13 Sep 2021 10:30:41 +0200
Message-Id: <20210913083045.1881321-30-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e4e8c5c-50e7-49ae-20d0-08d97690f286
X-MS-TrafficTypeDiagnostic: SN6PR11MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB271729191749B56EAF3AA32C93D99@SN6PR11MB2717.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BxzM1wBOmycT53nxqcIExwbhfdqNJ7d+WUCX3xbzuvEOEXFnk8V23v0AXYN0dRUaShqUn38rTPbS2sBKscMfvfH8rDRvG4C4ScHMM7N7S5dJRBJP4bsh8SOvLyv+YV/PqT5nqm6ADehAj5YkIo/UQHBdy7OVAut6zCsWgjF/8A1mid4/k4x5aUnbPcBhQkuoN8IVO4MoXMcUrF9K8ggd1UwyNtkY380sotJfFC5jE6Bnmc3BKDdkiWNb9p7bPbP+YfeTbgJC4rzyEK9MyQTLNw+CSgrpZBLpf1TLqfvFB2v6RLHxi9LEA44hRLq+km53aUtoappJYet8TD+qS73Hu62g6do+6cdtTsk1dE9BYaSf3i+e0Uck7uIRDx1tF/SG76yMB9Cm2GlXS0Gp2V1g2Wggxgdjw+p7gYnjPbhreqNne+8Vgqsdc6tslNBxXKxOcFziSaw5DDJPnS/uGAML8SF7co3PRKtaQCRROXwYdB5p+Xxz+JqQRHEfg4n7bDhSBajj5KE0urwif3CW4rbjLfkWcmn395c1GaYCn1ggZafYXnlsAjVud3Yt0NgSgSinLQvanI6p8LO47atYsotnbOfDBFKExDfvviKdUer3AsuCFRt0+HhJ5EvNimRqNVJfLCKQkAZOemL/shllFSoSPfIMEtVLeACBtOC+ciO4l/QZEBKYep6Q8syZmMh8cmaT02arkuhgDUBhG8w/snme6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(107886003)(26005)(66946007)(38100700002)(52116002)(7696005)(1076003)(956004)(36756003)(316002)(8676002)(38350700002)(186003)(8936002)(83380400001)(54906003)(66556008)(66476007)(508600001)(6486002)(5660300002)(6666004)(86362001)(2616005)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3duMFpzd1JWSzczbWFvZHF3UVNtZFEzZjg4bVRaQjBiaVYzYVhFS29MdW9S?=
 =?utf-8?B?Uzk1YlhTSXJtUmpXdGo1TENtUnJDNTVXLzkwTTJaeUdSUVQ2bWtDOE5GSGIx?=
 =?utf-8?B?SG11WENtb1gzTW43aHFkMFBxaDYrT09ZaGpHRDBVQWpBYWh3cngzcTVVSzFS?=
 =?utf-8?B?RU5VWHJ3SFRwYmREZUFWZldpaHdWZHovRktJZ08xVGhxWjJWazBVTHc5NU5C?=
 =?utf-8?B?UTROV0c1SUk2ZWV0OXp4QXB4Q01mYytPOHg3VGZwRWhyZEdleU5yRG41NW02?=
 =?utf-8?B?U1FPaTJwVVhQMEN4T2xObHl0MmRNVFhLUURob1dpWk9EcldBNWtjZ1Y0aHU1?=
 =?utf-8?B?V2RPWTdTSVRJY1AvVFhFNmd3c005bytuaks0OTY4Z2NzcXROTTd1dyt0VjRW?=
 =?utf-8?B?VnArWXhJWVR5Zi9JTENmNXdIV1d6TkJpa2VOS01lUHFMYy9XbWg2SFNWNWNt?=
 =?utf-8?B?RlhnQkVucWhMcG15cnltN2dua3d1Zmc2U0c5UmpLcEQvb3dSSW1hNldHWXNt?=
 =?utf-8?B?K0xOc1FOOE9sWEJyTGhVN3ZjSFVCZkp4UjE1SndYckZCeVY3MjdTMjZlUkxz?=
 =?utf-8?B?Z2xYdVNGVXR5d21pRkFsdkx2ZnRtTC81QldFNUlIWVVuV09Wd1BoZEdRbENV?=
 =?utf-8?B?UE9VN1RPMHNOZHBVRENTQTFsN0UzQ2FBbFllZUVHci8vSGhBUG04UnhGMmJq?=
 =?utf-8?B?YmdRWERBS0xXMHcraGFHaFkzSFo0YnNGampBMzVXZVNnSFVmaUkxRFJTTFFT?=
 =?utf-8?B?QkoyOWhOK3dMd1c0MlYyNkszV0wwRXhrQ2k2Um5kZ3BqdzE1ZXlHbVNvdFJD?=
 =?utf-8?B?K0RyOGQ1bldoUXBRN0RvNjdmTGdGOHhCNE1RYWQwYlZMdGtqRStnZHFPWFhI?=
 =?utf-8?B?M2l5Ymwxam1pa1ZwL09PTHQrbS9SY2R4UlpweVBtYmNvYXpYK1RFMU1iL0hB?=
 =?utf-8?B?dG5oZG5Md2tKV2xKL2lpZ3FXNXZUTHFpd2pMYVc5b014UmE3bjJpNEpZNGEw?=
 =?utf-8?B?aUUvTFFqeWZ2RGR4Yi9zOE9uaXFYdG8rUng3c0ovd2tzMU1iVDdRa3drRGc1?=
 =?utf-8?B?R21rRWtMYkpLOTM3blNZWktzN2wxWVlIWllxQStpTGY5NmdjVEFHZ016clAz?=
 =?utf-8?B?SVF4ckZsR2x0Wll6cTZYS054YjR0Q1VXUURIeFhDQm9UTnlQUjlLeFN1VUdE?=
 =?utf-8?B?clFZVXlkNGdQNlVTK0p1bVRoanh4S2tPcWV0V09DWWdRbWFXTEdMQkF6ejBs?=
 =?utf-8?B?UThyTDRaaXJsQXNFU2hLQWs4RlNhZUo2em4rbkpEc2FhUjRqWUJJM1F6QmVl?=
 =?utf-8?B?dGZYcTNtZzQxWWpReUJXSVhJdkFOdmw3dkpGRzI2OXJ4V3ZrYXdXZFZPTE9q?=
 =?utf-8?B?ZWk5RkpvUHUydTB2TVM3anJSeWpwZ2VKdGd4TUc1ZStqMzdzLzVhRjNFQTd2?=
 =?utf-8?B?U3ppT0Y2d1V0QitRL00vVExvQ1d3UmVPV1FQRlNrWlNsUFB6YUJQYU1kcDZa?=
 =?utf-8?B?OXNGWFNzbEJ6QVZwNUdiYWUra2VsK29XeWNyZDJzTW9CejB2RzA1QkdxcTA4?=
 =?utf-8?B?YXBBL1pKMGtkSkRzNDBHU2RUZmN2ZEVIbzBpd1BCeXhvVE1ad3BhenJOTlZ5?=
 =?utf-8?B?VXRWc1VGdWh5bDFKU1RTZzEwRTlxUDZ1THZQL3JiRERMVC9KT2Jnb1NmVS9a?=
 =?utf-8?B?SlNSMk9Pd21makowa3ZhSXRueFJHa1JOdHhRblYyenY2VWhybmhqdTI3alVR?=
 =?utf-8?Q?9KdozsLOX807eAeExMcd6TVen0JSiKzMCzSZWrr?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4e8c5c-50e7-49ae-20d0-08d97690f286
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:56.7219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hpWrfVaN78eSV95thShGGtUWuZtLyRrE9b/SVXRX7v3U5+3ljw4LdikbBmnqwmbznqyoGKolmdpuS+Za5BcKeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2717
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ29t
bWVudHMgYWZ0ZXIgdGhlIGxhc3QgI2VuZGlmIG9mIGhlYWRlciBmaWxlcyBkb24ndCBicmluZyBh
bnkKaW5mb3JtYXRpb24gYW5kIGFyZSByZWR1bmRhbnQgd2l0aCB0aGUgbmFtZSBvZiB0aGUgZmls
ZS4gRHJvcCB0aGVtLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5w
b3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvYmguaCAgICAgIHwg
MiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmggfCAyICstCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguaCB8IDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuaCAgIHwg
MiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9md2lvLmggICAgfCAyICstCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2h3aW8uaCAgICB8IDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93Zngva2V5LmggICAgIHwg
MiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oICAgfCAyICstCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L3NjYW4uaCAgICB8IDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmggICAgIHwg
MiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCAgICAgfCAyICstCiAxMSBmaWxlcyBjaGFu
Z2VkLCAxMSBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2JoLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmgKaW5kZXggZjA4
YzYyZWQwMzljLi42YzEyMWNlNGRkM2YgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
YmguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmgKQEAgLTMwLDQgKzMwLDQgQEAgdm9p
ZCB3ZnhfYmhfcmVxdWVzdF9yeChzdHJ1Y3Qgd2Z4X2RldiAqd2Rldik7CiB2b2lkIHdmeF9iaF9y
ZXF1ZXN0X3R4KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KTsKIHZvaWQgd2Z4X2JoX3BvbGxfaXJxKHN0
cnVjdCB3ZnhfZGV2ICp3ZGV2KTsKIAotI2VuZGlmIC8qIFdGWF9CSF9IICovCisjZW5kaWYKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV9yeC5oIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9kYXRhX3J4LmgKaW5kZXggZjc5NTQ1YzA2MTMwLi44NGQwZTNjMDUwN2IgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV9yeC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvZGF0YV9yeC5oCkBAIC0xNSw0ICsxNSw0IEBAIHN0cnVjdCBoaWZfaW5kX3J4Owogdm9pZCB3
ZnhfcnhfY2Ioc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJICAgICAgIGNvbnN0IHN0cnVjdCBoaWZf
aW5kX3J4ICphcmcsIHN0cnVjdCBza19idWZmICpza2IpOwogCi0jZW5kaWYgLyogV0ZYX0RBVEFf
UlhfSCAqLworI2VuZGlmCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHgu
aCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oCmluZGV4IGRhZmQ4ZmVmNDRjZi4uMTU1
OTBhOGZhZWZlIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaAorKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaApAQCAtNjUsNCArNjUsNCBAQCBzdGF0aWMg
aW5saW5lIHN0cnVjdCBoaWZfcmVxX3R4ICp3Znhfc2tiX3R4cmVxKHN0cnVjdCBza19idWZmICpz
a2IpCiAJcmV0dXJuIHJlcTsKIH0KIAotI2VuZGlmIC8qIFdGWF9EQVRBX1RYX0ggKi8KKyNlbmRp
ZgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5oIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9kZWJ1Zy5oCmluZGV4IDZmMmY4NGQ2NGM5ZS4uNGI5YzQ5YTlmZmZiIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9kZWJ1Zy5oCkBAIC0xNiw0ICsxNiw0IEBAIGNvbnN0IGNoYXIgKmdldF9oaWZfbmFtZSh1bnNp
Z25lZCBsb25nIGlkKTsKIGNvbnN0IGNoYXIgKmdldF9taWJfbmFtZSh1bnNpZ25lZCBsb25nIGlk
KTsKIGNvbnN0IGNoYXIgKmdldF9yZWdfbmFtZSh1bnNpZ25lZCBsb25nIGlkKTsKIAotI2VuZGlm
IC8qIFdGWF9ERUJVR19IICovCisjZW5kaWYKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvZndpby5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9md2lvLmgKaW5kZXggNjAyOGY5MjUwM2Zl
Li5lZWVhNjEyMTBlY2EgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZndpby5oCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZndpby5oCkBAIC0xMiw0ICsxMiw0IEBAIHN0cnVjdCB3
ZnhfZGV2OwogCiBpbnQgd2Z4X2luaXRfZGV2aWNlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KTsKIAot
I2VuZGlmIC8qIFdGWF9GV0lPX0ggKi8KKyNlbmRpZgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9od2lvLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2h3aW8uaAppbmRleCA5YTM2MWVk
OTVlY2IuLmZmMDk1NzVkZDFhZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9od2lv
LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9od2lvLmgKQEAgLTcyLDQgKzcyLDQgQEAgaW50
IGNvbnRyb2xfcmVnX3dyaXRlX2JpdHMoc3RydWN0IHdmeF9kZXYgKndkZXYsIHUzMiBtYXNrLCB1
MzIgdmFsKTsKIGludCBpZ3ByX3JlZ19yZWFkKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBpbnQgaW5k
ZXgsIHUzMiAqdmFsKTsKIGludCBpZ3ByX3JlZ193cml0ZShzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwg
aW50IGluZGV4LCB1MzIgdmFsKTsKIAotI2VuZGlmIC8qIFdGWF9IV0lPX0ggKi8KKyNlbmRpZgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuaCBiL2RyaXZlcnMvc3RhZ2luZy93
Zngva2V5LmgKaW5kZXggZGQxODk3ODhhY2YxLi4yZDEzNWVmZjdhZjIgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngva2V5LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuaApA
QCAtMTcsNCArMTcsNCBAQCBpbnQgd2Z4X3NldF9rZXkoc3RydWN0IGllZWU4MDIxMV9odyAqaHcs
IGVudW0gc2V0X2tleV9jbWQgY21kLAogCQlzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLCBzdHJ1
Y3QgaWVlZTgwMjExX3N0YSAqc3RhLAogCQlzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXkp
OwogCi0jZW5kaWYgLyogV0ZYX1NUQV9IICovCisjZW5kaWYKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c3RhZ2luZy93ZngvcXVldWUuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaAppbmRleCA1
NGI1ZGVmMmUyNGMuLmVkZDBkMDE4YjE5OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9xdWV1ZS5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaApAQCAtNDIsNCArNDIs
NCBAQCB1bnNpZ25lZCBpbnQgd2Z4X3BlbmRpbmdfZ2V0X3BrdF91c19kZWxheShzdHJ1Y3Qgd2Z4
X2RldiAqd2RldiwKIAkJCQkJICBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsKIHZvaWQgd2Z4X3BlbmRp
bmdfZHVtcF9vbGRfZnJhbWVzKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCB1bnNpZ25lZCBpbnQgbGlt
aXRfbXMpOwogCi0jZW5kaWYgLyogV0ZYX1FVRVVFX0ggKi8KKyNlbmRpZgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaApp
bmRleCA1NjJjYTEzMjFkYWYuLjc4ZTNiOTg0ZjM3NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zY2FuLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmgKQEAgLTE5LDQg
KzE5LDQgQEAgaW50IHdmeF9od19zY2FuKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3Qg
aWVlZTgwMjExX3ZpZiAqdmlmLAogdm9pZCB3ZnhfY2FuY2VsX2h3X3NjYW4oc3RydWN0IGllZWU4
MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpOwogdm9pZCB3Znhfc2Nhbl9j
b21wbGV0ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgaW50IG5iX2NoYW5fZG9uZSk7CiAKLSNlbmRp
ZiAvKiBXRlhfU0NBTl9IICovCisjZW5kaWYKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCmluZGV4IGYzNTlmMzc1Y2M1Ni4u
NGQ3ZTM4YmU0MjM1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmgKQEAgLTcwLDQgKzcwLDQgQEAgaW50IHdmeF91cGRh
dGVfcG0oc3RydWN0IHdmeF92aWYgKnd2aWYpOwogdm9pZCB3ZnhfcmVzZXQoc3RydWN0IHdmeF92
aWYgKnd2aWYpOwogdTMyIHdmeF9yYXRlX21hc2tfdG9faHcoc3RydWN0IHdmeF9kZXYgKndkZXYs
IHUzMiByYXRlcyk7CiAKLSNlbmRpZiAvKiBXRlhfU1RBX0ggKi8KKyNlbmRpZgpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgK
aW5kZXggYTQ3NzBmNTlmN2QyLi5mOGRmNTlhZDE2MzkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvd2Z4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApAQCAtMTYxLDQg
KzE2MSw0IEBAIHN0YXRpYyBpbmxpbmUgaW50IG1lbXpjbXAodm9pZCAqc3JjLCB1bnNpZ25lZCBp
bnQgc2l6ZSkKIAlyZXR1cm4gbWVtY21wKGJ1ZiwgYnVmICsgMSwgc2l6ZSAtIDEpOwogfQogCi0j
ZW5kaWYgLyogV0ZYX0ggKi8KKyNlbmRpZgotLSAKMi4zMy4wCgo=
