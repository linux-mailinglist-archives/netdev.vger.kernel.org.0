Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644824C9A14
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 01:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbiCBAux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 19:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiCBAuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 19:50:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2311C13F2A
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 16:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCAB46156E
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 00:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22344C340F2;
        Wed,  2 Mar 2022 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646182210;
        bh=z/EKJXoeY3Uy8xSTKIqFzSazXn0IOgQq+lxMJkIrrds=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T+fFPy6CzmDyBsQ/3TeWVDChgm9HmS4/P41yktFT7KcOm2VSJe1p/dikBO6YOfYhv
         LyKVob331V/YmtGIaEtCQxi15+C6FYN2GxtiKESydRQY+0kR5SR5W8PNjCKndUIpy7
         dBZ//lAQSdL8Ef3f1touWaRMwK9apDCZfl3G9OknWJsWfnWhTHLl+K4xnuU3pyneor
         P+KStJoVyNYJIM6Ai/6WXyhGI96SSrnolBzSkzMKL1RD93i+ubCo5b/US5CcBFANxK
         TEmwzeESO3TaJI0+l2USzjghh1+f9Kf30UV6ToydLmMYnPeiykXEA2183YpX6nhQog
         C49h96M4Gbvsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0882DE6D4BB;
        Wed,  2 Mar 2022 00:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: smc: fix different types in min()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164618221002.32166.15400460241668487690.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Mar 2022 00:50:10 +0000
References: <20220301222446.1271127-1-kuba@kernel.org>
In-Reply-To: <20220301222446.1271127-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        dust.li@linux.alibaba.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  1 Mar 2022 14:24:46 -0800 you wrote:
> Fix build:
> 
>  include/linux/minmax.h:45:25: note: in expansion of macro ‘__careful_cmp’
>    45 | #define min(x, y)       __careful_cmp(x, y, <)
>       |                         ^~~~~~~~~~~~~
>  net/smc/smc_tx.c:150:24: note: in expansion of macro ‘min’
>   150 |         corking_size = min(sock_net(&smc->sk)->smc.sysctl_autocorking_size,
>       |                        ^~~
> 
> [...]

Here is the summary with links:
  - [net-next] net: smc: fix different types in min()
    https://git.kernel.org/netdev/net-next/c/ef739f1dd3ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


