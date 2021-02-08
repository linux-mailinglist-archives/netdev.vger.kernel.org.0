Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB08A31444B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 00:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBHXvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 18:51:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhBHXux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 18:50:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E11F564E9A;
        Mon,  8 Feb 2021 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612828212;
        bh=NjAn8MpPTmzWARmHQFR2RzaApSx+avbx9XsS1V8KTog=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iSxfNBrFVPoD2Y6z3cnNaOcfEzEXOnJB7E0bHeTPCQy8fY+LmIIcR1E0AGkBAnJxm
         QW1v9CJuk6m3dttqbqzpQobs7uorl3GjfUctqmcEX/kQ+M5VJoKTpRxutUjbVHg8Vu
         9ziowIRC7VxNNPt5+apKc3o80W7VHV6FIf7kdZqD3S7QdxSrwsDDcp3L2jHVkIeYTD
         hlv66F1n5rRrol1sRIdEDLQZqiJrxkdfcpj6DwtKNZ5TRjLVE87umQTImnWb2ZCuHi
         LJEewoaBhf9Ixb5/x2uzFwfc9N8D1CmmlfuG6DUYP4Bv3JlQ407BuV0mn7MGLeWJAy
         bUF0WREiM365A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D8A68609D2;
        Mon,  8 Feb 2021 23:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bridge: use switchdev for port flags set through
 sysfs too
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161282821288.13069.16334035236215483610.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Feb 2021 23:50:12 +0000
References: <20210207194733.1811529-1-olteanv@gmail.com>
In-Reply-To: <20210207194733.1811529-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  7 Feb 2021 21:47:33 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Looking through patchwork I don't see that there was any consensus to
> use switchdev notifiers only in case of netlink provided port flags but
> not sysfs (as a sort of deprecation, punishment or anything like that),
> so we should probably keep the user interface consistent in terms of
> functionality.
> 
> [...]

Here is the summary with links:
  - [net] net: bridge: use switchdev for port flags set through sysfs too
    https://git.kernel.org/netdev/net-next/c/8043c845b63a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


