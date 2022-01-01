Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AE848265C
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 03:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiAACuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 21:50:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54472 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiAACuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 21:50:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D611061840;
        Sat,  1 Jan 2022 02:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49316C36AE9;
        Sat,  1 Jan 2022 02:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641005409;
        bh=4isFAuSFMLuEC69cKGSOHZhQ8TBxUfw4+pkLEqc+GJ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PeYElZ/qCUeY25e338MrCpRxC3df/zJrGD4MjkCsQTb9oyFoF9ix7L6GTYVNk/9Qq
         DTGFIif5wyQdGO8ASsGZSdaoUvoG/EDkFg4VAGF2L1gRy4bN27LYrZhLe7YeERg/bZ
         xKSTUCXgmBIUiptCIkX3cnbZyiJ47OMm3pA7w8a/ywRHNixtd6NE2adpDtyWVvubPE
         hRxgAnUTNSia9wxmQyClodPqxFl84JguX7pMtt1A8YOwsDKleK7SspHxdjTu9f59+4
         VSyJeSJ87f/Kd3HnZZKhChdeoMzag5knyiyVpYuIPPPfxLaS6Df012oQPYnxgX1hX0
         OJ+avF4Qcy2HQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2FA9EC395E4;
        Sat,  1 Jan 2022 02:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2021-12-31
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164100540919.540.10261600948083342065.git-patchwork-notify@kernel.org>
Date:   Sat, 01 Jan 2022 02:50:09 +0000
References: <20211231160050.16105-1-daniel@iogearbox.net>
In-Reply-To: <20211231160050.16105-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 31 Dec 2021 17:00:50 +0100 you wrote:
> Hi David, hi Jakub,
> 
> First of all, we wish you both a happy new year! :-)
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 2 non-merge commits during the last 14 day(s) which contain
> a total of 2 files changed, 3 insertions(+), 3 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2021-12-31
    https://git.kernel.org/netdev/net/c/0f1fe7b83ba0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


