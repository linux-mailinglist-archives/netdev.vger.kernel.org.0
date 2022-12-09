Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D9C648AB1
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiLIWTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLIWTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:19:09 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1560B9766F
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 14:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670624349; x=1702160349;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ElA0LwROfhgaEgkaHokeuZVFhesOrbrWDkn/du+G75s=;
  b=O3LDLma/2o9MuEaGazXtVo/tbw5BXomMq2Y1q955KqbCHauC0M8crfFK
   iU6H4Sci7YtP0Tzy1ToguN1XxXlxlw0Iax7sGODH/34ew7pmT46HoIvcL
   TBcaEPvwX0OyTXX35arvTmOkq3kURYqr8XmfIzVM55yru/h9z+8OvNgCe
   faonpcc7IclgMQCvMRVfWFpaUf3tXs3+RASEZr5slV0SaIE/v1qmpGd6g
   rUYKrMS8ilD7Q1SFt5uhic7YJ8reTB+jB5vd1kMzZSxommNzxP3A0az95
   Mq/9ZIy6o+IiyCSS6uT/UMo2Se4x5pX//NzzWhp2dORTS2CTWKFJQ0I5l
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="300980368"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="300980368"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 14:19:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="680063570"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="680063570"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 09 Dec 2022 14:19:08 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 14:19:08 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 9 Dec 2022 14:19:08 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 9 Dec 2022 14:19:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDlb0gFnNIojObf70UIa8jVJwhWhZUVqxoba3YN0lFPXNIf+3oZsEe/eDFKXiDa/c1p1f3EBhmfgQKvkTgU9nMMJHsbCj8CQbwKHKBzaJ8ASmSkpvKBb1cLiRUvlHWNJF6OaUzWQD1+1/ZG1mrdhc1hFxLlB2NkktD9OY9Ah8RPcJ+VqpV2pHookSBVNs94InjRbo5iKFYqDliO7q3QilXNhti2y3gVJVr3UuDAa8RSPHJw/cefxNNjl/lCXQML0Wf357k7LqpLNo2xdlhqKzfiavJAQAp/dWX+zWrIn6dSsdNOAJkI03Q7yrAnPfKT6GVpb0ltq3/L5pQTqsCY97w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HF5raszIrQSdOYkhl7B2NAc4MhNqB1z+hmy+0sp2q/0=;
 b=DFmT5+tskWpCgB6vCXn0tTLrISPpNBOh233Li+tQlYHMVhtpI+ht4jPtR86McR+ZVmF4GsoOE7mbeACxeqW6JaxlA+fVQKjQijY/q3BTGX08Bo9p0yYQoB8zXtrzjOAEux7dKxGXcSt8ZsT9s6kwDem8Xb0DpsC1/ldpSuaxYHfVinHzIwKGCrCLoVf60uJwMDM0/PxafZ1J/i7XvzOrgWJKEM+xEZX/5iFlJ18UZoqhQPxrucA5LdO7tB6SXrllhKUCBER+H0VcItuobwJXeZX1gzH9tqoaSrdR6QRKFk/N2rhzE8cMjLUR0P754tFhLFgKI77ZQkfX4iunqjvxOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CY5PR11MB6461.namprd11.prod.outlook.com (2603:10b6:930:33::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 22:19:01 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%4]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 22:19:01 +0000
Message-ID: <b0fb2e75-9832-7c95-4b49-d26e5aeec973@intel.com>
Date:   Fri, 9 Dec 2022 14:18:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next v1 0/2] ethtool: use bits.h defines
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <mkubecek@suse.cz>
References: <20221207231728.2331166-1-jesse.brandeburg@intel.com>
 <20221207184029.3996bc5f@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20221207184029.3996bc5f@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::11) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|CY5PR11MB6461:EE_
