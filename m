Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0E943B3D7
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236487AbhJZOWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236474AbhJZOWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:22:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 533326109D;
        Tue, 26 Oct 2021 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635258008;
        bh=gCxgjYcUvTZ8gQYxL8C+hH6s+MEbMQRUmZIMC6aogJ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Djxd6bbYhirSCNzYi39DwFasSj7Hdi2OmtMEzKNRir37hUVKRazN62lQYtYlVitUS
         T26nr9x8VPHvqvo3sGLJi44NL3MuUYfhwLTK+VmB4UxVYzz94Sf+jIQydKBgUcmbfL
         Nkbc+z8cL+zHRZ/mQQj0+KA7xJUZOIaHzn+VtGYRPxWu6h1qeyilb2f89iWIJUUV/9
         wTLbWfhPm8fsjrZnYry1XPAc0A9vkdul9as+utHD8RRo6R+J6x03cwr7fGcOARh5Xu
         qrQmrw+fMoywVeEgJPxs9PiPXuDKLarHzjqiLyvnqa1tXY8wxDghFYUkVfjx54GC2t
         Vta+FgqZfWGIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4DC67609CC;
        Tue, 26 Oct 2021 14:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] DSA preparations for FDB isolation between
 bridges
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525800831.18574.13565094303297219162.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 14:20:08 +0000
References: <20211026092556.1192120-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211026092556.1192120-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 12:25:54 +0300 you wrote:
> This series makes 2 small changes to DSA's SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
> handler, which will make it possible to offer switch drivers a stable
> association between a FDB entry and a bridge device in a future series.
> 
> Vladimir Oltean (2):
>   net: dsa: flush switchdev workqueue when leaving the bridge
>   net: dsa: stop calling dev_hold in dsa_slave_fdb_event
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: flush switchdev workqueue when leaving the bridge
    https://git.kernel.org/netdev/net-next/c/d7d0d423dbaa
  - [net-next,2/2] net: dsa: stop calling dev_hold in dsa_slave_fdb_event
    https://git.kernel.org/netdev/net-next/c/425d19cedef8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


