Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03016349B3
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbiKVWBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiKVWBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:01:32 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020DBC6D01;
        Tue, 22 Nov 2022 14:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669154492; x=1700690492;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=B/hJ/SRD1GIV+rvP7F9hh8KmjFinEt5rDHi+CEf6ASU=;
  b=DIbgjkgHw4rj67THe8qqymuikSXEC86mSuTrARcGAVpE4yuUC7sL99ZD
   p2XpEeoftfh0+USRDAa/XWq3dTqxgr3sBrHkYkQ0DErjr5ZuXbhWpe4H6
   uZul57icQJnK8yZwf10fvFgtnkCmz/TMM5MuBWSANk5fjJQBuixQhXKFv
   4M+3Ny3KU5t9sRb8uWNI91C+JfwG0hFw904UtapoBrtn2A/+3yX6VZe9e
   HgtWB7NWtiq8QhCjXJIcaaf5viQwKhX21eDrq+S43cGP8Ic78byrhKlOo
   re8gWPBc0SOolKT5W6fKeQqWDg9Zp6Bb8cMLYMVgW+w4Dz9F8gjr+QmHw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="297282575"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="297282575"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 14:01:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="730556288"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="730556288"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Nov 2022 14:01:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.13; Tue, 22 Nov 2022 14:01:29 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 14:01:29 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 14:01:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AsDNI6Jy5F9IWCexTVmTH9cG6Fgo8JOWnUTl8yR9iFANnw6p1KTsczXREZCgYNFylBXl83VnUkkw9UU3lWbiv2miS2VkuBgbMitaZvPXNOi/L6KiY72gMPisIZIXP7YOEOgLFHtbvK2/RTM21PP7twWcVha/DAiw/WnNU5nsgUMymsk1GXr/BFTIMRn2+veODv9hnA2E4Ms+GFf2GH/x5WKiUg7U2NSpwSg2IW9FLSb1lzNSnoqGlp51ZG2rFMFM8jsGtYNVjMyKnTCEZjaTjjq5WDTCUkF3oXwc2hr95I1anJ7W+MOVUhGY87Ce5jRtL5tCX3LSCMcxuN5wiyQo1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LAqNgpl2JpwI5bJck+0YYmIwIivVK2O+29bvlbXLCr0=;
 b=g6wasZdz4WXHkzUO6P/uCdQwhVLswmiFyLX7ryUbfCd4p9Gi5Zrx2BvmQwqABozJaFt1o/xrnhrvkgyRbzl4RTjm2C2SoQs9lbKkHSXyGtCj5iv6Oqvj0UMDTJUBIPELFzy+hpur6bM0DWqTHfx5y3Ljg5etNCusgrOSRJJlJ8QyzgUn5Zp+55UmdLIx0twI6CulQG7tYvHX8whCkXgu/i8SEmjWjMZ+ZYfOl0lsudCBH5QxJ6cypBITYZ9Y00ZRI4Bmd3yPGdFsrihbiJBGYzXS9i0gybBOKeA5fQXaidZNS1Vl8ajGGcjyCBWSl5OJOyqQfqIyjW0qXxbxkoUpbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 IA0PR11MB7188.namprd11.prod.outlook.com (2603:10b6:208:440::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 22:01:27 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Tue, 22 Nov 2022
 22:01:27 +0000
Date:   Tue, 22 Nov 2022 23:01:20 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <alexandr.lobakin@intel.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v4 4/7] net: lan966x: Update rxq memory model
Message-ID: <Y31GsPEhDOsCB70i@boxer>
References: <20221122214413.3446006-1-horatiu.vultur@microchip.com>
 <20221122214413.3446006-5-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221122214413.3446006-5-horatiu.vultur@microchip.com>
