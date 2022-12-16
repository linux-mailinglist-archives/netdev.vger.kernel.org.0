Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D91864F4FB
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 00:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiLPX0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 18:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiLPX0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 18:26:47 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D3822B1C
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 15:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671233206; x=1702769206;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eSKXZNh6bxvg6eIi0pMriypw/dnNtyWPBQ9QHiwpez0=;
  b=N3cBKxRozPKdtD5pymwHET2kl96c7T1BfuGQCcjj/fLe5iOHqQgJ2RHe
   DrCKNda9fycCd2SjX4mRVzNI8BNnvDaqowtbNhomnposDONGv6atPWkgn
   Nz94LTi61ecbsAswBrRtR/nR1G0ReanP6bp50vJFAAB05QTfGrKw8DWKw
   uLXhOTIniQggOanNahfYC/HKqCaI9mU9Ptkh/1C1N9sJ77Z14WUkiGDg5
   HEnWXDuy9kOgdI60yT+mw5y1s3GJS0pJNXY7mmUMZy8V7kO5QBHC360qJ
   XL+g99Vkdr3OfZA7HM6Qlaor73XSXsrd51C6Bm14CG4abgQ1zldpl5Mz/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="346165432"
X-IronPort-AV: E=Sophos;i="5.96,251,1665471600"; 
   d="scan'208";a="346165432"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 15:26:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="652093034"
X-IronPort-AV: E=Sophos;i="5.96,251,1665471600"; 
   d="scan'208";a="652093034"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 16 Dec 2022 15:26:45 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 16 Dec 2022 15:26:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 16 Dec 2022 15:26:45 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 16 Dec 2022 15:26:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATYIa4NeTqswObGDBdwy7K4bwrywh9En+7IsT4cDP2EHc41bvG/4yrIg+K2Dr2z3e5VWwrVCLnyzu+xylvewYDWq/GnMuXg7LsEhWmcsTgkJ9lbcQjKnFVDGoYQl46IvSHz5ljqFgMpxqLkY2K1JgBb/yEZVPHa3HXDlEbbN3HysM+kKmz7V0sswpzKb/jPrtY20df2numCJc9YerRsut4r7xlyQxMmgjP8HxDY7R3uhn9cAuSTDOuoLVTbuqGBrsagrvARYCAqlrR2OiaEPVl9VoXf8sY4rqpYba5K1XZVryrZqWyv/jK/IjaflCltkM8YpbatIunRJSLAsBZDNhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1v70LHYds7ggfqycrPp6pv6v3BrIKOy7MtPynhl4vZ8=;
 b=KzAoYftzjgrnh4j9xRzA/JLQdrIvSqp5STEv8c+nzdnTnKyR9eklv7T6jF6q21DLR/BpVwOouadkPMh+6N8xqLtdrkmXjZwvLgSwXRTYtDZyBCWdznu8GvUuFjmZ6vN9t8QjC1jCMeGmQxzwm/3vLdZIiyG+Ht5wgo0raf0Hzs5GDeitat97OjSgztAWiyxLDyblUeZD16v9+VTz3gk7nQCbJ/+H5ZlSKRVATaOOvog4t+HkIIBHaPOC2Nvk6a8iK73d+9yHU4duCx/BieMOaiCBrPFUk+YuO9D++rgNha1H4u7OiC5Iv2qls18UPfXKIpsUOgR3wrLHJ43c4OmW6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5509.namprd11.prod.outlook.com (2603:10b6:208:31f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Fri, 16 Dec
 2022 23:26:43 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%4]) with mapi id 15.20.5924.016; Fri, 16 Dec 2022
 23:26:42 +0000
Message-ID: <d69ae883-6723-efe1-2b93-57927595758c@intel.com>
Date:   Fri, 16 Dec 2022 15:26:33 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 01/15] devlink: move code to a dedicated directory
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <leon@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-2-kuba@kernel.org> <Y5ruLxvHdlhhY+kU@nanopsycho>
 <20221215110925.6a9d0f4a@kernel.org> <Y5w2EXhHyxxSxQCE@nanopsycho>
 <20221216103216.6a98725b@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221216103216.6a98725b@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0007.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::20) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BL1PR11MB5509:EE_
