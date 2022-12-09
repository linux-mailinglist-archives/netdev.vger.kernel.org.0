Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860F1648800
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiLIRyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiLIRx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:53:56 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC00215731
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670608434; x=1702144434;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vijq+ECMCHsW2Cz+s2keyD+K0ZYYCK6ZgoJWnroX1HY=;
  b=j0PEnhjibC/2Nw2nGJ/dayH9pEZlY3KoovtlGT05UIojyJcJd2QFkKjU
   4zJDtkpYE3jL7MooMUyANBSvUqDCHqJJ/c2MsM2o+Ghx/qsAA7ZTCg7r2
   43q4yQOjp0i2QJLOB0TXAK0Xfy8l1RTjL1ULiO1hBYB9zVpqqfjz3LsDJ
   RiFOTH/DuBvL82jznb9G36eSw7Tz6ByTNctTvk+21Gd3d/xaiOk25SD2+
   rdf6x7ekRWZlaXZY1FZpPw8vN1WurK4X6yyyCgqKP1dI39TyGgJHb/JL6
   dI64MCOwGn0jiaYnoxfkNPTX2XeDH1e1+o8PHycz7TM9p1rw/kD+Io/5B
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="297865653"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="297865653"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:53:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="716091702"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="716091702"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 09 Dec 2022 09:53:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 09:53:50 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 9 Dec 2022 09:53:50 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 9 Dec 2022 09:53:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lbb7mAyl8IucD6Ra2AZUwPmqfDYt6bqOVr7WvYVFfN7DEKLxGClGnji8oMJffjQ9drPczURk32A/L67bK7pj+SQfYzvFr6N5eZn99ZhnzMgnMxudWHz2YxMEE7PE5zlSeClyf+MPlspKO05383bFAOkXTuxMH3twIYxYsw8uoX/OkPdI6FpzRLcXv9yj+uEmKc+toUSNxYgzx9Zosi6p/tpFnDIJC4zTmYPKJBJv+bWMt/NMdkGxc7Shpq9FP/9aec62ejKn7pgyvDFgS3PZm0oSk862J5Padrqb5ZF4lKIeZEpi5Wurpe+1APbZKYGK523ym1+iQSYk9URZt6Cpkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NCi9bKDUCQcykllS/RFMBPxqjEx2skDmcQ9oywf1k/o=;
 b=JHHosogWZTVHXzxjNlbanQr+OvuewP4rw1dXMpR85C3sTCEBAOqxarhJZ4KRRy7uJJxhwnHW23O9A1X83wyZ73MN8CS4vVWLKnaA3cN56vOOBcSWloX/3Gp5MGMY4pnxIi//pHzkXGdxhylPFGP/5//l6BlqoOFlfzDqDwtV0z+0YDKvHUIyaU/tj5RPi08aLZnXJXMsyVSTwHdlvSrIa5SyFFUGTqlkbDi4QzGDV6S4w391qpv5YLLS6ccmJHY8h01kBfRXi2XrZtaSgk/ZrFYeAGQEPJLp9bWNDZfzkeBwQhbdVPjEgVxRkHPvNF6IzTojKs0U2lD07bOnKvddkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by BN0PR11MB5695.namprd11.prod.outlook.com (2603:10b6:408:163::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 17:53:47 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%4]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 17:53:47 +0000
Message-ID: <7993b83e-c53f-6b16-3c3a-53601e0ffe14@intel.com>
Date:   Fri, 9 Dec 2022 09:53:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH ethtool v2 09/13] ethtool: merge uapi changes to implement
 BIT and friends
Content-Language: en-US
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-10-jesse.brandeburg@intel.com>
 <20221208064438.e4e65j5ngfdmowoi@lion.mk-sys.cz>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20221208064438.e4e65j5ngfdmowoi@lion.mk-sys.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::27) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|BN0PR11MB5695:EE_
