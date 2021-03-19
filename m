Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76563412BF
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhCSCUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231179AbhCSCUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 22:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2ECD164F18;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616120412;
        bh=8nn6xxtEQEInhtkEpK0Ioz8rsKzmrwyc3mIlxscVhyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F/zpSKgnUjmapPXVbo2BA+QRKFLd2gPpq52myy/cw/uF/adFQGmK37Ndl1B6YaYT1
         EeuROHTodiHdv7zXpIFzmkS5cdNaLSiUm7V+MsOpKxF+ieYtWTuqb17CwOUkInHsTC
         HXtlfJXrAQXwWhh+5liM/i9OYSxdE0xFbm8GhLjP2RIfAG7aaw1d9mjoslT2npXeaO
         kgscsTkbfRuPC3dEzdfsQysKpTfYvyxl+Z4HvriusSYhQTmj1oeaqdTelkeHhArxeS
         xuyqVbad0JvOaXGZtcxeUpENYashrC/E4KfK/MHtH7WqJdgz3I7bf5xFZgbdjyw6Po
         thFBubBGwc0/A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1E35860951;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] ionic fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161612041211.22955.13272187036066010092.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 02:20:12 +0000
References: <20210319004810.4825-1-snelson@pensando.io>
In-Reply-To: <20210319004810.4825-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 17:48:03 -0700 you wrote:
> These are a few little fixes and cleanups found while working
> on other features and more testing.
> 
> Shannon Nelson (7):
>   ionic: code cleanup details
>   ionic: simplify the intr_index use in txq_init
>   ionic: fix unchecked reference
>   ionic: update ethtool support bits for BASET
>   ionic: block actions during fw reset
>   ionic: stop watchdog when in broken state
>   ionic: protect adminq from early destroy
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] ionic: code cleanup details
    https://git.kernel.org/netdev/net-next/c/25cc5a5fac15
  - [net-next,2/7] ionic: simplify the intr_index use in txq_init
    https://git.kernel.org/netdev/net-next/c/2103ed2fab7d
  - [net-next,3/7] ionic: fix unchecked reference
    https://git.kernel.org/netdev/net-next/c/9b761574fefc
  - [net-next,4/7] ionic: update ethtool support bits for BASET
    https://git.kernel.org/netdev/net-next/c/acc606d3e4cd
  - [net-next,5/7] ionic: block actions during fw reset
    https://git.kernel.org/netdev/net-next/c/8c775344c768
  - [net-next,6/7] ionic: stop watchdog when in broken state
    https://git.kernel.org/netdev/net-next/c/9e8eaf8427b6
  - [net-next,7/7] ionic: protect adminq from early destroy
    https://git.kernel.org/netdev/net-next/c/e768929de1e4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


