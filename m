Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451502C7861
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 08:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgK2HiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 02:38:18 -0500
Received: from mail-bn8nam12on2059.outbound.protection.outlook.com ([40.107.237.59]:21184
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbgK2HiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 02:38:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lcuyn49/lJ8v1Hj90Cc4jrGsvC2ufmlTOKTnDVDbJ0ztUseMqgTgE/FU73bG/2qqb5hOp2OnwiR0lQsY/KQk7mHZ6xHEipQhkW252+Y8rYqdMMLFwOuid9kekFX4KaAfOhZCGZGSI31KKQ1rikmfTHD6rWeShfRwZKKFzxv9fK2a8x2LQAHlhd8txItu+x0ei+cN/CsAUZN2sx0daAIde3hYYw80aEaRQkWQ+EJyTfrIhW7FdSFCJwShU+OPuwrIk4wQu0vyA0fGy3ar7e1Fz6L82ATwrb1a4H3ZpEIPPKic1u1ZTPWdkx3xfJuGPGMcvsFp086kpblZkfQsutCn/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsowewy0xYdClzCd32H2qI2bskLgAaS/Izx9WOna7Jw=;
 b=UUL5EifNwLF3d3ULCRQwzbPzk8lvK6xUwXP6RmVqwnCSN9UgE+i/L68l56hzf2Km59x3upwK/5sJU2g8cRa2UcMCWM7Z1G2/A7vYkhvYpGdlM2APNG/MsG6vbpdFW4TeCY5Xa7g/LTr1EL78IxX5eH0+lwNOKrXxay6uSDA02Urwkj5yNmLpsXRV5NbfXtdmxZ1MA4r4nG5ff1x7z/P04CupJPdA2aF3BRDcXk79l0t/Z1Ifl0HwpS7U6wviYQ6NM0pkbBT6vQDr8JngmQ7k3yFJXpmwx/mC/A9+Ys9PjigGdTyj4qFexPnJwr/wLueC9tysf90kkRHp0UgmSgYnSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsowewy0xYdClzCd32H2qI2bskLgAaS/Izx9WOna7Jw=;
 b=KC7ECxaKc/Jf3Xc0gzV8Owyrf7+zNr91o4tBRyHqSJXYtzMzHOJ4kJSrTTSectUuKxQc99CYQYmLV/F6ZRtlvWNTKP8LzeWBXxuE+VIP7FmOHcCXlu3WXl2r1FmawOyiQNSJRnbM2+8gpdavGVxdh/zaC9WgaG5YIaUs+9Ing8A=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB2603.namprd11.prod.outlook.com (2603:10b6:5:c6::21) by
 DM6PR11MB4626.namprd11.prod.outlook.com (2603:10b6:5:2a9::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.23; Sun, 29 Nov 2020 07:37:28 +0000
Received: from DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::54f7:13ae:91ef:6ae4]) by DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::54f7:13ae:91ef:6ae4%5]) with mapi id 15.20.3589.022; Sun, 29 Nov 2020
 07:37:27 +0000
Subject: Re: [PATCH 00/10 net-next] net/tipc: fix all kernel-doc and add TIPC
 networking chapter
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jon Maloy <jmaloy@redhat.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20201125042026.25374-1-rdunlap@infradead.org>
From:   Ying Xue <ying.xue@windriver.com>
Autocrypt: addr=ying.xue@windriver.com; keydata=
 xjMEX1nnURYJKwYBBAHaRw8BAQdAZxROH3r87AOhslT5tP2cdYcg89+pbHiYf+LIny/C0fLN
 GDx5aW5nLnh1ZUB3aW5kcml2ZXIuY29tPsJ3BBAWCgAfBQJfWedRBgsJBwgDAgQVCAoCAxYC
 AQIZAQIbAwIeAQAKCRC3Qmz/Z9beRSLiAP9kPgF+mG4F3elbrVTen/sybJfZidnvF1YVq5Ho
 sUbt+wEA6ByAVvGqlEbt4SE1JP6xVgTzwlwihyCgl/byRAQzeg7OOARfWedREgorBgEEAZdV
 AQUBAQdAsdHm3QQyX4RnhnVEmywHpipu0cUyHWeuAkYuLavc5QYDAQgHwmEEGBYIAAkFAl9Z
 51ECGwwACgkQt0Js/2fW3kXZKAEA0jTzhaLbmprQxi1BbUmAYtlpQCrrjCWdpFGwt5O3yO8A
 /jVE1VxnEgu71mYXX1QE1Lngk+SPVEfLm0BVZFk9fBAA
