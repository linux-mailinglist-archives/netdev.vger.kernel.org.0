Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07815647AF0
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLIArm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLIArk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:47:40 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142601018
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670546857; x=1702082857;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1gxSA92Ho1RIye0S5RpSlHEG64l00wkHFOK7Fxgp+fg=;
  b=NMkmwZAEkfYGhSBMg36Xx3a9wkLyyz7rBHVmmQhqoYDMTcIFL2XVuC1Q
   vhgBblZRwt2K06G3moUInMfHEwyLXfZhIzWYvGaKW+PxsEIuuKxuw6bXZ
   rkr2/p3DyCHhDl1Gooy+K+prAz708eZ3vZuhZlGh78w5k6S2tU6XLFeBg
   eOKI1p70BKPMElzGfoje1ifaw1BG3Wn29s858JSQGp6sLCMqT9GD3GeDF
   FXPg/HOOXZK+q8u09lzonT73I+DWofSa8JBzuWqTH5Oi3dw5l+6dQ2zhd
   8dmaPSxLLTC2F9JVQ+nl5opwDzAhNWTHCaBXw6pdYgE89w7MPslF+J7ln
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="300766495"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="300766495"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 16:47:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="821553813"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="821553813"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 08 Dec 2022 16:47:36 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 16:47:35 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 16:47:35 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 16:47:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnKVgKEjerVtJ5yQ+qkVNvGPxzsDtqJbeHMYs/4LpQ2YCx8c2+eTxWWaSouS2k24XctmpTWGstrkhdzkvbr5nmdEl9BEZlydjrUW5zBRMCqZZtIk5D0l+GZaufp6dTjMvZCZjNdit3UR5123CjgkLnSG9dvYq6MyQZzWNYXFo95FOKotk9JMjnQJUIvhChWa1ZMXw0doMvlny6w5Exe0Gkx5eQV96xHpxmNbPDQoyHgiR0DaUxKbBzvBwaoEHDPVdYVOaNJpZ2N+C7pa6mHt9cnevT/lf+Sn202mk9gLu0R+ucC85hI3odSUwS+qMFulftm6FqvG7uEkaIQXznZVLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ojN4C7dvrVNPBunsAp9jPSEv80thJnGTaZ/TJu9BdrM=;
 b=P7pdk6jYuUXD1F+AFDgKegewYajaGCjPR+NVjgmGjqRuSWHE7FHE19NmSIUopymPXBJY/mfVi4Ugjov1H3Wc/Ch4ug2hKsM5x2nr9Gs5qhUCkAPJWlVCSeEDdpbDvd6EaQJEIE2Uep4mlWLOeOboGSKGJ5YrYd4nSq5nZ2Lb2hPHkLW/oog34nDrdHpqkemOWwjToO+gByWSs2kA8hZJz46x1Y4/f1vk1+aO0y+gmb456qPylmZtpFpcRUp0+MEepaXX/JD6bGCy28q5wYsU3RVvjdVshqUHcwgdp/5gwbT2AJdjfMBY0RvUyZQQZxksRB/rEyZ3OBPN166eHPl26g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN9PR11MB5305.namprd11.prod.outlook.com (2603:10b6:408:136::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 00:47:34 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 00:47:33 +0000
Message-ID: <d194be5e-886b-d69b-7d8d-3894354abe7f@intel.com>
Date:   Thu, 8 Dec 2022 16:47:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 1/2] devlink: add fw bank select parameter
Content-Language: en-US
To:     Shannon Nelson <shannon.nelson@amd.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <jiri@nvidia.com>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <20221205172627.44943-2-shannon.nelson@amd.com>
 <20221206174136.19af0e7e@kernel.org>
 <7206bdc8-8d45-5e2d-f84d-d741deb6073e@amd.com>
 <20221207163651.37ff316a@kernel.org>
 <06865416-5094-e34f-d031-fa7d8b96ed9b@amd.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <06865416-5094-e34f-d031-fa7d8b96ed9b@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BN9PR11MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 53d61afa-528d-478b-5e14-08dad97ef5b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w+trxU/OyU0EjgsnFqy9sZaZ4VRWtPcSfz0NQjEqsY7pv8CCQtBMTr/n/85pxcv9muwfHIX+Z4TBDF+bMQQi2d5KG+93e3Q/5iOGhvEU6E3RAtI+iYF14RVmwLJEMCuhXxrhhR+j0fOzfgEDsRXazPlIpteFhMBzknPX+N334eyfc9+g0yEGLZzwomT51VnVeBHbZjnYwB2xlqaGgBjxcKz3HNH1LXzyvPWatD3dp7BgVF/w/J7F2ea/skAOt5FDE1PRYgqzwdQY3gwH9p63Buz156Ql0+QmDRvlXx6jqXXsdbK0gL/KeKULn/AVXuA1iqAN9XO/rkcu0AxsLUNH6Fh2jy02RSoZtvmPtzIvKIkV3T+yzMaJDjpQ/0ZHX7YqlE0xvcXj88VD43ySdkJOaQZxDUfyFMCf1dtdVsznWvmm4q3WjT5it7x5qcqhFpTr0czuPn1ypjyD2dnpobPCThrBcPwtcBsh/LVMFKjlc5i7yk2cZSnSW8kGjNV+MN7RJsrA0ntSg9x49C0nZji+O9VIzqyjjFaUvGXixKGbX4xJ4VcG3zzUgvkbSlD1JuFhqy9wnf6mAQIGCxLy0TBBVf3s/BnPaMGDFGE2L+0/vkmQgY77FMKCQAi99NXmD6lx37S16JLucMyKnX+PTaULMaCMkApF3byafXZVm4MvmOf9HjopNNBLzE7aJT2cWZlfv5s0NdAvle3CwZGxnt6WSlXy3VJYKr4ZMurbB+znyRY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199015)(2906002)(31686004)(316002)(110136005)(8936002)(5660300002)(66946007)(15650500001)(86362001)(66556008)(4326008)(8676002)(66476007)(36756003)(53546011)(6506007)(478600001)(41300700001)(6486002)(6512007)(82960400001)(31696002)(83380400001)(186003)(2616005)(26005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFdodVZ0VnNMWTI0UFNVbVU0ajVzWWZIMktJcXFObWpPcHY4TUFXWmF0QmU2?=
 =?utf-8?B?R3FwRndaYXVmWEwxVnVGK1ZISFFkWVhOK05qdmxQY3NOTENRYjNHbWdIYkY5?=
 =?utf-8?B?Z05yR3hPZVFTb244elR6MUF1RkRLRjRSRzNMbVBGZ1AvTnlCcjJkTlBlcGUx?=
 =?utf-8?B?SWxWZUZDbWZTSWprWnhXK1RNcHRhRDI2RHljczlYWGxxY1ZUY3dvVmZkcWJv?=
 =?utf-8?B?eUxZaCtwakRVWi9zcXhSL2ljRGxUMmtrUUlyZlJIMWM3ejJJZ21SWUw1RUIw?=
 =?utf-8?B?VmJyWGd4bUxNR2IzbVpJREtSR3NoTkI1UDBqc0JBRmwzZjd5ejdneEYyQzQ0?=
 =?utf-8?B?ODNqWHFmSEo5YzJaR2RXMWRISll1NUNUOWMyVTN3bFdNMkNBNndYT1M4UTRt?=
 =?utf-8?B?THZxT3N5WlpIVWtiVDVob3QzK28reEwwa0dVR3p2emZNelZVTERTZkZwUlgx?=
 =?utf-8?B?SmRoVmJJUGhjaitkZ3hYMDlEZVNSMCtTUzJEWVJkWXUzRnhHOEJRamJLZEoy?=
 =?utf-8?B?TTZMQjkrSkJYekxjZkJ5ODhwdXdiYWthbTJsYzErbHVHT0ZSV1ZhT3Z5dGtX?=
 =?utf-8?B?SnRzNmVSVlROaVlwazhvNmw1aXJqWXZwcXZZaklSZXFlMnZiOWVDTEtxS1Bx?=
 =?utf-8?B?NHRhNnVkcHlnK0dXd1JWaWVrSjhoSDhVVHArSjNBd0pPS29YS013ZTRYdWF2?=
 =?utf-8?B?aU53T05maU5jZnlta2NIcU80SDlpUWtZQmlIdmVzT24xSGZjeUxGcklpWTFo?=
 =?utf-8?B?ZUlaQmJVTmZWaGdQT1FzTEFiK3FHWlVmS0ZpT1hneGZwdHVBcTJqZzBKbHhw?=
 =?utf-8?B?OXlneWs2S3NyaWF6Y29DcWVXbDZzSWJTM2RGZUwrTFJtYmswYVVobXN0ZExI?=
 =?utf-8?B?Ym9XU1IxTSs4OWtLZVorckw2MlNFY0pNUTMzY1M2L0Mra1FsOVkzS1hVWFBH?=
 =?utf-8?B?d00xY3Q1SGdoNkRJcTAyNXZIRnRCSjR0WUg4Z0hZM2ZvS3BpSkRZMHV6RWxW?=
 =?utf-8?B?SFpvWXc1S05LME5kN0dNVHV3eGo0M1U4RzFISWVjajlzQkRHaEVHYlUxTUdn?=
 =?utf-8?B?cis4UUJpZnVSNWlvYjJPNTNDYTF2VFlvcTd1RE5ybG9hbndHMDhDYzBrUmVR?=
 =?utf-8?B?N2N1V25ldVJqNkx2ckNBeVRVY0Z3dWFDU0ZJS1dWbnpWQytibEJwSUhvY25W?=
 =?utf-8?B?LzFSUWFubGRwZVpWRUJhMHp0WnNLaWpiRGsvaU9CMW5IY213aWRrdkFZODln?=
 =?utf-8?B?N0piOHpSeFNXdFpvUXgwb01mbkZrS0VpTENvQWUvbnFRcUlRNlg2NlBEWktE?=
 =?utf-8?B?cTZUUFNHblVFTTZaZHNSNExORk9IaDlqV1VKNzVRZENad3NrdzlyR1B1V3RM?=
 =?utf-8?B?M3hnbU9tWHdNdlZtSVR2UXRuS3lGUEZYMG9HSUc2WXlxanZySHRlR0p1dEti?=
 =?utf-8?B?R0s5OERzc3M2dUtNclFlOUJCMWU4ZHdkNkl5Mm5EVjFqVDI5VWlYTjNBRmh6?=
 =?utf-8?B?TjFEVUp1SEMyRFVPVE0rTlV4aWJFU3BnN1JjTGN5VzRXVEhQc0JIbmpYNnJv?=
 =?utf-8?B?TnJ2azl6c2dWb29rZENCQ0EvSml3RFg1VHNzWVhzQmQ2VzRrTGMwTGdIZGxt?=
 =?utf-8?B?Qm5lS05KNzZDQjB5Q2FsdmdNbW02Y0IzYkRpb3R1NlZCMEtXNFg1Y3dvMU9q?=
 =?utf-8?B?RHFjcGl2bHVxQktlY2YxUStMWHlYTDZrN1lVL2YyRCtPTHdzRlZXekwwWDFU?=
 =?utf-8?B?VWZNS2l1Y1lTTU5aYk1jRWgwbTRpbGFxeEh6cVRIQjBQSjdYVEN2YXZMRDB4?=
 =?utf-8?B?djEwYlpUTy92bXhQb0gzZENlUVpJNW9GVElFb3AzdzIzemdFOXhVUFFyQzV0?=
 =?utf-8?B?MTBYKzBjSFd2RFJXdVFGK04rbXMrUFFNWVZYdlV4eEpjS1hpZno1VkJvRnpE?=
 =?utf-8?B?U1NXZ0gwOVRHTDVpQndMSmN5U1ZCY0xNNElOcFBOZmVMakVuZkF3Z3ZGdlhL?=
 =?utf-8?B?YjFVZ1Y4bThOcDI0TUlFazJ2MVREME05aDlNaDFEOVZacVRCM0k4QmorbHdm?=
 =?utf-8?B?TW5EanRka1c3QThsTE84WHBVQ0JPWk91aXhQMnhjSDhjZDlvSnEwREIzdDI5?=
 =?utf-8?B?SVprcmt6OHNVWHpsWTVnNWlMOHo4OUFBLzBnbWxYWEQ1TFdRcG5HNnhkTTA5?=
 =?utf-8?B?OEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53d61afa-528d-478b-5e14-08dad97ef5b3
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 00:47:33.9032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqUkQNFltga+NEKCk877eIhwvFhRqpUcsdjcOvwzCRIAIAc8jAuUh9Ir8LyFIFtal4v44zlLXvNSVqi/iLj5xrvfR3xu4e38rQOhQK8QoUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5305
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/8/2022 10:44 AM, Shannon Nelson wrote:
> On 12/7/22 4:36 PM, Jakub Kicinski wrote:
>> On Wed, 7 Dec 2022 11:29:58 -0800 Shannon Nelson wrote:
>>> Is this reasonable?
>>
>> Well, the point of the multiple versions was that vendors can expose
>> components. Let's take the simplest example of management FW vs option
>> rom/UNDI:
>>
>>          stored:
>>            fw            1.2.3
>>            fw.bundle     March 123
>>            fw.undi       0.5.6
>>
>> What I had in mind was to add bank'ed sections:
>>
>>          stored (bank 0, active, current):
>>            fw            1.2.3
>>            fw.bundle     March 123
>>            fw.undi       0.5.6
>>          stored (bank 1):
>>            fw            1.4.0
>>            fw.bundle     May 123
>>            fw.undi       0.6.0
> 
> Seems reasonable at first glance...
> 
> 

This is what I was thinking of and looks good to me. As for how to add 
attributes to get us from the current netlink API to this, I'm not 100% 
sure.

I think we can mostly just add the bank ID and flags to indicate which 
one is active and which one will be programmed next.

I think we could also add a new attribute to both reload and flash which 
specify which bank to use. For flash, this would be which bank to 
program, and for update this would be which bank to load the firmware 
from when doing a "fw_activate".

Is that reasonable? Do you still need a permanent "use this bank by 
default" parameter as well?
