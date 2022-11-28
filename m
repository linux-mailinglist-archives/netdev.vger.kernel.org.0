Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A145263B5F7
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbiK1Xes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbiK1Xeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:34:46 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FA511A18
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669678485; x=1701214485;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+okccmB1hpcUBuJTyDPYy8qtD0/aCRsL1Ph5mQcoCoQ=;
  b=RqSjFXKIkiEN/bp4uFJ5vyWfoSnu5C8w/coLV2vs03PwNlR8RWOzynTm
   yMDQ8k5UAXChjIcPqlAIJ3xBNvyal1O0vFgHEAuJZts7areVuhdtud1Xp
   7LJxKx0dU/gu3k7iVXR9xHOqJoYJ9ru+t714Bm7xjZhN5jARnpDqoO0xY
   uDmLvZJ5GIAc1WwJNnB6oQkz0tublA9EkhdONQyvMK+h7xieG+KuT0pft
   XSGVPZYsWYWVN0vMyrdzJdkHaXjivnC4IsWugh+94SI3r0GLA+IP47ae8
   3tmQU9rbsfespCsOYhZSvIy4uZ/3lhhIZLqbvyq5RSwoRh7xiHJizo/VX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="298323691"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="298323691"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:34:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="594052625"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="594052625"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 28 Nov 2022 15:34:44 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:34:44 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:34:44 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:34:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A69Za6iMU/fLba87MKC+jEOgE7E4jDgtmGK+WXcNBBw/xMagPnpSKLWElx8uCXShjNRy0M1MlqniToN9wKp39UiLL6cM4D+0L5p/qkMrihd8/bmxa9Xt3aM3QxV72oH3lWrvN2BClVldjWZ7OJ/IotdkHCkiTwXm6Dx1tXf0edVYYiltrzs7eDNS8i0s6ByLCKwe9tTSyb/XIX9SNJMiseDwze1b3Zttl/8j64DfJ7V2h5SLxxc7RN7qXMl4dkhXutGoTTolnMC9KefFaYJoHBOJT5E117fEvh8qiYAZntPkBks7GR9PoYV9ixlVVr+jaldmR0phe4zmCOy5ptwwPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+okccmB1hpcUBuJTyDPYy8qtD0/aCRsL1Ph5mQcoCoQ=;
 b=Nmggf71dZAfKpOQEMQlPeB69fyH8knZRyVpxchBe59dgbpG58npTMy9TuSnowAwlQhzUbPwNWYxQL4P8hI1S9Qx64f8zXcE5n+vduKvnr0B/QPVirTAdP/zOOgJH05F9b0cFAkMM/Sflv6ZczFsu2srGfq5HY4C1jwMaPv+EvrflKQMkF+/IhiR3uo+dzrcqyWUNqmNyGik8t6YhEC+KY66c/R2vTfZV5AC+0QIyzPEsFnI06mDTdGMkFBoM3To0wx8OGPEKSPtBrDlMI87cQpI7aNJ4mGKRft0YeYjeuxShytA8e0H/O14SHukvTIO0v/yLz/iVI5ZPGHGaFMX5Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB5166.namprd11.prod.outlook.com (2603:10b6:a03:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 23:34:41 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:34:41 +0000
Message-ID: <d27701ea-f538-eb62-513d-9d90c5834b29@intel.com>
Date:   Mon, 28 Nov 2022 15:34:39 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net 07/15] net/mlx5e: Use kvfree() in
 mlx5e_accel_fs_tcp_create()
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        YueHaibing <yuehaibing@huawei.com>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-8-saeed@kernel.org>
 <822ae1fd-c059-d834-60a0-af0dc944ff9f@gmail.com> <Y4USTZyzqENumz9J@fedora>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y4USTZyzqENumz9J@fedora>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0155.namprd05.prod.outlook.com
 (2603:10b6:a03:339::10) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ0PR11MB5166:EE_
