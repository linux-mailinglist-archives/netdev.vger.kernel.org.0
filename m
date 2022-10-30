Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1BEC6128FE
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 09:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJ3IQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 04:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3IQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 04:16:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FC5267
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 01:16:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C729160B88
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 08:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6865EC433D6;
        Sun, 30 Oct 2022 08:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667117800;
        bh=PN4xCUSNDQA1YfStIttqniRpnc5FWE8xJudEQIYRDRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ris92oJHYz8JAg8PnExby+oK9W7y+54SbX1d9QDsWm9kS4gb2anhWE0IU+Dl60sXp
         YRr4Putmq/UtrT1O6kd+/2vBeQcUznHsbZ88hB7S4Y8KndsL1ZbYfU72pmq8TbdLYN
         NmzKAAOt5mVN3tX8uc/t/gSU9PoIHUIuNuo98pMiwDlyXyCzg9ERopgWKKlOEZqRD6
         8OZ/IPOE5N+G5HMuefFhOFxil9xV1rmf9v0ic2dTEppjJpDxAyw+aPcNgx5FR1eA9C
         wvT1sGHrYxodCfDbE1gE27jGTrGxLf7eHMrm/PL1nabd7fnuwbNyFCarseXLUFRld5
         Meqy8j6BCXWwA==
Date:   Sun, 30 Oct 2022 10:16:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net v2 5/5] macsec: clear encryption keys from the stack
 after setting up offload
Message-ID: <Y14y4yJS/ZXmfsvf@unreal>
References: <cover.1666793468.git.sd@queasysnail.net>
 <685b32aea1db3864560f7c72f280bd44ac7b3450.1666793468.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <685b32aea1db3864560f7c72f280bd44ac7b3450.1666793468.git.sd@queasysnail.net>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 11:56:27PM +0200, Sabrina Dubroca wrote:
> macsec_add_rxsa and macsec_add_txsa copy the key to an on-stack
> offloading context to pass it to the drivers, but leaves it there when
> it's done. Clear it with memzero_explicit as soon as it's not needed
> anymore.
> 
> Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  drivers/net/macsec.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
