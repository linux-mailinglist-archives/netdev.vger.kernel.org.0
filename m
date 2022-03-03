Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1474CB759
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 08:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiCCHA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 02:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiCCHA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 02:00:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910F432067;
        Wed,  2 Mar 2022 23:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34C926197E;
        Thu,  3 Mar 2022 07:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 874EFC340E9;
        Thu,  3 Mar 2022 07:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646290810;
        bh=dhCFnKdOs/pxQNk1NhM5E/S4Xg1k4C3OL94VoKl7dWA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YfHaJjD+68xn9YETeGNSAaJCA6Pa0VjJJRScx/LuoIaxBOcMza2miSVvhWPv9lg6J
         6VEPSt9hu86W/akL6NdPH0vju+E/AXXDLTg7fLp46O0PD3R0NTHbd08pFEqBf5GUKk
         4onqzBR7KLs6R0R/qmxLMhVE0ZB1moUHSnN4cZOzHtd6EltTEaaGe3Ez3Hft2Xnvas
         V8ZXHTar0q4wVtdhLLc0/SnKI+WlmhsJ0tyUHJCZ95b1IAea9r3NA+JswLbqpaq57b
         v6TmycEVCxRO+86axikCzs1h0oP7P1ALGlapqYmK+vw/+fF4CjKHUcNPjR9TtxWFIa
         ykRcStjbtIY/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A53EEAC096;
        Thu,  3 Mar 2022 07:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] bpf, sockmap: Do not ignore orig_len parameter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164629081042.23910.10991604475899860456.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 07:00:10 +0000
References: <20220302161723.3910001-1-eric.dumazet@gmail.com>
In-Reply-To: <20220302161723.3910001-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, edumazet@google.com, ncardwell@google.com,
        syzkaller@googlegroups.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  2 Mar 2022 08:17:22 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Currently, sk_psock_verdict_recv() returns skb->len
> 
> This is problematic because tcp_read_sock() might have
> passed orig_len < skb->len, due to the presence of TCP urgent data.
> 
> [...]

Here is the summary with links:
  - [net,1/2] bpf, sockmap: Do not ignore orig_len parameter
    https://git.kernel.org/netdev/net/c/60ce37b03917
  - [net,2/2] tcp: make tcp_read_sock() more robust
    https://git.kernel.org/netdev/net/c/e3d5ea2c011e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


