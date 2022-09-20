Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854A85BD9AB
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiITBuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiITBuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D247253D1A;
        Mon, 19 Sep 2022 18:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EA87621E8;
        Tue, 20 Sep 2022 01:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3E56C433C1;
        Tue, 20 Sep 2022 01:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663638613;
        bh=PDUs57s3zQfxu6C1AesMhHgtBl/HbRU5UhC9pSKBWZg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b93iWSfsYbFaWzzTMJg8SMn5X9PCnH3l/DoHHWqCKSOE8oaI+ocBdPl06FVZEfNxq
         tskxhracl6cgy9dUBhfQ6E1t6CblEB2SEl0W3o3RbD93NnjTAvUVDGWPikr0hBA/UD
         DXttMgKCmHbO8QDD7YKNZmIByM9P0stLB/rQKbajUvNoAhNDBFgcNIcMXEgzbxTSnz
         Wvu7VWf0jpnLciaXONIMDmziIw1TD85cvLNVq9N/Ily035jVQVAhHEeukmHUMiSZFa
         yooeFk+D5eTS/N5EUfRnAjcGNRgzd9xE1SdVm+qH43a/1mSUiPEbTCcn2OpQG0phbS
         8I22z5xGUlUAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A43D1C43141;
        Tue, 20 Sep 2022 01:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeon_ep: Remove useless casting value returned by vzalloc
 to structure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363861366.13314.3231581815038712048.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:50:13 +0000
References: <Yx+sr9o0uylXVcOl@playground>
In-Reply-To: <Yx+sr9o0uylXVcOl@playground>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Mon, 12 Sep 2022 23:03:27 +0100 you wrote:
> coccinelle reports a warning
> 
> WARNING: casting value returned by memory allocation
> function to (struct octep_rx_buffer *) is useless.
> 
> To fix this the useless cast is removed.
> 
> [...]

Here is the summary with links:
  - octeon_ep: Remove useless casting value returned by vzalloc to structure
    https://git.kernel.org/netdev/net-next/c/ed48cfedf1e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


