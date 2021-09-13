Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39357408713
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbhIMIgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:36:50 -0400
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:21169
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238445AbhIMIeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F35yjArQ3LHKOEaNh1ijJEu0Ws2F9JKtG3T2bOpDVCHA5witXUI9GvDe1EEV11FUZEqVZkTJkwxmSONziOliBzmhFHpuePGRLorOamoUSFaguytZSZT5MTNkSHRmRVzbZn2YTg1gzmKwRotpIOouoCLF88M6BmlOyQfGIEJ0NcdpAa5clUIlGaRn6WiKUs8GxWPb8fEfsr3cMAqPKm56xMX2AEnPHUiNzw3SvtyLrSStc2G+kTIYeMkjSJ9J5dTPm/DoIWs3C7MvjZBSr5IQGMk02awNkCucdWpA4Bf9PC+rCU8FcRnKGWxr34UpOgu8KptBw2VqGLGVxgec4u4J4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZGgVdt2go7Q00UnAPMxv3X7ETCI2xEeAi//N9oWKOxo=;
 b=TXTdtpg6Z5Gt/rC7Bf6e9gjl6Qo7gB5zIeJG5ga/YKKX1re8fOM+oWx8q5lW/69UEYfq+qEmgH8Pak+E8QmytN2RaXRW7Z88ktnY7C6z3nygcK7Rk1FZewwmjZRT+s6YQImkglvl0mfgjpEmEQc/FQlOG39OJ34X2atjO2+kp41bGal1uH3p6fDXWURNIxPTzy0EUPf5TBNxxXBiY69dxmwbvQ9DUD0k6QD4aOHx1KnOmhF4fevTUPLtGgdAkMLDw9EL5Y4rMgNE7lz9A8Psn4/WEbMyCtVEDL7atPJqANM2YxKOUcL7LMTNGDu1s8yLJVQVsHRkyDbMC1pjkv/uxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGgVdt2go7Q00UnAPMxv3X7ETCI2xEeAi//N9oWKOxo=;
 b=V11jLYzsLAR8DBZHZ4az45nvMpxKJRZawF+9G5Pa0CeedXO+DAHpCZhRcLg1VKzgjvvW5vy/XWIqWwTHqSAaN7ZHSqQeBXBY5iln5x5SrP3VqDXLom1xRtDq7HSKSMOaa1JhxiJo5G9vAVTDW6KpFBwkU8yDrQu4vZuNC1k0OTc=
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
Subject: [PATCH v2 28/33] staging: wfx: fix comments styles
Date:   Mon, 13 Sep 2021 10:30:40 +0200
Message-Id: <20210913083045.1881321-29-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3929018d-2e8f-4888-26a1-08d97690f17e
X-MS-TrafficTypeDiagnostic: SN6PR11MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2717D641E081840325949DE993D99@SN6PR11MB2717.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w5deJQ/olp98IGoioFoJfdLMKkY0SO4eo370jjHCyFCK65k7KiaeFMisPmbz0a4vF634j00I2lzo/uroT+or97VykqOHK0UQm0o/h2Ox0ZoAEMw7sVqkr5iQpiCWAnzzHY/kict8MGh1XCFl1OMSfvLpAep5G7TYP6aSn90uVZE8CXtCx7y0yx76R//OchZ48cfsDxGmoitK8wIWNaxT1I6QaZeBOBBTgNlRKCMEXVU70a+aQhGjH9HOVJoem32CpWUVQXIzcEL5dToTmoagN3Hn2F3RUoK5J9cbmbome7yOx3Q/+uxeEK8ahaNmHHQVOoxq+xlO9K2DbiP4NOpHxs7kj84W0o8x57alP+JjtUDrCD63DuL7rqaMBRcY7KJGT/D/rEI3IB8e+tW3EHjHGifeQxYQYndKf+W+t+z6aSndA9lA5sVF44nOdKX7z8gqeeWg9HuwBphKCCwIvH7ZVf9qd0ls+GhuHLsbLAp30u1p0JwZLd3/+IZdJpbPQh2WgbSVI1eFFQaFwmcyYOkqqjTZXKpv62uG5Lh2IqJ7+VClTLyLxgDatBWMxnHSAyHrVJZOgG9nkCnAtrgDEK8FohwhWmo0IsQp+Qm1Q1smZBW3l3MOS7H8+TWGURt9IZdUPGQObOC01j7hL0cQ0Qcevl7To6UGUE2gD0K5UCkPzpai4S+Ue4wGX61dgAukTdSEH81hDzmpvnASNCm3q5pM+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(107886003)(26005)(66946007)(38100700002)(52116002)(7696005)(1076003)(956004)(36756003)(316002)(8676002)(38350700002)(186003)(8936002)(83380400001)(54906003)(66556008)(66476007)(508600001)(6486002)(5660300002)(6666004)(86362001)(2616005)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEN5VHhkcEtoNkJ1c0NLN2ZIZStYMWo0TXBDNWNnOHpYTGdEMEI3aWJnOGMx?=
 =?utf-8?B?M0RESWNHTFFRUFdJcWR0NXBYSkkraHA4U0RsL0p5L0oxbHNmazVJNXd1aE1w?=
 =?utf-8?B?NWJQamVPeVducGhUakpwL0xEY3ppdWJvcEFHSjExQnliclRHNWUyMUJjcTZ2?=
 =?utf-8?B?NVNzSlRYUS9vYXFrak9va0hRZ0tFZHpvUjhPVHdITEF4dUFaSm10K2VBcDh5?=
 =?utf-8?B?NlNFUk9PV2VQci9DUENQckpGMkdzTjBidXlEekVEMG9xSk1zc0JyZVREUGtE?=
 =?utf-8?B?TjIwUk10am1Zd0djWlh2ZzBXK25qZFhpZ28vWXE3NjZ4ejFRcUlDdXJFSkdO?=
 =?utf-8?B?Y3NVaVg5b3AxSlFNeWkxNEJESC8wK0FLNGl4dlM1WnkrZ3BKVXVFcjNHM2Vp?=
 =?utf-8?B?WDZ2ZDBmRGlzSzBTbEVteTA1Sit5NVdEbnAvcGdGaW5ZUEIrd0pnRHFPZ2p2?=
 =?utf-8?B?SzdJQThlc1ZBTjFuZXkyNGVRd1YzNEZmSUhJMzYvVGcxM3VVVDhuSTFXeUlO?=
 =?utf-8?B?ekRQZzVobjZxdFJZTUFzZUdsRS9GSmJ2SzN3aFl0TndKb01aM0cwcklsUVFD?=
 =?utf-8?B?eVRjUmlBTHNDL0dpY0EwY2VCdHpuUnZXTzg2TU00Zmp3b210dnFKMzNYMXIr?=
 =?utf-8?B?K2VJQzg3TnRZMXBNLzE2Z1lDeUNOVzJFZHVxZ3pmSXdjdmtCZHRPZTFOUS9q?=
 =?utf-8?B?ZlRmblFSRVZOV3h0L25OQUFmSUlVRUliR2Fvc0s0cXJ5cEhqRG5ZTTNpRlUx?=
 =?utf-8?B?MzR5ZldsQS8wdFZRdW9DZ0NIb2Q5SEp0TkJRWE45L3hWN0xtRW1FUXg4bEpr?=
 =?utf-8?B?WW5MVFBBNVJDb2ZyUG5xTVlHWUJjbzlHRDVxaVpKL1hJenJYYitQSU4xaDZD?=
 =?utf-8?B?WnpBekxlaWlqVjFLcW8vTmo1ckxETHJkR3lkakJOK0w3eUszSTVxaFdSQXRv?=
 =?utf-8?B?LzZGekFBeWoxdXMxb0ZKb0ltL0tQY0gwM2V6U2U3NTJ2d0c4WVAxMkJRbkVB?=
 =?utf-8?B?Si9JeGFQMFdkU2dRL2g3NzdKc2xPL25vVTNwUFhlVHRvYjkxeC82VHl0c2kv?=
 =?utf-8?B?WEZCWUI3M28rU3J2YUFxWURldEFBcFhtTlNqVW1VTmN3WjhVNXJGR24rM2NI?=
 =?utf-8?B?QzZyVFcxYmtuaTFsOTFDNGdoMlpkL1JRQysyVXhjTW0zSEY4Nnk1bWd3NlNX?=
 =?utf-8?B?RllwdXY2OHNVMXBwL3FraHZnWUlGQlZxa2FxNlRvR3F3eXhRdDJrdTJTaVBX?=
 =?utf-8?B?MTRROWE5cG9NcHl6MUdhcEJKUFNUUE1EUkZMQWcxNmlSOThHWTVjODhkNkhW?=
 =?utf-8?B?TmxQWXRtWEtGTjNxOERIbEErWWtjemRyMWtUTDhCRG1yWHM4UE51UkNncXJR?=
 =?utf-8?B?cW96Q0tuMXJuL1ZxVGtDN1l3SXpzZUpobHp2R2ZDSUdaOGh0enY5R21xSG90?=
 =?utf-8?B?dDI5ZTQwaVBxRHVGZ2RtYmNYeHhLcFRaVGNPUkd5VjdaK0hONXR5UnNoMUpB?=
 =?utf-8?B?Qk1JeU9jd1hIMzJlakxKSzM4dVRZK09PbUxFaGJLK0FNeFBxWUlyYnFoYlhU?=
 =?utf-8?B?dkVadTdrRFpBWFhkWVMyaVVPa1pvbkRkRWdRWnlyRGc0UFJIcitqSnhZaHJO?=
 =?utf-8?B?enB6bGEzcUhQa2RtT1JCUUx1VVRkTkNVUTdrQmFFei91bUZzd2ZVMWMxQlBX?=
 =?utf-8?B?ZkxVWXExWnJYM3lrcWw5Q0VUQUZGdjBuSmU4RVlxT1QxTVJadDBXMHpiYzh4?=
 =?utf-8?Q?j7Ul+MJ7laD65N2P2tToonb/yRdukwSDwoF+3mx?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3929018d-2e8f-4888-26a1-08d97690f17e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:54.9659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XSHafNSBqwJQSEDXAfHoZP6K6r9zq42vSD2mSZZULABeen6gS0e8dikh3aSjC4176bs6xzKg5IcjeGGGkBalYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2717
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVW5p
ZnkgYWxsIGNvbW1lbnRzIG9mIHRoZSB3ZnggZHJpdmVyIHRvIHVzZSB0aGUgc2FtZSBjb21tZW50
IHN0eWxlLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxl
ckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvYmguYyAgICAgIHwgMTEgKysr
LS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jIHwgIDYgKystLS0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYyAgICB8ICAzICstLQogZHJpdmVycy9zdGFnaW5nL3dmeC9t
YWluLmggICAgfCAgMyArLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jICAgIHwgIDMgKy0t
CiA1IGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9i
aC5jCmluZGV4IGUyZDJhNjRjZTY2ZS4uYjAyNjUwN2MxMWVmIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2JoLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jCkBAIC0yNjUs
OSArMjY1LDcgQEAgc3RhdGljIHZvaWQgYmhfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmsp
CiAJCQl3ZGV2LT5oaWYudHhfYnVmZmVyc191c2VkLCByZWxlYXNlX2NoaXApOwogfQogCi0vKgot
ICogQW4gSVJRIGZyb20gY2hpcCBkaWQgb2NjdXIKLSAqLworLyogQW4gSVJRIGZyb20gY2hpcCBk
aWQgb2NjdXIgKi8KIHZvaWQgd2Z4X2JoX3JlcXVlc3Rfcngoc3RydWN0IHdmeF9kZXYgKndkZXYp
CiB7CiAJdTMyIGN1ciwgcHJldjsKQEAgLTI4NSwxNiArMjgzLDEzIEBAIHZvaWQgd2Z4X2JoX3Jl
cXVlc3Rfcngoc3RydWN0IHdmeF9kZXYgKndkZXYpCiAJCQlwcmV2LCBjdXIpOwogfQogCi0vKgot
ICogRHJpdmVyIHdhbnQgdG8gc2VuZCBkYXRhCi0gKi8KKy8qIERyaXZlciB3YW50IHRvIHNlbmQg
ZGF0YSAqLwogdm9pZCB3ZnhfYmhfcmVxdWVzdF90eChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIHsK
IAlxdWV1ZV93b3JrKHN5c3RlbV9oaWdocHJpX3dxLCAmd2Rldi0+aGlmLmJoKTsKIH0KIAotLyoK
LSAqIElmIElSUSBpcyBub3QgYXZhaWxhYmxlLCB0aGlzIGZ1bmN0aW9uIGFsbG93IHRvIG1hbnVh
bGx5IHBvbGwgdGhlIGNvbnRyb2wKKy8qIElmIElSUSBpcyBub3QgYXZhaWxhYmxlLCB0aGlzIGZ1
bmN0aW9uIGFsbG93IHRvIG1hbnVhbGx5IHBvbGwgdGhlIGNvbnRyb2wKICAqIHJlZ2lzdGVyIGFu
ZCBzaW11bGF0ZSBhbiBJUlEgYWhlbiBhbiBldmVudCBoYXBwZW5lZC4KICAqCiAgKiBOb3RlIHRo
YXQgdGhlIGRldmljZSBoYXMgYSBidWc6IElmIGFuIElSUSByYWlzZSB3aGlsZSBob3N0IHJlYWQg
Y29udHJvbApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc3BpLmMgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYwppbmRleCA2MWY3M2IzZWJjODAuLjU1ZmZjZDdjNDJl
MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc3BpLmMKKysrIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9idXNfc3BpLmMKQEAgLTM4LDggKzM4LDcgQEAgc3RydWN0IHdmeF9zcGlf
cHJpdiB7CiAJYm9vbCBuZWVkX3N3YWI7CiB9OwogCi0vKgotICogVGhlIGNoaXAgcmVhZHMgMTZi
aXRzIG9mIGRhdGEgYXQgdGltZSBhbmQgcGxhY2UgdGhlbSBkaXJlY3RseSBpbnRvIChsaXR0bGUK
Ky8qIFRoZSBjaGlwIHJlYWRzIDE2Yml0cyBvZiBkYXRhIGF0IHRpbWUgYW5kIHBsYWNlIHRoZW0g
ZGlyZWN0bHkgaW50byAobGl0dGxlCiAgKiBlbmRpYW4pIENQVSByZWdpc3Rlci4gU28sIHRoZSBj
aGlwIGV4cGVjdHMgYnl0ZXMgb3JkZXIgdG8gYmUgIkIxIEIwIEIzIEIyIgogICogKHdoaWxlIExF
IGlzICJCMCBCMSBCMiBCMyIgYW5kIEJFIGlzICJCMyBCMiBCMSBCMCIpCiAgKgpAQCAtMjQxLDgg
KzI0MCw3IEBAIHN0YXRpYyBpbnQgd2Z4X3NwaV9yZW1vdmUoc3RydWN0IHNwaV9kZXZpY2UgKmZ1
bmMpCiAJcmV0dXJuIDA7CiB9CiAKLS8qCi0gKiBGb3IgZHluYW1pYyBkcml2ZXIgYmluZGluZywg
a2VybmVsIGRvZXMgbm90IHVzZSBPRiB0byBtYXRjaCBkcml2ZXIuIEl0IG9ubHkKKy8qIEZvciBk
eW5hbWljIGRyaXZlciBiaW5kaW5nLCBrZXJuZWwgZG9lcyBub3QgdXNlIE9GIHRvIG1hdGNoIGRy
aXZlci4gSXQgb25seQogICogdXNlIG1vZGFsaWFzIGFuZCBtb2RhbGlhcyBpcyBhIGNvcHkgb2Yg
J2NvbXBhdGlibGUnIERUIG5vZGUgd2l0aCB2ZW5kb3IKICAqIHN0cmlwcGVkLgogICovCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
Zndpby5jCmluZGV4IGM1YmEwYTUwYjQ3NC4uOThhOTM5MWIyYmVlIDEwMDY0NAotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYwpA
QCAtNjksOCArNjksNyBAQCBzdGF0aWMgY29uc3QgY2hhciAqIGNvbnN0IGZ3aW9fZXJyb3JzW10g
PSB7CiAJW0VSUl9NQUNfS0VZXSA9ICJNQUMga2V5IG5vdCBpbml0aWFsaXplZCIsCiB9OwogCi0v
KgotICogcmVxdWVzdF9maXJtd2FyZSgpIGFsbG9jYXRlIGRhdGEgdXNpbmcgdm1hbGxvYygpLiBJ
dCBpcyBub3QgY29tcGF0aWJsZSB3aXRoCisvKiByZXF1ZXN0X2Zpcm13YXJlKCkgYWxsb2NhdGUg
ZGF0YSB1c2luZyB2bWFsbG9jKCkuIEl0IGlzIG5vdCBjb21wYXRpYmxlIHdpdGgKICAqIHVuZGVy
bHlpbmcgaGFyZHdhcmUgdGhhdCB1c2UgRE1BLiBGdW5jdGlvbiBiZWxvdyBkZXRlY3QgdGhpcyBj
YXNlIGFuZAogICogYWxsb2NhdGUgYSBib3VuY2UgYnVmZmVyIGlmIG5lY2Vzc2FyeS4KICAqCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uaCBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvbWFpbi5oCmluZGV4IGEwZGIzMjIzODNhMy4uMTE1YWJkMmQ0Mzc4IDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4u
aApAQCAtMjMsOCArMjMsNyBAQCBzdHJ1Y3Qgd2Z4X3BsYXRmb3JtX2RhdGEgewogCWNvbnN0IGNo
YXIgKmZpbGVfZnc7CiAJY29uc3QgY2hhciAqZmlsZV9wZHM7CiAJc3RydWN0IGdwaW9fZGVzYyAq
Z3Bpb193YWtldXA7Ci0JLyoKLQkgKiBpZiB0cnVlIEhJRiBEX291dCBpcyBzYW1wbGVkIG9uIHRo
ZSByaXNpbmcgZWRnZSBvZiB0aGUgY2xvY2sKKwkvKiBpZiB0cnVlIEhJRiBEX291dCBpcyBzYW1w
bGVkIG9uIHRoZSByaXNpbmcgZWRnZSBvZiB0aGUgY2xvY2sKIAkgKiAoaW50ZW5kZWQgdG8gYmUg
dXNlZCBpbiA1ME1oeiBTRElPKQogCSAqLwogCWJvb2wgdXNlX3Jpc2luZ19jbGs7CmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nh
bi5jCmluZGV4IDllMmQwODMxN2M5ZS4uNjY4ZWYyYzYwODM3IDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3NjYW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwpAQCAt
ODUsOCArODUsNyBAQCBzdGF0aWMgaW50IHNlbmRfc2Nhbl9yZXEoc3RydWN0IHdmeF92aWYgKnd2
aWYsCiAJcmV0dXJuIHJldDsKIH0KIAotLyoKLSAqIEl0IGlzIG5vdCByZWFsbHkgbmVjZXNzYXJ5
IHRvIHJ1biBzY2FuIHJlcXVlc3QgYXN5bmNocm9ub3VzbHkuIEhvd2V2ZXIsCisvKiBJdCBpcyBu
b3QgcmVhbGx5IG5lY2Vzc2FyeSB0byBydW4gc2NhbiByZXF1ZXN0IGFzeW5jaHJvbm91c2x5LiBI
b3dldmVyLAogICogdGhlcmUgaXMgYSBidWcgaW4gIml3IHNjYW4iIHdoZW4gaWVlZTgwMjExX3Nj
YW5fY29tcGxldGVkKCkgaXMgY2FsbGVkIGJlZm9yZQogICogd2Z4X2h3X3NjYW4oKSByZXR1cm4K
ICAqLwotLSAKMi4zMy4wCgo=
