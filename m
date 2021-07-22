Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763FD3D1DE6
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 08:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhGVFTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 01:19:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230339AbhGVFT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 01:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3ACA661264;
        Thu, 22 Jul 2021 06:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626933605;
        bh=ZJ5omcpAA34YR9NTXDeR3R2vmEIUczGn75XQ772rBvw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U3QD/Ni0riV4Sle5MXwIoG6QcVs0JoQGcrM7XQdeIXV+HJIHz553j1RZrIccWmnQI
         7BEt2DCu84+kGGZazlBxNMVeHn7gC3Nn+9qOJuoxE+IFb3/MK9vbi4Hq+FMESnMGQ3
         J8jb+jIevNP2gbqfPSFhIq9YUmeGoihZ6IrZLs0vPwkVCdZdXQ5xEYWDfsrTPjNnAX
         S9kE7ZhwSWUqdB78eWw40buEbm9EIMjTdEy6oBJpSmQdaR0GvoWR1bc6UVVNmdSh9/
         gab9Uer7kbX9/ox63D24rId/Zvp57oE0ETrfbMscRBMx+ufvAnOsRTrbyykI9FuXbX
         pAO+QX1PLgkzw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2EB28609B5;
        Thu, 22 Jul 2021 06:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: sja1105: make VID 4095 a bridge VLAN too
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162693360518.26975.15496484554449728760.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 06:00:05 +0000
References: <20210721123759.1638970-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210721123759.1638970-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        radu-nicolae.pirea@oss.nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Jul 2021 15:37:59 +0300 you wrote:
> This simple series of commands:
> 
> ip link add br0 type bridge vlan_filtering 1
> ip link set swp0 master br0
> 
> fails on sja1105 with the following error:
> [   33.439103] sja1105 spi0.1: vlan-lookup-table needs to have at least the default untagged VLAN
> [   33.447710] sja1105 spi0.1: Invalid config, cannot upload
> Warning: sja1105: Failed to change VLAN Ethertype.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: sja1105: make VID 4095 a bridge VLAN too
    https://git.kernel.org/netdev/net/c/e40cba9490ba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


