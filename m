Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDCE49F72E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347824AbiA1KT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:19:59 -0500
Received: from mga18.intel.com ([134.134.136.126]:14406 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244160AbiA1KT6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 05:19:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643365198; x=1674901198;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+jxtqsc+mPZ3vcOUIaB1V2KB+KfYmMW9csNwSDA4oHw=;
  b=jUdghbZx2Pw1QQy2cVnpzx3Qg9X2sUXA3uqY1Gy6GJR41CvASj6QNXvC
   F99SM8bNDaGdg8xq3wnUiVEA/KoyYjRDxmoVK4mQbM8w80x0q1qY188xM
   TTWHVmquSQmXZXz7/HN4d+d3p/rVGOjK+yPWrsQu5+uJd0Tet1IcofRrd
   sYZyVYGko3DTFC11p/y6VPgeIUfTSuw6LcM1Eq/Diy15va1pwaoMXm2r2
   wMp6TSd0I5RGMaxbRkDvYu+Pq1ESju/C6O6162BGtW9cIN7xKY18DWiJf
   acm6Zex+eXZqZX+gxieex3WXcRiQRJK7hTA+Cx00lNBdNPuvU7IPVnDOo
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="230671716"
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="230671716"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 02:19:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="564155044"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 28 Jan 2022 02:19:58 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 28 Jan 2022 02:19:57 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 28 Jan 2022 02:19:57 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 28 Jan 2022 02:19:57 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 28 Jan 2022 02:19:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWQwGHAhKyfbYOW5c65DL7t1+zJ4MpT/xo0943syAG/0169AacdwmrYgTcSZgEV9206ZsYGAGqlby5WUUc/5bcyqtYuPch9FSQ34gzbooNCVpAj+ChlPYErbybjPH+UkvCK6nmUGPbeMfiLM7EUJHrg5E+BEMD8nm3rv55zQUpsirF+zZOk3oOeexS54QYKJNOPS5XGRqUiD02ErY3tjg3XjjUBYFwE85Ybbp8zeXR0b1EKLMQcuc/x3jEvGuxAUinYgHeKGD3LY3qhLC2NkaBuBZrbO5+xffYWsXkaoIcMKAbZgLc3jvTpNfhsekFDDtVBciy5ZuCiFpgJXzvh1Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+HFO0wFGWS4et4BjmDOCxwNUbU6fovb1OCAUDJNysQ=;
 b=hrlW/rIRMFtQMGyxt9rLOrKUqSObtB88BworhXSOiUO4b6nxd+69I8dOCKT4sS9WuaOuuZUTTmNgaHxL6072USxicFZLozvmlyOLd03rMrGoXH0Y57CaXjXvackwhHy0u+aVS+KJRFwvhVPYUhCmLP+9t+XZ+DPvFfSn94mpKid9OGUIAbsQII6d2mF3KBpsNtKyhlwHCDG7x9nQmJ6xvJvH/csg/fBJO9gcXEu42dLnGYO00RxMRuySBm3RQJbzju4iBCV7ELkkg1fpFczXdmoBz0wNXu6q0+kCsDdlWHGMnlmRVUT1VWeFOjWpBeo638akaKhl3U/Ee11YANhrrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by BN6PR11MB4004.namprd11.prod.outlook.com (2603:10b6:405:7c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Fri, 28 Jan
 2022 10:19:54 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::44df:92e8:8706:13a3]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::44df:92e8:8706:13a3%3]) with mapi id 15.20.4930.018; Fri, 28 Jan 2022
 10:19:54 +0000
