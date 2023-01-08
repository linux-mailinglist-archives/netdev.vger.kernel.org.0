Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8114166158B
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 14:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjAHNpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 08:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjAHNpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 08:45:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9A0BE0D
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 05:45:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB076B80B26
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 13:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD52CC433EF;
        Sun,  8 Jan 2023 13:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673185510;
        bh=h8ty4SF01hRcyrS6KzkakItTbR1f1HLj79uobFmOA00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iVmCWa2FnyHIOvQec7PYEm2eylTI74eQXXP05R7m5DlvdNs29BSvRJ0oTtr0LUL2J
         UbIp6jRn5k1gLrRn4yUTPUFhnZLvgJxF2Ub3MHhEE7YoDtBM0PfcJUjTUs0Rh1JnRP
         Ysi+S0aO5CWmR9wMv0Cplm+n5YM9UWNYUBGJvIqcO1bvvYp3371D1E7Yp3O1oXhDdF
         N4VpeNx3gBfYhguVI8T3aG+OqBIdewSezLh1B93QQI0n9/8J6xHPxwWmpeE4az0pFs
         BWlleoiYBbL/bH1ua9+6GoGly8ePOodkGrlBwEwhwC6VMjfcqaTm1YD6e6IuP0GtGs
         7Skaj/9jI8iKw==
Date:   Sun, 8 Jan 2023 15:45:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com,
        daniel@makrotopia.org
Subject: Re: [PATCH v3 net-next 4/5] net: ethernet: mtk_eth_soc: add dma
 checks to mtk_hw_reset_check
Message-ID: <Y7rI4tH+E8Rem+Wh@unreal>
References: <cover.1673102767.git.lorenzo@kernel.org>
 <0128a91db1788deef5bc48bd7c2760d8e2d28a7b.1673102767.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0128a91db1788deef5bc48bd7c2760d8e2d28a7b.1673102767.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 03:50:53PM +0100, Lorenzo Bianconi wrote:
> Introduce mtk_hw_check_dma_hang routine to monitor possible dma hangs.
> 
> Tested-by: Daniel Golle <daniel@makrotopia.org>
> Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 106 ++++++++++++++++++++
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  26 +++++
>  2 files changed, 132 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
