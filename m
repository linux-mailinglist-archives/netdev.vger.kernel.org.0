Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B294A590F76
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 12:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238474AbiHLKaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 06:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbiHLKaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 06:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263385FA8;
        Fri, 12 Aug 2022 03:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D6A16166E;
        Fri, 12 Aug 2022 10:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0170C433D6;
        Fri, 12 Aug 2022 10:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660300216;
        bh=hiSM/bbuTPIVJNBggcPfAoMfkcFE+eB4niJGjlsyT+o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VP/caZKV3Xcnu7G//RTOgTJtkDX5CRvFGJ3mLqSxI8FcWQ1HFnXgF+jUS/4RUaptH
         MbCGMClTyvVmr8G7pJycRInJugNr7IFfzs4rKmFgtMyH1hjSQEctwqY1smhFlEufsE
         eXIRW/R2ItxVpPJrvp6Ofjkc6GikoUOlyRDW0Kes/VcQ13X5mT8lKuDDHLyxoNr8s5
         S+QaZJUD/juWOmZZ4kmojAmmdCp/PGpVOXbMR9W7z4fJqVks27Orm4LrK4Fw8gSDdV
         T5mdFXhiHJU+QDZmiFqIuWlc3ahADhBHwgYpbvYWcXh1KWTDGNlNMOcjLfIYZwWqxw
         e6yDv9Vz5WBcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83CF7C43141;
        Fri, 12 Aug 2022 10:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnx2x: Fix comment typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166030021653.10916.10271329346132079458.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Aug 2022 10:30:16 +0000
References: <20220811115620.3596-1-wangborong@cdjrlc.com>
In-Reply-To: <20220811115620.3596-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     edumazet@google.com, aelior@marvell.com, skalluru@marvell.com,
        manishc@marvell.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 Aug 2022 19:56:20 +0800 you wrote:
> The double `the' is duplicated in the comment, remove one.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - bnx2x: Fix comment typo
    https://git.kernel.org/netdev/net/c/0619d0fa6ced

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


