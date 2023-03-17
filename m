Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AA26BE21B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 08:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjCQHu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 03:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCQHuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 03:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495FE769C6
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 00:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EA5FB82479
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 07:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 232ABC4339B;
        Fri, 17 Mar 2023 07:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679039419;
        bh=/sDGFmeMdnhjZlK6pZoJgZ0o3ruP4FC+82NB09sBO+g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QV4DPbQrsZRGi7jkPuFHCu93KiXV5If7DFAynX7NSv9U4jsezCg9zdzoS1tP6Bm26
         cTGVTwIA9mrSXc5jI5qFPoa4rliDeEjmtWInoGlSrJIBow5f+8kqVR4qbh2bPBOBlx
         mpqf9lyDbPBeehgoyeOx+RdzyC8IA4OBXJcxK5gBFkQs0Y6BeH/aMMGLfNKDCVpV/V
         k9utxcPQmKmGsfVxabS1iR4j3DEd4uOHvHl2bPxjmL+KCYTOfIVUf1DJych1yRLc75
         9pRQTAOO/0/rrk8DfPJJUZCC2JfJWu7FvoN7PIgh+vcfifr5+X0JVFRc5vt2JoMuC7
         TUfzAjv7/4XNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 062F4E66CBF;
        Fri, 17 Mar 2023 07:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: sun: add check for the mdesc_grab()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167903941902.23387.8512925250208629429.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 07:50:19 +0000
References: <20230315060021.1741151-1-windhl@126.com>
In-Reply-To: <20230315060021.1741151-1-windhl@126.com>
To:     Liang He <windhl@126.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 14:00:21 +0800 you wrote:
> In vnet_port_probe() and vsw_port_probe(), we should
> check the return value of mdesc_grab() as it may
> return NULL which can caused NPD bugs.
> 
> Fixes: 5d01fa0c6bd8 ("ldmvsw: Add ldmvsw.c driver code")
> Fixes: 43fdf27470b2 ("[SPARC64]: Abstract out mdesc accesses for better MD update handling.")
> Signed-off-by: Liang He <windhl@126.com>
> 
> [...]

Here is the summary with links:
  - ethernet: sun: add check for the mdesc_grab()
    https://git.kernel.org/netdev/net/c/90de546d9a0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


