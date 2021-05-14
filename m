Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DBD3806F5
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 12:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhENKNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 06:13:34 -0400
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:5698
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231124AbhENKNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 06:13:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P07icZMKzsOv+Ftay2vQ3Xd4Fm93omcb2BC6WFdeLboclTtfVzUlKCzxAfcwbLv6OZCQAXCsyUgC7RnxhUjR3+cGdWTpm9afumRBKs43EEEe/K2oprNyl16AWDUlXdmWeIOjBOBf0SXBXmUoJ/OY2kPtskIiW7z4NN4b5O2WxmDzcon+nbTn/QtRDymjFK3lNIRVEzJjIDXe+WYHxzQA3hIRc/ZTyg4v66KlOmbAPX9ZTLBzzH8itmJK0xb5p3I98TFMYZ7mmOHbNItC7OqeEpUeplWwJE/vz99jqOe8tYtGshlZAEqIOBF1IRIX4fMlI/VPTwVKp46R7HNg4J5WaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=erYHtcNZBE7I1lDDEg5p4qb0b9DVuP6c1KHWYqgua5A=;
 b=Oc9G9FZWoMXzqG7ZjnIproKBFOB0k2jSWao9ZAljdYMgmZ25ROaaRmBHqf2BzZQy9DsmTaWEiu9ZMe7UaYOwerQXCtTq9dhfg1fDCtHH7kgFpAIevkt4ya/143BWzxrytLJtmM6hW1qJLY62uayDi4IgqnefSoggbsGD/YifgRPZZIlU7ngpHLMnagAxt1KXNd0d0Phm2muqSLgAXu1Tf4SLb5uZZVEFPNWVUJxoaL8hGXneJR4SgGhj2LV6zylLHW+lwwcoGkyCCSPJ4eb3Ukik5Jb2l/b9zgfxrX2R4r5p0WCTbewzmBoKgTnpHJ/NfFHGkshfR8tFm4PjKTAvuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=erYHtcNZBE7I1lDDEg5p4qb0b9DVuP6c1KHWYqgua5A=;
 b=ugms00XOFLkMI81IBmIU6v/fgKWiq/7/DjpFFtzP0+dh1BWs0DTy1GcTobItpt1wMLyg+E36aaBnEfHHcIVOaNmWnNfv6f1YOa6pP00ohnlPCa6hVY78KzZXok0TizgzdURwjKaQUGlYM2dfNVRVZjp9H0tABBdSxu0V4vV9wk/QPs8Ge+FanKUSNDRG5pnNHRpDbw4FqHAxOHZu5PscLTT+7PqPsAolbB5QOdCIHCf7Oj7FaAoC7hlMmsZdhrEt12qHy9SP8MsQR0ZVr2mjRlgBgZkPYzXH88r6CQdXKMvtUsETt5G+iFN7gPn1peh6qzU7MIf8E2NZL7vD7rjSYw==
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5293.namprd12.prod.outlook.com (2603:10b6:5:39d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Fri, 14 May
 2021 10:12:20 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 10:12:20 +0000
Subject: Re: [net-next:master 40/65] net/bridge/br_input.c:135:8: error: too
 many arguments to function 'br_multicast_is_router'
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        kernel test robot <lkp@intel.com>
Cc:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        kbuild-all@lists.01.org, Netdev <netdev@vger.kernel.org>,
        linux-mips@vger.kernel.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org
References: <202105140925.xZEBEK7v-lkp@intel.com>
 <CA+G9fYuSVLOOu0aEs1bm5myxDMGe1VK_MVm61BmY3dwDx_yRmA@mail.gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <7dde3521-3df5-8b65-b6a9-c974b84ab0eb@nvidia.com>
Date:   Fri, 14 May 2021 13:12:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <CA+G9fYuSVLOOu0aEs1bm5myxDMGe1VK_MVm61BmY3dwDx_yRmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0096.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::11) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0096.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Fri, 14 May 2021 10:12:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db55e55c-bff0-46bf-820f-08d916c0c230
X-MS-TrafficTypeDiagnostic: DM4PR12MB5293:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB52930B3728446387F4204CBBDF509@DM4PR12MB5293.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Irx+KFlkA1Moza61RAygUyQrByUJ/+iek/bh8FL6QmDM8a93EqJMPA5haI+S29VrweaY6R+GNyvx55gczqp5TjyjACV70aBFm6QrxeImA1tR8Uq0C0MHgrflqHhT8IGIsTiZmGQynfdsrB7GYrEFNGROgQACipu0FPeaBgPxWO2TrVpEkvrHdNyDdj+UKHCDjDTuLzjIZFBpVQw/s3/qysQJv6NVpt+MJJ880Km/B2rG5UAC6OmPRlKM9Qzex4FcvT/EEEHq6i5kLyfu78GHfXcRchRMmo2bUp3ff4DTj0F6+NBGoIl9YrIU5D8/z+mjEUTkUTPrKe5eocpFR5BtUikxdtkC6VpqBvioOWW9pZfAgQtTH6HXZ996qbJSmjhvBMJ0fusXJgDaT8FQR4gqsywHLo5n/5csl4OtNnu5FdSmuHgXgHgsAF8StXbCybl6ck0m1Tg5VtW8/CNfuGJv/QaYjHXe/dRVeDPHqb8TLH8P3d/TTP4YmgN0tYbLou8yhHQ4G2G3GRtEk1s6rh8xphGWH4YHqhX+SaCUNWjTHHq1/qCp+jagCx9t2wTmI2T2rTVwZmf/HXwS5AtqwqvJs5tW9ZCAzUYG2jln0c8a2hqM+lrohi+xQ7tUJHHLwOZKD8buIp3zIvIec4se+QlQp39gmRbY63PIA1LeTjVOvrEfqV8NXGoldVdmZRzfr+niZu6DRGK2mdnoayIzgdz5EKXpZUHawBu+xeAiCUEx9kB9KjhQ/LDUdFdVTuN/wVHClY25avkLEvXrllTssTmcvR6wpSt1i8Vdb4CuNLu98W0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(956004)(66574015)(83380400001)(966005)(110136005)(66556008)(7416002)(6666004)(2616005)(66946007)(31696002)(31686004)(26005)(8936002)(478600001)(38100700002)(316002)(54906003)(36756003)(16526019)(2906002)(5660300002)(186003)(6486002)(53546011)(66476007)(8676002)(86362001)(16576012)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WEZkTGFjdGI1czkxZGVHQk1oYWVxN3lac0RJL3h0dEJoQXdZWGZkTDRvNUsy?=
 =?utf-8?B?K0htdWg4VzhJeUV3U2dRbUR2VE9OK1NNUXU5TzVuS1ZPRVEzTEplUnZjTThQ?=
 =?utf-8?B?OFpCNkY0T2NQbEQ3N0MrVlBXS01SRE83RkpPTTBHaHZjT0toVmF2OVd1cGkr?=
 =?utf-8?B?ZDJqbG1rRmI1bXd5VDRNZTRBT2pHR2EyNnNsUWhiOXpPNnFpQ000ZDJuWkNM?=
 =?utf-8?B?K0tnWkc4Rzl5NjZielZVU0VuYUR0Z0MwYmZXUWlWMXBIczhWeS9helVmTENx?=
 =?utf-8?B?bk4rc1hvWStSUG0yd05iUlduOVlONDRHNHIwakw5WGdmL3pPUGVBbEF0YUlJ?=
 =?utf-8?B?ODZxelEwOXZVaFdFWXpUU0FyT3FkaGZWM3lRVnBrNDlTMTRURWpYdFBualo2?=
 =?utf-8?B?OHpOL0IvN2dlYnR4ZmpnUnFJeHcwb0luUG1CZnYrUjNxWWhtZGtRWW1JSXFF?=
 =?utf-8?B?N2ZwZjlrYmNhRWYyYVc2YTdTZis0WGxaVTNrQXJGcXVta09JNFAvQXV4VnpO?=
 =?utf-8?B?V0RIcVZGZ1lvWUtxUWZmTDNYVGVQMDFXb0o0dDRKUC9ZSGlWVytMMWovVHFn?=
 =?utf-8?B?K01RWTRtU3VJYjR2WVh3aGpma1RuWjlxamdBcmpyNEpLSGZmWnlaY2FWU2h3?=
 =?utf-8?B?Zjg1cjlyTUhVSCtZaHJiUVhqSUVBaTk5RlczTUd2bzR4SndUWityNDJzMTVT?=
 =?utf-8?B?UWFMNjJESHN1cVFtZ2IyU2NaZlU1VFFzc00xUDE2VllFUkE2VFZIZ1FTR2F5?=
 =?utf-8?B?dVZ4YnhUdjZLS3hETmRjMjlWOXV6amRtS3RzUlZyMVRkZkl3anhYMGVZZzll?=
 =?utf-8?B?NlFFRXBnZlcwSDhsTW5mcm15WTJPL2U0VGNNeWV3L0VQV2V3WTBDcGJzV3pS?=
 =?utf-8?B?OTFKK3pVU1NreHRITFkvVXJVakxGSDB1aEFXaTlDOWRHVUdzNDlYbzE5NHBn?=
 =?utf-8?B?NXRSWFl6b0dUTWJhQTdPa2E5c3hjYUh0SW8xeEoxUG9wVmxzWCtkdUU1MTFY?=
 =?utf-8?B?Wk9GS2Q2MEprVGxDS3ZtcG00NEZ3SFEvVUltTkUvVkh0NzlXSW5TUG1TREZJ?=
 =?utf-8?B?bVEyeHpLNlBDN1M2dmx3SFZyWkdVY1U5S1pxYmtTUTM3ZVlHZk9Cci9icVVN?=
 =?utf-8?B?cUM2bkdLNE94cG93V0JHanY4T0NHZTdDdjVNZUxCdjhma0VFcWNGOVlXS2pa?=
 =?utf-8?B?eC9QbGJ2WTJhbXA3QlZLSHNweUlJd2p0MWpBYjduZ1RGYTRxcEZkSHpGQlBP?=
 =?utf-8?B?cFlMaXFySkxjMXhUdmcxeGNCbzB1RVoxSGtucjJDUGlrTDlKSTEzcnZUNEpB?=
 =?utf-8?B?L1B3ODlnczhsYXQ2R2NUVHN1dDlWTjVNOUljaFplcDhCeEFkOThKRzhjSEM4?=
 =?utf-8?B?MmJNR0t0STU1ZUZMSi9JZ09WOXJWV2FTMWxsTDJFMldaL2p4TjZ3K204bG1C?=
 =?utf-8?B?bVN6c1BFTmZwb20xY2ZKRCtoUlZlZ1BhYUgrK0t1U1d3SENYUmhSS3FWVzRp?=
 =?utf-8?B?ckJYSTdnQjhnZWFLa09NZ3luQythQWVuMXYwQnZQRDZVem9mYWgxb2xPV25V?=
 =?utf-8?B?MFplaVFkNjNmblEyOVk1cC9yb1hXU0JqSnlBNVRtMHcyckpBZ2plZDlFWTdK?=
 =?utf-8?B?djF4aVpOVng3T1N6VW95UWxFSiticUxGWXB0MjFMYTlhTTV5aDRmTWV5eXlE?=
 =?utf-8?B?SnVIMEVDcm80bkpvMHk0WHY4dFhwNDNXZGdSUWJyWDlQZU1LUUc2clJMaDRr?=
 =?utf-8?Q?7ZOgkvc7GBr3k73xuU7T97GhKeKnGAEM4OGScZO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db55e55c-bff0-46bf-820f-08d916c0c230
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 10:12:19.8829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W5SsryIVqrRn2+OnceLe4OjOrNk1CSpBm7PynVLP8NTZ/KWOCMe001XZ44kAXv6ZyZ4ofp0Of735hpOf8wSijw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/05/2021 13:06, Naresh Kamboju wrote:
> [Please ignore this email if you already know these build failures]
> 
> + Adding maintainers
> 
> On Fri, 14 May 2021 at 06:35, kernel test robot <lkp@intel.com> wrote:
>>
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
>> head:   ea89c862f01e02ec459932c7c3113fa37aedd09a
>> commit: 1a3065a26807b4cdd65d3b696ddb18385610f7da [40/65] net: bridge: mcast: prepare is-router function for mcast router split
>> config: um-randconfig-s032-20210514 (attached as .config)
>> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
>> reproduce:
>>         # apt-get install sparse
>>         # sparse version: v0.6.3-341-g8af24329-dirty
>>         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=1a3065a26807b4cdd65d3b696ddb18385610f7da
>>         git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>>         git fetch --no-tags net-next master
>>         git checkout 1a3065a26807b4cdd65d3b696ddb18385610f7da
>>         # save the attached .config to linux build tree
>>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' W=1 ARCH=um
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>    net/bridge/br_input.c: In function 'br_handle_frame_finish':
>>>> net/bridge/br_input.c:135:8: error: too many arguments to function 'br_multicast_is_router'
>>      135 |        br_multicast_is_router(br, skb)) {
>>          |        ^~~~~~~~~~~~~~~~~~~~~~
>>    In file included from net/bridge/br_input.c:23:
>>    net/bridge/br_private.h:1059:20: note: declared here
>>     1059 | static inline bool br_multicast_is_router(struct net_bridge *br)
>>          |                    ^~~~~~~~~~~~~~~~~~~~~~
>>

I have already sent a patch for this one:
https://patchwork.kernel.org/project/netdevbpf/patch/20210514073233.2564187-1-razor@blackwall.org/


