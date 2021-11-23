Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A80145A1E6
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbhKWLxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:53:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236516AbhKWLxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 06:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8DB6E61039;
        Tue, 23 Nov 2021 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637668209;
        bh=76UfINGQNngK+PA9np839WQjDD9b+FXI4mhGHs1EGKE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZRWOk1c5P+k/CORhbfaaeqRmG+tqmgontCvY25pgOvOFLlVZOS8Z6GcYpiz4Honyc
         EgM2+1M4hd843v+/3ZCtHFacLS9hPGKzwmuj4fmeQITmankv52ZKzrv/lxtQN7w9xr
         pbcnHrZ/n7aM3Q1ahgbqtKUVmJFPl+jVV/Rn6xwjDqqhOwM6s0XDPiZ+PtSdXA93Jr
         +bV3M4oL7oy3Zkhw75mS/xuc02vE3bT17bslcsvyCkqGYdq7nc/6WscVnrE1mvdTVV
         15DB6x8u7JQMNikNB4In+CMwQG82EIggSjAHGow1hOX6dbPublMI3CuU7Nc97puhPJ
         rnNTPPTLK9WsA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 81E2060A45;
        Tue, 23 Nov 2021 11:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mlxsw: Two small fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163766820952.27860.13808393439028301821.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 11:50:09 +0000
References: <20211123075256.3083281-1-idosch@idosch.org>
In-Reply-To: <20211123075256.3083281-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 Nov 2021 09:52:54 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Patch #1 fixes a recent regression that prevents the driver from loading
> with old firmware versions.
> 
> Patch #2 protects the driver from a NULL pointer dereference when
> working on top of a buggy firmware. This was never observed in an actual
> system, only on top of an emulator during development.
> 
> [...]

Here is the summary with links:
  - [net,1/2] mlxsw: spectrum: Allow driver to load with old firmware versions
    https://git.kernel.org/netdev/net/c/ce4995bc6c8e
  - [net,2/2] mlxsw: spectrum: Protect driver from buggy firmware
    https://git.kernel.org/netdev/net/c/63b08b1f6834

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


