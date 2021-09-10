Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D766406EC8
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhIJQIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:08:23 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:5600
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230005AbhIJQHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:07:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnW2YAGYu/okRnO2A2GynIZPiFZQjfcbKl2YA0oiuB0eXRIy9vX9Ny2zymL5P/exERxgk9e3dOv9VWfNlsadsdLApxrulPyKLGVKBIdFwVAThSDtt2P/lZPyS/nqQ6u9XsBQp+U6ozwDkVfcVA8MNZsR89Nii+HDBQky1KD4fmQHg6/kEAUJCqGQi1p0W07+/UWUQ7bXWunS2Uw6lTdNemQplxPinEPcuSZCYb1wjPbZkuGPHuM0q8wbkQPZDfprKkRmcTwmbtcT9mnIrqQObYvd6Q32xnJUehhRHftsydCMqTggupmLa6jCxPh/tcbTme3N5Iud6kwnzqIEWmaI5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZGgVdt2go7Q00UnAPMxv3X7ETCI2xEeAi//N9oWKOxo=;
 b=M5PHPPgFIg0Rvebg0w+Xi55Eszu1AaMBkFITos4g3LczHh1xNwYg3nMgbdaURJgUHbZSqs587vcE+lABWcD+g63vTAxlaBDrTS/8GuyaQVPajK/QkdelS5nWfzGZ0jbI3EAjnqldgLyVN6shx/P51fcBLtB8PENHUXw6xoTB46IZoF+IMoPLGum8NGJGxoVWG9nlDw07iQ2diM40/0cifK425XkSrNEPD8S3qSn/E+DgFUE45jmROxc4XDLEonBNlYYOzIQywZyDuX1Yq7O9PXb5JiUBe42mo40oHjn02jQEUrGhtneiNd0Ar6BCxG+tcerQURafHKO+kcMtz/6zMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGgVdt2go7Q00UnAPMxv3X7ETCI2xEeAi//N9oWKOxo=;
 b=S1Q2UTNoXJLPKnqoHI4iJYZ7TWrye5ddTn6SsetGmEUxdhN21xXTmjeCtYrCwnrXYRNBFVcdK9EScScuPrKOFYshc2bJ0hm934N39+C+dj41APG3mPAaiqlPdhvNwjzNRn0XL49w4/J8GGrXW+XagAqm/P1AjmktvwMz5HzSUzI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5099.namprd11.prod.outlook.com (2603:10b6:806:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 16:06:26 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:06:26 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 28/31] staging: wfx: fix comments styles
