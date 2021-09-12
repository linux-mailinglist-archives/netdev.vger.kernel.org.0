Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB079407CBA
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 11:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhILJvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 05:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229643AbhILJvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 05:51:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8C76D60F38;
        Sun, 12 Sep 2021 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631440206;
        bh=OgQwrVUxS7/qdw3UscGoxmc/3kScO2tGCbAelLxxOmM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JW5mSeu5Z7KUE1fK5K7GSwXLb5ihWwrfBJLsHPpG42O4FfrS3Wp6DM1DFYoBz6C2H
         HmBiPcQCk1GsedDK1Ly14reL61Dv15C9Fw04mybVpI5zdK4YyXTmxft5Y/7SszVbdl
         oc24Adpg2Nk8E36Czhnj+tYfyVNBq4fXkfduT5iwUtLrh8wvno0yuEQSByaZofh8VW
         e7RnwZV+QU+XFvDnIdKUX9WzswcLywM93o9wUF1ujVRokIBDmH80KoTjfCALmaGUTl
         aeUhFQv5tXeUn2wPpXhs3t4wX0spfSd068XRqjUDbMXeEHM6yETk3BPNchEPUO6+gR
         f1K2SprHGKJrw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7EEF2600E8;
        Sun, 12 Sep 2021 09:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: qca8k: fix kernel panic with legacy mdio mapping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163144020651.29472.9873983978968397352.git-patchwork-notify@kernel.org>
Date:   Sun, 12 Sep 2021 09:50:06 +0000
References: <20210911155009.22251-1-ansuelsmth@gmail.com>
In-Reply-To: <20210911155009.22251-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 11 Sep 2021 17:50:09 +0200 you wrote:
> When the mdio legacy mapping is used the mii_bus priv registered by DSA
> refer to the dsa switch struct instead of the qca8k_priv struct and
> causes a kernel panic. Create dedicated function when the internal
> dedicated mdio driver is used to properly handle the 2 different
> implementation.
> 
> Fixes: 759bafb8a322 ("net: dsa: qca8k: add support for internal phy and internal mdio")
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: qca8k: fix kernel panic with legacy mdio mapping
    https://git.kernel.org/netdev/net/c/ce062a0adbfe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


