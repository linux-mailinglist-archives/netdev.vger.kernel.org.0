Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFDC48D3F9
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbiAMIzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:55:55 -0500
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:28322
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231376AbiAMIzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:55:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijvrbe/bQykgFLuodwqhIKJ6HmT8fk7G7HnGex3uZ9ESqEA/5bcZzdXdOoKa3BgP8JPtiVDv5vmEoHmZgA/QPdis4UtRk50hybRLSqSz8JdVjKW8OcGoKSMbQ4qP8xFOLtOSNDL5qnbIuAgicybRUt4R+0GX81ShIwT5lPmAqVGlGlM1q0zObNJ/5Y/rIrAcZQln2F95ofd+Dgl8UVjn9sny/zppq8s/au+tl7SokbW13fUL59ragbABrMdLvKKp2f5EprDxk/MTJxrd7UvMM8rAwFCCU4LioWO8husqaOI2gKrb5KFSLcNs7Ylswjrw8TX102Y1dz1C7ei3L8licQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvZl16TELr7l4/hx5wQeeZi+e9QX3BFwwPMgJvqTK7I=;
 b=OPEj3U/tm/A9fUozY+Fi5LTyHjzOQcZ/DbbmY8BmAUvVYJjrpVzloMojGQ0FHdu+LzEB2yqM7CwZPBlH1nKh/VfZzYbXbb2ok+jg44+dqfDtThm0/LS3OsjWXEMqco27XPva8raMYXly9fWqVZi4n/ry1UJNVjttWmvjddYfMre7m6L64X6rWJbioOdW3HsBdAhNqRVQfuX2gqcV/hQKdZ5CaniZAvsuozVtIm98sH/IaVjr5dxs+jsYjsG+l4+AIYLMPZeVd7F5NFkExJyNx9DJb7iwtxMguyCyC0kSDe6mZu1487053qktfe/7Lyy2grVz/c7T5mkxZo3gaDwSQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvZl16TELr7l4/hx5wQeeZi+e9QX3BFwwPMgJvqTK7I=;
 b=TuTbAr0mvPkzkpTVU3HJKgxeNjV5xzyqTGmjppJYT74YsbWkMCz6DVfZ/3bfN2/dVZcOtWCIKegTkREXavmD2tg1DpJSJmKTbaohl+lzFGRqntLrsR23hM3D9ZlhTa20cnfVqXB/EYPz7zoyXphksScZXWIMUXlaj2q3JIPirp0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:55:46 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:55:46 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 04/31] staging: wfx: fix comment correctness
