Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881C765116B
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 18:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiLSR4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 12:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiLSR4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 12:56:45 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734B412AD7
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 09:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671472603; x=1703008603;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6bSihyVn9j6GGlnkatLBC7Eky9benlJST+FlNWWUVeg=;
  b=hLsQP6sAIoSJoGbxgNz5V2ZinUz4Qr1vxFaXDS9JthQc+4584vcaZ5hn
   6UdchomGbCAjc16z+tx1gij3tl+U3rZi2ph/IPJixHDCC6NQU+Wp0DEWP
   PCa+GNNOt9ZjX/9a3xwVLsqjmx0c+OU2vrybMrOhlA3GkJkgTRAT7unrJ
   Fzr8Bj26YLLmZD+a2w+AfEOJpqXz/wQP4EQ9zxccmDzvLIB//mkkNB8xA
   sdIMp2d12IyJUcZlJr+KbTbNuJt4TaIFeMUfGo5EdXNZZrskUijxQ2kHD
   qBdBlcWDwYCqFRkhpPGqBZC2tf6AlIHyxNjuVtipeV5WHbnacQVEoSzb7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="405663269"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="405663269"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 09:56:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="979473360"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="979473360"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 19 Dec 2022 09:56:32 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 09:56:32 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 09:56:32 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 09:56:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieHj2XCVs93AWwn1EOQA1501TZALJ2j+/9vRtp8gotVdtJXIzXm8NvpbyfEjAGr85i3AZK3a35LBdHSRj62jTCRpSEMigmdwYWXyzKbJUkkw6WWxm7QA+QZ8oIwxvAU+3PuaADvjkkbUnAdCWP+pD45ePI5PYms2zHRdqbtB7O0DajrUGRN6+X6rZwueHCDLnMd4LraYai6MhbCR8fH4DzqRgABw+TxVWSt5+Ijw94E3FyCfD9UkJlUSTvQANqqgc+en1UB+L1Pg3rX8I1Ep65lBwmJYhss1VUO31y7lm6eN9dkG2CGvTtYyEmw9oi7B+I48gP0ooj+OkrWYK1sZzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XizDzP1t+SqTQn2DuRntwzaKAcvx0Jrf2a/kWZmijQI=;
 b=AjXIZkIDDzH0CCMPu+eUx7t3p6lhVPJ/mBdKaV9F4QwWsgze4mQ1ky83Qt25SJTU+ZAvH1iWHuE5xyjZ+Wyg8BgzrzwdsIfBx7ndyVzc176RtIei/aNOANX8qJnOJ1MuQC1cJP5MC8I0wzITM2UK0OFJr+uTvs7fCo+XFA1kQ032XNM05w0Vfhq8MUMParjP9/iwFAvXYLRE01d/EjfNg29AC4B+trCZ8BKDjfUFRrpMNvZ2vzRpIrLKLaUDYuGSKEFmHRpeUH/gf1CV8sTeDoXFJQhX9HVl1sszpePcnUs6opAue7p1BN0wtQViFVd+Z7Lk+aMdwbgFKdveiNeCOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH8PR11MB6853.namprd11.prod.outlook.com (2603:10b6:510:22e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 19 Dec
 2022 17:56:29 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 17:56:29 +0000
Message-ID: <ac6f8ab5-3838-4686-fc20-b98b196f82c8@intel.com>
Date:   Mon, 19 Dec 2022 09:56:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 05/10] devlink: remove the registration guarantee
 of references
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <jiri@resnulli.us>,
        <leon@kernel.org>
