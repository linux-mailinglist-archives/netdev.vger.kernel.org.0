Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A2A35B7A7
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbhDLAKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235762AbhDLAKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 20:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 18E0D61003;
        Mon, 12 Apr 2021 00:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618186211;
        bh=OGEQ3MhUItIZS16ROlV+T27dH7B0EylRTjZq/SNciYs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VW2285MhDSh4ijfednmqQ8DiHBsx0WP9ktU7b7EPglwDIyaSsE9kwqy2fRAsgD98m
         YWTD0pTYFr9xvvnCEtctvL4HBfi0rtQCwN8vw4R0MiWDi81NdE2n2O4DriRGLeV6R4
         XuCRx8x9m/gHTlKwIneJmMLbyvEYaAsmlakM+vuqlWBx/rPg1mBc6AKnMw8vGJ6RWh
         jpeta96C0eHhUoNjlOepV6oyYQ4I9dj9Y+SNLu28O2dsK7DTyRJcGvbL1aIbJZ5JM/
         dLY4VyXP3NtzRCulpHeARqPFmD3Ev0OB/XAcKJTTxty0vx5y2+ukeWv+EgI4ykq6p+
         sAZB8cXZA7lrw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0A72F60A2A;
        Mon, 12 Apr 2021 00:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] ethtool: Extend module EEPROM dump API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161818621103.2274.14386044370210980683.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 00:10:11 +0000
References: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
In-Reply-To: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        pop.adrian61@gmail.com, mkubecek@suse.cz, netdev@vger.kernel.org,
        vladyslavt@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 9 Apr 2021 11:06:33 +0300 you wrote:
> Ethtool supports module EEPROM dumps via the `ethtool -m <dev>` command.
> But in current state its functionality is limited - offset and length
> parameters, which are used to specify a linear desired region of EEPROM
> data to dump, is not enough, considering emergence of complex module
> EEPROM layouts such as CMIS 4.0.
> Moreover, CMIS 4.0 extends the amount of pages that may be accessible by
> introducing another parameter for page addressing - banks.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] ethtool: Allow network drivers to dump arbitrary EEPROM data
    https://git.kernel.org/netdev/net-next/c/c781ff12a2f3
  - [net-next,2/8] net/mlx5: Refactor module EEPROM query
    https://git.kernel.org/netdev/net-next/c/e19b0a3474ab
  - [net-next,3/8] net/mlx5: Implement get_module_eeprom_by_page()
    https://git.kernel.org/netdev/net-next/c/e109d2b204da
  - [net-next,4/8] net/mlx5: Add support for DSFP module EEPROM dumps
    https://git.kernel.org/netdev/net-next/c/4c88fa412a10
  - [net-next,5/8] net: ethtool: Export helpers for getting EEPROM info
    https://git.kernel.org/netdev/net-next/c/95dfc7effd88
  - [net-next,6/8] ethtool: Add fallback to get_module_eeprom from netlink command
    https://git.kernel.org/netdev/net-next/c/96d971e307cc
  - [net-next,7/8] phy: sfp: add netlink SFP support to generic SFP code
    https://git.kernel.org/netdev/net-next/c/d740513f05a2
  - [net-next,8/8] ethtool: wire in generic SFP module access
    https://git.kernel.org/netdev/net-next/c/c97a31f66ebc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


