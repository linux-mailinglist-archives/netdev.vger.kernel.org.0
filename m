Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2CE56411F
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 17:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbiGBPkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 11:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiGBPkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 11:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D633EDF73
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 08:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D79460FA3
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 15:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D44A3C341CD;
        Sat,  2 Jul 2022 15:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656776415;
        bh=0oQmlUbRHcCGhWXW1bN7QmX15/fK8qehy0LahyRw/Uk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HEg8bSiQg2ra3rKgsh/L2SqnJVWftJpKLJP+mxA/ybh/D8uRo/VBfx0ZsmviO+4nA
         XdG9LuSkRz/Vd66rM1IWWNu1+ro11FM1WhpLS3Y+IS5eNSXMC9OeY80f+R2fSC7C8F
         d4TXPc6Of5/XcFtKc3BxxUWOlRi09Ci8bUsdkfvscPQOPHFOOBCJ3sMHCCUgN7tzEa
         4Fazzcnp9/a9k5bxdMjCr0ttf70ZzpVZPypgnv8tUZaPNZp9zar/57g3sD5hzhYebi
         yR8nUJLeaqs9bJ+OQ/KScles4cKDSXMxrIk0kiFIkZVw7bNGw9KB6fJDTPLSYdBj25
         cD03YFVmeoSlA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BADA7E49BBA;
        Sat,  2 Jul 2022 15:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: add skb_[inner_]tcp_all_headers helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165677641576.21073.8745144025583761368.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Jul 2022 15:40:15 +0000
References: <20220630150750.3247281-1-edumazet@google.com>
In-Reply-To: <20220630150750.3247281-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
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

On Thu, 30 Jun 2022 15:07:50 +0000 you wrote:
> Most drivers use "skb_transport_offset(skb) + tcp_hdrlen(skb)"
> to compute headers length for a TCP packet, but others
> use more convoluted (but equivalent) ways.
> 
> Add skb_tcp_all_headers() and skb_inner_tcp_all_headers()
> helpers to harmonize this a bit.
> 
> [...]

Here is the summary with links:
  - [net-next] net: add skb_[inner_]tcp_all_headers helpers
    https://git.kernel.org/netdev/net-next/c/504148fedb85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