Date:   Thu, 13 Jan 2022 09:54:57 +0100
Message-Id: <20220113085524.1110708-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 669b5183-06d1-467a-f444-08d9d6727ce2
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB404002B4F7FF559059EE7DB993539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1pf/6arT+s+eNFYl5bK530mEnN6Cft7qQWG3nUTamDWoEcD8vhrovxc0MvUs/0c4ObXCpBiecxYJzMTI1l/vyZj0SLWI3p8gNYNH7NGmjy3NaUjfJ9UyRkfxRBrO8zZR5ZoR55lyf9XmLENxJkLSet89i47mJNMTFAOArFBBjqm8mMe/YH5fouzevWAXHFHNwcYM+qEAqzRWOW6Uh/RMARxQtmlr4ZhEbTEomBJV+RW8oREFs9OXcccdTgoQzO/5M/0cYRrnX9GejEfcifsKN0H7KN7eh1+SzH3LL9dxK4X5NzRHaDfoKgvVuPgutNK/042yzUZMRo3KCZUj88DSewSOSSotYZFCleQhk6V5nBGcFerhCLswk4FHchaXGF68coYx70mxUfmvR5TZExCktoaY9fOyQzv6FvGd223Uk4LCq9ViX7ib1B2zyvlx0SybzMGhDo6SsJLuZoPfanUYtOjL2VejHSgp/ZLUzQNZkIrSvL4vbdqTirc2MovigrWHxtD+25sCoRJ17IdPpXRaRgZSEPm61dm7M0tlgvbD7f2wB3zBpayDpaP2tuYkw9S0oz1DY0d8MK8bOVQBWBaHBYPNM3GZA/r85UxuGdKX3JkImpUIea1IoU246bLg3shWSZe9GMSIcl/iFNmvFk4CPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(38100700002)(4326008)(8936002)(6512007)(6666004)(66946007)(83380400001)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(66574015)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QndWbEFFQ0NTbzV4WUhNYkE5eTl4SU5QSWVCelloL1F4aGpyZUlqYzZsLzJ2?=
 =?utf-8?B?SEkzV1BPTVQ1TkNEUVBBYlQya3Erd3NOS3I1dVNmQTVQbWlOcHQrZEFxaUp3?=
 =?utf-8?B?ekpLbGFpMWxuVWZZdUhKSzlESHhVVlF2RmIwOGlxT3JWc2VDOWdiVTZvcUo2?=
 =?utf-8?B?NXpMalF0TitSM2tmUlc2Q3JNcnpxcGZnRFhVbDVlQitia2k3a0s1dGMxMGtx?=
 =?utf-8?B?d1lEODNCR1F1UVZzNmNmUUFweEkwblNrOFlCR0oyTVF6TW0wV2ZRNmh0QkMy?=
 =?utf-8?B?VDVHaXBpRHBTVFM3SVFXUkYwb01tenZNZzFXSUZJQWhSR0lvQlJFZEtUbG5m?=
 =?utf-8?B?ZkJSQTlDbmMwTTJka2VqVER3bWlEbHU1MWpLMGNUYThFTGVyNFNLbmtJc2o2?=
 =?utf-8?B?SXpSS08yNk9pUm5zanpIbEE0T3lnZkNuTEZOQjBsbGNGTVBRS0V3eG9OT2M4?=
 =?utf-8?B?SUxJMTBaQXN2cWt5MlJHNFYrL0NYUG9JeWRYd2I0b0lCeDRmaWdETTdpS2hN?=
 =?utf-8?B?TzJUd1FxaWlkMnRDam82djNQVFVPZGY3UnVrLzhMdkhRSXU0WHUyWi9wV1pO?=
 =?utf-8?B?bzlRa1lHYWhkZGMwME03Q3RMTFJSbHpicnFmdkUxYVFodFBHUGpGQy93Z044?=
 =?utf-8?B?VHNuTE9WOFYvR2l4b29hWSszUVNheTRKL3FJOExDOWNqTlFadlEvbThPYVBP?=
 =?utf-8?B?TGRQZnAwTHlTZlFpeUhlbkVEV1NRK0pxclFQRForTmpxdURyT1c3anl1VW94?=
 =?utf-8?B?WmNpdTJERWNTeUY0eDhRV1FqMnpTTStqdmFsME51SDZYUG9UYnVwbDAvMFNG?=
 =?utf-8?B?VWJTWjVwK3lwbHZEdGxjRUZoc1ZiYnJrMEQ0Z3NBOVd1QTdxMGhCaWhjVEZ5?=
 =?utf-8?B?WEZvRGxlVEducmFMQ1RYZ1Rja0RLdHNKcEJueEYzVWg4ZFlqR2RnTUxydHEv?=
 =?utf-8?B?REdHcDZRQmxoYXlBUnhpa05rdytVRVFtdDhiRFBTNkNuT0d4MnRhTUFjQklQ?=
 =?utf-8?B?ZlZOZFBkMnJUS2xCa2lLNTdiUjlEWlh1eStaamJ1T080MkVaeGozb3lTNTho?=
 =?utf-8?B?eExROW5rTjVzcXE1L3pMQnBvODNpd3hxaHpid3lOakFnNlk5NjFhOHBSTlY2?=
 =?utf-8?B?NWxPa1BhVHIxVG4vZnhJaURXbUIyRGdTd2QrRGFmSEJCNUcwZTh5MGNUMVRn?=
 =?utf-8?B?QlR1NzE3STYvbU1zb0Y1OS8xVWYvd0dkS1Mvb3ROa2VtU29xODFrUWdjZ1hM?=
 =?utf-8?B?dGlta2JPQ003emJIOVN4ZzFINkszb05tamlDWUlyU2E4L0lhZ0JmZ0tMU3Iv?=
 =?utf-8?B?cUNCOEZ4L1g0RTJWSnFWM01FUkF4a1FyaDFpV01EYWg5MXFrVENYZzNEMWpZ?=
 =?utf-8?B?c0hTSDR3cVcxL0ZROEozanQxVnRSQmgwL2lGNktLcVI0a1MwREIxSy9kOTd1?=
 =?utf-8?B?aTZPSEo1WTRVS1pyaVNtTUpJRHMvOUxUUUhoaGJYQm42Qlh1NzNYMUFnTVkw?=
 =?utf-8?B?cGNUcXZLWFFkMGRPR0pNNjhGcktCZnVHcFpGSzVxMVNWNGJiaU42bFpyY3dt?=
 =?utf-8?B?aklwZHFhTEY1ZGpseS9iMlY0ODVzNjRhMTVSaHdmdUFMTTZOaTZSVWthbnJh?=
 =?utf-8?B?K0pZbjZ5Ky9PaXlZU0h2TjZjSlFzR2Z0aktXRjZhN3pDKzVDNTE2RDdMN3ll?=
 =?utf-8?B?RTIvNVVhTVBZZG5ScUt3VVJrNHV3MzFibDFOU0d3djdIR0w4dDZPUmtYQVI1?=
 =?utf-8?B?SXA4SUtGK2NWbFYwS1doU3JWT3hlV0x0cmV6Uk11Q2daS29hUm5vZGszL0lv?=
 =?utf-8?B?WCtGMWdhUmdYeWFGczk1NUdzakwvajdya1hjTFVCSWpLWnJXR2srd3dTSWFC?=
 =?utf-8?B?bUVTRW1tZ3ZtYXVqaUw2MHhnZGhka1FYRDV2d3VyblNYOThYTmo5VmxoSEY4?=
 =?utf-8?B?WU1PTDJrTjdYb0FzRVJjem52UnppZjJ5aFJpU1AzWkFhWkJwZEd3a2szSlRX?=
 =?utf-8?B?TU9qUHFYSk53VGNaSmxsRWtsRFkvVFVtcFZRdEg1MXVkdzJyT0NEeTErZXh1?=
 =?utf-8?B?czFsSDhIVzFuMHFyU09Ea0pMYytqdE9VSjh3MkFLRkExVE5YSzBKbndsUzQz?=
 =?utf-8?B?SkZsRVh0ZUtkR0tTVm51b2xCQm8vWVZnaCtqdG5UMnlrcUh6NUV2SFI1RHRJ?=
 =?utf-8?B?SGlucU5UYUh0Y1VvbHBXbGp6SUw0b0xzK2VQb2JKdlZlQU1WV1JDL1hsY1Qv?=
 =?utf-8?Q?SxKcQc3HlFi/2jM5z8QauHP5JVFSXol8mIK0FUNCdI=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669b5183-06d1-467a-f444-08d9d6727ce2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:55:46.1843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: shKO/srK8sUwrPO1b/pYdtesqHF61Jj6mN/sF88OmuDmBIeBf16XGOvkSgVJ0Nb2wlgWS4kt31WKjxEju6TPow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVXNp
