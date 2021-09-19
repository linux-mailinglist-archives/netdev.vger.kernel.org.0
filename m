Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4725410B92
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 14:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhISMbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 08:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhISMbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 08:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CB2C761351;
        Sun, 19 Sep 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632054607;
        bh=kzYmtIm68b1O+0pEJzEWWqzl6dfreNgBkTXil3FdHDE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ooQ50Bd5pqiPX4LqIG5Ud3ewFdayRnhxKqIay0g3L53KSIRjaJ7Gj0gS9FRhqf5fJ
         PbpGdZhoXS6V6AkhroFDAa7mz9h5k19ART0cgQ4UsoXYeVWlOOiyGjncZL0vuzkOTo
         xI6WBsvOG6J40DHpVFMzvuP3WAjdVDSIQj9ZLgIEntwmV7zazd70gxIRxncPXoFT+4
         CFFH091qz4/MAb50IWBgpIKQuvKcjPGnABS7dTLTMQf/8A9Qf0e7hvEnDIh1viKp82
         LlkSqvPm3rjkxVCLx57gvQ6eLfZFWNUVsOyfYVthNfr4t2HF/X/VAcjMvVj7Nhqm3e
         ZUjb4XK6rrBpg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C553260A37;
        Sun, 19 Sep 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: don't call netif_carrier_off() with
 NULL netdev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205460780.12471.3527443201333135002.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 12:30:07 +0000
References: <E1mRE2Z-001xhc-CB@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mRE2Z-001xhc-CB@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, qiangqing.zhang@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 17 Sep 2021 14:36:31 +0100 you wrote:
> Dan Carpenter points out that we have a code path that permits a NULL
> netdev pointer to be passed to netif_carrier_off(), which will cause
> a kernel oops. In any case, we need to set pl->old_link_state to false
> to have the desired effect when there is no netdev present.
> 
> Fixes: f97493657c63 ("net: phylink: add suspend/resume support")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylink: don't call netif_carrier_off() with NULL netdev
    https://git.kernel.org/netdev/net-next/c/cbcca2e3961e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