CC:     <netdev@vger.kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-6-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221217011953.152487-6-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::11) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH8PR11MB6853:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ec66203-1890-4d66-59b5-08dae1ea5acf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CloS5kHAqhkvaZz3nutw0kt/4EIlKf1oUIWPP/3J/dArLyCxx58K9rTMu19pqyrnT9L+FZgF5ALkULLDuYwi5XyfytixFWFFQ2oHOIozMMtcnq5ha7ouJtSruMVPfauHyTIH88fpFpShy+PpkmgtabBWEMdPJxEAos/18bLc5hJw1Fp1tiwb3TAhv4h+oow9ctPqILKntv8pm3CJ30bBLnh58awe/DanfYPk0rnBlMFO5DnXRLUYPZkrQ24KU6GCs+o6YzldJ0EGgOjOGJfcn8uesLKAYwvnd7kPC6QDY+RBNz9UQrp1ww4cHEgJT3ig8za0tqaBa1iup/diJ+bxyFfA3/vEu9clEPpOioXTADxL5caLoqAQ1jc39tOsqXp+VjNrePhbDKWibMKO3Ga1/5OY24nO9wJncaMG7R4r90DOBC0OdRVJ1x3F69Cnh6RMsSF+9abcKB1Rq587Mr0ULizjqBHoDDZrBMMs4D66QkhREnRTeEYxhjeRLSabBm1O1CmCAg+Ex4g3bYVnKUIvqgAz9b6GDyQ68E6VePmdW8qL8FIm3OcdtPmri2cY+yxQ8bTQdl8vu0fVDjK+LQSMQIdCqAsFIhbRiqA5MbMJKVydMgysLYgt8yZ1FQOhvNntZhADl7xOsYm/ygUcWU32bmTzPOCwm8jk1VtvNQOEbsHsxL7cWDSE8cwFQyLmJqXkrZEB/PSGxeCfy9fUBwZ3N/v/d85rVZyp2/4x3Icbu+o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199015)(31696002)(31686004)(66899015)(86362001)(36756003)(38100700002)(186003)(4326008)(6666004)(83380400001)(478600001)(6486002)(26005)(53546011)(6506007)(2616005)(6512007)(8676002)(316002)(82960400001)(8936002)(5660300002)(2906002)(66556008)(66476007)(41300700001)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmJGYitzelFZb1FncVVDTzRMYzR1RUc5bVlMWXF3YVhUTExsMHNYclpzVU1B?=
 =?utf-8?B?UGZaR01xdWxDaFlueEdJU3FmbVpzOGRZQnUyblJzN2I0SHo4K2t2MzZTZytM?=
 =?utf-8?B?dTV0WWJDZUJiTStSMDU1QnBnaTc4bXZTNmx4alFDbGdDZXVEcHJjL20zUDFT?=
 =?utf-8?B?R2ZFeENtSjVWTUUrZDlxOVNPT3RtTEhsRWgvaDA5dTVXNzVnd1E2MUljZkZI?=
 =?utf-8?B?empSbFdscENPQjhKaW53bUUxNVdmazlwNmhOLzFzRjB4MGVsWHlNM09jZTNG?=
 =?utf-8?B?SXE2akJ1YUMrNDJVcWVwT3h4RDNGNXZoYU1TMzlmWDEyNGljck9aMzcwOHhU?=
 =?utf-8?B?U2hLZDY4dTVjK1Q4ZzdBaEFNWGhKL2NmT2FqcnZoT0s2ZTdZSDNmOENubVI0?=
 =?utf-8?B?UmxBT3ZGZkJvemo5Y1ljUGNkWWwvNU1yclFuK2oxdi91d3U3SzRzNVYwTWdo?=
 =?utf-8?B?S1Vnb0s1WVE3RTJnZ0JLbjhmd3BSY0kwalRyWUhmc3k0U1RpOUxQNy81Q0Rz?=
 =?utf-8?B?OTl0UFJNeHBjK3NGYjMrU2tFamhnL3hSVnBSYTlPaHRrU2RJUWRIMDQrbVln?=
 =?utf-8?B?Y0hPM2cySjJQV0swYlZiS084SG94S3F0RTA2bWt2TWJ3TmdlUE1hZFk1WVow?=
 =?utf-8?B?bUVJcndSMkRvWWE5RTM3dExCa21ya1RJTFgvOEMzM09ZdndzQ3FrZ2ZTZzls?=
 =?utf-8?B?TGEwZWhGekhVbFdiaTZVbzZUaGRhaC9iWVdnRU1LRUVncHdDTVdaUjZlS1RB?=
 =?utf-8?B?OWFNclkyTFNDc0hPY29EWGZCd2RlempnaTZDQmdwMS9ySG8xaGdUZW95dzNK?=
 =?utf-8?B?bWRPTGtCN1hZVnRUSmtuZjdzdWFiNCtJQ2w5ejlWaENjUlFZSXVlZXNjQ0x0?=
 =?utf-8?B?NVZNQWFiUTMrRSs3L3BlSlNsNUFsNlduVTRreVNPNXVCK2NpR0h5RzdvTEll?=
 =?utf-8?B?WmZnRzhPQnB3SXpMU253c0JleFBuUmN6REpKQm5Sd0ZUdGFZQThjdi93VzQy?=
 =?utf-8?B?a0FuNkpwMzgwSE5yWlEvQ2kxdXdnWGh6cEo0dVgwZXBWRUxyNzNOQko1Q284?=
 =?utf-8?B?UGg3VDdxVUxZaE9FcVZvdDlHSXhnclNQODQ3MllNSzVRdHdtZXVvTXBIazZp?=
 =?utf-8?B?cGtZNm94SzZ1WGZsMVRmcWNXUldvZzkxcjcxd3BYV2cvOC9nRDN5WS9nRERs?=
 =?utf-8?B?cGt5UTRDemN5aUR4Z3NWNEEwdGcvOTcwaHNkMHY1Y0lMeGpPcGJzdzA1YS9U?=
 =?utf-8?B?K290U0NoZDdJTE1WdTJVZWtvcE54c3lINE5IU0QyN2cwVFBLalkzR28vWDMx?=
 =?utf-8?B?ekVlTEN5Tkw5SUVBWUpES3BlelhzOEgxZXpId1ZQM2VxSXJNY1pDajdUOFdm?=
 =?utf-8?B?RlFqY1l6bnpvUEtlbTRYem54UU96b1hjWkZqY3d2ZFpYZHQ2S1V4SmdMMWlO?=
 =?utf-8?B?UmV5V01tOHp6TDA4QzRaSlhDUVZmalBJazJmYmFZcUIvK1YzS0NRVVF1VTVW?=
 =?utf-8?B?RGswbXVMbXNNclc0T2FvVHllbk5IbjJiOVZRMnJpOGgrOTdoeHpTZ05yT1Fq?=
 =?utf-8?B?SnE0K3VZNzBabVJnTi9HR2ZvT3Qrb2xqbGdOM3pVdkRqLzBxQlJ1MVpZektr?=
 =?utf-8?B?MXpjZSt0QjFaV3MzUERLRVN5QzFUb09Icm1McG16dFFBR2lxLzJuQlZVY0d1?=
 =?utf-8?B?bmJBbFV3Z0FJdWt6ZXBmS3U5WHROMHdOaWY1bTNyNFMzLzFxY3ZjeTlJVWFo?=
 =?utf-8?B?MWVkK0RBS2srbTQrZ09zeHNGR2RlaThUUEljQ3RrWU9VQ3RkazlFL2I3VXp0?=
 =?utf-8?B?UGo2YytkRUFuMjdPT3hGa0ZSd2NOV0xRZEpCVlo2T1YxeDl3dzJ6cTFrbVBS?=
 =?utf-8?B?dUVFOGJzNzZtZkZVdm9UMnFIbWV1djB4T2FoZ3RabWYxSnFlSlhneTMxWVYx?=
 =?utf-8?B?YW9OSk50ajhpVU9NTG8xWTJ3NG9xWDB2T2ZLREtFWnNHd0xzbGJiWWNFeWw0?=
 =?utf-8?B?UXRUYWpLQVpibCsvNk9UUitPLzVpWnNjbkU3UW42N2VWbnRBM01IcG4vcWpP?=
 =?utf-8?B?QStFZzR1MDFPTzg0Q1pUM0taWWF3VGRyZVo5NVowYUlmOFdMeTJUVWNaVmc1?=
 =?utf-8?B?Yzg3czQvdW9BTXN6MGVZU3JPRDVOTlpGSlloaFVNMHRpSXU4bnY2aS9weXVB?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec66203-1890-4d66-59b5-08dae1ea5acf
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 17:56:29.0057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWdCBBImfYp9fR6sW0AHIB2p5cdWXPRh/6FUSWutxp1LHv+zdtlehvmyr/0QfSMmJxaDyswASbP0fFOq6bb68LMFP2IqONKByRSLWqtcjzI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6853
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2022 5:19 PM, Jakub Kicinski wrote:
> The objective of exposing the devlink instance locks to
> drivers was to let them use these locks to prevent user space
> from accessing the device before it's fully initialized.
> This is difficult because devlink_unregister() waits for all
> references to be released, meaning that devlink_unregister()
> can't itself be called under the instance lock.
> 

