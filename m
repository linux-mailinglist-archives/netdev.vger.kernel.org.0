Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A0D33A25E
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 03:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhCNCUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 21:20:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233233AbhCNCUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Mar 2021 21:20:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D8BB464ECB;
        Sun, 14 Mar 2021 02:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615688407;
        bh=r/M2gBTOh1NrNHVrZSHIE3BRDHUYfL7Q9DPnjPKmyCo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HoSSSVYNLn84pSG9OudB044qcero+TuFaSpz3CD36MpY7c+N7ugA906d6kwgAQc8Y
         oDrpWdEF54XWUKMRoTlJdTrW8gBZz2HIsG7NFduIEud7DNF7mbFvX151VTAX1KcJVp
         ms9GD9vqhwTY2Nkjp2WOxzw0lejQdfmtSeRbvB4kWygqeCOVMzMd59bRxhr6K0Pwxu
         6pFLnO79S595g0RTAbugUrDuZDXCdrtpLAd76HvvQJFhWU6huX5mXLcCUJnsXof8RI
         10C7P0NlGtKCincu+weyOeWaM0pYnXHw1QR5AV5MFFmvYRgIPi/bLiVavJdLzEUiuy
         y4bjD0gtD1b7A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C731B60A5C;
        Sun, 14 Mar 2021 02:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] devlink: fix typo in documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161568840781.14251.4426493547774986604.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Mar 2021 02:20:07 +0000
References: <20210313000413.138212-1-eva.dengler@fau.de>
In-Reply-To: <20210313000413.138212-1-eva.dengler@fau.de>
To:     Eva Dengler <eva.dengler@fau.de>
Cc:     linux-doc@vger.kernel.org, jiri@nvidia.com, corbet@lwn.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 13 Mar 2021 01:04:13 +0100 you wrote:
> This commit fixes three spelling typos in devlink-dpipe.rst and
> devlink-port.rst.
> 
> Signed-off-by: Eva Dengler <eva.dengler@fau.de>
> ---
>  Documentation/networking/devlink/devlink-dpipe.rst | 2 +-
>  Documentation/networking/devlink/devlink-port.rst  | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - devlink: fix typo in documentation
    https://git.kernel.org/netdev/net/c/ad236ccde19a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


