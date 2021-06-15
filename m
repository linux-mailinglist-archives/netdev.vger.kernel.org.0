Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC553A8894
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhFOScJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhFOScI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 14:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 85B30610F7;
        Tue, 15 Jun 2021 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623781803;
        bh=7iXMp3/7MskyuJtO5fgwPKxPSeCCil795wxwNE+PgCs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n2I+hk5kEuHnM9zhscUDQqnsbbtDGDT4OLaGNaBOuA9NhJBVbALKQZoPXVh3xi5Jt
         0v1m/hBr9FLTQsoHsCdoykYyf41n7tBfYjCOCtWs526eB/hEv96EGgKk8+VjyokqxI
         qmLSkX13/8gGlX6IksXZ88dmUpXc+cOrBvAfqzJ7jJdfmOGhwFTArGoCdbpLdoAsAh
         PYzf5HeYWlr6qK1RugZBN0F9etK+b3w7Byq6XyH/THJkPTKmosd0nyPNYHjfKOPsk+
         Z/6IoJ2cyHN1C7VF1Mw+dpYvBh9H7EaWGl+TvQsfMagY2ajE4+IOYxAPJABlERWovP
         Gu3l1lO/98QPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 76B60609E4;
        Tue, 15 Jun 2021 18:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: cdc_ncm: switch to eth%d interface naming
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162378180348.31286.4984081071906700248.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 18:30:03 +0000
References: <20210615080549.3362337-1-zenczykowski@gmail.com>
In-Reply-To: <20210615080549.3362337-1-zenczykowski@gmail.com>
To:     =?utf-8?q?Maciej_=C5=BBenczykowski_=3Czenczykowski=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     maze@google.com, netdev@vger.kernel.org, lorenzo@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 15 Jun 2021 01:05:49 -0700 you wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> This is meant to make the host side cdc_ncm interface consistently
> named just like the older CDC protocols: cdc_ether & cdc_ecm
> (and even rndis_host), which all use 'FLAG_ETHER | FLAG_POINTTOPOINT'.
> 
> include/linux/usb/usbnet.h:
>   #define FLAG_ETHER	0x0020		/* maybe use "eth%d" names */
>   #define FLAG_WLAN	0x0080		/* use "wlan%d" names */
>   #define FLAG_WWAN	0x0400		/* use "wwan%d" names */
>   #define FLAG_POINTTOPOINT 0x1000	/* possibly use "usb%d" names */
> 
> [...]

Here is the summary with links:
  - net: cdc_ncm: switch to eth%d interface naming
    https://git.kernel.org/netdev/net/c/c1a3d4067309

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