Sure.

> To avoid this issue devlink_register() was moved after subobject
> registration a while ago. Unfortunately the netdev paths get
> a hold of the devlink instances _before_ they are registered.
> Ideally netdev should wait for devlink init to finish (synchronizing
> on the instance lock). This can't work because we don't know if the
> instance will _ever_ be registered (in case of failures it may not).
> The other option of returning an error until devlink_register()
> is called is unappealing (user space would get a notification
> netdev exist but would have to wait arbitrary amount of time
> before accessing some of its attributes).
> 

Nice summary of the problems and options that we have tried already.

I think its also important as this can allow sub objects to be
registered after the devlink instance?

> Weaken the guarantees of the devlink references.
> 
> Holding a reference will now only guarantee that the memory
> of the object is around. Another way of looking at it is that
> the reference now protects the object not its "registered" status.
> Use devlink instance lock to synchronize unregistration.
> 

Right, this makes sense.

> This implies that releasing of the "main" reference of the devlink
> instance moves from devlink_unregister() to devlink_free().
> 

This makes sense and I think aligns more with how most references work
in practice. Good.

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Code change seems straight forward enough. I had a minor question, but:

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  include/net/devlink.h       |  2 ++
>  net/devlink/core.c          | 64 ++++++++++++++++---------------------
>  net/devlink/devl_internal.h |  2 --
>  3 files changed, 30 insertions(+), 38 deletions(-)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 36e013d3aa52..cc910612b3f4 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1648,6 +1648,8 @@ static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
>  	return devlink_alloc_ns(ops, priv_size, &init_net, dev);
>  }
>  void devlink_set_features(struct devlink *devlink, u64 features);
> +int devl_register(struct devlink *devlink);
> +void devl_unregister(struct devlink *devlink);
>  void devlink_register(struct devlink *devlink);
>  void devlink_unregister(struct devlink *devlink);
>  void devlink_free(struct devlink *devlink);
> diff --git a/net/devlink/core.c b/net/devlink/core.c
> index 2abad8247597..413b92534ad6 100644
> --- a/net/devlink/core.c
> +++ b/net/devlink/core.c
> @@ -89,21 +89,10 @@ struct devlink *__must_check devlink_try_get(struct devlink *devlink)
>  	return NULL;
>  }
>  
> -static void __devlink_put_rcu(struct rcu_head *head)
> -{
> -	struct devlink *devlink = container_of(head, struct devlink, rcu);
> -
> -	complete(&devlink->comp);
> -}
> -
>  void devlink_put(struct devlink *devlink)
>  {
>  	if (refcount_dec_and_test(&devlink->refcount))
> -		/* Make sure unregister operation that may await the completion
> -		 * is unblocked only after all users are after the end of
> -		 * RCU grace period.
> -		 */
> -		call_rcu(&devlink->rcu, __devlink_put_rcu);
> +		kfree_rcu(devlink, rcu);
>  }
>  
>  struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
> @@ -116,13 +105,6 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
>  	if (!devlink)
>  		goto unlock;
>  
> -	/* In case devlink_unregister() was already called and "unregistering"
> -	 * mark was set, do not allow to get a devlink reference here.
> -	 * This prevents live-lock of devlink_unregister() wait for completion.
> -	 */
> -	if (xa_get_mark(&devlinks, *indexp, DEVLINK_UNREGISTERING))
> -		goto next;
> -
>  	if (!devlink_try_get(devlink))
>  		goto next;
>  	if (!net_eq(devlink_net(devlink), net)) {
> @@ -158,37 +140,48 @@ void devlink_set_features(struct devlink *devlink, u64 features)
>  EXPORT_SYMBOL_GPL(devlink_set_features);
>  
>  /**
> - *	devlink_register - Register devlink instance
> - *
> - *	@devlink: devlink
> + * devl_register - Register devlink instance
> + * @devlink: devlink
>   */
> -void devlink_register(struct devlink *devlink)
> +int devl_register(struct devlink *devlink)
>  {
>  	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
> -	/* Make sure that we are in .probe() routine */
> +	devl_assert_locked(devlink);
>  
>  	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
>  	devlink_notify_register(devlink);
> +
> +	return 0;

Any particular reason to change this to int when it doesn't have a
failure case yet? Future patches I assume? You don't check the
devl_register return value.

> +}
> +EXPORT_SYMBOL_GPL(devl_register);
> +
> +void devlink_register(struct devlink *devlink)
> +{
> +	devl_lock(devlink);
> +	devl_register(devlink);
> +	devl_unlock(devlink);
>  }
>  EXPORT_SYMBOL_GPL(devlink_register);
>  
>  /**
> - *	devlink_unregister - Unregister devlink instance
> - *
> - *	@devlink: devlink
> + * devl_unregister - Unregister devlink instance
> + * @devlink: devlink
>   */
> -void devlink_unregister(struct devlink *devlink)
> +void devl_unregister(struct devlink *devlink)
>  {
>  	ASSERT_DEVLINK_REGISTERED(devlink);
> -	/* Make sure that we are in .remove() routine */
> -
> -	xa_set_mark(&devlinks, devlink->index, DEVLINK_UNREGISTERING);
> -	devlink_put(devlink);
> -	wait_for_completion(&devlink->comp);
> +	devl_assert_locked(devlink);
>  
>  	devlink_notify_unregister(devlink);
>  	xa_clear_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
> -	xa_clear_mark(&devlinks, devlink->index, DEVLINK_UNREGISTERING);
> +}
> +EXPORT_SYMBOL_GPL(devl_unregister);
> +
> +void devlink_unregister(struct devlink *devlink)
> +{
> +	devl_lock(devlink);
> +	devl_unregister(devlink);
> +	devl_unlock(devlink);
>  }
>  EXPORT_SYMBOL_GPL(devlink_unregister);
>  
> @@ -252,7 +245,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>  	mutex_init(&devlink->reporters_lock);
>  	mutex_init(&devlink->linecards_lock);
>  	refcount_set(&devlink->refcount, 1);
> -	init_completion(&devlink->comp);
>  
>  	return devlink;
>  
> @@ -298,7 +290,7 @@ void devlink_free(struct devlink *devlink)
>  
>  	xa_erase(&devlinks, devlink->index);
>  
> -	kfree(devlink);
> +	devlink_put(devlink);
>  }
>  EXPORT_SYMBOL_GPL(devlink_free);
>  
> diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
> index c3977c69552a..7e77eebde3b9 100644
> --- a/net/devlink/devl_internal.h
> +++ b/net/devlink/devl_internal.h
> @@ -12,7 +12,6 @@
>  #include <net/net_namespace.h>
>  
>  #define DEVLINK_REGISTERED XA_MARK_1
> -#define DEVLINK_UNREGISTERING XA_MARK_2
>  
>  #define DEVLINK_RELOAD_STATS_ARRAY_SIZE \
>  	(__DEVLINK_RELOAD_LIMIT_MAX * __DEVLINK_RELOAD_ACTION_MAX)
> @@ -52,7 +51,6 @@ struct devlink {
>  	struct lock_class_key lock_key;
>  	u8 reload_failed:1;
>  	refcount_t refcount;
> -	struct completion comp;
>  	struct rcu_head rcu;
>  	struct notifier_block netdevice_nb;
>  	char priv[] __aligned(NETDEV_ALIGN);
