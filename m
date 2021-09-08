Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB06B403835
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 12:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348884AbhIHKvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 06:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235209AbhIHKvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 06:51:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0535261166;
        Wed,  8 Sep 2021 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631098207;
        bh=uXjkdrMGnvK5tp0H8+/6dUTwU8RQiAKlThx6/t/KIuI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WqGkshUOkVZCdM7jbge+qTKc6QfIyIPBcu795/F45zdzTFFTPFrOTsYYNC5WWhlup
         qEsmuS2MJYQ7aROrvY0BIqzb1kPZfanFG2JSXhMe2auQ2ZIIe/ZubCRfWjv4LSXtqD
         x7VcAfwA/a3X5zJgbq5ykJqBU1elAXJjlCGkGTjBfMjIL6zz0Z7NLHHMsy/8nrPoQa
         BRwW98ptV21VIlgtlAj+lj1T0aZWg0w8cDvEJyzmCbilVgk/EVDL4nQHMMQvxkWhHO
         /RvOPH+hwG8JdjwsxufMxEdpWN14f8uS4QoE/qf5GJvRy5qNfCa0QUpESyE7SaY0Bm
         QYwuC+lGWacpg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E80AC60A24;
        Wed,  8 Sep 2021 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [v2] ne2000: fix unused function warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163109820694.21737.554020052243923826.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Sep 2021 10:50:06 +0000
References: <20210907134617.185601-1-arnd@kernel.org>
In-Reply-To: <20210907134617.185601-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        geert@linux-m68k.org, W_Armin@gmx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  7 Sep 2021 15:46:10 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Geert noticed a warning on MIPS TX49xx, Atari and presuambly other
> platforms when the driver is built-in but NETDEV_LEGACY_INIT is
> disabled:
> 
> drivers/net/ethernet/8390/ne.c:909:20: warning: ‘ne_add_devices’ defined but not used [-Wunused-function]
> 
> [...]

Here is the summary with links:
  - [v2] ne2000: fix unused function warning
    https://git.kernel.org/netdev/net/c/d7e203ffd3ba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


