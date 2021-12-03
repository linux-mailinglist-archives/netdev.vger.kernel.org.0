Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C616646796A
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381477AbhLCOdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:33:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55224 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381466AbhLCOdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 09:33:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFC2F62B91;
        Fri,  3 Dec 2021 14:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F1D8C56749;
        Fri,  3 Dec 2021 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638541810;
        bh=jH9g0yPvfLmcAo0dxSvBnnGWpU+C73b1E0qgJU1prp0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kffnn+5xoUunzP4eOphbIeK+TTcTI3CnR141OE5WLJ1oPY8ewjbYp03eqUrZov4XR
         rmAFcxk6tsybByXLedETYBo3lQ84lJ9ReHHyG55GAhUpAThgBHrE7TMUDSQmeHqSOz
         mIGe5XfcnT447rRQQWoNYIiVe99gkAsnnVEw0KQZiMpwt2L0f6nWr2hdVCGkfL5rzg
         TuZtDDwxXePZSYRlxFQ/y83/qd71GymwlcEYoNptPE3f7nQXxnjoq/fN6p8KrYXhqj
         XQ9dBKCMn3TTcKpmVxwHEo+u/4B1ao9ydnBxW2DM0bCG1Y2k2zuCT+wwvyTQtBqODu
         WPm1K8Bf0IPCA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4998860A50;
        Fri,  3 Dec 2021 14:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 1/1] net: dsa: vsc73xxx: Get rid of duplicate of_node
 assignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163854181029.31528.13198527515956564896.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 14:30:10 +0000
References: <20211202210029.77466-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20211202210029.77466-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     vladimir.oltean@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  2 Dec 2021 23:00:29 +0200 you wrote:
> GPIO library does copy the of_node from the parent device of
> the GPIO chip, there is no need to repeat this in the individual
> drivers. Remove assignment here.
> 
> For the details one may look into the of_gpio_dev_init() implementation.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [v1,1/1] net: dsa: vsc73xxx: Get rid of duplicate of_node assignment
    https://git.kernel.org/netdev/net-next/c/ab11393fd004

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


