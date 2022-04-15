Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA5A502835
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352208AbiDOKW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352263AbiDOKWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:22:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DCEAC05A;
        Fri, 15 Apr 2022 03:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C212F6221B;
        Fri, 15 Apr 2022 10:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F2C0C385A9;
        Fri, 15 Apr 2022 10:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650018011;
        bh=rN06VtNyp17zOERDLGvx0orwMt3aWVdKCk+ayFql4mU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jOyiOztXv0bf2/zqwDkv31ATm+7U8jVHTDW9f6pfd1q0tm1z/LKcCEEbnXSFsunV9
         JyvsEqJmtAw2D/BzvHvxhNuJ8FAyh7WJnYx90gh7EDxpv4shD7yIWn5ppNJKTvrcKw
         ym0HRnlY+PwEaDg6jQgWHVBdJ08ttCOX6wraKSbBDJ8KuDSRCPwLYM9tG7gbykhzZk
         ELRdqPgUjbrTh8TVxiJULmLIfAjhT9yelWCccAazqpBX3eQoN/qQKrju1d5SUq+20w
         9vmwyKy5y4HorXQmKMrwTa3kZK6RZZoMF1vhq1Vw7aYnXK1vG0TG8aEwiFZMJwofEf
         2aC9Q1JW2JEFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 04958E8DBD4;
        Fri, 15 Apr 2022 10:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: Fix sock leak when release after smc_shutdown()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001801101.12692.767949231929668750.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:20:11 +0000
References: <20220414075102.84366-1-tonylu@linux.alibaba.com>
In-Reply-To: <20220414075102.84366-1-tonylu@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 14 Apr 2022 15:51:03 +0800 you wrote:
> Since commit e5d5aadcf3cd ("net/smc: fix sk_refcnt underflow on linkdown
> and fallback"), for a fallback connection, __smc_release() does not call
> sock_put() if its state is already SMC_CLOSED.
> 
> When calling smc_shutdown() after falling back, its state is set to
> SMC_CLOSED but does not call sock_put(), so this patch calls it.
> 
> [...]

Here is the summary with links:
  - [net] net/smc: Fix sock leak when release after smc_shutdown()
    https://git.kernel.org/netdev/net/c/1a74e9932374

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


