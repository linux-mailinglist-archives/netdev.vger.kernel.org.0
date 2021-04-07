Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16BA35603A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347497AbhDGAU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237769AbhDGAUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:20:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 12A42613D0;
        Wed,  7 Apr 2021 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617754813;
        bh=68ezURRB4IzMUiiFsKN47apLoSsRPZ+MXLR9pJgl0dk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HPpNXmeN7inrJ64lopW5zGrefa3HtQKEBPDRvgn0KYeDZRczof5Q+UZ0OkP0qnjql
         S+aUIJwJ7XFF15zfSnehdq8yeZThdHndKYi8eIIVD+ciGECReXqV3rf9LclM7X3IYg
         XGH/ydAu5JZ2T0u2yxWGanAGwe36u/9uRehE+sKJyvEmt8KUctPvIS5pvUYcMRomml
         YyfvQxa1MqSwNMgNzS0nRRz8jfd/aSK2SGfUsxXwSGRXeLZpU3YPT/zQqkNGaxkzT0
         hERcyipbn7h23+vXd/K2gL0ml7Xk+j2QNMIDyntL4diD1BvByCveWSAqLtSfs69qfS
         H9tIqVivSFHLQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 06ABD60A54;
        Wed,  7 Apr 2021 00:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/1] time64.h: Consolidated PSEC_PER_SEC definition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775481302.4854.4555470311488320359.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 00:20:13 +0000
References: <20210406102251.60301-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210406102251.60301-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     davem@davemloft.net, yangbo.lu@nxp.com, vladimir.oltean@nxp.com,
        heiko@sntech.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, kishon@ti.com, vkoul@kernel.org, luto@kernel.org,
        tglx@linutronix.de, vincenzo.frascino@arm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  6 Apr 2021 13:22:51 +0300 you wrote:
> We have currently three users of the PSEC_PER_SEC each of them defining it
> individually. Instead, move it to time64.h to be available for everyone.
> 
> There is a new user coming with the same constant in use. It will also
> make its life easier.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Heiko Stuebner <heiko@sntech.de>
> 
> [...]

Here is the summary with links:
  - [v2,1/1] time64.h: Consolidated PSEC_PER_SEC definition
    https://git.kernel.org/netdev/net-next/c/a460513ed4b6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


