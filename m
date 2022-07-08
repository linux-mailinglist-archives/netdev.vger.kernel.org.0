Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A75856B816
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 13:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237994AbiGHLKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 07:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237923AbiGHLKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 07:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BD984EFC;
        Fri,  8 Jul 2022 04:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A74A62480;
        Fri,  8 Jul 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 783E7C341CA;
        Fri,  8 Jul 2022 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657278613;
        bh=aCtXti091cuDxdiFhNRKpJ500AeRV5xrA/DHZ+VEEjg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eJVTZ8DLtJ4EmERr9ATHZ++ArfY6OXw3YUbnKZlN7p+x94/i//oawSyVJYmjj8O6i
         sP5Y9njunkYVsmFhpx90BadBynDB5Grd3uJDOFa4zvDUq2Csaao4ALKopkhggc8ZbH
         j/lFLqlzvWEoNVDzjgCvhfiLejHCZqwTiWlendGB2BNZa8Bwo72/JiDFs4AU2Y5A89
         Bv+ONlmhoRtBd6epaiGjx6/zdvo3RshLREBUEprs35cRsIM7UvzM3UELJ+3uecP5NZ
         94FZuFzFA9gt1Nvs/jqe14HCNfUTDLXkqra8jEug+u66KBpMVWMKgh4QgY3QsG3kJW
         6jLtbud8T3vsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58B90E45BDA;
        Fri,  8 Jul 2022 11:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sock: tracing: Fix sock_exceed_buf_limit not to
 dereference stale pointer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165727861336.31785.10791410995734457119.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 11:10:13 +0000
References: <20220706105040.54fc03b0@gandalf.local.home>
In-Reply-To: <20220706105040.54fc03b0@gandalf.local.home>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, nhorman@tuxdriver.com,
        davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        kuniyu@amazon.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 6 Jul 2022 10:50:40 -0400 you wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The trace event sock_exceed_buf_limit saves the prot->sysctl_mem pointer
> and then dereferences it in the TP_printk() portion. This is unsafe as the
> TP_printk() portion is executed at the time the buffer is read. That is,
> it can be seconds, minutes, days, months, even years later. If the proto
> is freed, then this dereference will can also lead to a kernel crash.
> 
> [...]

Here is the summary with links:
  - net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer
    https://git.kernel.org/netdev/net/c/820b8963adae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


