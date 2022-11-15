Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C37A6298DC
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiKOM3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKOM3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:29:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41BB15729;
        Tue, 15 Nov 2022 04:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668515375; x=1700051375;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7P4oJPAZaiSofeKdRg5/5gKreLO+hHbKMdnx0Lrufg0=;
  b=RnC9drQSw/JGjDgSMz55Dr8UnnGHEa0cNNpbeZ4hg+s2SP/12dBvQMQp
   XY5GvpRmjLwvtOYi6yYQ/mVXtS9XPc0ffj1cYu1p9h2ikH472LfTAvJBX
   t81X5AsVWz24JLpqiGZTphQK8/fP2OmnZ/1TN/+wu/FQgIyWAm1uEJOTZ
   yyv5WNZ+9FyvVhBxk6uk605wgbtTJu00ZISyg6zH4qmINhlVatg+eSbl/
   jaqAb8B83OE7fe/yWFxUF/+1rJy9A80RQBFAN8gbiqByvHyiXcrFgQQzT
   kiqSJw8zdQAMIqio2C5ffoNvcbkNOwAny70QDOceSqzfdjj0fBdZlhQvP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="292635255"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="292635255"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 04:29:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616737577"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="616737577"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 15 Nov 2022 04:29:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 04:29:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 15 Nov 2022 04:29:33 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 15 Nov 2022 04:29:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izXiwIw20meP1f3wUXJ7pZRnO1GZI8ilp22ZLSs2w7Z9BcUdeD/DbnVidKib8XxCh9KzO5vxgtNTiTw66SYBUvv6lJS7x965gpf77Nx5ujmH4i6PCqrYBi3ygCHrdL+OS6QxHwV5jVvzy0YabqM4d6EY+aoLG7wXztxrzATUOQRBBaAKDjgVsLmaRvsagSWNtGaNhhDINNvz3ovANrqNwm1LA5Fy3O8o1Wwb8pJhtxROr2KeR3UX8fKRczkiQpJIWrwpr61KTl8KKZ9w9j6G+QsacErQruxiuDiz/KL2eJk6N4enAPwR4HOnpLZcA7IiJPDW5ThgqQ2VLD5rqRvpgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxc3UIBSBiqPRwARqRGu3h1naLXoiTtKDJno+CvxksY=;
 b=gnJaeD5HVaM+HLHxrAkOXmC4EhCuM5AkJlouUTOIlKErvvjbYEm2D8/iup6xqwgvkcjGVDyq48XKkCeMmEMWTErm8eql4uMUF6BPGht6A04kncGKiyydqXudhnyGjl81LFby2GFC6kL+H63CI/cyGjd8xXgCzQuqdccW46NH4c/C5+9Anm96Mrmp+kiIFVhWIxBF4Mx3VT4DlndeaP5KxMF0E19YddTVozqkJfDogANjE6Se//fJk0POQ2bNIF+ULOi12AiNrIIK2FGapo0wgVgMI/UpTj9KEZLidc5Mx/LAqVUs0U9h6cu405nWhGnRJlLmRW0a1RKnqSHl28uv+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MN2PR11MB4696.namprd11.prod.outlook.com (2603:10b6:208:26d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 12:29:32 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%5]) with mapi id 15.20.5813.013; Tue, 15 Nov 2022
 12:29:32 +0000
Date:   Tue, 15 Nov 2022 13:29:26 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <jonathan.lemon@gmail.com>, <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf 1/3] selftests/xsk: print correct payload for packet
 dump
Message-ID: <Y3OGJv2lym4u86C/@boxer>
References: <20221115080538.18503-1-magnus.karlsson@gmail.com>
 <20221115080538.18503-2-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221115080538.18503-2-magnus.karlsson@gmail.com>