X-MS-Office365-Filtering-Correlation-Id: 83afaec2-431c-46c8-faff-08dad1991f94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p6VcDSdwijj2G+/7opAa/HeauWySztYyDhGnXDMFae1Ra1xVaranvCa46XvXw/oTBM2+AqngYtIMwMhKOEZ3N4ZeU9CqWN3rsbcc2LUkD3mEX0gWEiM9KhGDoa3fCxyFCqUdaEMcC4FIXs4fig91wR/c8LHjSnuWzMPlo75btbb/hQUmf7fPAdj8R735L7ME7i4bahFgnk05vuej6o9PDT7OveVSyJuUbNE7TsW4pjvZTBqxwjWoPiILjqmAHsVtJx2KbxyvW0ln+6gXUgstki0FaijhHXHb319teO9wuHLIzE8EqsWz+rkJIhtYGcwmPDdMua/QdEuaDW9sevaSk4KPn2BltqQ/vi+Op7tC7tEKpSXPGsplRJPth0SEqUjuXVzmnpL4bUeMfFRCvkddyQELAYiIKtUWM3eaIIyARceBGU3MVvL89FuNB9Nca4Rk8plhDeF+SgET7cLA3QKwBtejYhyEEEcsFUtm50TfVJBmXyUCYrHntausZhxn6bUkx7k5NWSdx1H+3HWsEsJ2KJ31MQrDf7jp3e7Xks/niXJhA6rrhvuyU+5EokRvMj+0KUDdmCibBZgwhHJoFqBrlAVkKL9az0EO6WN01gZ8F48uiYnTFYhRlfumxr3HcqLIwnYJtzMNV20/MSY4gbMVUlrSBqV8q+HiPzMIOpeoS/y5zHfqnIoVZh2PvGSlvNEAoIrFGN6VyWHnXYWx1JTZhZwJC2OdtjigGgqU7LnHD04=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199015)(31686004)(2906002)(478600001)(5660300002)(7416002)(6486002)(8936002)(4744005)(186003)(31696002)(2616005)(86362001)(41300700001)(53546011)(66556008)(66476007)(66946007)(36756003)(6506007)(82960400001)(6512007)(316002)(54906003)(38100700002)(26005)(110136005)(4326008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yzk4U2ZFbWo4d1VjdjdoenZZcG1uZ012c3gwNGdaZnBuVkRpTi8zZDZzUUlY?=
 =?utf-8?B?dytXWjdYMEpENlZkSTh2Yis3UGtnaUhNc2FpL0ZNZmlyV1d2YW1BYjk1cm1y?=
 =?utf-8?B?UDY1ejRHL0E5Z042VDZhZXJDMmVVMFJSYXROQ203ZkFNbTVHTWVJa21vL2hZ?=
 =?utf-8?B?TDZWZkZMRFVKL2pEMjZobXhoWVB5Wlp5K3JkdWZHM0NNcEk1RVJMTUgvcS8y?=
 =?utf-8?B?Wmpla01HVkpwQzllWWhlNjgyZ3NxKzlhSE11dENtZlNxRUtOTk04V2NUdHNw?=
 =?utf-8?B?QTdEM1JKK1VCZmdpRXpKY2hPTUtrRGtub0FsWkNjc3o1b0dGREtqNmhJMVZt?=
 =?utf-8?B?SEJnaHV5WGFrZElISVBMR2FNZk0xZzFlZ3NHalJuUlZpVjh2VzRwWDgyU3Vi?=
 =?utf-8?B?NlZtUUpUeUpIUzJoMXV4UXJGRm5VZGkxVk9paTdIMitnNWMwODV5Ulh6ajZY?=
 =?utf-8?B?Q0J2OUw4ckFIZGxlcDE2SENuV2JObG9qRVFva3dIN1ZNUWp4OFlOcHdnaHEv?=
 =?utf-8?B?dlVBYTllR25SOHJnd2N5UzF1c2t6SzNta3N0ZEpETzFTWEdvdGJzQUp3dVlX?=
 =?utf-8?B?OEFjQ2pjdzFMcGRsVzA1UkRTSXF6WUxzODNmcmEzRDJEUmtOTldhZnNqb3JB?=
 =?utf-8?B?QjRrbjNlK2N2Zy8xUzlReHFES05ocWpuSzNmak8xLzczOC9lbGhCd0xwYjNH?=
 =?utf-8?B?M3h1d1hYdFlyaVBtOTFUSWt0QS9hWWJRQzgxeWFuc2diSjVOZUM5VzU1STJG?=
 =?utf-8?B?S09UUTNBaXRjSEQwQUJUaGxXMnV2SmVMSndkRW5EbFlzL2FzcHpQTTFjb2xC?=
 =?utf-8?B?dUlYZ2REc0tTY3B0NTdwanBobDdScFF5ZUZuU3NrN09oRXNWdkoyK1lKaWVj?=
 =?utf-8?B?RkJObmFIaFRzazRLSmZWaGYySUlWT3V5SXpOb25XSGtLR2RneHdyd1U5bmU2?=
 =?utf-8?B?eGZBYmNrSGUyZHFJN0xndVRhai9HRXFjb2RWVHo1eThVWEo3Vml3VFdLV2Ev?=
 =?utf-8?B?SHVlaFlFYUJiMHdxV2RMYU9STmJsSnRhajJtZk11V0JVZi9tdUt1VzhUVVZG?=
 =?utf-8?B?Rno1S2txbUpCeFcwN2RYZGhoUjlGS2ZodXpyTXUxanBuNzVXZDJ3d1JjZ0Fh?=
 =?utf-8?B?RWs1QWVFTWloTHUvVGhwbkwzYVhGNk0zcXBQU2hhM2JtOENKT0h1UVZoRDNS?=
 =?utf-8?B?cktna2pXUStZY1I4a1FZUWNmVFJ1SEJOZkxrajJ2SUVoV1MwWlJ1ckh6RlhJ?=
 =?utf-8?B?ZlhKbVdWNTdGbTVWZjJlbGxSa0k1N3JTU3lzNnN4TjFjL0tUcEZ4K3lKZ3lh?=
 =?utf-8?B?NDRHNXBMWFh5UHVOY09XSEhqaXhBUUIydGlSTTRWT092YU84UnJoSWpKNDlv?=
 =?utf-8?B?djdHTlFvVHhmc3pidEJZa0FnRGpPbnBXNVpiektxNGRaVUxPcEVOZUNCVVJs?=
 =?utf-8?B?MmFhLzNySVExeldja2NlY05YblJENmNlc21wbkpLd1NBVDVKSmEvZlQ4TkQv?=
 =?utf-8?B?RzVWblhRTkI3TmZVRmhFaXZkTHJvOG1aMWE1OWFmV0U5SStOSml2OVNyb3VC?=
 =?utf-8?B?d1hvNWNCa1YwUytoaG9UbUp4R3JtZCtTSncxNGVFdXpNRDJuTG1rQXNlU2E5?=
 =?utf-8?B?cnZ5QVJJTTFiK0FBZzZPTUlveFd5eHc0QjlTc1hmOXBsdU1ORU4rVndFaWZa?=
 =?utf-8?B?V2VTVHNBQUNtQXlzckl1VTdJY0RiS0RLVGdzM05Ia1ZmSHNPRU05V0F6Zlph?=
 =?utf-8?B?NFI4OCs4aHNvOC9BanNZbDVaNkMvbFFwWkJUQTZNTGdYTUE1VEk4akUyQUd3?=
 =?utf-8?B?SmNTdVNhaHNLZTZ2ck40c3dhb1Zsd2ZFVUEyOGVHMVdoOEwzZWozem43OGlN?=
 =?utf-8?B?OGVQT0RrTUlON3l3UkJCRk1YWldPZkVqeUgrU3oyNGQvczNGOVhSUkhpOGRo?=
 =?utf-8?B?WUcxWlp0bk1UQzE4TzNsR0FBbWIzelVSc2xOS1Q2NXFSb2JpWTRBZ3FkQXdI?=
 =?utf-8?B?aDVDcGRYWUlMMmt0bmxoRURyZEh1akNqOVhHZWorV3hrSTNZdEVLblNBNzVM?=
 =?utf-8?B?cXdVVHk0SmltTjJqaTQyWWxRTXZTSGxicmcyd1V6UDJ4aVlKNzk0dWY1OFlD?=
 =?utf-8?B?Mk8xTGV2UzY1M0N0STd2OFJoYm9wdXJ3aSsrZnNwWFNLYWF5THRPdnNoQUdp?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83afaec2-431c-46c8-faff-08dad1991f94
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:34:41.7655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DrN7PNsjAzI2jhueMH3GcjyslmnAik1p4DzqiYlwcCCuJ8RlpxJnVsgdjGzdZYMsXKZjExmmoyXw2o/9/Up+dD+IKLZnpgM4DBrCC2NQl+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5166
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/28/2022 11:55 AM, Saeed Mahameed wrote:
> On 24 Nov 10:32, Tariq Toukan wrote:
>>
>>
>> On 11/24/2022 10:10 AM, Saeed Mahameed wrote:
>>> From: YueHaibing <yuehaibing@huawei.com>
>>>
>>> 'accel_tcp' is allocated by kvzalloc(), which should freed by kvfree().
>>>
>>> Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>>> ---
>>
>> Hi Saeed,
>> There was a v3 of this, that changes the alloc side instead.
>>
> Thanks Tariq, that patch was Marked for -next for some reason,
> and it's in my net-next queue, i think it's ok if this went to net and the
> other to net-next.

That route would make sense to me.

Thanks,
Jake
