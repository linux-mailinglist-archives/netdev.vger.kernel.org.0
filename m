Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699CD443A9A
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 01:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhKCAwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 20:52:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231533AbhKCAwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 20:52:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B8B8A60F90;
        Wed,  3 Nov 2021 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635900607;
        bh=o2xe1unT6/OIQcRhUNsxVPvo3YZ42Zjr/sKjAQ7bkQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=js8KTS8JqC7KvkLCx73s0lwk4xYjss1etHYm3UzmMLBZHseqsRxPWUAJ5GXbMDVWS
         r0TVQAz3+SRKyoDeZtzHf79fsjL5oZLZRUIDWAlW3PCKXSjM6FS9+mX3YXz/U13Frl
         8tOIKwnIQ41jBRdBJP14qpgVCOU5E+tYjB0m9tWgNWr3PGcvzoNKUIzuBWMLoG/rjv
         BmnStUEmb/yTA6P2zn23918IWh4I/jColyK2iGuq/X3Cmt7ExMlg64Y97UZRy2YwPi
         kBy5g9i6gGGDyHA76LfEwFssFKFxqG/4dnrCLkwF6NQQEOziLkhrO+8pA6Vi/uUw+w
         6XS8r3+rmjpag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AE133609B9;
        Wed,  3 Nov 2021 00:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: davinci_emac: Fix interrupt pacing disable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163590060770.14144.16946664384523632045.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 00:50:07 +0000
References: <20211101152343.4193233-1-bigunclemax@gmail.com>
In-Reply-To: <20211101152343.4193233-1-bigunclemax@gmail.com>
To:     Maxim Kiselev <bigunclemax@gmail.com>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, kuba@kernel.org,
        yangyingliang@huawei.com, andrew@lunn.ch, colin.king@canonical.com,
        moyufeng@huawei.com, michael@walle.cc, srk@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  1 Nov 2021 18:23:41 +0300 you wrote:
> This patch allows to use 0 for `coal->rx_coalesce_usecs` param to
> disable rx irq coalescing.
> 
> Previously we could enable rx irq coalescing via ethtool
> (For ex: `ethtool -C eth0 rx-usecs 2000`) but we couldn't disable
> it because this part rejects 0 value:
> 
> [...]

Here is the summary with links:
  - [v2] net: davinci_emac: Fix interrupt pacing disable
    https://git.kernel.org/netdev/net/c/d52bcb47bdf9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