X-MS-Office365-Filtering-Correlation-Id: d547abd2-9dfd-4961-ca58-08dada0e5293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MWnCFd1xDQjoHRnW/UbqkX9NYrpo+qKxVVeWNrOpWkqkwshG3KZlPieJPUG0gy/bz3bG3CjQuIXiujHfZEuVa2uBXHT2YyHjyWeyV/hF3uXa01j9x3odral7G2AxKdmp1gNO1QFIt/qccKR+QwSSQ1/Jke/MZDYnEr6i91HVYe+TYPkkzjR6YbEUws8Tr/e/yHJiR7WyTAPTNroHz5Uqy1bAzk1UEvXj9l0AkRaVgr3shNztdSVbLSqAI/W4UnoBaTwYy8CuLlU56Qax/HLAWYi0NMySV78WaumDX8Bk+XLWYnf0PdyJWgoPiS9c1tIZV/amOgI4JzwOKo9gkSvaQYcIjM3zjjK9AaMBh6IzVmScRJDbH0f8VV18OXvoSFfxel75vuUrxmgZMi8UtoK2E9Z+alUUJ4QVfm0lY74QzC52qsvx95RNzbay2eyFMP2Jo8F29epBahqOQKPIUU5b5nD9cOmy8rlZRUuU4RqDiKWWymy8YeIsPm0UPy20rbs2tZjXNU8Jd3iR6wb1CgHrike324gfENnQXEZbf3q/cUPjT/3p6l63t3v9L86LOmGOevTSJy770iXMZQM0p8rAjTvtDxlhDtG6UKNkY8s1O2ZrI+v9ak0jiCUN09iTHDj+q7lp/fM4J6S/fCz5fT61NV5cPvDwa3Psct1bJWuzI1BKqr8Mu8hseisFtEdIM2Z6kC6Gje5OZOslhhT4B/quS23kKrcj4xmU7JpfDV/nnGqfDb7vug0C3FdeMtsAZYhHVJemL0GeJMFPDLpjROVyjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(396003)(376002)(39860400002)(451199015)(66946007)(66476007)(8676002)(8936002)(66556008)(4326008)(36756003)(41300700001)(2616005)(83380400001)(6512007)(26005)(186003)(478600001)(38100700002)(6486002)(966005)(6506007)(53546011)(82960400001)(86362001)(31696002)(6916009)(316002)(44832011)(31686004)(5660300002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVZadjA0OHFzTDZLOUxFeGdaNTBuVkZlKzBUNmNVZVB3SWFZeXNiU2FNYXM1?=
 =?utf-8?B?UVFaOEh6MjdRUWEvbjQybUJMT1RVMDRLQmpsczBjSGZFZUJidk5QdlFQZTFY?=
 =?utf-8?B?bHdqR25kUzNFVWhwYXJ0c3V2ZnFSYmRnM2dWV0NiOHE3L3NsVlNOODVUWGFk?=
 =?utf-8?B?VG1JRWJobmZyQ1NrTFN0aE5KV0I1NDJlY3lJajlvNCs3YkhaNis1bndHZzRx?=
 =?utf-8?B?MVFRQ09zdUlKWEVNaWcyYjRGK2lrbjRtenc2eU0yeXFkRDZmSVZIcG1rdHRL?=
 =?utf-8?B?RXUrQTlidVJ1aEd5MWVFMzI1bmRwc0ZiZG0wajAzaWJiRGtiYzVBQ21BbE51?=
 =?utf-8?B?ZTVFZ0lQa0FxTTFFNWdtZ2dNSzlXcUloWStEa1JjL2VPRjFTSDhWZTduRURi?=
 =?utf-8?B?bXJCVzNTM0txeUg2NDR3WERlbmszRFRlT3IzZWpxRC9hSTEyZG0zN2pLdUUw?=
 =?utf-8?B?QjNRVlg5UUNXQ3h1ZDFHZ3FsQzl3OUc5RzlHNWZhUVIybWhhVFhwRFZ1UVRx?=
 =?utf-8?B?czJTQzNUVTYzNCtoOUJoT205SWQvcXR4d3pUNU9ZVlV1TzUxYkdjbHVjTmVn?=
 =?utf-8?B?bE55N3Q1eHJ0eTlkN2F1VjVvZDVyaVdxanZpcGJBZk1pa3dsaVYzckQzMmVj?=
 =?utf-8?B?eGtyV2JYc3M1V2J1Q1p2WU4rWXg0UzFWYjA2a3VXNWZJSmhYUlg3Q3FNYi9M?=
 =?utf-8?B?SmRGSUxFR2QyQ29INksvQTRPYmdiNFlNc1JHYkZmVWFwUFBjMU03MnlRbXJh?=
 =?utf-8?B?WTluL1NTN1FzcmZMY2lHeTNuZW1mSnU0MnNnalkvYlhnY0RGcGYyTW43b0No?=
 =?utf-8?B?TjN4RVUzanhyZnF6d2RLLzZLbGFzaUxWV2J4VXRianNad2FVTm1LUTN0Q2pD?=
 =?utf-8?B?ZFVuUlhnRXRPSXVHRUZkTkVaR2Z4SUV3VW0zOE52TEc1OGs4RHhyNzkwbzk4?=
 =?utf-8?B?RUlVdUdBbHJkUWduRS95dTlwYTJxakpVSVoxZTdiVnpwcGZTUEVYd2I2Z2hx?=
 =?utf-8?B?VFRuSEVxZElHN1FDc2dMbkJZNE9BVGp2dVk0VUFaTTVDQ1FSdmZLMGhUOEZt?=
 =?utf-8?B?TWk2cVZOWWQveTVzU1lRbGlqMlJLNUxGaVltNkxwdXZnVFJ5TVlmVGZwdnoy?=
 =?utf-8?B?amk0MWpRVEpXb3M0bE1xMmtLR1BKYkErUk1hTURBR09HSTk1aHNhVTVJQ2tj?=
 =?utf-8?B?N01ROGlLY3R4ZVRHUW9KRWVxOFpObXJTdmxEMHRUOEdRQ1RiQ0k3VWYwKzZU?=
 =?utf-8?B?SG4wbUNWdUtGTFMrbU50eUtTOTRJbytmNHBzM3Q0Rk1SVTBtbzNEbk9mTDBh?=
 =?utf-8?B?NElaWE5tZGZmRFliZDQ3WUw4OWFTbTdUcDgrM04zZzdYN2IzcGh1cUVUUXdo?=
 =?utf-8?B?QzFURk5MdXFSK0hKTUl3WkllN1kyYTFSd3lWNmEraHVPSGVkVUZ5QkJDZnlh?=
 =?utf-8?B?UkFnc0lJeis1TTVVWHNGaVFMVndyeFpFS21zS3N2TVJLRlJFR0R3Z2hhWWNs?=
 =?utf-8?B?TTJOZWRGcEV1ZmxPV0dRK3VSeVlQSHhKUVhuNXd2S296RnBuMmVHVFFXN3VC?=
 =?utf-8?B?NDdndW9XMVRjdVZmenEzcTJmd0lOaGFFU2h0QTdzQVFNRkc0aGdJb3A2YnZ6?=
 =?utf-8?B?NndVWmIrSzlSVUNySEpSbUgrNUpFYW94UDZtRENsQUg1UVlVdWlUTXZNV25P?=
 =?utf-8?B?SlBHc0ZNcEdlUFJxSlhwcGJqM3drRUJLbDZXY0Fodk50WjFRZE1rRld0Mzl4?=
 =?utf-8?B?M0hReHJvRG0yOHVFaFBUK25PUEp2ZTI1U2IxRk5VeUV5eWp5WGJSMExDbTUr?=
 =?utf-8?B?YkpsSkZZZldzQ0hnVzd2YVdCV3poQUlHTTgwbEhNTk10VFNkWDk1MGFmMzA5?=
 =?utf-8?B?SDg3eHYyd2pBZzdYRWxIN2t6MWo2aHgyZFhHcE9DL2VPL3d1YzRDd2tiQ1dN?=
 =?utf-8?B?dmlHS2w0ZnNLa3ozTC9YUVBvbjE3YXVQN1Y0WHd4SFhjQVJGMDczWEhCZERk?=
 =?utf-8?B?RG5Kckxqck1rTGhmbXlYUVhkdTlhMzBBeVUxbko4Rkd3NnU0WDVYc3V0TGZa?=
 =?utf-8?B?UGtBMStHUEp6SlNDak0rWkNXMnVzY28xRlJqQ1p0VDJmYml3UG1SMGR3L1h1?=
 =?utf-8?B?Sll3VnB3dUxZTFBNSUJKQWFGYnJTTWMzdDJwa0JweXhuTTZWdXRVUmozWVFB?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d547abd2-9dfd-4961-ca58-08dada0e5293
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:53:47.7567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJLbxqB68E9P8RhFSsac2Vs8a+gzopW46I6MmgdMF+tyOzfiPIKbgroUAR8o2TOX7eJCRgY+CWYc/KqRzxVqKFjEplac20gSaMVMlD07DvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5695
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/2022 10:44 PM, Michal Kubecek wrote:
> On Wed, Dec 07, 2022 at 05:11:18PM -0800, Jesse Brandeburg wrote:
>> I was looking into some errors reported by the runtime sanitizers and
>> found a couple of places where (1 << 31) was being used. This is a shift
>> of a bit into the sign-bit of an integer. This is undefined behavior for
>> the C-specification, and can be easily fixed with using (1UL << 31)
>> instead. A better way to do this is to use the BIT() macro, which
>> already has the 1UL in it (see future patch in series).
>>
>> Convert and sync with the same changes made upstream to the uapi file,
>> to implement ethtool use BIT() and friends.
> 
> Please follow the guidelines on updating UAPI header copies in
> "Submitting patches" section of
> 
>    https://www.kernel.org/pub/software/network/ethtool/devel.html
> 
> Fixing fsl_enetc.c within the UAPI update is OK (and definitely better
> than trying to avoid it) but please update all UAPI header copies to the
> state of the same kernel tree commit which will be indicated in the
> commit message.

I'll respin the uapi changes in the kernel to use uapi/linux/const.h and 
wait to see how that series goes then.




