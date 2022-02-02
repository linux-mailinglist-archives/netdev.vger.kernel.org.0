Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF394A739B
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345126AbiBBOuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:50:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56036 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239892AbiBBOuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:50:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 981C360B8B
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 14:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE443C340F0;
        Wed,  2 Feb 2022 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643813414;
        bh=6HYQ47Hl6TH8Pa9/Hfq7LgNYBd1Q9EL2gPphCu/1elg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pLvmRHjd3PsXtUiQyk9RRoC61qkcC3rNtGnH4Yd4w8SCcFu6sNqSSPsHOcGQkuTYf
         2FDdQhMa/7UH9pWn4i1qUW2L6kOVA/UXTgLOW4kcffOYP8PaPZLoL6HVTPnAOhMkdV
         To50qLoMvP5Jkuq50npqgMG1y4iNjSe6DURHP1GqPyJX5CLVDEHv0wxoSUQJ+mzMQR
         KjDfchZbD1kDVsfKtE6ZwYGkDMh1Vuy/K7TSNyz5Yu8P4wAGILwyKsteYkwNy+hHY1
         dE6po7Yvv7Kmr9jc6q6hFh0ga2s5IWRo1ZXTUemoRWCpP1ycyx5eBtb39xLCF69mNC
         RdaptNSoFm2Ew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D25C9E6BB76;
        Wed,  2 Feb 2022 14:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] tcp: Use BPF timeout setting for SYN ACK RTO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164381341385.24396.15980481535136045718.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 14:50:13 +0000
References: <20220128192621.29642-1-hmukos@yandex-team.ru>
In-Reply-To: <20220128192621.29642-1-hmukos@yandex-team.ru>
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, eric.dumazet@gmail.com, kafai@fb.com,
        ncardwell@google.com, ycheng@google.com, brakmo@fb.com,
        zeil@yandex-team.ru, mitradir@yandex-team.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 22:26:21 +0300 you wrote:
> When setting RTO through BPF program, some SYN ACK packets were unaffected
> and continued to use TCP_TIMEOUT_INIT constant. This patch adds timeout
> option to struct request_sock. Option is initialized with TCP_TIMEOUT_INIT
> and is reassigned through BPF using tcp_timeout_init call. SYN ACK
> retransmits now use newly added timeout option.
> 
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v4] tcp: Use BPF timeout setting for SYN ACK RTO
    https://git.kernel.org/netdev/net-next/c/5903123f662e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