X-MS-Office365-Filtering-Correlation-Id: b555ba1f-0818-498b-c168-08dada336000
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nXP9/vOAtlTN9DIPAKFobBsZuvqTBlwA2Ne3DhgfCtUj6SBwQlm0e5zTmNo0lEJZlfEiAKuR+jAAIGAkIH9fCjvZvI5jbcaGRwMf6WtZtIxGe3H8AGEVrnfZ/8Y5uMsuYJEyPWhPfhfdHrSm3u62jNA3X6ZCwOGa4+0PwEKQNU8VTIqkTr74ha4QcUyYK44brB+OGLm0eTinOkvUBubciZr2BapeSTDOOZP764xoJXx5RUTK4a1UkdGJHvrU/wFuqOAz29n+pDsjonaEUTn1EXix4wt9sv0lBqngMKkQqmAvgKYUb3fdCX2OjFzfM12ZAa+tX4Uz9kGxX7favTEdKo6c5dw6iGHePs16YedThLOXlQjgeGNg28KL9kR3MxT04XIVuTKnF0S+AFsfB0H83Y3R0RXFaaC38bZbSGe8pTvUL3QTvXhJUdqLv0ekSBTOhyWNNtK8RkPsmFp9QlDRwAgDsTPjd8p9i1P4ISUlWHupZo0FNmTEz31pxw3NwfJVuuHuPROp6iY3/uvFpAqxC3Ms4QuIXNIORnewgJ/WV5cmtG+dUn/hP2QnTHjCSUVIxJSNJ4LPfcJGeLccQF7F4yPud1RWr1c35Oc8Cs+0V3hxhe5fIxSOXgLX4Fc/Ea6pr+5XhLZdba5gobKz7goLUyZa/HJlwvYSV6e75UG10XiyLzzFkeMUJLplh9/s7sIdFp7vzuZty+RKsuYDH2AsG4KNaAsL+70nUo9QSnMFjyM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(396003)(366004)(346002)(451199015)(66946007)(66556008)(38100700002)(478600001)(8676002)(53546011)(6506007)(82960400001)(4326008)(66476007)(2906002)(31686004)(36756003)(6916009)(6486002)(86362001)(316002)(31696002)(44832011)(4744005)(2616005)(8936002)(5660300002)(186003)(6512007)(41300700001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHV0aXdRTWFveiswVnB4Z3NBSE9zemU5K3NyWElYazY2bGZzMFViYVIyTDZP?=
 =?utf-8?B?SE4wOWlXMWowZlBiL2dwOHBoSC80eFpsQmI3WlFyTW9mdmlYeTdKV2pSNTlZ?=
 =?utf-8?B?SEoxK1pLQzdLM1JkTlVITEd5cXlvSHF3QysrQWlrbENjM1lXdkZLV3dWOGpp?=
 =?utf-8?B?ZnlrZGhucjFCZHA4cGJja2dUWXhQTzZzTHFxM0VyRUR3SmZzUHRxZjNtWDlk?=
 =?utf-8?B?OFZpTmw3UXJINFRTMEwyL2xUM1V2U1NoVGJ6cnJmb3djcEVHM2VUVDdpQ2ZK?=
 =?utf-8?B?S2EzUDBjL21HYXpENmtHZUJQbjFWWTQwWno0ZjNpbXVyODVUVkhTOUJhdjE2?=
 =?utf-8?B?cjU1SkVXak1xek1XNjdLYXpCT0JtVHAxR1IyRDh4a1g1UHNrcGZCdHdDVDNo?=
 =?utf-8?B?WnJyTWdnbmFYSi9sVkFCeVZsSjh4NFVleUxXSWFWdDFqUTVVOHIwWWJybjJU?=
 =?utf-8?B?cmlqc2xEUGFNUmYxQTJHREwrZ2QwSGhsZEZPQUhTWTVSM21zTG5jdEhTeGFj?=
 =?utf-8?B?WU1meTE0bWZwOCtQYTZXb2FOdlJwT0ZjdExpYnBpUmx0VnF1QlVWL0o1Wk4v?=
 =?utf-8?B?QW5sbEZPY3dPNElpZXZlMlk5bDdsQnU3NDA4bm11Z2YzeWtya3VRdHRZakwr?=
 =?utf-8?B?RUxieklqY0VaY2k4Ky9odjlxYzl2SGJSQXRpclB0NVhyUWhQVkd6a0xCUCsv?=
 =?utf-8?B?VjN6VzVnNGFQazVFUUEvZ3N0aldmVEhqZEN2YlUvdWVEa1lQVk5VNFB2am02?=
 =?utf-8?B?MSt6VUhpbUFIQU1rSGRIRzdreTlEd1FpbWF0VGpCa1lJdm9xN1VZSVFZY0Qy?=
 =?utf-8?B?c1lxNTNMZjFnS3VmWGRqRDErREhOc0dZYzlnY3hySVZFa2dHcVZ0azh1Nkxs?=
 =?utf-8?B?MGpzSUljREVkcWsyUlQ3U0VmMWhEYkFLdC9zU3JsWW1uVTArOWo3YWZtS1Jt?=
 =?utf-8?B?UkhLQVlIMHNZTXJ4Q1FzU2kwK1EvV0UwRWZHQVlpYWJsQTFJcmcyNXFFSU1G?=
 =?utf-8?B?UXF1bXFKdHNYbno1Tk1ZT1FEWnc0NEpXSWhrNGs4MUlNZWEya2RleE1ZZmsz?=
 =?utf-8?B?T3JRNEo3UjAyb3BhUWpEM29rOWs0NkxPcFJpQUsvck9McG1vRTZuTFRFZzY2?=
 =?utf-8?B?anYwc3pvVnhzekZuVkF0SUZHWlVhQ1NEd1lydVNDR0NOenF0dFdRcVRIUVFm?=
 =?utf-8?B?QmpkT2xsd2oyVm1sVmJwNW9CbGZMRVJySG1yalpsQ1dtQ2NFV004aVJBbnlF?=
 =?utf-8?B?aURnNHJYcWZHb2dvKzJkSW5KSDYwMUxLNFJzQ1I2eklNaG1IRUFEOWVnaU13?=
 =?utf-8?B?cE41eUtHY3NUWm5IQm5Gbk9LVUliU25EQ1NCREZGNkVtc1Z0bGJjeE43UXZx?=
 =?utf-8?B?RTZCbUJodnc4V3MvT3VtT0xmMk4rVDdqSURlSkFCaHplMitlTWtydmJNc0M5?=
 =?utf-8?B?NHIyUkNTSTc2OHRheDdsZmlYc3FKWk9wbjFienhNRVNRSW1keWJ0WFRzUld2?=
 =?utf-8?B?ZHV6enJuVEhSWmx6TEUyUGVkSzlUL2pmVjdaZVVtcG9VMFpualBSbHFBcjM5?=
 =?utf-8?B?Z1ZseFQrMFVFaVRWODNzd3BkV2R3Umh6Z3NIdmtHYWZsSUZPRXE1YkhJVlI5?=
 =?utf-8?B?Q1JMdHQxTm9uT1FmaktBLzlOcERtRXdpVlk5eGgxUUFzeHZNMzEvUlNrU1lH?=
 =?utf-8?B?Rk1raVR3dTV1MHhiN2ZGTXpXcU1KVFRvTlZkbElkczZYU05OZDhTcGtzSk1k?=
 =?utf-8?B?Zy91YzJFTXU5ZDU5aEJaVXFLVGpvWWNCSHdROFZ6M2RpV2hTYzY2d21zVjBq?=
 =?utf-8?B?QnpiT0IyNkszVEdmYnJCSDI2SXdvZXg0SFQrOUVKU2VpbjBFZ2h3dFlMZVdT?=
 =?utf-8?B?SjJuNjBzZ2JQc2UxN3B4Z2s2QnVqaEN0WDFxZnRGUm4rZTMyNzNXbnZPbE5a?=
 =?utf-8?B?M1Z3UUFVRnNDbm5lTlA4bzZpRW4rK2NxS3dwa2RYZVhyWmhtNU8raW81SGNS?=
 =?utf-8?B?SlR0RThoVHc5YnZVd00zdVQyUU5KZW91MDM3UFdDSkRTR0RTUUZRdE5TazV3?=
 =?utf-8?B?M3NFamkzNnEyWEpTQ1BZVkdEZUpyREcySVp4UzBnRWpvRkpLbTV0QzI3Tk5F?=
 =?utf-8?B?SDU1c3pqUXFKNTN6RWdYaGpkSWFXVU5SL0xEelhvRFlGbDJPdkRrS21LSmhx?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b555ba1f-0818-498b-c168-08dada336000
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 22:19:01.6133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XMapGhfJdtVnwpUeX+mou39N9wtDdMX6VdTKmA2eS0lth3DqM9somVqTuLXjS6tjjLdl/IyoR+IL94ojYZUQPk7jUhQEWHIaYjrx6sFHqbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6461
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/2022 6:40 PM, Jakub Kicinski wrote:
> On Wed,  7 Dec 2022 15:17:26 -0800 Jesse Brandeburg wrote:
>> Change the ethtool files in the kernel, including uapi header files, to
>> use the kernel style BIT() and BIT_ULL() functions instead of
>> open-coding bit shift operations.
>>
>> Making this change results in a more consistent presentation of bit-
>> shift operations as well as reduces the further likelihood of mistaken
>> (1 << 31) usage which omits the 1UL that is necessary to get an unsigned
>> result of the shift.
> 
> Let's hear some opinions but the BIT / GENMASK macros are not
> universally loved so conversion == cleanup may not obvious.

Fair enough, I'm open to feedback but haven't seen any so far.

I'm planning to wait past the merge window now and submit the next 
version of this series in a couple of weeks.