Message-ID: <6fb7df68-9772-0552-344c-27a12ac00b0a@intel.com>
Date:   Fri, 28 Jan 2022 12:19:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Remove useless DMA-32 fallback
 configuration
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        Christoph Hellwig <hch@lst.de>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>
References: <5549ec8837b3a6fab83e92c5206cc100ffd23d85.1641752508.git.christophe.jaillet@wanadoo.fr>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
In-Reply-To: <5549ec8837b3a6fab83e92c5206cc100ffd23d85.1641752508.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0077.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::10) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2170f6b-07b2-46da-0966-08d9e247b9cc
X-MS-TrafficTypeDiagnostic: BN6PR11MB4004:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR11MB4004B4C07F6880D570DAB98697229@BN6PR11MB4004.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: duUjzE1yIHt++2xiZokNqe+0smLcNbymPWG1FVp224kJ8sR3Sqlga8h//QIngj+tzijxzJjqJdShUP43F7eexIztVJ68eeIezEKGP1bxHaWTdkRV+AIkUMTHx793bTD6efwhcT3pieiK67Ib1XKb7HfP9yDQ4yLoXU7VjZILtHIgTd3Njg+OMgfkazL/JbZqeCHDzJ+2ExpZMJHshJzydr5blBnT53sBs17PHLFTE7927V9WtkcnjX1qWSNt9YZ4wfo6ZyxSYWbwr0aJnPhdsqki8XtPPZB0o27rh3Bt8nndAIy5YNS+fc88/DUOtLloNThAV3J+fOtgoFedXkpMGgOXjYPdHAdSxDQkMzNk0m11lKAk1rlmJXXcgnnw4h3WGWjlJI92pQyaX4JUSJIX1fgNymmS6BRWLjXAMsjbvwuyCZjyewlxvwUeiwSCHlIumJI0FibY/iCL2PoZ27AVYAFMU3XFvLyJCN5DiLev4RfKCdD9BLNzhC+28CND5SniyKK6CNgoJKr81fufx0s/r2FuP0n24eny7bMhYrnMlpCclmFXUNcCjpX1a98SAWOD0sRibw7BNPUGWGmoTKx2M1UjDtsfaWUwcr9PXMEgohUK8bx5UywtAY71hKYwfV1nd7UaVF3PWKGTPF3WzGswttQ4gg5+y5VWDzm28HpnZ1wnh/u2AFhKWy8gFFmcJAIVE1USio4dieA3wcEt2OixmSV5/cQQI+IyfqiyhduRnfC8eQL0DZHjKrp0OLnhhUIO+yysCKMFQhRiYRv9tqdcN3p7WJae0Yb9hZDGmOyJS1yhvTe61TCK0jiv6uad4rTJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(6486002)(66556008)(26005)(966005)(66476007)(186003)(316002)(54906003)(36756003)(66946007)(110136005)(508600001)(2616005)(31686004)(53546011)(82960400001)(107886003)(6512007)(6666004)(86362001)(5660300002)(6506007)(8936002)(4326008)(8676002)(38100700002)(2906002)(31696002)(45980500001)(43740500002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1hXSHp3d1VHR2IzamUxWFVjcnFqUlozOTVwbE1YdktQOTlJeWtFWUVWNEpu?=
 =?utf-8?B?d0hHWXk3NmhUN21lVm9NWGtHVWkyOVl0TmRzRytYa0l1dHFMV0owSTJmdEsw?=
 =?utf-8?B?c3NIMzhWc1J1VnJwWXVjWGtMVEVnWU9pK1BGY1pKTHUxNjQ1Q25zaHgwUENQ?=
 =?utf-8?B?T0pCdzVicXRnbC8wOWFwTHR2OHlPeXU4dGJwMFJYYS9EYkQ1TDJRdzBYUlBR?=
 =?utf-8?B?RkFpaHZZVUhXckdXQVdqdDhyQ3ltd3EyakJZeis3ZHA3Q1VQOEFzTFRJNW5k?=
 =?utf-8?B?RFpPQ0RKUUYrc1BoREFiM0g3RmtpSmhLN0VBSDBjQ1k5dXdCakJaTldwS0N4?=
 =?utf-8?B?UUVkODVQYUVCN0hQdjdEaWJtMCtaVUxBUjBmcytEUmtsQ0ZoYzlVcXROSExV?=
 =?utf-8?B?RHFTd0RPcjZ5aC9UdjlIM3F1MlpOckxWYXU0bmxjVGl0TWVnclE4a2MzMW9l?=
 =?utf-8?B?WE5ad0tUWklSVzVoQzducTA0YjdTdnA4T1hSOG1rOGQ4YUtHQkRBVmg3aitQ?=
 =?utf-8?B?dmlvT2FWQWJxUk15ZnJZaDQrck8vSXZkbkJvUEZ0WXpoY0FDZVFtQVdaOEty?=
 =?utf-8?B?bTZSSVpYd0VCcHIwZC8xZDBjSUo5TWJUZ0RjcEkwanRsNEd6S3pvcG1hbWV4?=
 =?utf-8?B?NnZzbVVEWlFQd3NmVlJmTGxQMlloSDhZak9icHhhWlA5aGpUdVNFZmZTbyta?=
 =?utf-8?B?SldwWEZ6R0wvQ0dvOEMyNDFCQW8wVUZlQURjNHdiY01qZm10T2twZkE0UzYz?=
 =?utf-8?B?TEZ3UmFtUXdyYitIOGkrVWUwMzFVQS9VRmtpeEJYZDY2b25NaElKYTBYb1Fp?=
 =?utf-8?B?SDAxQjdyOFBra3FrWnU2NG9ncCt0NllEb1VtSzhuZ3RhaGZaVGV0TU1xNW50?=
 =?utf-8?B?SzhnaWpPNC9hNE0raldhS0s2dDVoSTd0Y2E3RHdvWERHaVJCdDBsTzlKcVZI?=
 =?utf-8?B?cHBFdUphK3RJeERhcHA2L3o5RHg1VHVwNVBHTWt4RC9Gd3lUK0RTNHJPT2dW?=
 =?utf-8?B?bUZaczlUM09GR3lGYWNNc2xVUG56VFhxaWwrNFNoUU1WR3V6THJmN1pxY2Z3?=
 =?utf-8?B?amw0L3NVVno1VUxnK1FtMXMvYjF5MVJXY0x0c09lbFRLWXFGYWhDd25TNkZk?=
 =?utf-8?B?VXNMMHZUVFZEQ3ZFeFdOYWtxZGpYQkkvYnI0ck1TazBnV2lZVDFwaitrYlBW?=
 =?utf-8?B?ZEY0WkdjSjNZZGZxYmNabExVaHFHaFZjOTFyL2JRczRkb0VTOFNzNCt1ejEw?=
 =?utf-8?B?VEpab1J2ZjNrLzRTWktpVGhsMFl1eE1PcnBWMDRxT1hwck1XWUVWMGhMWk54?=
 =?utf-8?B?QzZWbFQ0Rk8zaXFXQnV6Qkgxby92UTRSbDNUbUE0ZExsZTRVNjd3TUZ2Z3kz?=
 =?utf-8?B?VlBNeGRmSnlvTnR4VDlLTko5UXhMUUd2clJ2MkwyVjNKRlh2VEF2azZtVzNR?=
 =?utf-8?B?bGRjVzhieGZDa0Zva0hESkphTDIvMWZsd1pSTVdTVXppQ1dTMjFqWCtXUWpm?=
 =?utf-8?B?R082dHIxZHNFNmIzcDY5OExMeXQ5RXdKWEFhSXNLeU5aVjhEaFN3alhEbTlr?=
 =?utf-8?B?aUNGbGlrem40R3dwZ2NnRG5qNi9OQ3R2NHNqRlU5dDNjMk1ReGtramZQZ2Ri?=
 =?utf-8?B?cDlnaWE0Ump5TG1OS2prVUFLTXJLaVE1ZHZISThzcktTOWcwOVhLY1VNb0Rq?=
 =?utf-8?B?UzFNV2lhOWg3VnRaVmZxeWNPM1JvcVNDcG5PM09FZEFzVUw1L3Y0bHZEczNy?=
 =?utf-8?B?clc5NnJqZit6amczWEEwcVRxVUpOWi9WQitCcUZRV05QZjRWL01JWDYyQ09k?=
 =?utf-8?B?MGRWOURza2pYV1UzM09IRmJxZ2hlZHFWNmV4ZUhBY0hLU0pRL2hUQkx1Yk5N?=
 =?utf-8?B?RnFkUjFKY2djWUwvWDVldWR4YndVQmhYRWo4TTI1OE9pUkdxYUxFWTdwV005?=
 =?utf-8?B?V2Q4eWlPS3RKUE0yWThKN09ZdWpMZThkVmVkN3Y0d2RjMDZmaGl1dEpEbExU?=
 =?utf-8?B?YTNrVGdoKzgxU1VFOUNVTDU2RTZ4dlJoRlUvaGFWamJnWDJQb29rZzYvOEZH?=
 =?utf-8?B?Zm10cXNueGphQ0Z2MnBZNFNGV2VRUmFuOVFSS01iUFZSYTNUVXd2R1pxTDY4?=
 =?utf-8?B?cXhpV2ZtT0NRcXdKSEY3N3FyYllCY3Z3M09rTVV2SmQ0M25MWXRlMGI0UEhl?=
 =?utf-8?Q?wynbTdmy/Z9JzZCZFPQlEm8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2170f6b-07b2-46da-0966-08d9e247b9cc
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 10:19:54.1409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WJ9GbIfEB6HBDc/uwv5jwzcZxrbPiznNIsdd7HwpDEpIBFUIMa3aAvlto6iujcQgedAERtjwHBIfDMMgQaIn+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4004
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/2022 20:23, Christophe JAILLET wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to be
> 1.
> 
> Simplify code and remove some dead code accordingly.
> 
> [1]: https://lkml.org/lkml/2021/6/7/398
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 22 +++++++---------------
>   1 file changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 635a95927e93..4f6ee5c44f75 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -7385,9 +7385,9 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	resource_size_t flash_start, flash_len;
>   	static int cards_found;
>   	u16 aspm_disable_flag = 0;
> -	int bars, i, err, pci_using_dac;
>   	u16 eeprom_data = 0;
>   	u16 eeprom_apme_mask = E1000_EEPROM_APME;
> +	int bars, i, err;
>   	s32 ret_val = 0;
>   
>   	if (ei->flags2 & FLAG2_DISABLE_ASPM_L0S)
> @@ -7401,17 +7401,11 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	if (err)
>   		return err;
>   
> -	pci_using_dac = 0;
>   	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> -	if (!err) {
> -		pci_using_dac = 1;
> -	} else {
> -		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> -		if (err) {
> -			dev_err(&pdev->dev,
> -				"No usable DMA configuration, aborting\n");
> -			goto err_dma;
> -		}
> +	if (err) {
> +		dev_err(&pdev->dev,
> +			"No usable DMA configuration, aborting\n");
> +		goto err_dma;
>   	}
>   
>   	bars = pci_select_bars(pdev, IORESOURCE_MEM);
> @@ -7547,10 +7541,8 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   
>   	netdev->priv_flags |= IFF_UNICAST_FLT;
>   
> -	if (pci_using_dac) {
> -		netdev->features |= NETIF_F_HIGHDMA;
> -		netdev->vlan_features |= NETIF_F_HIGHDMA;
> -	}
> +	netdev->features |= NETIF_F_HIGHDMA;
> +	netdev->vlan_features |= NETIF_F_HIGHDMA;
>   
>   	/* MTU range: 68 - max_hw_frame_size */
>   	netdev->min_mtu = ETH_MIN_MTU;
Thank you Christophe
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