X-ClientProxiedBy: FR2P281CA0114.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::6) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|IA0PR11MB7188:EE_
X-MS-Office365-Filtering-Correlation-Id: ceea6a3f-40ee-40be-0053-08daccd51a82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 49Zutp/b54RaNi4TwK8lKoPfuv16fVC9p/7VIRFPb1zo1xBKFZiWchNOI3wVRkyWdliBQPy9Xr5xIGxA5yCnYiyhoPENthwsvvyAo4cU/CoA7Hs8yYWy6ACoSpD+jbxUMoQK8AjgOuDwsC309TKgzW7v3txgSFoAOOKvZ9lWHgToaF6iLSWhB3VrIhWSoaWuaRH0UE4u5Nfrt+Uy2zlaf+qRlC3Yo43HN4fA6Uh1yxiArty06u6xyNK8AP7Z84x9T4wxu/KZWgFXhWVPSG+wXd0lUdnUiL5QU6BSjo9QK+bXL1ovwV5BB4lXbsecWuNE0Ci/bf6E9KOrabI0z7AjXpE8JmhHWXEXTs1DZ5ZJEVngI4LQV/uQr1Pyf9akyZOzhFCuwuAj8suALvf/pm8zW2UCk/lvf+Y7HvUZZkrZdsBSABsFBFN/twxu39HfkfVXqUbC/gtFjedLmO1pe6JMA3aXdL/EKfiQWZ8x2GWTHIOg6lZDBgqzsAPDfmz11Lr1NH/ihUvbKipaqIc3GC1nBLCx2sz1s0c70AVVKIZHY/39WT5IAASxlDneRc1TbdfFmlNaCsgLajMtS5iBUrYIBO+wzI58nD1XBmVLziVbPajJaYcAMMk8POeER4R0f5gn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199015)(6512007)(9686003)(6506007)(26005)(41300700001)(6666004)(66946007)(66556008)(66476007)(478600001)(6916009)(6486002)(4326008)(8676002)(316002)(82960400001)(186003)(38100700002)(86362001)(83380400001)(33716001)(7416002)(8936002)(44832011)(5660300002)(15650500001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i54fQ0lPgg6sc5TjGX3nlqBsCBZeakgSsYAWrL1UZLGr7tMYzkJGgXGTcp9h?=
 =?us-ascii?Q?grvl819N5lXNSx1fu3gv8VSZPYqkxDt0/sYvkd/Rekc5C5wlXW5o6t8JfrH/?=
 =?us-ascii?Q?AgwtdlpkPFFPdLJrXsI6paMnEjQj24krfqqMbK/ofyK/hQx6KN/o5j8rhU1/?=
 =?us-ascii?Q?lq2zumEu5FUF7EEOcIYs8vj1edfFlYC2whvMwr4bWeE08o0QwhPSHV+whiPz?=
 =?us-ascii?Q?ZxMCqQVOfsgMuBUhLhmIElGteNJIDJZVUVbiDwWhVMDBnjqJqoFpq/Wvj//K?=
 =?us-ascii?Q?Dg6EzRuWRAZFKEvYG6Ub8tKsgL8gI4sSCSjiprQBQUH0fR9g87YvLaRAM0mY?=
 =?us-ascii?Q?qqMJQG/XNk860cIVrkLGs++CPQmvgZCUrP7hyNdixfMfPXhxqZW9TPmNCR+Q?=
 =?us-ascii?Q?/yJayU9QPor/XGGIAOn7LDX/gE2qprSLDrAdQf9jsqNwrpaNUDA2chdhTjBn?=
 =?us-ascii?Q?MviTxfsESYeYJBbHquIpYwhqaIceRWe8RCRjwe35NcS2r+wFcowVwS23ucB1?=
 =?us-ascii?Q?U0qyQEw8yVjjDL005/TC1Ww1JwA8ykEfV9WWB/DbHmrobYUC2AgRGRR8LyeW?=
 =?us-ascii?Q?0RQLKtqGFJZksyD30ZMuxHmn3p9Aew2uVn7dwgKesf5V5DIWTd4VE75xO9FG?=
 =?us-ascii?Q?uzgGELxrTj9IbTCtL4wd+4wjfBoPfz+GcLXCRKL854p2w3pH3HxRzAFgb79B?=
 =?us-ascii?Q?G0R+DEno6Y1dI/BSPfqIDRBbji6jr3cMQUvmV0v6S48oggyTLVwzlw0ZNU1r?=
 =?us-ascii?Q?HPHgr5cyrRCstfuSJOOLXG1GS00jwqhJfVSFIxNx3jnInIM1436Esj6SRBvi?=
 =?us-ascii?Q?e0z82ES+m3osK7BMvZgfpGjvx4MImwlMqG5n/zVsVAmJ2qyVqTEd2e28CH2a?=
 =?us-ascii?Q?w7e+FGhXVMpqgCOp91xI20n4YgU0DZjydM3jQ2SBLLTpRdsiQfXbaeMOOyK5?=
 =?us-ascii?Q?bGizMHzZlriA5EgJ6ARDmd/48tp/NbKH7OX7I/9tbqAV+yo+fbqIhPhWD+L2?=
 =?us-ascii?Q?v2ZfKsp1K+j6VoiR99vlI27TDxJwz4Wy15LbCG1fIXjaLZd8wUrEzpaFWVih?=
 =?us-ascii?Q?10IqkPzUQegRtRXT/W63o6VIAwgWGYTAfc1O+Dml9udFEXWeBLrw5z9Nj/38?=
 =?us-ascii?Q?o7gvS7q57yMV2xXzn7lPpT2DzqZtp7hg3Av8uZjl0Jw7G8qFOYDmpM7OkGo5?=
 =?us-ascii?Q?gdL8/JpwXH4zW0s6p8qAwCLwRN9BplEW6QvgQr/KBJ8iO21X/CRqqsgefzJO?=
 =?us-ascii?Q?lmT9UhAgV227e5t1oGAzf2wIQ7SeTSmXoKc1ekmKbL8UHeF+HEgnQ96MouSr?=
 =?us-ascii?Q?YztC5f3k3g2bdKH2GBvnrKFGsWXga5Gib62S4gNKNQrHV51IFM4BZf2PiZHD?=
 =?us-ascii?Q?4yJmOQv3Jz2IWpew/OHZ/Jbt+MsnEv1eutSDjg2AWm4FiBYLngtlizBeB3fx?=
 =?us-ascii?Q?Z3c0BHx/2dLDAcPYGjgvDnzZwrPjVbYmkhL1RqwnYHYgMG6P0TQ39SKUy5bL?=
 =?us-ascii?Q?Uaa9SPnZi5FhkE9Cs8bIp9gQuYl5ql6roF9xDMOC6DnFJCEs3D5TXnsd4JOw?=
 =?us-ascii?Q?fotl7SRawzmOvY5t3Rw6ZWRGIgJ0a0GBY5H2LxXmHrykDO2lbXldkJi3geAw?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ceea6a3f-40ee-40be-0053-08daccd51a82
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 22:01:27.2736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qAynuwvVkYJM8aWDc/95gZMFAiBLIueI3mWFo+rQMyjH37PUTa8On0fROuwh1wpKMkBc32iVRvECjFdMQY1v0NPjKuMhH0Jd2Fu8+xjO/MY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7188
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 10:44:10PM +0100, Horatiu Vultur wrote:
> By default the rxq memory model is MEM_TYPE_PAGE_SHARED but to be able
> to reuse pages on the TX side, when the XDP action XDP_TX it is required
> to update the memory model to PAGE_POOL.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/lan966x_fdma.c  | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> index 384ed34197d58..483d1470c8362 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> @@ -78,8 +78,22 @@ static int lan966x_fdma_rx_alloc_page_pool(struct lan966x_rx *rx)
>  		.max_len = rx->max_mtu -
>  			   SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
>  	};
> +	struct lan966x_port *port;

port can be scoped only for the loop below?

> +	int i;
>  
>  	rx->page_pool = page_pool_create(&pp_params);
> +
> +	for (i = 0; i < lan966x->num_phys_ports; ++i) {

Quoting Alex from some other thread:

"Since we're on -std=gnu11 for a bunch of releases already, all new
loops are expected to go with the iterator declarations inside them."

TBH I wasn't aware of that personally :)

> +		if (!lan966x->ports[i])
> +			continue;
> +
> +		port = lan966x->ports[i];
> +
> +		xdp_rxq_info_unreg_mem_model(&port->xdp_rxq);
> +		xdp_rxq_info_reg_mem_model(&port->xdp_rxq, MEM_TYPE_PAGE_POOL,
> +					   rx->page_pool);
> +	}
> +
>  	return PTR_ERR_OR_ZERO(rx->page_pool);
>  }
>  
> -- 
> 2.38.0
> 
