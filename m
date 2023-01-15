Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C83D66B3B5
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 20:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjAOTuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 14:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjAOTuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 14:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795A912878
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 11:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0604160DC7
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 19:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CA82C433F0;
        Sun, 15 Jan 2023 19:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673812216;
        bh=dv4gyAnqBqM+vj3q/weu4McSLQgSVPXHASZBjKfqF4s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jh5yYFyoBCYEE3uFR3N1KoJy5YPlnjQIcJlhUexAFBP3J7V5MdSuGNnDPx+cvWn4F
         wElbnFu0jsAfzHI9Y/+ogOLZ2pXnPuEBo2PHi29gTP/XbSkInoGMy3CasyvgiQ5Zh5
         EM/VbHWOlOGvCTl2Mz8WBzqEL3r9mX+NlVyT1UlX7+PRt89YMV2BO0ygwPuBIEa2n+
         7dpH5yhG8IkGqS+zzDf9tuWIh7bze/tnIMClVsChbEPA1ZmfAt9Ixj1AyoEJ0OzAz8
         U5BZU/y91OtDU2pFFVGCCbEOcgiJ08rUCCz64KxM4IPqFJYzxZ3TCRf24YcQoqI0MQ
         uQ9A0tQNdE1gA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E490C395C8;
        Sun, 15 Jan 2023 19:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 v3 1/1] macsec: Fix Macsec replay protection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167381221625.28915.16674838611784337050.git-patchwork-notify@kernel.org>
Date:   Sun, 15 Jan 2023 19:50:16 +0000
References: <20230111073259.19723-1-ehakim@nvidia.com>
In-Reply-To: <20230111073259.19723-1-ehakim@nvidia.com>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     sd@queasysnail.net, dsahern@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Wed, 11 Jan 2023 09:32:59 +0200 you wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Currently when configuring macsec with replay protection,
> replay protection and window gets a default value of -1,
> the above is leading to passing replay protection and
> replay window attributes to the kernel while replay is
> explicitly set to off, leading for an invalid argument
> error when configured with extended packet number (XPN).
> since the default window value which is 0xFFFFFFFF is
> passed to the kernel and while XPN is configured the above
> value is an invalid window value.
> 
> [...]

Here is the summary with links:
  - [iproute2,v3,1/1] macsec: Fix Macsec replay protection
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=16ed170abf4b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


