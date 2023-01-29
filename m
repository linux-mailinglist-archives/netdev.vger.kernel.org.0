Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4543767FEED
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 13:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbjA2Mgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 07:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjA2Mgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 07:36:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE1222A24;
        Sun, 29 Jan 2023 04:36:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81B8E60C70;
        Sun, 29 Jan 2023 12:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CF2C433EF;
        Sun, 29 Jan 2023 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674995780;
        bh=BnaDTaUpxxgmGNb6SekVLEnP5eTzdC3XaSBMXtPeRCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GV5cwY4r1qe7uqw3mhqpwU+3cZLvmqFus5dbs3BfKsZpcyTBPifAUQDUYlYvNIlR7
         ZsnNufK9D0eJuDrkseNa1dA1FoEJKoRUP+2ZPxgc5+z9/ygWJHQ0X5L6cLdT0PTpVg
         E32X/wL6UMmjs09L3QrZyU7ZQJcnXzK0MKngCDhAReCe1Ndw7U7P4wlfPhXoM+FKDc
         ywJmv4XX+qbHKCUrZhovhiXFkSZQY5zGpoVvXhikgdjVtHZWJLMRbR7sjYBHY2xRTJ
         TK6xoJ7PyuNtTVoPT3AIwpph33Jj6eWtxfcUrWLJA/hk1At3BhAy7xu96hGAAxNDC+
         FbjXGN11WjuQQ==
Date:   Sun, 29 Jan 2023 14:36:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com
Subject: Re: [net PATCH] octeontx2-af: Removed unnecessary debug messages.
Message-ID: <Y9ZoQP9gO53smbhj@unreal>
References: <20230127094652.666693-1-rkannoth@marvell.com>
 <20230127094652.666693-2-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127094652.666693-2-rkannoth@marvell.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 03:16:52PM +0530, Ratheesh Kannoth wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> NPC exact match feature is supported only on one silicon
> variant, removed debug messages which print that this
> feature is not available on all other silicon variants.

I would say that this is net-next patch and not net. 
You simply remove debug prints.

> 
> Fixes: b747923afff8 ("octeontx2-af: Exact match support")
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/af/rvu_npc_hash.c    | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> index f69102d20c90..2c832469229b 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> @@ -200,10 +200,8 @@ void npc_config_secret_key(struct rvu *rvu, int blkaddr)
>  	struct rvu_hwinfo *hw = rvu->hw;
>  	u8 intf;
>  
> -	if (!hwcap->npc_hash_extract) {
> -		dev_info(rvu->dev, "HW does not support secret key configuration\n");
> +	if (!hwcap->npc_hash_extract)
>  		return;
> -	}
>  
>  	for (intf = 0; intf < hw->npc_intfs; intf++) {
>  		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY0(intf),
> @@ -221,10 +219,8 @@ void npc_program_mkex_hash(struct rvu *rvu, int blkaddr)
>  	struct rvu_hwinfo *hw = rvu->hw;
>  	u8 intf;
>  
> -	if (!hwcap->npc_hash_extract) {
> -		dev_dbg(rvu->dev, "Field hash extract feature is not supported\n");
> +	if (!hwcap->npc_hash_extract)
>  		return;
> -	}
>  
>  	for (intf = 0; intf < hw->npc_intfs; intf++) {
>  		npc_program_mkex_hash_rx(rvu, blkaddr, intf);
> @@ -1854,16 +1850,12 @@ int rvu_npc_exact_init(struct rvu *rvu)
>  	/* Check exact match feature is supported */
>  	npc_const3 = rvu_read64(rvu, blkaddr, NPC_AF_CONST3);
>  	if (!(npc_const3 & BIT_ULL(62))) {
> -		dev_info(rvu->dev, "%s: No support for exact match support\n",
> -			 __func__);
>  		return 0;
>  	}

You need to remove { } brackets too.

>  
>  	/* Check if kex profile has enabled EXACT match nibble */
>  	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX));
>  	if (!(cfg & NPC_EXACT_NIBBLE_HIT)) {
> -		dev_info(rvu->dev, "%s: NPC exact match nibble not enabled in KEX profile\n",
> -			 __func__);
>  		return 0;
>  	}

Ditto.

>  
> @@ -2005,6 +1997,5 @@ int rvu_npc_exact_init(struct rvu *rvu)
>  		(*drop_mcam_idx)++;
>  	}
>  
> -	dev_info(rvu->dev, "initialized exact match table successfully\n");
>  	return 0;
>  }
> -- 
> 2.25.1
> 