X-MS-Office365-Filtering-Correlation-Id: cab76766-63d0-4d70-37ea-08dadfbcf98f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QzqxPTnnFzhT6zljZ5lRU+NYFJOLDzrWalckWTl0QKBYHiSEcp2xbt6m9I0LoepnMOjsQESlNtmNrS9qs4E91pNiuXnim5AI8ZTg1fHxhy8iObV7kNLLTZQhlEXASMDQ/mNG4na1CtU3ZnW17LISYNZgQrWEC7UcpX/39H21g/JvFDmtKZdtpdkkQW1TYkbmu0Q19zFmlMmHK3lW6I04uv0eSEJiq7HBTgzGOlw+wqzXMhGuzvapHrD0nv0dL8RGWgjDZBybOtZB16AUe2xr1NMFmVe+mwPRFBFaRxb5BXBy/d0CD+n3khVH2vm44BTzMfKoOHOxTFjhc2giM3hwmpWOE8BbGb86LiGvCcj4kdBcs+Wqe4Xuj7iZPTq+4ZhTHmT4NIbRhVAN0y6pl23q2ZprUYVZf8xuwHIPSIP9ua/Jdx+FFOkAU5+yyB/u09caxlj+O1uthe9EagvvXD6IztsE2LZyWzRsTqmgmW9/FGb42zrPQMA70Wf/0w6S0L2dTkeBigeEjRO9l10rULbzxu7Gw1FRx+oUqRfPp7xu0uTkTWcD9VI0+1kThUgPkHTGarq0zgGHtQlwjWZ14jZ4AXwJwQ0fOAkFMVCGMaPGVK2ihXezd140uxz/Ma33rNKXJ3qs7qpUXda1oWhgfLux52EXTbbL6Ffqfdly7TCsSeLKWvnjgCh/IvlSRnMHBKlmsm4iobD//fc9KLwjNyoiz7r7DSGH5yG/npa4WUtgD6Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199015)(36756003)(8676002)(26005)(6512007)(478600001)(66556008)(41300700001)(66476007)(2616005)(6486002)(31696002)(66946007)(186003)(86362001)(4326008)(5660300002)(4744005)(8936002)(6666004)(316002)(110136005)(53546011)(6506007)(38100700002)(82960400001)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGhPYUh6QWp1YktVczNrS2VtZ3hleEwwUFNNb3ZNWC9rc293T0JMMnJobjlj?=
 =?utf-8?B?NnJTMDdxYWk5aTRQMDNWSjduUlFqU0FES0sySmsyUG56WUYxRVVSeGZlVith?=
 =?utf-8?B?WldEL2Y0SXdmMSs4ZStQZlhQNGZuL0p5T0U0WThpU1BJT2RCdkduUXYvWjB4?=
 =?utf-8?B?MUplNDNEY1ZVc1VscFFISjRoNzcyamhOeTJuY2hGT0xnanNSWXdNcnNxUmJM?=
 =?utf-8?B?bGh5cUF1MjZ5RXcxbFRPTWNQcUI5WmFaTjdUY0pxZHo3M3gzZ2pLNWdaMTZv?=
 =?utf-8?B?ckVUSk9xMzg0ckxMYm1WWTRvV3VtczEwMEpkYVU3V3IxU0kxV01PU2NFY21r?=
 =?utf-8?B?SHRNUnVCMEJTNlZFME91blZ2eFErK2lJdVdzeFpaMFZuTE9UYk1SeUQwdnNN?=
 =?utf-8?B?Y2xML3BNbURpeGdnOTBMUHFELzFNTnZGMWc5cHN5VS9nb2tybENhMk8xNTZw?=
 =?utf-8?B?U0ZpdVhuM0JCQlpNRyt4LzZJRVJ0ZEgxRFFNdnNKdkRjenNnZXJmZ2tCYjlC?=
 =?utf-8?B?aUYzMmxHQ2FtSGdYSG01N08vZWYwS0ZQMld1dW9NQ2toRVhleVBmbTBWZUlR?=
 =?utf-8?B?S0V3ajVoK3pWaElHckp1YWFtRzZ3eDJrdjYvbVk3QVJwRmF2L2doc01wczFj?=
 =?utf-8?B?Tkh4b1hxWXVKSlhzc2RvcWNjUkNid0ZDeFlEclg5VWpvbE9kSE1FMzBmTmov?=
 =?utf-8?B?THBzR0xoQ24zOGJSWVNVckdadksrRTdBaXZuQTJkUnN2dnl3cURKOXlJQXQw?=
 =?utf-8?B?TUdvbE1EeDZ4RGEyeHNwODVTTThnblYxNlIwdUFKYXFORjdLL09KalhGL1BY?=
 =?utf-8?B?S0cvYmtHVDAveFJaamV5UENOU1M0RldjeWtmRnZRL2dQaG9tMzR5TUhmZk1o?=
 =?utf-8?B?SXdNZkV3YW5qMmFnbzQ4N0ZycjhwQkwzcm1Sck5Id2l0ZHhTbkhubXBpWHNh?=
 =?utf-8?B?clpRTkZnYTlqUVBJRVZUOVVQaFJ1Y2d5MUhLTE11STBFSzVMMElBM1Zqbmdh?=
 =?utf-8?B?RjFFWGIwZGhOVlBLWFc5QzZmZUIySVovQTBGejI3QU1ZZURQSFFnRlYzRGR5?=
 =?utf-8?B?L2poc2tIdlJBeThPQXo3dmxVcjdKSXYvRnBhbCtBSHJVU29OU3pPTkRBdGk1?=
 =?utf-8?B?VTlmMmZGUUZleDRnci90aGFLRDdqalhzV1BNVW1ab2RSMnFIRFl0NkNYOUhQ?=
 =?utf-8?B?NGxvYjV0QnMyRFdTNHRsOHdSYmpDK3lSQ0FwM1JrNjk4Rmh0WXVKQlpWd0dP?=
 =?utf-8?B?Z0JhR3BHK3FmanZvczhEdVVuZ0NXRElaTVBpV0lzNUxuZGExaklTWmVNMnYx?=
 =?utf-8?B?ekw5SHhIQVE0aWhkTzFhcEhEQnFCbGk0dEZmTFlGMHVtWld6ZDA2VkRnL0h1?=
 =?utf-8?B?aElkdXY4enV5elhjK1QzWmdjSnVBbElMZHB5dTdMc1pOUzZJL2N6RUlaSGxw?=
 =?utf-8?B?Qm1vK25CejlOL2NQTWc3aFRWQTB0K1V0RElHSGFCUFA5UXE3V1FhdnRTWERw?=
 =?utf-8?B?eDdseWd1aU10T0liSzBZN09Zd0M0L3RqbnU3THNIZnJZeDBXV3NuSjJiV3E1?=
 =?utf-8?B?WUhZOGdRa0FaUWxCMkljL1RQNWRQcVpDRnd6aDNyUCtMRUhONGxNektIOThF?=
 =?utf-8?B?L0gyUzZzQXpNUk9Bc1lFTHhoL05obkFVOE50Z2NqRWRsU2hBU3llQzJNaDgw?=
 =?utf-8?B?ZzByMG9hRlNuVDJMVmFkVlVsZWFyNTZkYi9oalRDdk84cW14R2k0cFRhS1h0?=
 =?utf-8?B?YzV6VFRRNGpOOE5ZY3NMZHY5engwQTlhd2lCSmNCRDZzd01jTy95UkIrVWZB?=
 =?utf-8?B?S0dmdmxETnRXclNFUGt3a3FjZHVZemh5TmZ2SlF4UTgzUjJlSTl5V0pDalVN?=
 =?utf-8?B?OUJxUWM3RGUzOWVCdlFSQzloRDRwQ2NEeTdUeUEvQ2NhMWNMVWVpRFlOWnhk?=
 =?utf-8?B?VWgva0NZUUI2ZzZzK04xQ0Q3RWdlNXcvWGdtdUxxUmZvczJQcTdaYWRwMnB1?=
 =?utf-8?B?WnVESWZ1ZDFweFVNQVh5VmlXWGs1eENjNmZGa3RFeEN3aDJZOU5KZktaRTVK?=
 =?utf-8?B?UHBnTEc2NENhVjl0QlhqQURudGpERHkrNjVoaVZxdFhlNnlLajQ4QUhWUzdB?=
 =?utf-8?B?MW9XR2I1cStNT0NrME1aODdkRzdkcnc5OXVRRXVsRDFtUFQrZXpkZHpwcmgr?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cab76766-63d0-4d70-37ea-08dadfbcf98f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 23:26:41.9801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MFHHA5ZlfHZ1M/Q9CxQvxCBOCcvEe0WcIrZsoFMYcDmaGWcMsD1czkDlmlZ+OFHjhzq1GgUlDG0L0IrGCwHD2I+884A98CtBTUTDypzRX0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5509
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2022 10:32 AM, Jakub Kicinski wrote:
> On Fri, 16 Dec 2022 10:10:41 +0100 Jiri Pirko wrote:
>>>> Hmm, as devlink is not really designed to be only networking thing,
>>>> perhaps this is good opportunity to move out of net/ and change the
>>>> config name to "CONFIG_DEVLINK" ?  
>>>
>>> Nothing against it, but don't think it belongs in this patch.
>>> So I call scope creep.  
>>
>> Yeah, but I mean, since you move it from /net/core to /net/, why not
>> just move it to / ?
> 
> It still needs to depend on NET for sockets, right?

Its going to depend on whatever Generic Netlink depends on yea.
