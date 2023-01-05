Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E98465F31F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbjAERtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbjAERtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:49:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CC750054;
        Thu,  5 Jan 2023 09:49:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0191A61B96;
        Thu,  5 Jan 2023 17:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DDBC433D2;
        Thu,  5 Jan 2023 17:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672940961;
        bh=60Bisue5fYe0gu9CmvimJ0EoeLxBcGrVUCr4du+TFkg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=os3CEgTo2kQ6G/DIsxeR+iGBmeurCYKSgGPWQEh2E/PRAFC8WwZVbuMuCQ1URqbFv
         w8z0L23L8F9lsEI3wDMxr6jUgmNtBowD7E1R8lbdvVwRZ4qFmfyADxOCGC59KBYIsn
         OdUNV6NEE+CSG4kPxPAdkaVucTkJHO1WdUVyDQjCa6efTptG7wb4r5IOEZWoljx35D
         diQkEtbcUqUMUSYub7mt/PrxJaiR6zg/O5P1snFbEFyXsbsGmLlTJlX1C/+A83Z3XS
         E3j0D+idNiPTFGR5ATFDtJDWGuyc2VHqUiOr+1JoHN/AqVC/6YE1Q7BZZSs3jvk0cq
         /z8I26u2+di3w==
Date:   Thu, 5 Jan 2023 19:49:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com
Subject: Re: [net PATCHV2] octeontx2-af: Fix LMAC config in
 cgx_lmac_rx_tx_enable
Message-ID: <Y7cNnJ9KopB4Q0nM@unreal>
References: <20230105160107.17638-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105160107.17638-1-hkelam@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:31:07PM +0530, Hariprasad Kelam wrote:
> From: Angela Czubak <aczubak@marvell.com>
> 
> PF netdev can request AF to enable or disable reception and transmission
> on assigned CGX::LMAC. The current code instead of disabling or enabling
> 'reception and transmission' also disables/enable the LMAC. This patch
> fixes this issue.
> 
> Fixes: 1435f66a28b4 ("octeontx2-af: CGX Rx/Tx enable/disable mbox handlers")
> Signed-off-by: Angela Czubak <aczubak@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> ---
> v2 * remove unused macro define
> 
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 4 ++--
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.h | 1 -
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
