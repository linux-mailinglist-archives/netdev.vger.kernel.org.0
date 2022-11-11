Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0C06254CF
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 09:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiKKIAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 03:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiKKIAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 03:00:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4652F45A3B;
        Fri, 11 Nov 2022 00:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0DFA61EC2;
        Fri, 11 Nov 2022 08:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2FE79C433B5;
        Fri, 11 Nov 2022 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668153615;
        bh=rp5s+WHWJdQXdj9VlFYO2btrCckerEkGtgYzOTDZ76M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LR93ubxCAffNpIsiFtUe0rLH43pSuXi2kJhcYsr/SjD++3XAvnBfQQL0Fdv0S4o4Q
         Uw3uiNzJb/fJLuFdN7BYNe/bDzcS9hyTmSG38nWbYPkbKxLmqmYje5Sd+VSLH72lmh
         JPm2A5nDVSJA8ibMdud2nPpwprXXsxN+x1VOyndMQtT+zTEL9P0ZgGvsraCfhhOKpS
         Y3KwK7kkmEfsU4LI48PHqKqN0WHfGUuZSfGF0xiB3+Bpl/3sC465bfQzr7KaPaazjl
         2iVkPaBuhOc/3Ld+X+gZD8/hhU2P4ks0adi1e8GnF034czIdbK0lttUwSt3hZg5LJo
         fBjE3wCxxo8fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12DF6C395FE;
        Fri, 11 Nov 2022 08:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] MAINTAINERS: Update hinic maintainers from orphan
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166815361507.21559.11527970974823578189.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 08:00:15 +0000
References: <20221109072641.27051-1-cai.huoqing@linux.dev>
In-Reply-To: <20221109072641.27051-1-cai.huoqing@linux.dev>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Nov 2022 15:26:41 +0800 you wrote:
> HINIC is marked orphan for 14 months from the commit "5cfe5109a1d7",
> but there are lots of HINIC in use.
> 
> I have a SP582 NIC (hi1822 inside which is a kind of HINIC SOC),
> and implement based on hinic driver, and if there are some patches
> for HINIC, I can test and do some code review.
> 
> [...]

Here is the summary with links:
  - [net-next] MAINTAINERS: Update hinic maintainers from orphan
    https://git.kernel.org/netdev/net-next/c/a07b3835b895

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


