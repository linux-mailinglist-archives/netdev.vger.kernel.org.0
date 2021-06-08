Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6325C3A0806
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhFHXv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231425AbhFHXv5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 19:51:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A4BF61287;
        Tue,  8 Jun 2021 23:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623196204;
        bh=WIijciGztdbF7uqqcN+U52EK6SCOx/vZqo/4CYo0GMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PtvM8uegkC7CDr9ss/Hy7fe4ZJ4WW0TV/EpKWCMCGuItnbVAGpFFP/PCLh+pE7sai
         BYeIdH1kDvEGF8J225QqoGB1jEediYwBwBaepW9LAweXKz4J6vxdUXKDU5QyhGSvdp
         z6jzk0bNNOe3iT0r0IXDJE8rZ8wIvnw7ugoAHmICxgEnI9/OH/qqvs1Fv/Y6IKqziH
         b2lmOLJhcRRjN5CtOQettXm6vH/y8U4EQMt97iO3Y+15R0Y2zrN/kpblkfXwMxxnQn
         S/aWKzkmn7kGvOjyox5gKLIo8ByTL4VekSUsFcPvUBJGFQMudaoTizlsAvNi4JaYxU
         Y5ORxUYcx/ZIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1D52C608B9;
        Tue,  8 Jun 2021 23:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch v1 net] net: ena: fix DMA mapping function issues in XDP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162319620411.30091.7406143790254613782.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 23:50:04 +0000
References: <20210608164254.4081294-1-shayagr@amazon.com>
In-Reply-To: <20210608164254.4081294-1-shayagr@amazon.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com, ndagan@amazon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 8 Jun 2021 19:42:54 +0300 you wrote:
> This patch fixes several bugs found when (DMA/LLQ) mapping a packet for
> transmission. The mapping procedure makes the transmitted packet
> accessible by the device.
> When using LLQ, this requires copying the packet's header to push header
> (which would be passed to LLQ) and creating DMA mapping for the payload
> (if the packet doesn't fit the maximum push length).
> When not using LLQ, we map the whole packet with DMA.
> 
> [...]

Here is the summary with links:
  - [v1,net] net: ena: fix DMA mapping function issues in XDP
    https://git.kernel.org/netdev/net/c/504fd6a5390c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


