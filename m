Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E00627B4D
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236369AbiKNLAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236031AbiKNLAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFC91E3DB
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 03:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 386ED60FF1
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FEC4C433D7;
        Mon, 14 Nov 2022 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668423615;
        bh=6CNvOeejULHRYGm5Amy9kAncjWu+qZfiueD0s8NAbbE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ItgWTOJYU4j048w1jbwAyggYoEvX2oK1sgPLMEigmBGDm0Eq5Mda6nJQcogjZ/ldX
         uW5SZ/VljZjCZ++Xdrgobh1V1+FMGbnqyutcsvBbZ3pOud1XXlAipmyHyxMCE9Qi34
         7AJut47rWqIv7clPRiXWCYwC5enwzmj1JNQG2VbZmqCuA6xB2xJ2ptbtEF3sXDwFIx
         bw/E4/JRZln49bIo6SvuhTRmOAxdYlj16nMqFy4T4FK+K45TRx+AJCim3Dsv49Rrgo
         grbxt5LXcvTgs+jg231ipvqPsqTG7mjEyyieaytfDyqjitSHHP5mtqrBv/wViFmOMw
         /45KpcmWQsmXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75370E50D60;
        Mon, 14 Nov 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: caif: fix double disconnect client in
 chnl_net_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842361547.12717.1461185869868349925.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 11:00:15 +0000
References: <20221111014734.337200-1-shaozhengchao@huawei.com>
In-Reply-To: <20221111014734.337200-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Braendeland@stericsson.com,
        bigeasy@linutronix.de, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Nov 2022 09:47:34 +0800 you wrote:
> When connecting to client timeout, disconnect client for twice in
> chnl_net_open(). Remove one. Compile tested only.
> 
> Fixes: 2aa40aef9deb ("caif: Use link layer MTU instead of fixed MTU")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/caif/chnl_net.c | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - [net] net: caif: fix double disconnect client in chnl_net_open()
    https://git.kernel.org/netdev/net/c/8fbb53c8bfd8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


