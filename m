Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660BB466446
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 14:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357970AbhLBNNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 08:13:41 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41842 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354157AbhLBNNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 08:13:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DB48BCE213B;
        Thu,  2 Dec 2021 13:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1B44C00446;
        Thu,  2 Dec 2021 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638450608;
        bh=LNYyYTd6rdmSSmpu5zp9N69YRhuG5/RhfeTm56Q2J6k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JDzsiAiPEEGlPHoVcsD/NAhBixnXMBhTUb9wdxcsWkwndPp5HzQ5PYrlQ2ZquIduZ
         qamTnsFk/bI5FEG8qLe5dlUpp/aw8YtYFYx28iVLuE8h7d0u68q41Gdk87Mm2sjmhB
         BM//4EKH81TTFYvjpR7JstY02f+/NGpW0AA+zQ+nXwMwmZ26Gc4nV0e4QLhrftP/La
         IZboxBtCvI/NEutFtmuFq5Dbynj+wS+/3vlj7MIFJ22R5e9VbjFixLvJApLlnXBJUd
         Uao0yDLeXq3hZ3foTQWMV6EDXhHOzQNWN8Kn5afGfEPyYhKqmELUa0MbTP8HN/02Yy
         ti3J1eTtBgy6A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AFBF860A88;
        Thu,  2 Dec 2021 13:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: b53: Add SPI ID table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163845060871.30486.6613197259077712613.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 13:10:08 +0000
References: <20211202041720.1013279-1-f.fainelli@gmail.com>
In-Reply-To: <20211202041720.1013279-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, broonie@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  1 Dec 2021 20:17:20 -0800 you wrote:
> Currently autoloading for SPI devices does not use the DT ID table, it
> uses SPI modalises. Supporting OF modalises is going to be difficult if
> not impractical, an attempt was made but has been reverted, so ensure
> that module autoloading works for this driver by adding an id_table
> listing the SPI IDs for everything.
> 
> Fixes: 96c8395e2166 ("spi: Revert modalias changes")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: b53: Add SPI ID table
    https://git.kernel.org/netdev/net/c/88362ebfd7fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


