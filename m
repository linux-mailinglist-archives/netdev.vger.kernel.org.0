Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2576326A81
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhBZXuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhBZXus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 18:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6EACE64EC4;
        Fri, 26 Feb 2021 23:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614383408;
        bh=E34GnxsQRlmVYXa9wT2iqUtesr7Y1nctAUemscN2esM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S5OP6ezekO9S/AQNpj+kP6rNcDQphe+unLgG51O0ieWPLhFfwZdvJPbpNUmXZXE2Z
         R4T3rgIhC/kVZ55YpAo0uo8EZS+PHnaaVECn5NBn3oCP847Ptx6MDrioP0OuVB9avs
         MM5ir63L/OHzFu2QanqOH6Re7D/ugZIbLV5VPndaLT+/v8euKGCS5pjd7ZTHEJQzDO
         lAuFprRmK/wfXiduZiudRvPEaN12FpWllHWXyIFBBYGEv1lV4CrWAnVerZcorgiSZP
         22oc7A1oz3a5S0tImoup08cwxV9Wy1dWHJPpfu0bi1zAZT8m6iYMJzctg8E8kIpW8E
         uX8QeUG+T6dxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 611C160A14;
        Fri, 26 Feb 2021 23:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] mlxsw: Various fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161438340839.31866.12281789442689763991.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Feb 2021 23:50:08 +0000
References: <20210225165721.1322424-1-idosch@idosch.org>
In-Reply-To: <20210225165721.1322424-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, danieller@nvidia.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 25 Feb 2021 18:57:18 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset contains various fixes for mlxsw.
> 
> Patch #1 fixes a race condition in a selftest. The race and fix are
> explained in detail in the changelog.
> 
> [...]

Here is the summary with links:
  - [net,1/3] selftests: forwarding: Fix race condition in mirror installation
    https://git.kernel.org/netdev/net/c/edcbf5137f09
  - [net,2/3] mlxsw: spectrum_ethtool: Add an external speed to PTYS register
    https://git.kernel.org/netdev/net/c/ae9b24ddb69b
  - [net,3/3] mlxsw: spectrum_router: Ignore routes using a deleted nexthop object
    https://git.kernel.org/netdev/net/c/dc860b88ce0a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


