Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FDE3A200B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhFIWcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhFIWcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BD455613E3;
        Wed,  9 Jun 2021 22:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623277805;
        bh=iNdCoAF8rT47oMJWWX3PRepLiTvOfDGodzhN8zzWGMo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EpObuBJc62jsWzzMQISpgSWTeAp7PSBvUPjzxzUY5KRhmidrqfbq4u4dDi7EwmSQj
         9ISFk5pbrqpp8wLEWYMcJ4ce+qzJBEZ6DOgq5x+nc8l0Wqsoz2kkCtO98drdLa2wFV
         E7+805Ev6Voa3HRlHaVUVScJacENnEgWcAdrWhdtF4COVeSpFAuyxN0XDBT6p6k/4n
         2ndz0hNRW5Hirp5SGfs0vwf4MC81AE9mZX53dE8SpB3W+itts4b/FUFYMSQQcB1z7W
         IWFPc3FfS5g6IUeVc7DOsbZ+DuLM4uogbeJzx//5BfSro0HufMVHEvtJ9hJE41apH8
         B7LLfWLhgDESw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B0F96609E3;
        Wed,  9 Jun 2021 22:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] mvpp2: prefetch data early
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327780572.20375.10241142073927075009.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:30:05 +0000
References: <20210609134714.13715-1-mcroce@linux.microsoft.com>
In-Reply-To: <20210609134714.13715-1-mcroce@linux.microsoft.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, sven.auhagen@voleatech.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 15:47:12 +0200 you wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> These two patches prefetch some data from RAM so to reduce stall
> and speedup the packet processing.
> 
> Matteo Croce (2):
>   mvpp2: prefetch right address
>   mvpp2: prefetch page
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] mvpp2: prefetch right address
    https://git.kernel.org/netdev/net-next/c/d8ea89fe8a49
  - [net-next,2/2] mvpp2: prefetch page
    https://git.kernel.org/netdev/net-next/c/2f128eb3308a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


