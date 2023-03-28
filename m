Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11836CCB2D
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjC1UDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjC1UDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:03:39 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A66DD8
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680033819; x=1711569819;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=/V5PSNpfgFxxRL7qeDkokPVMuD4tx3c6nGKThjtyb6E=;
  b=D49QHUMj6QgocDLqaiCh2WfZal3ePuFSqDP2Fj/JUhJcc/xWegAb9A4u
   c/GvxyRe5hDPb4SCFigv0RrVirjB46kWoCQ3CV7qkCLfX78ebowg72hw7
   6yW3HtP+WSyN80nocN8nevC9uqYpGubmPVmV038go9seALkDHLi5BoLBu
   8=;
X-IronPort-AV: E=Sophos;i="5.98,297,1673913600"; 
   d="scan'208";a="198452983"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 20:03:21 +0000
Received: from EX19D011EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com (Postfix) with ESMTPS id 4F46D410A7;
        Tue, 28 Mar 2023 20:03:19 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D011EUA004.ant.amazon.com (10.252.50.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 28 Mar 2023 20:03:18 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.176) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 28 Mar 2023 20:03:12 +0000
References: <20230328151958.410687-1-horms@kernel.org>
User-agent: mu4e 1.7.5; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Simon Horman <horms@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Arthur Kiyanovski" <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        "Noam Dagan" <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>, Tom Rix <trix@redhat.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ena: removed unused tx_bytes variable
Date:   Tue, 28 Mar 2023 23:02:11 +0300
In-Reply-To: <20230328151958.410687-1-horms@kernel.org>
Message-ID: <pj41zlmt3wbq4k.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.176]
X-ClientProxiedBy: EX19D038UWC001.ant.amazon.com (10.13.139.213) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-10.0 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Simon Horman <horms@kernel.org> writes:

> clang 16.0.0 with W=1 reports:
>
> drivers/net/ethernet/amazon/ena/ena_netdev.c:1901:6: error: 
> variable 'tx_bytes' set but not used 
> [-Werror,-Wunused-but-set-variable]
>         u32 tx_bytes = 0;
>
> The variable is not used so remove it.
>
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index e0588a82c8e5..e6a6efaeb87c 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -1898,7 +1898,6 @@ static int ena_clean_xdp_irq(struct 
> ena_ring *xdp_ring, u32 budget)
>  {
>  	u32 total_done = 0;
>  	u16 next_to_clean;
> -	u32 tx_bytes = 0;
>  	int tx_pkts = 0;
>  	u16 req_id;
>  	int rc;
> @@ -1936,7 +1935,6 @@ static int ena_clean_xdp_irq(struct 
> ena_ring *xdp_ring, u32 budget)
>  			  "tx_poll: q %d skb %p completed\n", 
>  xdp_ring->qid,
>  			  xdpf);
>  
> -		tx_bytes += xdpf->len;
>  		tx_pkts++;
>  		total_done += tx_info->tx_descs;

Thanks for submitting this change.

Acked-by: Shay Agroskin <shayagr@amazon.com>
