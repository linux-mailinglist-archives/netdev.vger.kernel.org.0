Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F95F3799F1
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhEJWVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232177AbhEJWVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 18:21:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2E0F36161C;
        Mon, 10 May 2021 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620685212;
        bh=DPufKTlQo/+DorwT61wv8lVftcfjqUcX5vWqEzJyCwA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BHAAPjw0ImoS4OuvrEn0LULODDys6dmIKXIitA+w5qNarfhNndOTpGi43Ectzhkrx
         45XNEmSKkJ0p96C0coqvn9UEbCTSH9uPGpwgFrE+LM+RFkDoeBYuLgNYk1PoY4omv4
         fLwKoVzWqcUSeKGAQBQc8EBTmGMrnkFS1YThbmklE8srE0mE6Nv0bed4YReuEf5Oqu
         mxQ1R0hoLLtyCeRYKqGUF7GdDE5G1n0H8WNQGhsCA2h9Ol+Mw+ORCxUsDPFQDKxkZd
         Rzn0WDEvyoF1Tc/TwSk8guRekkLW9e42GNiAiAKh4u7C2xH3cnVh5/dHvLNpDmtpg1
         7xTS3nelqYw4A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2322B60C09;
        Mon, 10 May 2021 22:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/5] net: pch_gbe: fix and a few cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068521214.17141.13468046440928102441.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 22:20:12 +0000
References: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     davem@davemloft.net, f.suligoi@asem.it, lee.jones@linaro.org,
        jesse.brandeburg@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 10 May 2021 19:39:26 +0300 you wrote:
> The series provides one fix (patch 1) for GPIO to be able to wait for
> the GPIO driver to appear. This is separated from the conversion to
> the GPIO descriptors (patch 2) in order to have a possibility for
> backporting. Patches 3 and 4 fix minor warnings from Sparse while
> moving to a new APIs. Patch 5 is MODULE_VERSION() clean up.
> 
> Tested on Intel Minnowboard (v1).
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/5] net: pch_gbe: Propagate error from devm_gpio_request_one()
    https://git.kernel.org/netdev/net-next/c/9e3617a7b845
  - [net-next,v3,2/5] net: pch_gbe: Convert to use GPIO descriptors
    https://git.kernel.org/netdev/net-next/c/aca6a8746c36
  - [net-next,v3,3/5] net: pch_gbe: use readx_poll_timeout_atomic() variant
    https://git.kernel.org/netdev/net-next/c/6fcfb267cb49
  - [net-next,v3,4/5] net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()
    https://git.kernel.org/netdev/net-next/c/443ef39b499c
  - [net-next,v3,5/5] net: pch_gbe: remove unneeded MODULE_VERSION() call
    https://git.kernel.org/netdev/net-next/c/40b161bb16c4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


