Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2835232FD
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiEKMUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237729AbiEKMUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5BC9E9EF
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81E8DB822CD
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 12:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F1D5C34117;
        Wed, 11 May 2022 12:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652271613;
        bh=jRfpgEckeX4PDjPAzku5lDvCZ5OXIljoWQiUpMhuhq0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bhzNr5rnb6ng7Uk/2WWfUe1GUBoPVtVFTio5WvWAtwDIA6AuxQn3HMAqy86ce50Nr
         9vNNNv4eFSdE+3P6o/DihQxk4Szj/z0RxQZEIVn0V1Q8R6VZYE5LjwCrsnqpRZ8tKi
         rLimNmSltxAljjqixACZGlBGZluaAXWocfJkybMMhS8yntAk/5Gt2msGQJtYecqGb4
         xBmLhpMCxWPCW66EMNOLQV6aO5rtFliuOO/YP1h1Loy5A1vZ00gYy143xz99qk11+/
         FaU+Oge3UMk/zQ1ecc0m+nqUHUu8cpEVk+8aD8zRPTMpZPXIeD3OZfn558yqon9rn0
         uxDgKV1OzNwvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F6CAF03934;
        Wed, 11 May 2022 12:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: amd: remove NI6510 support (ni65)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165227161305.6774.12531142492763410761.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 12:20:13 +0000
References: <20220509150532.1047854-1-kuba@kernel.org>
In-Reply-To: <20220509150532.1047854-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, arnd@arndb.de, tanghui20@huawei.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Mon,  9 May 2022 08:05:32 -0700 you wrote:
> Looks like all the changes to this driver had been tree-wide
> refactoring since git era begun. The driver is using virt_to_bus()
> we should make it use more modern DMA APIs but since it's unlikely
> to be getting any use these days delete it instead. We can always
> revert to bring it back.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] eth: amd: remove NI6510 support (ni65)
    https://git.kernel.org/netdev/net-next/c/01f4685797a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