Message-ID: <bde23bb7-9c96-b107-cb06-64695726b21b@windriver.com>
Date:   Sun, 29 Nov 2020 15:37:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201125042026.25374-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR04CA0073.apcprd04.prod.outlook.com
 (2603:1096:202:15::17) To DM6PR11MB2603.namprd11.prod.outlook.com
 (2603:10b6:5:c6::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.155.152] (60.247.85.82) by HK2PR04CA0073.apcprd04.prod.outlook.com (2603:1096:202:15::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Sun, 29 Nov 2020 07:37:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 424b8f77-c506-4dd6-1c99-08d894399ef1
X-MS-TrafficTypeDiagnostic: DM6PR11MB4626:
X-Microsoft-Antispam-PRVS: <DM6PR11MB4626A4872B84C79FE95D626D84F60@DM6PR11MB4626.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Du4xLc0Oksn79a51/iIECDNkXI8mtb2TKThZwSNBKHQYv3ZzhB4S2IxBzOjC/lwyteenV+FfSVi6AqeosXaCb9QBPo9WXi6Ws7y2KahshqztFsLoMH8CFPLeosvt+CEMLQGG8RDRw8N13upEkOYWUAbKKQnYmkdD+5izB2vZdjONwsPnzB5Qvb+mnhaDHruF8VNd39zJUTACECvsX04+Fp6CgNjLBlhUVu4p8f28DRrN7cHSVbLglrCw1D8/vwaEBltpj8pCU5mDxQef+W/1Krywi1Wi+mD/ydbXGvVWuxCuAqeDYUyzfTC6ZQHUZgggmoyO4xrprdh4JSFmyznnG/NR4H6dz3uD198p65USj4rPBZ9mN2qQqiOeW79GQ0MxFBOvTZjQGD5UNuazRpOZXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(396003)(39830400003)(478600001)(6916009)(83380400001)(52116002)(16526019)(66476007)(2616005)(6706004)(53546011)(44832011)(26005)(66946007)(8676002)(956004)(2906002)(31696002)(186003)(4744005)(316002)(6666004)(66556008)(6486002)(4326008)(36756003)(31686004)(16576012)(54906003)(8936002)(86362001)(5660300002)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Wnk3VDZ6Qll2VjJjVWNJbzduNURMVmxKRCtETVcxait1a3BxMm9hU3ZQcmJ1?=
 =?utf-8?B?NTNxMVhMMFMwN3BKS3IzV3pqblZJQ1ltaDFHcnR1bTQyQUdQWjRrMjBMeHZF?=
 =?utf-8?B?cS9pSGNhZHFzVGVIVDNJZFBIWFdXTWdtZDNXc28wSHZyaGpOQnJwOGVvK09P?=
 =?utf-8?B?b1NISTR5d2xXZTJqUUtaUEpSNFdHeVpDMi9FdUV3ZWVwbnR5SVkwaDY5N0Y1?=
 =?utf-8?B?cUd0YUV1eFZVdThmL3dRQnJWR1BqMURlRkkyK3JoRmo5dmxsd0FxZDVNem01?=
 =?utf-8?B?d1FmVlJBK1ViaFJLZEpVb1Njd3ZrQ01oK1hKc2pLWmlKMkFxdzNUNTFvMlpE?=
 =?utf-8?B?MFNpK1IxOUltRFNNSlU0VGtrcDQyemJYMXhlUXp3NWJXdFUrZGRUdCtMcFJF?=
 =?utf-8?B?ZEhPTThHU3NjaS96Tm9YYXBsL2UweUdlOGFaR2tzdTJmK0tCV1hMVmF2czdD?=
 =?utf-8?B?WGRVZWdjZmMwWTlQdVVYMnFMalp0dE5mcmE4TnZYOElheVB1ZEJ5T3JtTllF?=
 =?utf-8?B?UzdsNm5jWHFveGVKRzZjZXV1ckFtdFVNcVk0L2tYdldHNk14K0tXOXVqczVK?=
 =?utf-8?B?RDk5cXFLRUJsR1VtMFY3a1JyVlRpYWtsOUlTbGliVE5seEdHRExWM0lqTitQ?=
 =?utf-8?B?aTNqTkZGa0Z6TW5UdGY0S3I0aDdYZDlrblFJM0t0dFZjc1BCbXJZSGpONWxC?=
 =?utf-8?B?UXpaOHUzSm9aeGl5bjJSZUo4Vm1BNVEyL1hxZithNElpTVZreFE3MXZxTkov?=
 =?utf-8?B?TVY5OXpVV0RCeWthQnNrYVFKdXJ6aTJpcGZESjdjL1JJclhjK3NxZk9GZmlr?=
 =?utf-8?B?TURIK3lGZ29FTGxmN214dTQrMXhDQnRvMHZEdjJ0L2NXQXBZSjV2Mmg5aUJQ?=
 =?utf-8?B?RjZxWTNzSlU2MXU0SjFaS053ZGk0ZmF1SnNyK3cxNWdZTEV2czBzWjhmQ1JB?=
 =?utf-8?B?NHlDNXQrMFBiMTZSaWpWMFZtZkdCZllCMXk5ZUh4S3FOZ3ZZbFRYdDZWZXR1?=
 =?utf-8?B?L0d2YXFMSXlWaDVEcmVuc3VESFR6aEVHN20xam5sUFFoeHR5NEFteFM5bmdr?=
 =?utf-8?B?bTBLWXlsc3VpVGFDNi95cHRJbCtWT29QQ2hUbzRWZzVrNHUzeGFsaWlHeXNL?=
 =?utf-8?B?WFpJY1JteDBQU2VONTlvYkx6V29nOHB3STAvbHZFZGVaR1ZTNGpLU0h4U1lj?=
 =?utf-8?B?K3NIQ0ZvRTNzNFYzeCtURWwwdEZlbXdPNWRsVWxqTU1ZK1JURWNDajUrWEhG?=
 =?utf-8?B?cURjRjlSeTZsVXE4Y3RMT1JTYXcrUGQvbklBeHF4eG8yUmhlN2tjN3kxU0w2?=
 =?utf-8?Q?t6YlrtDuxP2xm3yD4IJrkgVzW10F+8i4P1?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 424b8f77-c506-4dd6-1c99-08d894399ef1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2020 07:37:27.8020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0RmPoXSH0S1nEqFtdnHRwB6oY3/JozUR7oGj9vkj1L2ogBexRC8+PLoua2qRNum5MUgCbTk20IKmAH0fShKWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4626
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/20 12:20 PM, Randy Dunlap wrote:
> 
> Question: is net/tipc/discover.c, in tipc_disc_delete() kernel-doc,
> what is the word "duest"?  Should it be changed?

The "duest" is a typo, and it should be "dest" defined as below:
struct tipc_discoverer {
        u32 bearer_id;
        struct tipc_media_addr dest; ===> "dest"
        struct net *net;
        u32 domain;
        int num_nodes;
        spinlock_t lock;
        struct sk_buff *skb;
        struct timer_list timer;
        unsigned long timer_intv;
};
