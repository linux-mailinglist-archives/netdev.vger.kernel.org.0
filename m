Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD6F56319A
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 12:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbiGAKkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 06:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbiGAKkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 06:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E62A7B34C;
        Fri,  1 Jul 2022 03:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A1386246A;
        Fri,  1 Jul 2022 10:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E35FC341C7;
        Fri,  1 Jul 2022 10:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656672017;
        bh=uLLR+kRtWhieUPAXiXI7WJc07BuUyFsorV/m6SnB2ro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H4Cs6tdOaHQbq6NBeGHDW8oJMgWfQrZKr88UKmhVPA38zF6l06kdM7pxgdCrECbbd
         myobEzTNf33oFUFF2rfksAaTawhZ8XtLvQ1aV9zLGdFfErWexoJYMmn7b1kw67BG2l
         3yuZD3KvZ9ma9xhIeKKVQXvkDVFGLlFMpfgjn5hlzqSo+ajkbNJXUzjSP2Ki0arcZc
         tyPXpbCAtS/06frnK7nbE9sOr7yqNi/r990mlGz6zAmE/ivNPGZYziEtyULcakRNft
         B2WPoTcF7YGX+jZqpC13sM1tZWEtxPbWIvwwuPpcfdXGljhW9SnCpqj9bYQtUvzHru
         ZIbmb4tzPl67w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5815EE49BB8;
        Fri,  1 Jul 2022 10:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet/marvell: fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165667201735.26485.18435115239377915498.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 10:40:17 +0000
References: <20220630054925.49173-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220630054925.49173-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 30 Jun 2022 13:49:25 +0800 you wrote:
> Delete the redundant word 'a'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/marvell/sky2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - ethernet/marvell: fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/1c3997b1cdb0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


