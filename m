Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A15C6219D6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 17:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbiKHQyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 11:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiKHQyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 11:54:37 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320212315A
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 08:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667926477; x=1699462477;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dCaqqxKzIOKy7J+xFdpdB86htuG5uV/9QEBnrJkyKl0=;
  b=gVTV+U3/PftTpNE3LfwZcnIv4RcJDzUvNR9+5RFBw8ve/WkKJNrX+eDy
   EoCR7PMIONnbPLvXssBV7OGG6HdTRi31t5sB1ATaEKOvC9y0vjl02fSRc
   po3VeVDk5xLjGJzFmDuIITjLtYsMmQjx4lHrC3H24PdO24P62MiCqzTYn
   GVxQa9r16ZRPucaXVk05nXMVK97KTGtgnYkmddPrr18VSy3FM46Y68OWP
   tU0+Kcwg5F1+58JrJBzR5VDqRenvf0cm1+fh6rZbayKtBZZvMDvzpTsvv
   IlgnrXYmhjF8cbpupQQ0DVcie/PduexxQa2JbH9pxZhtNno7lguHKW4gI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="291134069"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="291134069"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 08:54:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="614343311"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="614343311"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 08 Nov 2022 08:54:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 08:54:36 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 08:54:36 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 08:54:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOyPaHucdPOw4Gy7oJKpBFmPvQ3ye9QYnH6PZCc3lJ0lR0WszZ0yWb2QT4hSCH4MEeSE0Bs0QfAieGfbm8q5qNHo5EV4cthRaJKgiQMS+P//vOZUZwFUZzfuu1Iq1q3/E5puqmSK/kTnQ9xhVlYfMY0ZqzMooiyGNoPBuaPzOINrDXyVman1UbmUdKb07uni2Gg82rV5/Ah2VT+yE70qS8dUzxUdsBaxQf1x5soE/uZwbPlLtR1gPn/vDTLMJA6SAG105pbYQtlpxMpKJPW7MtDhlaXTNo+CC2aPfRi3ch6yV1dk+6Tey4cttk3HbS7CPQppSmPEwTLfEAYvB7ddRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8egJjrmu7ZKWNLAsGYFDKP0ytSXL93ebhkdc3rsYms=;
 b=BI1H7loTBeo6A2Q832k/5/MQx3rBjt7TAwzgoF21vxYtKSTDtcK+CUE5AGzlVeULZE/8SgUxoym7Usldn9OqFI6vkblVI8UcfqIbTKzq64OnTP4+gPdlotubVhryZsJTEi2/qAbYo37NZI3JUxDmWm65fhiL4QICQRNyNjosRW3PJ8ZfPUjM1N9mAttJAwiX3qwvDjw39ngnss8imKa5fzE52cBofALycUKQCTcmmsEsBXyVTaZrUx2jBLCqbHTBSNL054KU2TnL0Fnc39vGyNpbqCOaTY5S5WXOizj+DEnTei30cTTa7Q5q/9UYl+MjP7byzqWV5ZIcbFZ4iBsazg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4852.namprd11.prod.outlook.com (2603:10b6:303:9f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Tue, 8 Nov
 2022 16:54:34 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 16:54:34 +0000
Message-ID: <644f926a-17d1-175f-8a40-39f75d1e49a8@intel.com>
Date:   Tue, 8 Nov 2022 08:54:32 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next v9 0/9] Implement devlink-rate API and extend it
Content-Language: en-US
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>,
        <anthony.l.nguyen@intel.com>, <ecree.xilinx@gmail.com>,
        <jiri@resnulli.us>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
 <20221104190533.266e2926@kernel.org>
 <561f25bc-40dc-78c7-0a2c-e7e0fe74ebde@intel.com>
 <20221107103145.585558e2@kernel.org>
 <f0075083-8a11-a2f4-a927-7cd5f255bde4@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <f0075083-8a11-a2f4-a927-7cd5f255bde4@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:303:8f::18) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO1PR11MB4852:EE_
