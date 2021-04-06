Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D22355F99
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242806AbhDFXkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245173AbhDFXkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:40:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C9796613CC;
        Tue,  6 Apr 2021 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617752409;
        bh=Cztl8+1YDNggIF5BPVqueMeWUuEVSSvZdOqpc6EzcUw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dzYIK5FwsDlV1ANnZwU38kFXDLZRFKU71reooy11wWVAfAQZdkkIwfZEn2CUcTnwW
         dAkJHi5QwgZnarAYuPA/pk4hIJaOaC9terwStGzWyI+u9B7AM4nkIGEFmgpNIN2VfI
         f99Et9qb5l/yvb/fMrOF5O51tVw7uQNIDbhan8GjD78Jbnd4Yeq5Cbo4838MeSl/Jk
         ereyj/oAq4RHfIxcoPdZjBmm66tgsZCHiMUv4QrQHBEh4XY8NTqdnPQ3myO+ivaL8t
         DqodnYJRVvngLMfO6AnxtvpOoOYCXqLD13+AoOmydEpX9BSxQfWZeHDWC/WAB6vfV7
         vyaomm3Stkxhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C139C60A2A;
        Tue,  6 Apr 2021 23:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-04-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775240978.19905.569061289554147402.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 23:40:09 +0000
References: <20210406103606.1847506-1-mkl@pengutronix.de>
In-Reply-To: <20210406103606.1847506-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Tue,  6 Apr 2021 12:36:05 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 1 patch for net/master.
> 
> The patch is by me and fixes the SPI half duplex support in the
> mcp251x CAN driver.
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-04-06
    https://git.kernel.org/netdev/net/c/f57796a4b80b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


