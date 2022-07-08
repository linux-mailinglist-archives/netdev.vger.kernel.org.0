Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCE956BAC4
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 15:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbiGHNaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 09:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238043AbiGHNaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 09:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BE62CCA6
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 06:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20F06627A4
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 13:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 760ADC341C6;
        Fri,  8 Jul 2022 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657287014;
        bh=+LjVxoi4qmvdqAipijy1pyEsZ48lX6TRMgklPwHePIA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GYcfJ1BZR6MkDFbJ3TxrRp7KlCwKiHR5McgiQrPc+yG0zLvVNTEpO4ju7ZnyquPHw
         /qeXkHNXtlWfi4+VVk3pUWB4NmYq1IQS4nuvtb5WPun+i5MQ2AtRjDNVk5mDViw/xp
         GdJeeQLTDEQqj+FrElPC/5hTi48xS9yGNVkKzf3IrdWdNQvLsCmVIZNj/H5Q2YcaEk
         WWXxnOMLKWLDE9d1JKa6Z8xEYhSK+PWWBYoe9zvsdkR+94LzJDN7w2xe2iWvjxz13z
         CP/qsfs2z9WOMoCqypoQNp7yzR0sTxk2K5hXj0dHR5uqheaW++KVmrB4woLcT4b82N
         Y4Mq6u5v0XpqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58EAEE45BDA;
        Fri,  8 Jul 2022 13:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: minor optimization in __alloc_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165728701435.7845.11694241833008086582.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 13:30:14 +0000
References: <20220707191846.1020689-1-edumazet@google.com>
In-Reply-To: <20220707191846.1020689-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  7 Jul 2022 19:18:46 +0000 you wrote:
> TCP allocates 'fast clones' skbs for packets in tx queues.
> 
> Currently, __alloc_skb() initializes the companion fclone
> field to SKB_FCLONE_CLONE, and leaves other fields untouched.
> 
> It makes sense to defer this init much later in skb_clone(),
> because all fclone fields are copied and hot in cpu caches
> at that time.
> 
> [...]

Here is the summary with links:
  - [net-next] net: minor optimization in __alloc_skb()
    https://git.kernel.org/netdev/net-next/c/c2dd4059dc31

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


