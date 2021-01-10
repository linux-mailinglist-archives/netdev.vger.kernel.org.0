Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109282F0496
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 01:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbhAJAat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 19:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbhAJAas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 19:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F87C23998;
        Sun, 10 Jan 2021 00:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610238608;
        bh=VNEqf0DvwQ7iWd//7xvO8fG6laBPcY9o3qIIulZNIqU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AafrrGEoMgUofugM8Mi0ovFugS50H2LWwAHtKZ1devpw9+IDj5gscY3VleVWK/n9+
         8QIcsdgS4DrzISENzo6FjAi1D1iSwNEfe0tl6PiWGRgl+O1l93RVRMqDu7/fizkXm5
         3d4Ivwd2IrgtDQ/H0h/PYPpZKZpm6FVYX2V2y9O6ltNGMzTHzJu97MURfp0OOS0xfl
         ZcCcJ6tDzTn0eObUKQvLSO0JRj57+dYsVQDmJAN454FaGOMn2mW7qNDWfRo+Ip/NEi
         GHH3dJJfYCh+UTH0ctM6a/maBFZ3mqAreNBF2cDGv6kBvKTTZy2vyHviQLiPfB4o15
         /HWvA61vf2R5w==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 19B0260661;
        Sun, 10 Jan 2021 00:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mlxsw: core: Thermal control fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161023860810.20943.13933686527788830861.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Jan 2021 00:30:08 +0000
References: <20210108145210.1229820-1-idosch@idosch.org>
In-Reply-To: <20210108145210.1229820-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        vadimp@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri,  8 Jan 2021 16:52:08 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This series includes two fixes for thermal control in mlxsw.
> 
> Patch #1 validates that the alarm temperature threshold read from a
> transceiver is above the warning temperature threshold. If not, the
> current thresholds are maintained. It was observed that some transceiver
> might be unreliable and sometimes report a too low alarm temperature
> threshold which would result in thermal shutdown of the system.
> 
> [...]

Here is the summary with links:
  - [net,1/2] mlxsw: core: Add validation of transceiver temperature thresholds
    https://git.kernel.org/netdev/net/c/57726ebe2733
  - [net,2/2] mlxsw: core: Increase critical threshold for ASIC thermal zone
    https://git.kernel.org/netdev/net/c/b06ca3d5a43c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


