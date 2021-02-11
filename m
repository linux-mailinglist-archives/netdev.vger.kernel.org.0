Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1F8319597
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhBKWKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:40978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhBKWKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 48BE964E2F;
        Thu, 11 Feb 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613081409;
        bh=7gyYGGGjTFOZrySHpAo0w8FD7+7axG/GlhZCEDGVWOA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AIdQ9/3oxgblYyE+6shLVQTkBwPLKJykoqh4VtjyVpcJTnNt431LZSTpObRz5hmIw
         SnWWrSjnEyHtyh4prjd4vAFrBE7amNkzcJaDVeqxj3r6uSshnOdJrvc6Ur569fsEM8
         CE3N05k5Cog0QHo46My43PfPiCA3NOhTcPkh+59rtGTkCqR3QTrTDV/FUtCneNgJNa
         WEy2oPqwoT0QtOx9m/Nw3nSg46F/Pi2OUoFf7HIuH/E+AJZGw8G+FIaAziLe4L1c4S
         qisGnUU2sY3gaJS3MNoh6xUVCcz4AWT/OINmVNgaq5QCFl+BpJndxxpSwQywCZ/AC0
         0KcOP55Oh2EHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33A8F600E8;
        Thu, 11 Feb 2021 22:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/9] net: phy: icplus: cleanups and new features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308140920.31051.202179851153917362.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:10:09 +0000
References: <20210211074750.28674-1-michael@walle.cc>
In-Reply-To: <20210211074750.28674-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 08:47:41 +0100 you wrote:
> Cleanup the PHY drivers for IPplus devices and add PHY counters and MDIX
> support for the IP101A/G.
> 
> Patch 5 adds a model detection based on the behavior of the PHY.
> Unfortunately, the IP101A shares the PHY ID with the IP101G. But the latter
> provides more features. Try to detect the newer model by accessing the page
> selection register. If it is writeable, it is assumed, that it is a IP101G.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/9] net: phy: icplus: use PHY_ID_MATCH_MODEL() macro
    https://git.kernel.org/netdev/net-next/c/2ad4758cec48
  - [net-next,v4,2/9] net: phy: icplus: use PHY_ID_MATCH_EXACT() for IP101A/G
    https://git.kernel.org/netdev/net-next/c/7360a4de36a4
  - [net-next,v4,3/9] net: phy: icplus: drop address operator for functions
    https://git.kernel.org/netdev/net-next/c/8edf206cc2b5
  - [net-next,v4,4/9] net: phy: icplus: use the .soft_reset() of the phy-core
    https://git.kernel.org/netdev/net-next/c/df22de9a6f13
  - [net-next,v4,5/9] net: phy: icplus: split IP101A/G driver
    https://git.kernel.org/netdev/net-next/c/675115bf8c3d
  - [net-next,v4,6/9] net: phy: icplus: don't set APS_EN bit on IP101G
    https://git.kernel.org/netdev/net-next/c/eeac7d43d4dd
  - [net-next,v4,7/9] net: phy: icplus: fix paged register access
    https://git.kernel.org/netdev/net-next/c/f9bc51e6cce2
  - [net-next,v4,8/9] net: phy: icplus: add PHY counter for IP101G
    https://git.kernel.org/netdev/net-next/c/a0750d42e951
  - [net-next,v4,9/9] net: phy: icplus: add MDI/MDIX support for IP101A/G
    https://git.kernel.org/netdev/net-next/c/32ab60e53920

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


