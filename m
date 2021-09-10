Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B43406EFB
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbhIJQJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:09:32 -0400
Received: from mail-mw2nam10on2088.outbound.protection.outlook.com ([40.107.94.88]:56865
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230317AbhIJQIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:08:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kcf22SSCj054J68B9fJaVxu2hM2NtS0C2IpAlQD/8mSflIHUqdcPORNduziJHIVIPy/5D088ApkqGVgbH16SODvGG3Vrc0VCzrd3qpPmPHyW6ZVNQGRDWQlJgp7xYOZQ7eD86WgSj8EIdGM96LIKt1wK0O8E87VeX2wjDOWudsJexerhqF5sVSOU2TTxgQ6B4XYrq99kB4h/kVXWN9P6wJFbeJ8+0kSdCouKpSA7TIaZDC84IW3aPufOpyiqAsNgY1JocrpZktBt0EuAq7qL7T47w2tNwUVMc/n/JMGaThimPJU/S9nhqjnfhJ6KgMSW3Mlkh3KgKast5cee+yCMTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rtRjvSlyXDToLuWg9t+Q5N9m2nkpKJd5T4sJtezrxTw=;
 b=DEv6OuTlUP2ZKUUtYSF/xxkljIM32w5WSe7o3sH2y8pSbMSGkc+odyN9CwKKAS47krlrYeOwGQS6+K6J1zcQjiX/JzirGk2g1o5InUR/GGE91Ds3lqwA0dxK2ExLfNU4hbt/JvRK91vOWhzn7cdFJiZpvVIgrg3EpTsDJgy+YV+gKS0UsNeO62o2q/Jrz6wUjv8boqFWQplO8YOmSGBbF/mOZpdzhABTrlyg3C57nw1P0b5YxtEHPYVzOrqfJIjgs40GWkC/7BFlFehkkFxh0jw/nwvbtmlhm0Gn6H1IzlLafg0YvlrMtpvUfcJGeS6wU4/wFSRmPcsXvDMSJSItsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtRjvSlyXDToLuWg9t+Q5N9m2nkpKJd5T4sJtezrxTw=;
 b=Pw0Ebq8SSX9c8ATNeCmEvIkioaN6VSJmQyiVedZenuhPdGRzDK022n2lqTVAtVoVExLp3m4yDUKAksncSFsMWZjszqcWma+AMmS+Bcl9IQqvgIShPaDKk0EX7V+dmehLANnt6Bqlk26EJspXvPrEhEYJuqw82v7RWTZxTvc1QSo=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5002.namprd11.prod.outlook.com (2603:10b6:806:fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Fri, 10 Sep
 2021 16:06:16 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:06:16 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 23/31] staging: wfx: fix space after cast operator
Date:   Fri, 10 Sep 2021 18:04:56 +0200
Message-Id: <20210910160504.1794332-24-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 345e72c0-4416-4dd6-da6e-08d97474eb67
X-MS-TrafficTypeDiagnostic: SA2PR11MB5002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB50029225DD76BBDD85775D2B93D69@SA2PR11MB5002.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KBBGZ1EH4CN5/zXikZkQIGb0Xq/Vqg/3ZCcORbl/VTbS+k5xxqxZgGfmoSz52KEm7gy+hDhHLsf2hnOQ8YUnTnfmftY2ZXiSy9wqqOQM6uXAKjgLLJ9GFS9GTYN+L+VtUwDWSvjVrCMnqjooJ2jXsPDg9SEGd33akQKByBX9Q2+FRDPFkQWBSpbVYoKUcN7OEmG9ti7emTKuVgmmK+Tb2p8N43KtPBWO2w/GaoUrIlY910w9110oEp0KXFgngHqFt8tIhRCEb56nxnkzF+wRQ2zm00Y7TSG0XYhf7ESfupL0tAe3Ao41DBXTmPaT7azHDoZYuc/btaxV3pxsWwVnKZAfxjexrQ2bf0MquSSS5MATjS4zLVZY9w4L8ZwuSXCf+8eyiUfKuVJqjR4oEMwcsOvN8VnHMLny+cGmrYgvirZLs19idz+d0qcyIGu3DXa3SCSnMw9RcY0lD4A4cKiIhl64AvggP+U0cyQJZI44jora+Cj1MfI8HusUpoaGxaVV/At9lfIqU5crkzCT9P/zvemq3n1fDvHEnqRfKNh+kfFeU7DJQtewpCpEKaIR4+ZeTxH/Q06A0+r51VV4HY6BGaUEPBc02Hv5c7N6oFBiUSJyHE3GGINy5rXZGGgvMfItdV6E0kY24zm2wk3NJMwtgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(52116002)(86362001)(38100700002)(8936002)(186003)(66574015)(7696005)(4326008)(508600001)(8676002)(4744005)(36756003)(2616005)(6666004)(66556008)(316002)(66476007)(83380400001)(54906003)(66946007)(2906002)(1076003)(107886003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUViSDlGbndtbXA0TDIzYk9xbFg4Nk9KMGJVWDhrT2VMc25rYUJHcXdnOW41?=
 =?utf-8?B?OElmb3laQ2QyWVBVRmNGckdqR0VCOVI3RGZ3OVZsVlAyaUZhQk02MStKUEpi?=
 =?utf-8?B?UDZucytXZlNOc1pzSzNzRFRlc21JM2pINzNxejZuQzFQVmF4ZSt4ZUhNdnhy?=
 =?utf-8?B?TW84dHlHcU50WmpQRy9BUTdLSHZxNHROUHFGdjRWS0hpbjJwbmVLeThYK2FM?=
 =?utf-8?B?SUtXS0FEdWRCZWhrVk1TdFhzcmgwblZUNFd6NEh1SXh6ejAyQzU5WWtWZ2tW?=
 =?utf-8?B?eVI2bHFhZUJtVVF5a0srOXdXQnJiVkVMVk81c3gya0JNRmFpaXRjSVAraHJZ?=
 =?utf-8?B?RFRUdmkwbzhCNW9WczJnbDhGOW9QQzdlT1BkWnArUUp2UmZGNGtCNGFUVzFG?=
 =?utf-8?B?YTlJRnFwS1BqaXBmVS8zR01RZnFXNTlyQ0x3ODg2d0JsQ2ozeTlHVllOUnpm?=
 =?utf-8?B?ZWUyc05GYnhEVjNGcUhXSVUvdEc5Rm84QjV2UnpvQVdrSW82dlByNzYvdUhw?=
 =?utf-8?B?ZExGNkwyR3dPR2tXMU91R1lrVmx0T0w1MnpHZWh2VWU4Vjk3TUZyUldaSEc1?=
 =?utf-8?B?bVp5K3FVMFhLOEpuWDZ6S0tlbDg1MlArZDdIeGs2NGtLOU5OOHNSRmdpdXNK?=
 =?utf-8?B?M1g2UVlSR1o3VWliV3ZwQWJtL04wQ1Z6NHNmbXFsUW9RbUVSSEJwWmpvUTBW?=
 =?utf-8?B?SmVScU1QRGE5eFRPRUlFK0dRS1dvL25xdTlkOHR3aFdiZUVETmtiazJSTzVN?=
 =?utf-8?B?SjlVZGFtM2xZc0QzSEdnMTJXcDFpSkhDZzlGd1BmYk51Z0Q4Skc2TjJuaGxU?=
 =?utf-8?B?dUp4KzdTS0tJQmJMUzlsMXJzYWJvZmZ2V2RSWUJUREZvT0JraThHd2xJQlli?=
 =?utf-8?B?a25DM0lPZDkzOEhDY3FBSXlZZlJ0YUd5c1ZkaEd4ZVBhNGJrSHdGTkpZbEFj?=
 =?utf-8?B?MHFoNG9MVG1YT2ZtaWJmOUtjY3RiNnZCelBvQTlXSXZXcWtCZm96ZG1IRlov?=
 =?utf-8?B?aGRNRzE2S2NRc1BJbDBvZ0RzSmVqdU16RFZxZkl5bjRpY3BQcUQ0Skp2WlMy?=
 =?utf-8?B?Zm9pT2huRU11V3ZFNEszMHlrUTY4WEx6VUtIMURmVnAvOFRNOTJZdU4vd1lV?=
 =?utf-8?B?a3hLa1JiNjJVSHlPbzJwT3FsTUZRVlRJQ2FrZjNHY3BxTXBnek1xWHpyRU9i?=
 =?utf-8?B?cC9mYjVDSTRocFdaUy9BeFdNTzRmZjNqKzk5dnJEYmJBZEhJdEk5YTNTS0dj?=
 =?utf-8?B?UllMWm94K09yd0pvc0lxMUFnb1V0RGphK0hVTTZGYXNVUGcraHhnZ0FDVlBC?=
 =?utf-8?B?Tmd5UHpQd0gxTlJIMk1qVTZ6YjJndG1lc3JuVmJFWDFhRG15cEQ4bFdNV1Qx?=
 =?utf-8?B?R3p0WVZlOEUvMzFzRkFINDJHa09rcXZ3OGhFMjJPMlN3MVF4blYxdzAyT2dZ?=
 =?utf-8?B?NDU1ZWN5anBEV0o5alpKUm9rYkJTQU9TZVdoZkdVa2QyNkZWNUhNRnF6amFj?=
 =?utf-8?B?akdsQUF3blViSlpTSTU3YlpFTmV3Q0ZVWmxRN1FGOGpsdWtyL3JjTGduZkk1?=
 =?utf-8?B?azQxS0dMU0xPczB2cE1lS3pPdDRLUk54NjkrK0tMT1luZ0pZZnZmcTZrME1x?=
 =?utf-8?B?T2x1VUhNMGNJSTAxcXlVTlhBU3dMT0xOS3dwaEpFU2hNSUxjL3BzSVJWMXFs?=
 =?utf-8?B?L3d0MkJhTUdHQTVZRE1qb0VSRTRZcTBVZlp6RURNVk01dzVwbk42WW15QmNl?=
 =?utf-8?B?RU1PazdGSjJ0UmM2NzFINlEyUitIRzNHNXlxbldqOHdtaVNRb09MSlpjamVQ?=
 =?utf-8?B?OGIwcXRWSlNGeFJkb2k0Q0t3eW1lRGE2bFU5eVFjTkUzaEVKQ3A2YURkK0VN?=
 =?utf-8?Q?J9S+KI95YxH6S?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 345e72c0-4416-4dd6-da6e-08d97474eb67
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:16.6614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LdK9cOmFPGRDKSJaTRCJYCm01fDGMUx7M/klzpWFX9JCWqYRIpid8VnYyN/EH3cVX0y/fTGzdK44f75ZdJZQQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKY2hl
Y2twYXRjaC5wbCByZXBvcnRzIHRoYXQgY2FzdCBvcGVyYXRvcnMgc2hvdWxkIG5vdCBiZWVuIGZv
bGxvd2VkIGJ5IGEKc3BhY2UuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVy
b21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCB8
IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3dmeC5oCmluZGV4IGE4ZWZhMjVhMzhhYy4uOTc0OTYwMmY2Y2RjIDEwMDY0NAotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKQEAg
LTEwMSw3ICsxMDEsNyBAQCBzdGF0aWMgaW5saW5lIHN0cnVjdCB3ZnhfdmlmICp3ZGV2X3RvX3d2
aWYoc3RydWN0IHdmeF9kZXYgKndkZXYsIGludCB2aWZfaWQpCiAJdmlmX2lkID0gYXJyYXlfaW5k
ZXhfbm9zcGVjKHZpZl9pZCwgQVJSQVlfU0laRSh3ZGV2LT52aWYpKTsKIAlpZiAoIXdkZXYtPnZp
Zlt2aWZfaWRdKQogCQlyZXR1cm4gTlVMTDsKLQlyZXR1cm4gKHN0cnVjdCB3ZnhfdmlmICopIHdk
ZXYtPnZpZlt2aWZfaWRdLT5kcnZfcHJpdjsKKwlyZXR1cm4gKHN0cnVjdCB3ZnhfdmlmICopd2Rl
di0+dmlmW3ZpZl9pZF0tPmRydl9wcml2OwogfQogCiBzdGF0aWMgaW5saW5lIHN0cnVjdCB3Znhf
dmlmICp3dmlmX2l0ZXJhdGUoc3RydWN0IHdmeF9kZXYgKndkZXYsCi0tIAoyLjMzLjAKCg==