X-MS-Office365-Filtering-Correlation-Id: 84c409e8-baff-49d4-2b1d-08dac1a9e9b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CU4oSzcCqN1QwSpzxK2Hs2pB3NePDUvSK+QLK07/ceTYEtMPA64n0FXrdFe1qrhm6u2GLaIfOyDx9kWXxTwWNDn6y5JoZujdFAigCXJeQuz474sDUyyXYev5dVQUhftJ51pnpLaT5SB2XMKBWAjRpeQhL8pIU45P1wgsbEKx49iZgqZCkR0hXzhYLlrHE+jfYZLdQ8V9WhHsAI7I/3hgq5uYYynI+gqNDddTQLyGNuVnbbX6KM77D0b/Zl9Hb6BMhlQceo2Tzjpm/1+P+PlIdbYbTEn846wqVWJfWMgn2SLXu/xsHjXLkT4LYLzMLvKkwCzTEYsV+HfAoWsdGZ5gABiGyGs7FTPbUxYjDHtNx1/HjRUFDfI1DciEapWZ21pjO0lsceyL1goJxrweJS7/OzJROFbEl3Y1gw+Q/nnqaasaJN0Abg43byk0Q8ZXA5b433elbrq5PtK4W8iI1+0pLk5z6DqGYAdVcWdNiLJ+azihr5Rsby00qxW/E9j8HcPOC475zsO9PO4mbR161Q0vwwz4ZELqVnUUHMMMz8MYTZ3x5tT2/KPU4qtMQ9rcxLlLTiF+lggUC40TF2Ea2FbGFppRIdwIyWeiYQ97xck5RG2BTK9+E0ETH3mZjtgeJV1O0PN6EmI+5fgfVI7SYIDZSqeLXWwFgLKW4LeVUDY+yeUovS47423SfygY8UeZVPpRI6IcV9VGogD9UMidb9w/K2iffy0FWS8+i9+ZzdS9ls7zqnWSJ788MaiVQMBCqCta2FfBU3rPtvEygUwx45ncMFXrTkuBjXnexSHeE0dzSkCR7UmpHG0ia7fk3iVOmJPG/oeYj1kETQg8v4VCi9hLJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199015)(5660300002)(66556008)(8676002)(38100700002)(66946007)(4326008)(66476007)(316002)(8936002)(110136005)(41300700001)(82960400001)(36756003)(53546011)(83380400001)(6486002)(26005)(478600001)(966005)(6506007)(186003)(2616005)(31696002)(6512007)(2906002)(31686004)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHZTL21tWTIvZE9mdHVjKzhWTnJuOFM2TkF2aGV6VXduYU1YdWduQ2M3d0hE?=
 =?utf-8?B?VXhkTHB3ZVdnc0dxUjVJUjQ3MkJnaGh3OTRXWEIxd2lFeWMrK216V1VkWVhp?=
 =?utf-8?B?eVFZMkppUUU3UjRub1Jyd2wzR0Y5cWpWNFJjb0FFb3pWemhmUWFtYmVMUVVi?=
 =?utf-8?B?U1lMQ1VQc3pnMWlaWm1CenVPYTBNaEtQWEh6V3BXc3AybkpEQitRcnFhaVY3?=
 =?utf-8?B?Y3RzZHlzYkk5dzVEeVZGSVkvWXhmSlN6eDdiNTA0T0lJVEF6azRxbVhpakJl?=
 =?utf-8?B?MmxDUlI3RS9uc2ZxL2RoeW1Hd2tIZ002VE0zRVhRV0NUZnRNd2NSdDlJQWIv?=
 =?utf-8?B?d2cwRWJScWZ0ZktoOUdMSFJFUjJmcHFOcXY4emkxVHRMSCtvbVM0UnhjZmlR?=
 =?utf-8?B?ZENqRGN5N3pUQXljY1c0YzVIeENaVTVNakJDSDY0OWkvVlhNcUdnYUhxVUsy?=
 =?utf-8?B?K1V0N3ZxYmxYNzlJUnJnNjZPbmtPQkFaeVd5aVFKcW5LQkFHdUdCVndEcmdq?=
 =?utf-8?B?dmt6bVVSRWYzM20vZDk5NVJOTGxUSzBlcStBTjU5UFJwdEVyNVNodVR3UlhE?=
 =?utf-8?B?WTgxY1pGRWhhV1lqZlgyYjVidS92Tm1UZ00wdGJTb3pJdVBydGlCYTVqRnlZ?=
 =?utf-8?B?aXFEZUpOUVVkb0VHNFhLdEN5KyttRHM0a2Z6cWtaVEpnY3ZXUjFUYzVuMlhr?=
 =?utf-8?B?YnAvRGVUSmRNUFdLRHpESzJkcU1JNlNxYUxPMmIrZllsdGFFcXZaRGxWdFJ3?=
 =?utf-8?B?Y2ZxcVRLTGZXRzBhdE03N2xxc3R3Vm1xZFZIV0tFcHhaYk1LNWVpS3hRZVk5?=
 =?utf-8?B?K3pHaUpjTFRLWEJhS2JxM1Q1Vmp1TUxpV3FwcFNhL1A4VVlOV0grbVhCTVZK?=
 =?utf-8?B?WVdnQURFYmx0WVZvUkRBOUR1M3ZpZUsyOHRubnlEbnBwSXBxTDErQm1sL0hC?=
 =?utf-8?B?dGVSVjZUZkhBelU5YU9yUlNaQlVKMWRlV0tlSU11SDZsOEpXUXNwRGRIM0Zo?=
 =?utf-8?B?MjNhTE9PQ1pXSmorRjJMUlIzTUhuQXZTME11TC9aMVdVOHRpQ2c3ZXN3Zktt?=
 =?utf-8?B?YW1HZ3BDdmRPWGh4STBMdCtkM1VWSFJPd0FrMmJkRU4zS1BsYVJSNlpiQUFu?=
 =?utf-8?B?ZGhYWVFra3B3MzVtc2c1djdjREdyMEErbzVLQWtoTTFYMjFNcC9uajVWREhn?=
 =?utf-8?B?MTdVZ1FlRjN3YlFSUE90bnpXYnE5emoxMDJGaHVBeFBZcHArcEo1bHo4MTdh?=
 =?utf-8?B?YUJ4aUpkdGNocE9rVGFTZmtBR0ZLeGlvT2VHS2RBVm1DcTNsSkdhQyt6dEtU?=
 =?utf-8?B?SWZPYy9mTW9rQ1FCUEFFYWgxMVJBVWJLOGphVFgvR0RwKzVuNXpJaFo2ejlK?=
 =?utf-8?B?VXQzN3c2dDVLem5SU2tLKzVFQ0NkTkVsZTY5YWR1RlRwb01SVTdQN1JZR2Za?=
 =?utf-8?B?R2tvc1dZRzdvMEVKZVlGbUFiYXNuS2RmL2V5RVB5Q1VKd3l1d1BWWllJekxs?=
 =?utf-8?B?ZUFOZEVtdEFoc0N6ZGpFVjh0dCszc2Yyc1czSWtaejNwT1VaNjlTY3Jqa3M0?=
 =?utf-8?B?U0I3Y3ZwQ2xlMkZITi9YbDFNWitEbTJLRjEzTloxaFdWVnU1R21PTHBaMEtn?=
 =?utf-8?B?ajl3UHJQTDRoWVFWWmxPelV1TXN2RkUxNU1lVFc2WGhhM3I1MTNjSk4vSnRp?=
 =?utf-8?B?RWxPSW1jTU9rUzNkN2JkUHoyeWpUdUQrZXVCSlJQbVV0R2JsWENPcUFHQXlL?=
 =?utf-8?B?QW1sRnpGSGRHaXJ3MUNtalhJV2pqSXVOSlVkdmQ4Y1h2OU5pVW1Db1Bxa3E2?=
 =?utf-8?B?OXFsUHBic21rT3cxY0lYdzFBQnNLV1ZYVGxVSGlDQW9xWGF2Y2tka25Jd2NH?=
 =?utf-8?B?SkVONUo0bEdhbXpGblZOZDJKMlR1VFZHcE1kQkI3TWlUaUdVbFRTRElydEVC?=
 =?utf-8?B?M0xjdHlZdjJPeGRHWlJNVW5Dd1VtRzBwNFpSYyttaGdmYlhJY1NUVGNVMERI?=
 =?utf-8?B?VkJVdDdRRU1vK3FVajBPNTdZWlFoLzNMSGxQSUIrSWlnT3VwbFNsZU9zcWtt?=
 =?utf-8?B?YjZNaGV3QkZCbnVIRG1tU0s0MVdkS1E4eUdhOGFhVTlQKytMZDBza2JaSmtD?=
 =?utf-8?B?YVVNdXI5R25FR3h2R3NKaXRNd2hhcDBPb3o3d2NvbHZkV1JuRngxbU1QUnQx?=
 =?utf-8?B?OVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c409e8-baff-49d4-2b1d-08dac1a9e9b4
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 16:54:34.5097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQreexIKCiSADqjprK+EoAWee5Q4w1rOTJ0ksqaVaNfmbbiUQL/J9+mVl1gj3BBVkp0mNqmQHLxRoLKgnmisbU7+pJrX+WuWyOQmR9M756M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4852
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/2022 12:08 AM, Wilczynski, Michal wrote:
> 
> 
> On 11/7/2022 7:31 PM, Jakub Kicinski wrote:
>> On Mon, 7 Nov 2022 19:18:10 +0100 Wilczynski, Michal wrote:
>>> I provided some documentation in v10 in ice.rst file.
>>> Unfortunately there is no devlink-rate.rst as far as I can
>>> tell and at some point we even discussed adding this with Edward,
>>> but honestly I think this could be added in a separate patch
>>> series to not unnecessarily prolong merging this.
>> You can't reply to email and then immediately post a new version :/
>> How am I supposed to have a conversation with you? Extremely annoying.
> 
> I'm sorry if you find this annoying, however I can't see any harm here ?
> I fixed some legit issues that you've pointed in v9, wrote some
> documentation and basically said, "I wrote some documentation in
> the next patchset, is it enough ?". I think it's better to get feedback
> for smaller commits faster, this way I send the updated patchset
> quickly.
> 

 From 
https://docs.kernel.org/process/maintainer-netdev.html?highlight=netdev

> 2. netdev FAQ¶
> 2.1. tl;dr¶
> designate your patch to a tree - [PATCH net] or [PATCH net-next]
> 
> for fixes the Fixes: tag is required, regardless of the tree
> 
> don’t post large series (> 15 patches), break them up
> 
> don’t repost your patches within one 24h period
> 
> reverse xmas tree

Giving everyone at least 24 hours per posting (if not more) helps ensure 
that limited reviewer time doesn't get overloaded by constantly 
re-reviewing the same code. It also helps ensure that everyone has a 
chance to look at the patches.

Thanks,
Jake