X-ClientProxiedBy: FR3P281CA0080.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::15) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MN2PR11MB4696:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f1e0bae-47e5-40e0-cd69-08dac7050c38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ol5j1tsh7S3ELyx+VAUfKWGvJQQdB3i7mRtM5fJapnjFm+WE8y7PMFpmK3e7h1zhPo+6A9WkxwgkmrOIiPeL5NNlfj05gdligGE1oAC+bWykKDYOFAhUSgwuJ3pTA/mbEcn4DODvNNAfTCjd5+Nk3TbVjh31lUF0cwemP9/6fc/5fxyUTFo6p814wYdvpsLszlDXEv4d/eSWEO+bodanZIE6mDvSO2NRM3HtkwXejUa8ZCzi90gjtggflsnyciYYV54RZK+SSL+aENfYANkRA6tOG6YDF5o47XAZoq9Py1aXiCSZeG7H5p+Sf9CFbdyrqf4LUL8Gfczhm++lzDkMmfgFVFzZqFWtouOq4lo1wSEpSFWVqEuQUVMhoCsctoEqYz/CwLLYAdUWvUoxhrW3qsiIzI6P8tmBVgf+TpXvk+yWJrdUsHa3bvksqpBS6MtpqCo3RbG6OOdAkfaiZkZ9cNC7CDNLDyEHH7MigjXCvUlNfJONRSJngLENQlrBVJEh05aBd82S01fNfSLeTYv7z84kqWInG+5T0UeYWh4QYlFpJyg7KmI6pwb3bEJAgOaWP9N5z6FmqDprvrd5xsD2Rl/CcmyIYOtsZKsXCLcN1TbD7oY6Kkmr3Mz5J7HTcNp046unfJwr1ybH34wpt/w3FaV18wyTh916G8fk7WKEI6C7iaT+CfkcZTl45Y/niLPD6zDbNq413w69hn+6P/b33w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199015)(82960400001)(44832011)(186003)(2906002)(33716001)(5660300002)(38100700002)(86362001)(6486002)(83380400001)(26005)(6512007)(9686003)(6666004)(478600001)(66946007)(4326008)(6506007)(66556008)(66476007)(41300700001)(8676002)(6916009)(8936002)(316002)(66899015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SBDnm4EGuR/W6IiQl4wTF4ujQIB2ZHs+RFH3UG6XXatSnvDsuF4o5TcGyfyL?=
 =?us-ascii?Q?MMeJKxRhJzzfaol8YPj4Z6Tx3lKZ/UD9DzLS44UMtAb1jaIhpH5m9Zd48uLO?=
 =?us-ascii?Q?eY1uxaptVqk52YLpqY+j1Iwovt1MFeL2KO+BhYiiA3fyaqPdUcdEAfCfKCTy?=
 =?us-ascii?Q?fuvseiPn3sgsBMNu+rR69E5sjrnWzHtpkfqqFeQzIPwM5yCeJlJPpX8tBo1N?=
 =?us-ascii?Q?5OGyCtDbEmq36xwglwFbgFUq6zQWiBNhn438i+AQZQkl1J3/uNeQV+dJwcLg?=
 =?us-ascii?Q?n0gePIWP0RA+MzdUiSqiXNt/jaGWuw0pLcXVS2lPrRXGUjewFyt3x5U+3gm2?=
 =?us-ascii?Q?/GDCEBl+bFppew0gPYaw7VP5i83I5MPtxgEvqvVNj86hNomFTeYqpOF5cnet?=
 =?us-ascii?Q?DRVlJpLXoyYEC/3j5YDVMR4hwbmRPqjd67D76skuf1aWvNYz7yM6CDkiUiCT?=
 =?us-ascii?Q?NpI1Ad/SgnOp/hwhO5TO2SC/F1HrM5KOcKcx539kD3hlvt42Bm9HPcAANbEe?=
 =?us-ascii?Q?aNh03Pj3S8RrrodaJltbgALlMKdnXfvsNUlZAGQC6YGxWlwkZ28MDm+Pu3H6?=
 =?us-ascii?Q?bhlYHKlNTUNwPB0oNhgYIFI6eW9fnx0YMKbIV+WqUs8ZVQsG68IzkiN2iI0G?=
 =?us-ascii?Q?1PR0pfiRoleL+i03LCgavDuTo8EB1z//YhxxBTHKWLugIfBV/ip0kjzrCpz5?=
 =?us-ascii?Q?9LExVLzg1wWRbEeBH4bSxiDMcshBXuNcL5wRvIZakbeU1rWiD2dlnb72aQ9w?=
 =?us-ascii?Q?yEZaJ8IFbsxMVRRRMZ9079gAFKxaQskbproR7p8A9kM2fbGGGmDp6+bB81AJ?=
 =?us-ascii?Q?+Ozx1WQgtFimceoTAhCO8OaJQo9nbuJqVJhH5vSPthAwpye5EzNTh8U++7ka?=
 =?us-ascii?Q?f8qMldOBwOshHDw9NrlHVW8hQLnKd3JA8WJJ88Knn7AGBS3YZqKx3GBu8doY?=
 =?us-ascii?Q?wschC1TUo6zcytcpO4pfSYl6Ck0w45pwWN7GlFnarQCIICsmagzLprs0m7cH?=
 =?us-ascii?Q?d4lKGZHNNFojtFISbGhEV34Fv4ZoP5ac0eD6uoo98GHvDj3tGPXiC8e4igV+?=
 =?us-ascii?Q?nB8427MJPIezFTUKZ/LpcIRrMYCeh9o00UTlfJ5foYNC+qF2BcNFcX4nj06U?=
 =?us-ascii?Q?MJdlygsjuAn2P+Zd7rkP4aRtzbg8AXrZa/6fU6/tYeUtOY2rExs+zHI2YTJ2?=
 =?us-ascii?Q?ZBlFmLj/Dli5JesQSC/2L60sixdQ09Z12FDm2ytlz3/yHVUuzrqA4YObI8TX?=
 =?us-ascii?Q?sThB3nURhevJlOquUua8QzS8ZENudalDsdMgJc3hbb6MjOqN2smVqHIS3AQM?=
 =?us-ascii?Q?RA0QLK6zGcu6VjCimm+UdEStFR2Fk2Eswtkg1BMzMzOSwrMrB8MJFuoa0cZO?=
 =?us-ascii?Q?QvNulOzIVTrY7BNiYm53X7vT9dNcg9Wo5Iqy/IEVRl8Xhlj3Fg2tiSnKyOB9?=
 =?us-ascii?Q?mW//R3WcWeP3vKwJ0i72G3DCFOwtO2XCdYyxkflGhVhmsrILZs0XdluxKsmT?=
 =?us-ascii?Q?Nc+E5Mv80DKF9w7yM68PfFhT3cfqcHdk8jkKbPDimMnAd38qOgxjlAl3KwZK?=
 =?us-ascii?Q?WxPnDzuKPuXuHIWwSSevWq7NvEJ96k2cg+2RxX5uLzWxNcZWYNle2pq5MaGu?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1e0bae-47e5-40e0-cd69-08dac7050c38
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 12:29:32.0784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cM5eP1bL5+l3AeA2hso/kHftVL9h37P7LMtivVF76aZOwcYknVKomuQEO+AlXB6PkyDOrxdIOp7RdCmaRNcevXcGKEQPBjuxzTZUHfOM/wo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4696
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 09:05:36AM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Print the correct payload when the packet dump option is selected. The
> network to host conversion was forgotten and the payload was
> erronously declared to be an int instead of an unsigned int. Changed
> the loop index i too, as it does not need to be an int and was
> declared on the same row.
> 
> The printout looks something like this after the fix:
> 
> DEBUG>> L2: dst mac: 000A569EEE62
> DEBUG>> L2: src mac: 000A569EEE61
> DEBUG>> L3: ip_hdr->ihl: 05
> DEBUG>> L3: ip_hdr->saddr: 192.168.100.161
> DEBUG>> L3: ip_hdr->daddr: 192.168.100.162
> DEBUG>> L4: udp_hdr->src: 2121
> DEBUG>> L4: udp_hdr->dst: 2020
> DEBUG>> L5: payload: 4
> ---------------------------------------

Above would be helpful if previous output was included as well but not a
big deal i guess.

> 
> Fixes: facb7cb2e909 ("selftests/bpf: Xsk selftests - SKB POLL, NOPOLL")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 681a5db80dae..51e693318b3f 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -767,7 +767,7 @@ static void pkt_dump(void *pkt, u32 len)
>  	struct ethhdr *ethhdr;
>  	struct udphdr *udphdr;
>  	struct iphdr *iphdr;
> -	int payload, i;
> +	u32 payload, i;
>  
>  	ethhdr = pkt;
>  	iphdr = pkt + sizeof(*ethhdr);
> @@ -792,7 +792,7 @@ static void pkt_dump(void *pkt, u32 len)
>  	fprintf(stdout, "DEBUG>> L4: udp_hdr->src: %d\n", ntohs(udphdr->source));
>  	fprintf(stdout, "DEBUG>> L4: udp_hdr->dst: %d\n", ntohs(udphdr->dest));
>  	/*extract L5 frame */
> -	payload = *((uint32_t *)(pkt + PKT_HDR_SIZE));
> +	payload = ntohl(*((u32 *)(pkt + PKT_HDR_SIZE)));
>  
>  	fprintf(stdout, "DEBUG>> L5: payload: %d\n", payload);
>  	fprintf(stdout, "---------------------------------------\n");
> -- 
> 2.34.1
> 
