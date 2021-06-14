Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDDE3A7023
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbhFNUWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234021AbhFNUWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5568F6134F;
        Mon, 14 Jun 2021 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623702006;
        bh=kuoUQKWqtIdQ21mPnztd9eAz8/h1l1cbfV/ZiTkGYBc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JwcJOq7V3GnUC34M4r5stLzntOIBUAm4S6DH1nWKkbjuR7tRE8DqEkAEGe2te50b8
         2V6NscUoIVclmWeDKD7YQlCJk9R7n5YVlvkSMLaGWW0N2z2qP/FF6/ixwpnKqjoA28
         h6mQ1GND4dYDAf/VNs97GxPLpi6LqQn2VhY168QCX0CHhsced4nZOKqcTxXerpARbo
         xAot4J7nu838lScrbPrtt7rFNQ4YiVlwHItIZKe7lZV+qXi9K4WhN7jWkrI/tpKA4I
         R4jOpB5lY5xhqyNjN7jEvFDQA7KrCYYR+o2ngJz2LWS2lSJUYTtYTSIDhAXsg/Rm6q
         2gI3qXudHLgWQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 49FC860A71;
        Mon, 14 Jun 2021 20:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/4] Fixes and improvements to TJA1103 PHY driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370200629.25455.5932190213835446990.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 20:20:06 +0000
References: <20210614134441.497008-1-olteanv@gmail.com>
In-Reply-To: <20210614134441.497008-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, radu-nicolae.pirea@oss.nxp.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Jun 2021 16:44:37 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series contains:
> - an erratum workaround for the TJA1103 PHY integrated in SJA1110
> - an adaptation of the driver so it prints less unnecessary information
>   when probing on SJA1110
> - a PTP RX timestamping bug fix and a clarification patch
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/4] net: phy: nxp-c45-tja11xx: demote the "no PTP support" message to debug
    https://git.kernel.org/netdev/net-next/c/565c6d8cff6a
  - [v3,net-next,2/4] net: phy: nxp-c45-tja11xx: express timestamp wraparound interval in terms of TS_SEC_MASK
    https://git.kernel.org/netdev/net-next/c/661fef5698bc
  - [v3,net-next,3/4] net: phy: nxp-c45-tja11xx: fix potential RX timestamp wraparound
    https://git.kernel.org/netdev/net-next/c/109258ed6262
  - [v3,net-next,4/4] net: phy: nxp-c45-tja11xx: enable MDIO write access to the master/slave registers
    https://git.kernel.org/netdev/net-next/c/0b5f0f29b118

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


