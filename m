Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA4F539C5F
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 06:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349602AbiFAEuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 00:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349601AbiFAEuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 00:50:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD2252B31
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 21:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B7ABB817F0
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 04:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9CF3C385B8;
        Wed,  1 Jun 2022 04:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654059011;
        bh=mp6ebKmhlDknBpxfLUT1mS+AUH4p/f5I9GoZTZctvIA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iY6swcYpks6mbF9o9sepp+zI28OYYx8xA1FfSNbz2mERCMYA3zamshXM3U7NbQjlw
         YBOGrrh9WZvhEuouDw3djMt+r57wds+wfh8sMNhnZRTNJfBRBAPzeFuSMzd624c7Rl
         7bha8HaTzLah8M9icU9OLlt8rh6BfVkAwCxLeegMgvZQq2h3Rz6D+HhhY78LzdJoPi
         tbN6S6/KNVgZbS8rno6JchWwDW5NHTnL9jIab+R/ZGS02y+VSwOaAMa5fMRmHGNNsv
         lk7i5SOFIYb2QDN/8yh0duiwaD175oSz7eBxs5xe5SarsVfkfNcSs6hVZnYdHcWIS5
         Q8ZzISXcTqH9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1188F0394E;
        Wed,  1 Jun 2022 04:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: tcp_rtx_synack() can be called from process context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165405901178.18121.495688427897275328.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Jun 2022 04:50:11 +0000
References: <20220530213713.601888-1-eric.dumazet@gmail.com>
In-Reply-To: <20220530213713.601888-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ncardwell@google.com, ycheng@google.com,
        edumazet@google.com, laurent.fasnacht@proton.ch
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 30 May 2022 14:37:13 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Laurent reported the enclosed report [1]
> 
> This bug triggers with following coditions:
> 
> 0) Kernel built with CONFIG_DEBUG_PREEMPT=y
> 
> [...]

Here is the summary with links:
  - [net] tcp: tcp_rtx_synack() can be called from process context
    https://git.kernel.org/netdev/net/c/0a375c822497

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


