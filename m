Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A4138DDFF
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 01:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhEWXVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 19:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231982AbhEWXVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 19:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 379BD61155;
        Sun, 23 May 2021 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621812010;
        bh=ZVwz9mgA/9pfrVoLf+QE6jVCN2xSXMW4+QKcBMtLNLI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m5X8RJ1mf/wIV4vY7DXE+0qoDYJaslSuD1KMzydY5DTIG6KO15e2Yzfxew2EMJnwp
         T4xQCym4tMzfODTHdUy2RxigYFnUF3qUtBkU82T6WLpSGKsIs/uk50aiR0+i0k2zEm
         XCRkhlWtg4G5sQvyZeL0smsKMaUBX0PFAruxO+CpTBh6MClcm7VwaMjzE5PMD38bRW
         /vgD9ESlrjHO7b3trdBxOZLqiaNQKnd71lLUQfSuol4mrrPmRhxW6lJl6Ad9jJR2sf
         xTjPypVIdapxBtUmtpBbdyHqzOY0SEgRP+pkFRVAifl/4pSgLyRqghg4vnYMIWehLK
         lVGU97s175c7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2534860C29;
        Sun, 23 May 2021 23:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: macb: ensure the device is available before accessing
 GEMGXL control registers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162181201014.2631.11068199845594648051.git-patchwork-notify@kernel.org>
Date:   Sun, 23 May 2021 23:20:10 +0000
References: <20210522091611.36920-1-zong.li@sifive.com>
In-Reply-To: <20210522091611.36920-1-zong.li@sifive.com>
To:     Zong Li <zong.li@sifive.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        schwab@linux-m68k.org, sboyd@kernel.org, aou@eecs.berkeley.edu,
        mturquette@baylibre.com, geert@linux-m68k.org, yixun.lan@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 22 May 2021 17:16:11 +0800 you wrote:
> If runtime power menagement is enabled, the gigabit ethernet PLL would
> be disabled after macb_probe(). During this period of time, the system
> would hang up if we try to access GEMGXL control registers.
> 
> We can't put runtime_pm_get/runtime_pm_put/ there due to the issue of
> sleep inside atomic section (7fa2955ff70ce453 ("sh_eth: Fix sleeping
> function called from invalid context"). Add netif_running checking to
> ensure the device is available before accessing GEMGXL device.
> 
> [...]

Here is the summary with links:
  - [v2] net: macb: ensure the device is available before accessing GEMGXL control registers
    https://git.kernel.org/netdev/net/c/5eff1461a6de

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


