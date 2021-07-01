Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CC23B9721
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhGAUWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232113AbhGAUWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 16:22:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 504BB61416;
        Thu,  1 Jul 2021 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625170806;
        bh=igiiiI7bmYyrms3VOQ1TlbR2ORuUpoQUwcPnglcTAQ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dCAPj02znvCYkLSZc6CIkYvaCBIh5KzJw8l34hWqIdTlJSuDNfLMtC0XauFIjevjS
         ozAWq/PUfzbG9K1Q4EUuRo1gf2ELZmpTjkWhjOVkV6J1Gq2KZ16X4RSy1ppvznR/DP
         oBS0z9M+zZAd2U5DU/gVSsDgHfFFvSqTX5IiQ+IjNlSORqt9iJpuHvmtvYcPQdhRjA
         BA0c5LaV8mRlrCh7vgXeHqlYSgA+qJThlcvToag+F/wpLXHMXTcwfFxJSZTNZNjYTi
         nUdfaN3f6rMijtVEFeDdvZj09WW0AqovBhN9+lJgTm04mEYAhcfr9w7yhRjXa28bfe
         5oiHLz2Nwh+cQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43E0F60A6C;
        Thu,  1 Jul 2021 20:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 1/5] net: wwan: iosm: fix uevent reporting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162517080627.9938.15088340708232753641.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 20:20:06 +0000
References: <20210701150706.1005000-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20210701150706.1005000-1-m.chetan.kumar@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  1 Jul 2021 20:37:06 +0530 you wrote:
> Change uevent env variable name to IOSM_EVENT & correct
> reporting format to key=value pair.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> ---
> v2: no change.
> 
> [...]

Here is the summary with links:
  - [V2,1/5] net: wwan: iosm: fix uevent reporting
    https://git.kernel.org/netdev/net/c/856a5c97268d
  - [V2,2/5] net: wwan: iosm: remove reduandant check
    https://git.kernel.org/netdev/net/c/3bcfc0a2d319
  - [V2,3/5] net: wwan: iosm: correct link-id handling
    https://git.kernel.org/netdev/net/c/5bb4eea0c5f5
  - [V2,4/5] net: wwan: iosm: fix netdev tx stats
    https://git.kernel.org/netdev/net/c/c302e3a1c86f
  - [V2,5/5] net: wwan: iosm: set default mtu
    https://git.kernel.org/netdev/net/c/d7340f46beae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


