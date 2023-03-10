Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4413F6B3739
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCJHUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCJHUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4717FEBAF6;
        Thu,  9 Mar 2023 23:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D75D360D41;
        Fri, 10 Mar 2023 07:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 367CCC4339C;
        Fri, 10 Mar 2023 07:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678432817;
        bh=zciuZnbp2PhiS4g5DXZPPxBb/xwWrnYu1PzAz/zSHI4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lpmGiQrvmnMEMNObHpZYbEoQ19bLrEnhLG5sROqiwQq0PbnkpfrqwfIH3132bkO1+
         cYi+qlXWkS3m998kh5Fl1Io0Cs5xl84dTtdJ5qPs+auJNNI9yILSJOOtG6UyEsNBcI
         D8BPHFUirIqxgESRXkg8LQZS8evdf9kKE19zQXhJ5IDWj0Fq6W1CJv44awMFdW4VZv
         UVSizZgFo3sGd9cT4nTvwq5MBKZYL0K6q7Dq5TymELX0FaVrUXRSHVEne3/wAB5Xwo
         XtoDL3T4W5VNR+iQdJgtmgFigZpLLkLClrsE8j2vweF6lgJL0YHrzQuLn1YEBpB6wC
         6DzjLuzipzcCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1382DE21EEE;
        Fri, 10 Mar 2023 07:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tcp: tcp_make_synack() can be called from process context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167843281707.16830.4085596086029283726.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Mar 2023 07:20:17 +0000
References: <20230308190745.780221-1-leitao@debian.org>
In-Reply-To: <20230308190745.780221-1-leitao@debian.org>
To:     Breno Leitao <leitao@debian.org>
Cc:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        laurent.fasnacht@proton.ch, hkchu@google.com, leit@meta.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Mar 2023 11:07:45 -0800 you wrote:
> tcp_rtx_synack() now could be called in process context as explained in
> 0a375c822497 ("tcp: tcp_rtx_synack() can be called from process
> context").
> 
> tcp_rtx_synack() might call tcp_make_synack(), which will touch per-CPU
> variables with preemption enabled. This causes the following BUG:
> 
> [...]

Here is the summary with links:
  - tcp: tcp_make_synack() can be called from process context
    https://git.kernel.org/netdev/net/c/bced3f7db95f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


