Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F97336715C
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244764AbhDURax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244686AbhDURan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6221E61459;
        Wed, 21 Apr 2021 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619026210;
        bh=/nb529P65j8VgZEw/tVWrj9Vii89r6rf6Q+GUAvhKlg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jey4pxIZbomsug0DrrlJfyQ1vLv8MEUWZnuYPxzs40SB6i2j6yo/AEohdazX0F9T/
         4k/Uv83yj3OpjJorumPmM6GzLDWSPN82LjKvgkkyLYrxjTpk9wHGgnTwVY2E97gs3J
         gsIZc9tbBUfYUTQtFcwXspwu0NsQAJrt4AyxeBrj4DnBJ8XorXzl0p6qk1rSaI8lSg
         unUe6VG+mEV1wD7kB68WVf8lHSYcaHaACIUUI1WpzYmbnRIAr+mzcLG7R0WpLp4VvT
         waKSU9nMCsseEX1Qc6ASALHoPv0IILz6Zm0hh+Df0gDPlHmGSFJ0zijtHGQ1gjY1r3
         +4gcnNML2Ra0A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5A24660A2A;
        Wed, 21 Apr 2021 17:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: dsa: mv88e6xxx: Tiny fixes/improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161902621036.9844.6392319399833636805.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 17:30:10 +0000
References: <20210421120454.1541240-1-tobias@waldekranz.com>
In-Reply-To: <20210421120454.1541240-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Apr 2021 14:04:51 +0200 you wrote:
> Just some small things I have noticed that do not fit in any other
> series.
> 
> Tobias Waldekranz (3):
>   net: dsa: mv88e6xxx: Correct spelling of define "ADRR" -> "ADDR"
>   net: dsa: mv88e6xxx: Fix off-by-one in VTU devlink region size
>   net: dsa: mv88e6xxx: Export cross-chip PVT as devlink region
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: dsa: mv88e6xxx: Correct spelling of define "ADRR" -> "ADDR"
    https://git.kernel.org/netdev/net-next/c/78e70dbcfd03
  - [net-next,2/3] net: dsa: mv88e6xxx: Fix off-by-one in VTU devlink region size
    https://git.kernel.org/netdev/net-next/c/281140a0a2ce
  - [net-next,3/3] net: dsa: mv88e6xxx: Export cross-chip PVT as devlink region
    https://git.kernel.org/netdev/net-next/c/836021a2d0e0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


