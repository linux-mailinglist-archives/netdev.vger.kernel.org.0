Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F323522E4
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 00:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhDAWuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 18:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234273AbhDAWuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 18:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 98A61610F7;
        Thu,  1 Apr 2021 22:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617317408;
        bh=XzQ9t7E1vfxGLlA0Ov+CF+/XYR82rASkAZpibljHW3Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XTgFgm2NF7+p4Kr9gb10rgaevqFOotUB5bhrJsZpyQGSwareYD94y57naHMWbTssC
         1L4YmLW2hrkvA9xs06m5t2max9Fo1Z9A8Mui7l201aS2OLV7gYVeGZ9FysY3M++/Es
         xhRzSSOHicac8HovTbDhPWNNmHlmWSJEqFxftLSDH+9GHRICQDCScKT8qBTn/2qZuv
         xFujRwMF1/RoEkHfE1PKVU1SD7SsgXuEVYx85QY8MZkn14/IQWbjuYYsEVQH/oZoPP
         kYR5dmAVJS56jEzIQVByoiRdGbfdM1VFgmJfbSLFgBozG7T/abnkskZ1xkuiCevJfn
         nyG5QL1PW0rTQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8AC95609CD;
        Thu,  1 Apr 2021 22:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: net: fix memory leak in atusb_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731740856.4407.2943205104358647134.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 22:50:08 +0000
References: <20210401044624.19017-1-paskripkin@gmail.com>
In-Reply-To: <20210401044624.19017-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     stefan@datenfreihafen.org, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+28a246747e0a465127f3@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  1 Apr 2021 07:46:24 +0300 you wrote:
> syzbot reported memory leak in atusb_probe()[1].
> The problem was in atusb_alloc_urbs().
> Since urb is anchored, we need to release the reference
> to correctly free the urb
> 
> backtrace:
>     [<ffffffff82ba0466>] kmalloc include/linux/slab.h:559 [inline]
>     [<ffffffff82ba0466>] usb_alloc_urb+0x66/0xe0 drivers/usb/core/urb.c:74
>     [<ffffffff82ad3888>] atusb_alloc_urbs drivers/net/ieee802154/atusb.c:362 [inline][2]
>     [<ffffffff82ad3888>] atusb_probe+0x158/0x820 drivers/net/ieee802154/atusb.c:1038 [1]
> 
> [...]

Here is the summary with links:
  - drivers: net: fix memory leak in atusb_probe
    https://git.kernel.org/netdev/net/c/6b9fbe169551

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