Date:   Fri, 10 Sep 2021 18:05:01 +0200
Message-Id: <20210910160504.1794332-29-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72121be3-4b81-42c1-35d5-08d97474f0dd
X-MS-TrafficTypeDiagnostic: SA2PR11MB5099:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB5099AACE90F76334992A0ADE93D69@SA2PR11MB5099.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a3BOBfJxqzCMJoTaKwxv+p4zQrmR/5sQg09z3ZxO9MlekDYsySKzEMy0zKZ76J/vJlp5N2QNI3i/E84ykFDs5CUjhoZ47V4Kb7AEuWie520uOIUutKTQztx5WX8RVDo+wgLK+Lwpc46ygFZsGbyKruPnoj6gmmCyNXUdHjXShhEUSQP2bFwnAm4MIQkfMPf/2aN8OyFmZI34Jb+WaVpO0ghwnom7nkwrhemgnLE7WV2VWYYaPVkNbcUsw3uz52Jv1jiB+nPitrw49Z1gdwzMYAn9kZt2c/Teee2G9NyuJefR41SeMUOY4WWIGnIuU9d/jgBcjAcjvPMDI7OvcdUOmiGUZCRITIotD0VIhaDsMIhzFv+7l+r9F6/W7hWK0Mld04bcAyy1aC8MdLVOMBN1YIg3qgb/lHdAoP4VnBBTct66I0MaUKqNIMiNg6feNoTwaO6En8Ykfb0ke20k8MJUe8QZjIy40t/qnljkjvH6QozSXC4s4w8bMW1BELqp92x+7aKGkuVPNyU9axDy0zc80Bxnzal8Fg4YscF10YH47AIXuvTOEgnpLrrrIzaYLFd29cFnwTLqnvotYCxUZiro04bFPhmKkmQFbC1scBg43LIBiMhZFl8Ur2qeSozppF40kmZDraI4C5TLSBoCYjN9mA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39850400004)(396003)(136003)(346002)(83380400001)(316002)(66556008)(2906002)(6666004)(6486002)(86362001)(66946007)(54906003)(36756003)(1076003)(5660300002)(38100700002)(186003)(8936002)(66574015)(2616005)(4326008)(8676002)(66476007)(478600001)(52116002)(7696005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0phZ254T2RXYjdhUk8wampGM0hGMFl4eGtCQVgvdFBnZS9kekp1cHU4QWVL?=
 =?utf-8?B?RlhkeFBBeWNCay9lM3F0NXNnYWhDQnVyR1JiWGduZ1J5Y0FRR21ITFhTVUZJ?=
 =?utf-8?B?K0FZd1UyM0tQSlRMVTBGcDExWXh0Rks2N2oyTjZ0cG9mUzg0K0tmd0dTQllo?=
 =?utf-8?B?RkFKK0ZFQ0Q1K2cyVGpkNE15SGs1R21jZFdtaWFrWktyMHduMi9vekhzaWxK?=
 =?utf-8?B?a29rSjcrUlQyQytKZ2xlWkxCVUtnQUxubHV2emt1dmZqMGFVN0xDTVBPRy9B?=
 =?utf-8?B?QmRrTVBsVlRUaURCTTBTaEZwUFp2c2IySkRheWVob1FkZjljdHhrNmlzY1dy?=
 =?utf-8?B?VHZ4UTJxSDVmRnpTcWNhRWVjNEZ4dXFkWEFrZGtWaEdjeWUxcUFINm91S0tG?=
 =?utf-8?B?STdrc2ZXMjFYTkRrbk5ZbWpReUpuaWt3L0s5VlE0VTRSTXlJWVdUSlJLU2Rq?=
 =?utf-8?B?aU9XM3gzVUJ2MFhvQStDWit5dHZtRkxZT3FDTG1BSXhpdXNNcDd2VTR6ZmhW?=
 =?utf-8?B?Q0tac3pqVGdDZkFQcUJIS0REL2lXN2kwVFVZNG8yYVFnaXk3OGkxaklwblR3?=
 =?utf-8?B?MVdDRTJERUlZNlZsUmdYVERscFNtWFZNeHdLSGMvdFBHK2pmSkppNnRvRmhS?=
 =?utf-8?B?bkdOMHVnZlNGMUozV0UvNStlV2FVQUNrN2ZnNGlMMENvNlp6Nzl2VGhCWWo5?=
 =?utf-8?B?YVFlZGZ2eVIxTEZOUnRRMlgvVXkvWEJDaHlZa3RHNURSd245YStrenF5VkJm?=
 =?utf-8?B?VWtkVTlscXJiVlkzc3dNOGF2S2xXRk9yQkVISEpTRm4rU1NSV3I5RFI4ektX?=
 =?utf-8?B?dGFQNm1ONUFNN3ZpWndsdDF1bVFlQW5MU3B0Q25PTGNoOGc1UDZTdHNEYUI4?=
 =?utf-8?B?dkdCOG1MMklHdm5zTDFVVk1qMnZpOTYzUnQrc3AybjZuTndiM2x1Q2dIMS9Y?=
 =?utf-8?B?Rzl0NkU0UkQ3YVpKRUgwSDVUV0twOE55NUF2bnpaRThzUnlQWTRjZTltSmRt?=
 =?utf-8?B?dFdnWHRPZUVEMWJuMHFxTmo3aFVLeDUxYjVCUXdaamx3RWVTM1p6UGIyeEJQ?=
 =?utf-8?B?cFhhakVDNVZ4YkY2N09HZmdvNDlOMjFCZDU0UFgzNkpGa1JjVjdXdGhJNVEw?=
 =?utf-8?B?QVlCQXdlS2VFakJQc2VVd3NXUERDeE1GdjZBbmw4UytPMDl4b3FSMFZyNjBO?=
 =?utf-8?B?SHp3TVVIK0syT0hLczJXQlB6TjhtaEE3NGlUTFpjdEU4Wld0WCtLN096aFJF?=
 =?utf-8?B?K3k3TDdmdDVYUm5wTVAyQzAzTVZkeSs5V3NXOFVIdlZmQldVOGhqM0ZKRi9i?=
 =?utf-8?B?SWZQM3RzeXM3S29LdE1FTVFjNzc2WlIwTk1PL0NPbXZwRGV6WDBURXBleCtr?=
 =?utf-8?B?aWRFSEs2OHo5b0NJb0xoakxSYnU0QXFGNXB6engwaEhXRmRLRkFJUHBrNkhO?=
 =?utf-8?B?dyt6K3ZxQTlmU290VlpMRlJKWGtMMGxWY0tQVUtUdkdmVFhVRGIrWmNBY01j?=
 =?utf-8?B?dnc4NW16dTZGQU8zNXB1a1BEMEtrL2c0OUFLa3dSL2pVNEM5dGFyQXZpNDM0?=
 =?utf-8?B?S3BMcHIzdmRjVVRWZkx6NzB0VFMrcUZYUjBjMlBJSFlUOElFU2NpWVJiR2ZY?=
 =?utf-8?B?UzNUaW9xdk9ONXZqdFZ2T1Y1THVaVUdJdXR1SVBXOVFMZWJmZU1SWUphbEwz?=
 =?utf-8?B?VURNTDJWd2VLczNVWEt4dVArdWVRL21aY2xHOEJvVXZTV1lrc2pLa3Iwdzg3?=
 =?utf-8?B?YUttMzlsM3lPeVkyRHJ6OUtCWjZhUW9iR2dhN0JxK1RwWHo4Q3FEWEx2UjVY?=
 =?utf-8?B?MDlIOTArQytYR1dZSGJmakJ1cXFIdERjVTBBaThzUmNtWENJZU5uYi95ejBw?=
 =?utf-8?Q?NbBsFMdmQdNwd?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72121be3-4b81-42c1-35d5-08d97474f0dd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:25.8471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZTHw9aB/EIt3pIoCtAEy3ROGD4CtlnwMbGpEZ9e28kU8E1IdtwidKqOLIGhXZ1ETLcftAx0kqfnMH4JbBmTtXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5099
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