bmcgRE1BIHdpdGggc3RhY2sgYWxsb2NhdGVkIGJ1ZmZlcnMgaXMgbm90IHN1cHBvcnRlZCwgd2hh
dGV2ZXIgdGhlCnZhbHVlIG9mIENPTkZJR19WTUFQX1NUQUNLLgoKU2lnbmVkLW9mZi1ieTogSsOp
csO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvaHdpby5jIHwgMTIgLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L2h3aW8uaCB8ICA0ICsrKysKIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxMiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2h3aW8uYyBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaHdpby5jCmluZGV4IDMwZWI4ODg4MzBkMi4uMzkzYmNiMWUyZjRl
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2h3aW8uYworKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2h3aW8uYwpAQCAtMTQsMTggKzE0LDYgQEAKICNpbmNsdWRlICJidXMuaCIKICNp
bmNsdWRlICJ0cmFjZXMuaCIKIAotLyoKLSAqIEludGVybmFsIGhlbHBlcnMuCi0gKgotICogQWJv
dXQgQ09ORklHX1ZNQVBfU1RBQ0s6Ci0gKiBXaGVuIENPTkZJR19WTUFQX1NUQUNLIGlzIGVuYWJs
ZWQsIGl0IGlzIG5vdCBwb3NzaWJsZSB0byBydW4gRE1BIG9uIHN0YWNrCi0gKiBhbGxvY2F0ZWQg
ZGF0YS4gRnVuY3Rpb25zIGJlbG93IHRoYXQgd29yayB3aXRoIHJlZ2lzdGVycyAoYWthIGZ1bmN0
aW9ucwotICogZW5kaW5nIHdpdGggIjMyIikgYXV0b21hdGljYWxseSByZWFsbG9jYXRlIGJ1ZmZl
cnMgd2l0aCBrbWFsbG9jLiBIb3dldmVyLAotICogZnVuY3Rpb25zIHRoYXQgd29yayB3aXRoIGFy
Yml0cmFyeSBsZW5ndGggYnVmZmVycyBsZXQncyBjYWxsZXIgdG8gaGFuZGxlCi0gKiBtZW1vcnkg
bG9jYXRpb24uIEluIGRvdWJ0LCBlbmFibGUgQ09ORklHX0RFQlVHX1NHIHRvIGRldGVjdCBiYWRs
eSBsb2NhdGVkCi0gKiBidWZmZXIuCi0gKi8KLQogc3RhdGljIGludCByZWFkMzIoc3RydWN0IHdm
eF9kZXYgKndkZXYsIGludCByZWcsIHUzMiAqdmFsKQogewogCWludCByZXQ7CmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2h3aW8uaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaHdpby5o
CmluZGV4IGZmMDk1NzVkZDFhZi4uZDM0YmFhZTQ3MDE3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2h3aW8uaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2h3aW8uaApAQCAtMTIs
NiArMTIsMTAgQEAKIAogc3RydWN0IHdmeF9kZXY7CiAKKy8qIENhdXRpb246IGluIHRoZSBmdW5j
dGlvbnMgYmVsb3csICdidWYnIHdpbGwgdXNlZCB3aXRoIGEgRE1BLiBTbywgaXQgbXVzdCBiZQor
ICoga21hbGxvYydkIChkbyBub3QgdXNlIHN0YWNrIGFsbG9jYXRlZCBidWZmZXJzKS4gSW4gZG91
YnQsIGVuYWJsZQorICogQ09ORklHX0RFQlVHX1NHIHRvIGRldGVjdCBiYWRseSBsb2NhdGVkIGJ1
ZmZlci4KKyAqLwogaW50IHdmeF9kYXRhX3JlYWQoc3RydWN0IHdmeF9kZXYgKndkZXYsIHZvaWQg
KmJ1Ziwgc2l6ZV90IGJ1Zl9sZW4pOwogaW50IHdmeF9kYXRhX3dyaXRlKHN0cnVjdCB3ZnhfZGV2
ICp3ZGV2LCBjb25zdCB2b2lkICpidWYsIHNpemVfdCBidWZfbGVuKTsKIAotLSAKMi4zNC4xCgo=
