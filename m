Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F155330188A
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 22:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbhAWVa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 16:30:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbhAWVau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 16:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 74C4722CB9;
        Sat, 23 Jan 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611437410;
        bh=xWxjFL8KQ0wPPz2ZDkC580KuJTjd8N1tFJVySZm7f80=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sa9PpMQxUv97Be3bt6LRbPwvMf6jYgSqgbo4LeVjDjB696aSpxzp3ChAT0cWBMwmh
         xMJT14M55AkCPzp5Ss3uFgCCY5Oxw8jaMXJ+EqsvaDbKOartwLqgmRMg7V2vCTbdf1
         Jx2EwKqmw68ofLGP1qFzsic8wXfzmNino1z4xHpvm8PV5Pasi+U2Pma6kPXbsUkHNZ
         PBbzZurmsxOSgEZyOpLa0V7Fm4B4ixDB/fgF8l4Pafnfo0HtQW8Xa3DYzFv5mL8o4Z
         cQer+8RraN2i7l3qioqexyHy7ccDqm9nl8Ni8uSRO+/VM3WUCMXBsUFx+yj3E0l0TL
         Ly4NpDrbggBeg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64F21652E4;
        Sat, 23 Jan 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: bcm_sf2: put device node before return
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161143741040.6169.4592145285251122406.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 21:30:10 +0000
References: <20210121123343.26330-1-bianpan2016@163.com>
In-Reply-To: <20210121123343.26330-1-bianpan2016@163.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 21 Jan 2021 04:33:43 -0800 you wrote:
> Put the device node dn before return error code on failure path.
> 
> Fixes: 461cd1b03e32 ("net: dsa: bcm_sf2: Register our slave MDIO bus")
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  drivers/net/dsa/bcm_sf2.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: dsa: bcm_sf2: put device node before return
    https://git.kernel.org/netdev/net/c/cf3c46631e16

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


