Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EED569874
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 05:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbiGGDAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 23:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiGGDAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 23:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648B02FFC5;
        Wed,  6 Jul 2022 20:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CA226215F;
        Thu,  7 Jul 2022 03:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E441DC341C6;
        Thu,  7 Jul 2022 03:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657162814;
        bh=iDohzysbIgA5u75WBJw8oczhggVBq+2eCFWnUN7PnEw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DDI7I/Wc1taHL/CupzpcVQs4uncdo4CiJMW1qwPdefTP+0mytbYWJRjiFZTonyzgG
         ik4BknlpmDodPEm85lryqGsVyCKwUZjya2rxprESjCLNQzEuBiuM2BL2higslh/gSC
         3hcvbMVa0gqK/VqWQjrEqZ/jidY4Kg9IaFSszK4LAXWlw7bb88x2fpwzauj80Lh0Gt
         Bttwy7xSaIe8z/axRrevDBwOn8SKa1scACLfG7jEoLdTqWwkLtjQIRsOWrgwPbjxGh
         tt6WhD6CGtblseo8SMeAEHHG4jM8mflMgeOEflzC3J14ASAKTGNV8A9XVlTBdgVal3
         inhMhzV03oG5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF63DE45BD8;
        Thu,  7 Jul 2022 03:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnxt: Use the bitmap API to allocate bitmaps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165716281484.11165.665441439830624792.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jul 2022 03:00:14 +0000
References: <d508f3adf7e2804f4d3793271b82b196a2ccb940.1657052562.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <d508f3adf7e2804f4d3793271b82b196a2ccb940.1657052562.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     michael.chan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  5 Jul 2022 22:22:59 +0200 you wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Here is the summary with links:
  - bnxt: Use the bitmap API to allocate bitmaps
    https://git.kernel.org/netdev/net-next/c/45262522d002

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


