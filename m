Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B28B652DAE
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 09:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbiLUIJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 03:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiLUIJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 03:09:53 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4051AF14;
        Wed, 21 Dec 2022 00:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671610192; x=1703146192;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QOzoSEQ8FEQsUN2aWDDpPnisaR+4bJtN5NTGATZkgVc=;
  b=ThJG/os7Jc+s7Gu+zzxdR1Z4D8kKdqpmh/sZ7U0RyWKHg7KHwaWzvB91
   3RC6M+A90h1PvHqV4AWC2zW38m4zIuCvtUtfVFLnep+chbLBCJ+jEoh6F
   G+/m9RvLKMNkCc9JNAtPYDXzjW4CHrw2bCMg2wAV0wQgxqmy2IRgukGHx
   M/4wY4cx+DP15E0j3vINvPpbIcmiweZYG7VWB5fZSkAKGwNJ8lFMPwG1y
   zbf4jJvv38mNMujIWSi/W4N+sEQLplsJDpWJmA2p1yhmPkVilG3jEfWzy
   +tBhrqzIGywCgEg6o24PsxYZeHv0KfSW/gucP+S4PGcTQhLUV5QDiOUB7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="384163991"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="384163991"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 00:09:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="651333286"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="651333286"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 21 Dec 2022 00:09:51 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 21 Dec 2022 00:09:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 21 Dec 2022 00:09:51 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 21 Dec 2022 00:09:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5peqseBvZd3FcP/xWUo6dhqNaV1CS46Y/Xfe3khFsPHvkzP+B3aFiovlCH3EalE4HYrTc2eOPlBn0tOqJBHVgYm7S0DupsbbP2FQghpLA6SbracFPWryUEaV79YkMZc0ANjn6uuqDsgvSuMLgXrn6H4hnb8n1xTcs3OQzSVsKRP6ntVP1WGMNa66BhukCvSlCQONTgeMAw4RmHFyeRF3QxnO6G7tIZT/CzH9KjdbNizrXVbrLoFQHc9mAZ5bGvzT9TJk8LFYwFuH1Dl7SNDQO71OGhWiQmPm/rE39kGHqn468TUho9T9dLxL/r74uD42U+8MEn1sEOn/5t/VEfw8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FB+Gx8kUuPaZQUXm9OZB42PzT1fVBxNfJ7pkITXGhkI=;
 b=AZdIgOpwX95yOd2+lMv9kyHK3SGX2QJb+sr4WeytKeC4R+A4hNrrwSSR5AB0SaZnzvdzLk4wZ/ME2U8bQ5u2q2cdoibtUblYpX1jacJJJ3DyrR1kJHSiIzewmgD+Y0OL0SD8tvqPv1c5m5JjyQTd4nhBprs91TdNODQZ0N8D7pDz+wN3Rq/m5HUjcGQePTKzamAwsUlbNpci33ZCEgLYe4OvfJvHArxJrcTaebgLCoDlgcoFi3niQ/iExDvqLAni1Sc9UzLiiFaiSK85IhZQfzRGs6/qrWREcUo9AGC7GgEJmiVBfG4sT/jIUVYTtZAsmr0Fl/u1ngjcfMC/o8t0ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR1101MB2227.namprd11.prod.outlook.com
 (2603:10b6:405:51::14) by SA2PR11MB4907.namprd11.prod.outlook.com
 (2603:10b6:806:111::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 08:09:44 +0000
Received: from BN6PR1101MB2227.namprd11.prod.outlook.com
 ([fe80::5d3a:5bc9:4e57:622e]) by BN6PR1101MB2227.namprd11.prod.outlook.com
 ([fe80::5d3a:5bc9:4e57:622e%7]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 08:09:44 +0000
Date:   Wed, 21 Dec 2022 09:09:30 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        Robin Cowley <robin.cowley@thehutgroup.com>,
        "Chandan Kumar Rout" <chandanx.rout@intel.com>
Subject: Re: [PATCH net 1/1] ice: xsk: do not use xdp_return_frame() on
 tx_buf->raw_buf
Message-ID: <Y6K/OimNEzWMN1bS@praczyns-desk3>
References: <20221220175448.693999-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221220175448.693999-1-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: FR1P215CA0023.LAMP215.PROD.OUTLOOK.COM
 (2603:10d6:201:1::33) To BN6PR1101MB2227.namprd11.prod.outlook.com
 (2603:10b6:405:51::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2227:EE_|SA2PR11MB4907:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b84de08-ed93-4336-4fa6-08dae32ab7e1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lx6mMhg+huen7+WfwL90/CJxPybiXUYt0YXTyFC3W6FGCwadUHVKY5YkMSGPlzDmrBf41QS1VDglHHdmla3HtUTRRS/Z7LtDUbiranJA+6bqnMZVQDf3fPpH+NYc+G289DA3YQ5XbKh6hGEii+xhiupoV/vdFj2/1OJU539SwIAMV4ndd/DuJAL1B8K1l/O0WactSroBDslFTglIiIg5kuWhrSO0sWoYXNriIHp5krFSskhalF3YoH8vpIxi/kIuvqL7XOr2hzIyAX/KtMy+1HauR4UMm2Sjn2xKfZ0i+ekdq6bcANoeYgNg2PDCY/GmTLFd0N8In2liaxf2tj2Uge7u3aCC/qzjh4Xh2XbgOEMGYHzG6RBuIO4DMbGxn/mycS9YE0IidiWqp22+aBDmK0IdBlMU/r5RF9Hs8IVbfMYgqj6GnZCRu5n58mgRrtwwHjDuijJtj/ZlRg4av4mlxLyujb4MRElZtiqkqHlwjwW8iJ1t0a5yvwPY/bwxRBT59Fpl0WpmN2mlxCmo1ZC+t3YXGnj0pKk+4Po8xiz6OBt7eUE75od/s4Ntc3U2Jlgj1hakCfH4Mr/F98FeDh/MfeGtC8+wexcCqHdi248/wFH0I4BhvgGwiAB6G9Jy6wSSUElxutUTmMzA74jGg+v71Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2227.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199015)(44832011)(82960400001)(6486002)(54906003)(6636002)(38100700002)(478600001)(7416002)(2906002)(316002)(5660300002)(8936002)(6862004)(66946007)(86362001)(66476007)(66556008)(8676002)(4326008)(83380400001)(26005)(41300700001)(33716001)(6506007)(186003)(9686003)(6512007)(107886003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SHr9c/X1ueU9JUJDAVaP2+mqLuc4dNe7XH6+SKY0vkxewj1dIzcYIG/WIob/?=
 =?us-ascii?Q?XpIufbrxmJCaIYIpeZzMpXstWb+5tsF9a0PL8oj7DAjdX8yfNAIUUo5gQfRb?=
 =?us-ascii?Q?ZsM8tcoAdl7pqW5c3VsLHvjPD2cbYevxiO/2cy3XXiNiKDRGP3Y9Sjya6Czz?=
 =?us-ascii?Q?FTixLj9fDi8NO34gnFZfiS0zTNE55JL8uNNP5SY52qL4j4QtkVN5NKEF6hds?=
 =?us-ascii?Q?R25caWNdEWQcjtwZOoJEUzZ2pXAJV0ddHWJCSgqyUs+LFrd8PdQ5U31xWE8G?=
 =?us-ascii?Q?HQXLWuYUMosnvtajNqFwIeKkrieeFYPlMiMh3Wxn2U60BpOdcvDErJYlG+6e?=
 =?us-ascii?Q?W7bBJzho9PKeCW1mk1fOLLq/cge9Rqm5U1dVdtQaUZlF6mkJjVgyh3F14EIf?=
 =?us-ascii?Q?e4DpeUeYnXaL0K8D+Vn+Zhf4R8JbhXBDPZF5UqD+iRiarS3JGYFeE8+8fDw5?=
 =?us-ascii?Q?FPajNgCJn9ZpIdZZZ/JXbvgBIcqU5e/BDaCcibSj8vUA33k8XpxU+EMv29T5?=
 =?us-ascii?Q?2+uXBLyDiNjViQZ0feLRA1AjUqXglTUrbMpwMacuao3gE7hoCS9jH1Vo4Wu/?=
 =?us-ascii?Q?zd5n/wwYHysHHWAMTWNlzHvB0bamsvPtH80uRH7tO2fmULyWhbjGvsmyuCIq?=
 =?us-ascii?Q?gzwlA/Qib94A00YjXx+1nK8D/k84+vECtO9akWG+TSQYNPy0/MxB9MwN23Vy?=
 =?us-ascii?Q?+kZseSsUjQ47hBg8l6AACW09I6JFHLHzANb0L1D+SEOfl4DFj7WVzOBJv/xE?=
 =?us-ascii?Q?ZcTT4cJiWeeHGuKRtq3+mbhfoNOuAbHJsdNxmY6x/tdnYh9UNUlKt+FlGP5s?=
 =?us-ascii?Q?4mGv9AQLjRBrH6le9OzEuQOrIOi9c6UVAAAAe2H5ytYW7MWSw363PpXaJ/Y3?=
 =?us-ascii?Q?58tAcCPjDuCM74VPOmyNodaVJ8IaN3Q+XgnJ7/auwe28zSY/70Tzbbohmoix?=
 =?us-ascii?Q?jhtxqQa47iEA6DCR7dExo9gfBiOIXgOHgA5YeYQaFREjmTZS+g1xd7p+dAj2?=
 =?us-ascii?Q?dYJxaNR/PjdXOJStBfKKGi2qzTiaGx4ZhSgHwrRwWoCNzvBmuuHRHLj8GtvK?=
 =?us-ascii?Q?5dy0Bg1nuYZy23Yg8SnTz4tPlhYmrdTkGLda+gJco8LuWlrafX8K3+5nrgu6?=
 =?us-ascii?Q?gCzsMMv58ZXVGEKTR/AjST02kfs6Ox/cDLwhXKRiFcDBoR09b2Fo87QgdI3b?=
 =?us-ascii?Q?1XGEBFLRAXUSAVGDsgPj9qCUDVpadnZWi6ptyfyfS5/iFsEU68ZuSH4Kxr3Z?=
 =?us-ascii?Q?2UOIrejB2mnelrhsTv/+ckTS1quFP3MeIeFL78agBPYqm7bB+xMy4Ezfj5CM?=
 =?us-ascii?Q?neJ4FGL/DYUxQ8vtHiv0kVBQ6OQ7IuJJ3AFsGFLZf8aYLcszid9BjFotMiRK?=
 =?us-ascii?Q?J2FXJDbTHp0MxIXfCa9OEcqT5o12Odz87EPUzLZF+jXYTWaLEVQnspkjlNkF?=
 =?us-ascii?Q?JMb3Y5agymz9sVuvKYSBmjMcG/EZY8l8oRTDPPnsdIri+9YHA7QGx1XIAOqC?=
 =?us-ascii?Q?sc/11FR4h2S6vwPZaQm5H8voomNlOya2tOAMusXHy6KhhCKFpRRolVmSYhUz?=
 =?us-ascii?Q?CnqbZf1sGPUSk8jF9Pa+6YxDwY/+pxKj4pOqm/qHzhNADSk5IoFwEvhUFeaS?=
 =?us-ascii?Q?kQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b84de08-ed93-4336-4fa6-08dae32ab7e1
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2227.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 08:09:44.1974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EObyhBm9XHPfovutpGCjgLVtcCwqIlzLWW6tmmL2547lrB3p/tg9nnTfhtavKR93TFvMZ2E5C/6rLyJSmuumASsRrhRvcIfhAYk0jU7POPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4907
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 09:54:48AM -0800, Tony Nguyen wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> Previously ice XDP xmit routine was changed in a way that it avoids
> xdp_buff->xdp_frame conversion as it is simply not needed for handling
> XDP_TX action and what is more it saves us CPU cycles. This routine is
> re-used on ZC driver to handle XDP_TX action.
> 
> Although for XDP_TX on Rx ZC xdp_buff that comes from xsk_buff_pool is
> converted to xdp_frame, xdp_frame itself is not stored inside
> ice_tx_buf, we only store raw data pointer. Casting this pointer to
> xdp_frame and calling against it xdp_return_frame in
> ice_clean_xdp_tx_buf() results in undefined behavior.
> 
> To fix this, simply call page_frag_free() on tx_buf->raw_buf.
> Later intention is to remove the buff->frame conversion in order to
> simplify the codebase and improve XDP_TX performance on ZC.
> 
> Fixes: 126cdfe1007a ("ice: xsk: Improve AF_XDP ZC Tx and use batching API")
> Reported-and-tested-by: Robin Cowley <robin.cowley@thehutgroup.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index 907055b77af0..7105de6fb344 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -783,7 +783,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
>  static void
>  ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
>  {
> -	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
> +	page_frag_free(tx_buf->raw_buf);
>  	xdp_ring->xdp_tx_active--;
>  	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
>  			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
> -- 
> 2.35.1
> 
LGTM

Reviewed-by: Piotr Raczynski <piotr.raczynski@.intel.com>
