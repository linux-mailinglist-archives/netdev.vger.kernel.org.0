Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5870663FF5F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiLBEKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiLBEKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2934DD11E8
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 20:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADAA260EB4
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 04:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15C08C433D7;
        Fri,  2 Dec 2022 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669954217;
        bh=Nwrb6hmii3Vg8p3lNXbi5lGJEz4c81APOHTW/LRxjvc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TWMgs0iEnSyMtXiTKkJofcJjtNDvacXp9PYyZktEpxfaKfj3hx81vrEeTZWo3UAPh
         THuoaYHmo8jXxvq4Cl0svql3knrP6iarVnbNNM+6eMA6XZ6lNsOyZOc5TD5D9z/oFX
         zrLEex85tNYy3DRl8dCvT2B/MC9KMlaT8+RqvnbGtMEkANjYfGKEQ1IalBPBup9Ci5
         yQGW/UlU7kzBIXlD6k44wraL/QRcn2iN3HA764kWS+un6IFQCCaCIKf0PbI7ZEGcTq
         EHMliYsB+kHD8c7enLZ4vrkmkQdxZHfkCYk3Exko/3nj8i/VK97gd0VAjWwnnwfZ6D
         FDQbiqljbnQ0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0D1EE29F38;
        Fri,  2 Dec 2022 04:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] bnxt: report FEC block stats via standard interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166995421698.16716.12823724859274714432.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 04:10:16 +0000
References: <20221130013108.90062-1-kuba@kernel.org>
In-Reply-To: <20221130013108.90062-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, michael.chan@broadcom.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 29 Nov 2022 17:31:08 -0800 you wrote:
> I must have missed that these stats are only exposed
> via the unstructured ethtool -S when they got merged.
> Plumb in the structured form.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: michael.chan@broadcom.com
> 
> [...]

Here is the summary with links:
  - [net-next] bnxt: report FEC block stats via standard interface
    https://git.kernel.org/netdev/net-next/c/a802073d1c9c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


