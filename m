Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D16863B62A
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiK1Xwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbiK1Xw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:52:29 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3761E326DF;
        Mon, 28 Nov 2022 15:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669679549; x=1701215549;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o9Ix4C1269flaloTnE9pPyJ+t0NUewTgm6sSWHN9h3Q=;
  b=ax/HeGsTiPEYP9WUXo9TU18zTB7uOW151dtdyglJIBZya2yIuvbbsadn
   o5X7U0OgJZpcfHp2Fw2gjDgUPFFUWDFbVGiHRHPBYFmtSaTdc/LKE3H+I
   GA27bgQZrvcg5iRdhdJvNTMlcOIlF6f7CKzceVvACF4cDS6OT1cM3YOrR
   kuM5D3kcZDZIDZe/bQoHF0XpDTMPISIyw+q41ucb+R6JAh3bwivEVB0DL
   C/7o7NR4UTnvrdwniuZm1WEPEVkFh8X6+uJZFNGKB5T3GjyW+2rnQXXJn
   aqUtPI6C4dvz6/pEhvgUWYI5KEzfjWA7iOIIKfX29Wxa7z48NBYYzx8Wc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="298326918"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="298326918"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="768231814"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="768231814"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 28 Nov 2022 15:52:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:52:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:52:27 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:52:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTmTYj29BCCiKxPmbkC5wrLZLtiQP5EQ3DgbMZPz2ovEf+QxXCS2+bCHXkAK/ZzHigfnxz8EeqDJzNCUUJoojqT19TTt3EkMDtTnjapnuN5qoI+NRryu3v3LSyEx6LpREybofiQ7QH/oTeuVuVVRnu1yZzCGgBVKFp8AjsQgAikBAy9V96hpSiwCHgag04F81Ey+wb95h/3alEebC2OeBlByfFR/LjbGOC596WMcXMu0h3IJj9uuaYrlo/me5oObe4CpbEN8VuArYhpwEkIf23CCK7DFNYbPTs6YKWVKvbO1nWRqrt0s77W0bP6KQp6amjXN5uu1kIZ/Dvfv89gqyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXCRfIDG1yDAPWIVmaz5AxjAgDoBAYGSnJkrDw+7ddI=;
 b=RWhcORJYeuXU0i33JgMHyOWtC6mk+gi4qoAjTU0UgoTMS01xmLyejgdooYM+u+7ouGOJXZphs90R5NSsNRzFNSNVEyQ8xmyg8pFoRTP1cP39wWhGSsB9ktkyIB9cAt9IBDt6/hfUKJWiR022FeRy7REj8fdByQYvJEYELi7pf3zx5NJfAX7oXYpH/sAOOkEkypCaTQ63SbG/fb+AvdJBx3S5MpKECe3ZlkZfOrxJuExs+Rx+yOa2XfvVP1utUI53N7GTPUbRHaV6MEVcl6F2IjhIfEoa0/09YSC9Gshi8Gs3BwQBFI8RBQAxVZ34GxXNeRafccsYTxVps+c7vLFNPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB5014.namprd11.prod.outlook.com (2603:10b6:510:31::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Mon, 28 Nov
 2022 23:52:26 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:52:26 +0000
Message-ID: <67387f4f-5ece-fb9c-ae4a-2589cc7a34a5@intel.com>
Date:   Mon, 28 Nov 2022 15:52:24 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 net 0/2] vmxnet3: couple of fixes
Content-Language: en-US
To:     Ronak Doshi <doshir@vmware.com>, <netdev@vger.kernel.org>
CC:     VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20221128195043.3914-1-doshir@vmware.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221128195043.3914-1-doshir@vmware.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:a03:333::35) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB5014:EE_
X-MS-Office365-Filtering-Correlation-Id: 9564ea3a-7f0a-43ea-6e08-08dad19b99ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0NxfolKIZqeqlvg//gH/y7ZPv+AnI3DBWkqskndPpUjXVdkwbISJUD7Xp9QkL/FUeYZ6MHALfLfBdZCrBGju7gH6VI63X1CJCo7J4kpaNe4k8TUwz6WIeP9PJgULyAZpebVgUUhs3n/0RIl5zn4E7xLlF4qqcat/wItKiNgLPQHtOKm6jqxauH4bLqtXmIbikq5od3aSh5RU/TLrIFelsSCXhENIxAEUxCssGBpUqYTIjUSjnb+9yJFUOdsun+MYhPDbsO7yruFOAtEfWZ9930pkhZi1sVvPqizU+RBtGs0jk8BUAjfbF559XqKmuOHdbkaSnW/0HRf5NViNH98+6+i+46KQiOe7AhmgPRND/3Or8C5QNZhRdPFYhRPCcz/ci5Vm9n+LTCA94ufxjzlsM+DloKpx/VOL2b2bp30m3hIrszpGlu3FSrDdmI7CWaT29BXq3ymcWLe9UMe+I5u2w+kGghb4JwB3DZy6+LHBSXjfeHmoACUrXW+TCt2hZu/N4FepH3SxJNdvyfvmnHrJKahZ06hILcE3eVtTvjJxIgrzSCu1kwAd3NBjVba6Tfs8YgfdehYGqQ89bNKhDj6jgXYygR7QhPPef49H/lURZ9PaILI14v5tH/Qcjx+kM1MkUJZ4fK8UQDRqQwrAsVN+1nUzkHtgvwfYMqP8MTzD8gHdOVPT7mzYeSx0nwb2tqsMzLDflcTSfBHUPf4mccGRqYYA320iZfdlPIbOMgzlpeo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199015)(31686004)(38100700002)(8936002)(41300700001)(82960400001)(4744005)(5660300002)(31696002)(4326008)(66556008)(8676002)(66476007)(53546011)(83380400001)(66946007)(186003)(316002)(2906002)(478600001)(6506007)(86362001)(36756003)(6486002)(6512007)(54906003)(26005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3BEcFAzUTlYWkFhYzBYOVBZRlp3Z0Fhb0dGdjRQTGpiemh0U3hCYWhqQlFQ?=
 =?utf-8?B?aTNEeDVYUE1xM1o5aUdxVnpuUXRjRDlXL0dGSVJVcnNqYUFFRmEzYTgwd1JN?=
 =?utf-8?B?NjZ4SHZobDFlTTlXY1d0MzdiMmxLSytnRC9vWGtqTVlmT3BzYlA2M1NHM2hs?=
 =?utf-8?B?UjM1c0dvMHNpSENIazRYMms4dUk5bWVjbURHV0I4TlMzK1QxcWhuaTc5cE9S?=
 =?utf-8?B?Tkd0OHhkU1JLWTU4VTJZSFJISGVZci9kdy9MOHhXbTdTdmRVN24vTUlCMkpC?=
 =?utf-8?B?YXoxZzVKNkN6MHpSRWFVdjBLTng5d2xoVUpVaFFKeWNWRW9qTXJmKzVSbVNN?=
 =?utf-8?B?WVp2T3VGWDF5OWNOeTlzdUpKd0RPRUlLM2U3QkZZaFNvdjdKa0Jkc05UU280?=
 =?utf-8?B?d3hUZUw1UHFJeG9NNXRjakxYZldrdGdvUGtsZ01NNW9ONjM1cjIyUXlKUUFr?=
 =?utf-8?B?dHJWSE9MRVpYeTJkemdhRHVGckRqa0FjREJER2lkNVNKV2I4akMxaHNKVlc2?=
 =?utf-8?B?QWVrV3NlQlpuUkp5RmRudnV5Y2xMajVUUGlHMm1sQURoSlJQTmEwaFJveHpJ?=
 =?utf-8?B?WW4zUENWdVRnT2ZlTDlvUk5WVUFJcktNUVJhZExOY2twRERkZ0NJMC82a2NH?=
 =?utf-8?B?dDJGV0xRRHd5dmFDR0JBMkI0VVV1Q05YRitTaHhlcmJuRnoyK0hRNDVzOTNj?=
 =?utf-8?B?eUc4aWEvejZ3cG1ocmg3WnlFaSs3dnJIZDUwanMvZnpqZkxSUWJOeFFhTzRZ?=
 =?utf-8?B?dXpyamh3eWdEOHBDSlhkMGcvVld5bVVXbGZwa2pIQU5RNTdNZEVHOUtWWWlB?=
 =?utf-8?B?OHEvU0RKb3hQQ1ZmelBtbTZJbmVBcGMzREtwZmNDTFF0Mm9zV3VuTlRocy93?=
 =?utf-8?B?RjJadi8wdWJuTjZIZFNycG02WW0wLzZFVUJCYkRCRmEzMHpxTkszTWNUS3dC?=
 =?utf-8?B?RlJQV0x2d1dOaE1Ha0Mrb2IwY2M4YTdBdDlnbWlOVDRCNStwMlR2bXhZbEVT?=
 =?utf-8?B?YW4zWFh6M2orS3lkQkpXd0pXOEs2SG9EQTl2ZkNVUC9rWGNIbkE0NkdLenV0?=
 =?utf-8?B?UnpCYUw1N283SGE1MzVSVWNjdktqZlliYW1Id1podi8rNFBoZXhxSzM0NEk5?=
 =?utf-8?B?NFdscE9HdGRMR1NhQmIyNjFuNzd1Q0FkZVFKQWhDc3VEOTNyWExvOGlLL1VQ?=
 =?utf-8?B?QWsyQThXR0NDYlIwTVc4blk2S0VGVzZ0dm5pMFZOQ003U3VjQ0t5UVRyUEJD?=
 =?utf-8?B?MDRGTXJ0OWkvS2phV1JSMnZsYUM0bEF4MFMxWFJldG1Xd2Rla0FHajdydy93?=
 =?utf-8?B?VUZrdEhYVUFIZmUvOERIc2ZsMCtQaG51cjR3bk8rc1ROOGZvWVo2REw2STFN?=
 =?utf-8?B?Um1rS254M1RGd0JNcTJ3eVNVU2xwd3F1bmhrR1IyRjRpNGpkalZsbHR6Vll0?=
 =?utf-8?B?emsrWHQ3dXowVlU3Rm1YOHdSWVVIUzl5SVhQZm9CeU5zYmNObGN0OEo2UUxD?=
 =?utf-8?B?S0RHWnhBckpJMUEzRjJiWE1SNkwwVXc5aWpvT2lOVi9tc2xFMy9paHMxMnpU?=
 =?utf-8?B?Y1doOXExcWlrblNpaTRNVm9rUmNSQzNTdlM5UWFkMEhTQ0ZJL2F0aTB1Q3hz?=
 =?utf-8?B?QmNZbzltVk9DUmZheXF1VmlLWDNCV2hYSXo3WUlsa2EyWm12RVdJQ1lzM0Fw?=
 =?utf-8?B?QzdRVjFvNSttb1QxT0tkWXNFcENwblVOa25zelNDQXFKcDBBdkVlRXR2SEFt?=
 =?utf-8?B?N2I1d3VaV3AyaTJWbGFnS2szQjhldlNucWpONXNDVENMaDdpMXEvVlVEcUZI?=
 =?utf-8?B?SVZwVXJsUWdnelRmOXlablVlRFZBcVo5aU9ySituKzhpRXJPbXZVenJzYURE?=
 =?utf-8?B?YUV0L2lXaituUytLVm1GSS90N2JMSGVmdWRmY2NlNW9ITzI3dnhscTlrWS96?=
 =?utf-8?B?aHlNaGhka0VOeVkvZUgreFJJRm90VHV6NFFLOG13bndJbVUzYVlLZkI1aC9Q?=
 =?utf-8?B?MzRkZVRIa3l4R3RLMDFnbkZDa291eHprZGJtdEFNTithNlRYL3ZKQTJjOVRU?=
 =?utf-8?B?VTZyZ3paRkZFMzhtWlFPQ0tuMzJUdDBVU04xL29IQ29kVVEzMituWlduczdr?=
 =?utf-8?B?Q3ByanJyQ0FEZCtkMjY5VFBiTDRFbmh4MURvb0pKUGJVTTBadklyN0JpZC9O?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9564ea3a-7f0a-43ea-6e08-08dad19b99ff
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:52:26.1686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2m/YQ/tQlT1JryfgUtkoNMfJWmT9/pYyEZdEb6TNahR6GRUwX7Q0UNikom0G4OiJTTyas8+U9wFm1JAkkIlqbZLlaVcyItvuT/9GKtOld40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5014
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/28/2022 11:50 AM, Ronak Doshi wrote:
> This series fixes following issues:
> 
> Patch 1:
>    This patch provides a fix to correctly report encapsulated LRO'ed
>    packet.
> 
> Patch 2:
>    This patch provides a fix to use correct intrConf reference.
> 
> Changes in v1:
> - declare generic descriptor to be used
> 
> Ronak Doshi (2):
>    vmxnet3: correctly report encapsulated LRO packet
>    vmxnet3: use correct intrConf reference when using extended queues
> 
>   drivers/net/vmxnet3/vmxnet3_drv.c | 28 ++++++++++++++++++++++++----
>   1 file changed, 24 insertions(+), 4 deletions(-)
> 

It looks like you sent a bunch of versions rapidly, and you submitted an 
unversioned series followed by one with v1. That can make it difficult 
to track which is the most recent version and which one a reviewer 
should leave feedback on.

Typically it is assumed that the first submission is "v1" even if it 
doesn't include "v1" in its title. Thus your second submission would 
normally be "v2".

Thanks,
Jake
