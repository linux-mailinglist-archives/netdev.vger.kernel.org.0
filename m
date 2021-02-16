Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6EB31D27A
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhBPWK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhBPWKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 17:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9EDAC64E6B;
        Tue, 16 Feb 2021 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613513408;
        bh=nPRGtnnIXGIKmR5uUR2BjT0RaXjwKbgxqu5C+LoKjvY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T+6AJaS2BWLi8DaQyukOnS83VO4PhoScaOoXu/0PHrbtsOH1a08PZm+Ie6yBScgnF
         oQiwij5uikrMZf8tnVJ9M7+dZ8rlhuktiqSR79v6PdFr8wHrvqvAy+Jp5lkmf9Gjro
         CgCQAD+Xno1+1f5B69JtPBROABUxMi5H/cD5jy6Zsjv0UyzD7jgrvL8dQzXYni7Cul
         C9avLT8Jehzvhx0BpzjlimErSZ9BXt9ftRTszN1U8SUthEcf0jk4gQ+CJbjbcU7lcS
         ek9JQi97tGXM0QCCM2RLBwesREx8wNCC341kcq9yzkKmk1F//Mbj5k9Cus4wunGqGK
         0epOCIZCBh2rA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 92FA3609F8;
        Tue, 16 Feb 2021 22:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: felix: don't deinitialize unused ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351340859.15084.11127932682309408901.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 22:10:08 +0000
References: <20210216111446.2850726-1-olteanv@gmail.com>
In-Reply-To: <20210216111446.2850726-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 13:14:46 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> ocelot_init_port is called only if dsa_is_unused_port == false, however
> ocelot_deinit_port is called unconditionally. This causes a warning in
> the skb_queue_purge inside ocelot_deinit_port saying that the spin lock
> protecting ocelot_port->tx_skbs was not initialized.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: felix: don't deinitialize unused ports
    https://git.kernel.org/netdev/net-next/c/42b5adbbac03

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


