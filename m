Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0841F41946F
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 14:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhI0Mlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234341AbhI0Mlp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 08:41:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B9116108E;
        Mon, 27 Sep 2021 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632746407;
        bh=wtT03C0JlJwCD+bHZDs4s9aQl0KnULRyCExcPx6Td/o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eOlrrX6RDjrJfYtIKbSPc+jJwNTn2lJIY1t/FgvT8RSCt0OKIGycHbMJFiIKZVCI2
         oenmwiEKe2wHrfImb6ppnGd3DRluzDtj6S003EvOFV8aaNqnkZrVf1uVA5Eh+/Rsh6
         Ioyptf3zDqTqLxjZ1/u5YThq7TDnvfpG+0l1R7e3Na44GuI/4syU3DuoFo5Vq1DTgI
         bunyHmM11OBcOZ8fKwgC0Dcs6XQXIQXmo0rZsW7+mngk+J+saJ1W6dkKkmzhrh1lSu
         RpSxfVPeNKuLCpxm9WuJn2Kn/Klx17lKt/ndMfA4xG+VLj/hiHzJ9O84DJtkNrjkNI
         Ph/2j8/A7yKag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6D66060A3E;
        Mon, 27 Sep 2021 12:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] mv88e6xxx: MTU fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274640744.5898.12880095892698608708.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 12:40:07 +0000
References: <20210926174126.1987355-1-andrew@lunn.ch>
In-Reply-To: <20210926174126.1987355-1-andrew@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, cao88yu@gmail.com, f.fainelli@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun, 26 Sep 2021 19:41:23 +0200 you wrote:
> These three patches fix MTU issues reported by 曹煜.
> 
> There are two different ways of configuring the MTU in the hardware.
> The 6161 family is using the wrong method. Some of the marvell switch
> enforce the MTU when the port is used for CPU/DSA, some don't.
> Because of the extra header, the MTU needs increasing with this
> overhead.
> 
> [...]

Here is the summary with links:
  - [net,1/3] dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
    https://git.kernel.org/netdev/net/c/fe23036192c9
  - [net,2/3] dsa: mv88e6xxx: Fix MTU definition
    https://git.kernel.org/netdev/net/c/b92ce2f54c0f
  - [net,3/3] dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU ports
    https://git.kernel.org/netdev/net/c/b9c587fed61c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


