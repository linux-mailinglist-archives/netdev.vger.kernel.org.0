Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D932DA6E6
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgLODlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:41:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgLODkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:40:52 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608003608;
        bh=IBlpYvkH1g99lnVOuz503pa5fqEvfXf0AwlW7Jg/Xz4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mjlf9ZLOPveQP06HlfYyuzEI/VNdXxp0ws8FSP9Djd7wZswxna3g7erxML7wzqUfP
         E8pOgcmygReRhkadpcErQDgBQEExPzvAXTbeY57IFv1/6JvFsNNb5pIm3E/aC/2aA8
         /tlcVguPBDR+mgpEKL+zGAnvMe+7umS4kGpDaajGxPp99YLN/y+Gr4f70t7MPg4s2f
         dIYG+7rj1l6Y9XMb/Xis1mCqIVEKvyjo5Doho7VgRnY0RvRQX0Ny2Rgs7P7TOMYQnt
         jbXkK5qHIrRQa4hROGYIvdJDn4HgtkQ3xz6r7h6iyQ7kkcvCVgUUoL/Hmd51ZK4n9c
         HeMG6EFC2XG5w==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800360869.3580.13498349433335602151.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:40:08 +0000
References: <20201212191612.222019-1-vladimir.oltean@nxp.com>
In-Reply-To: <20201212191612.222019-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, steen.hegelund@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 12 Dec 2020 21:16:12 +0200 you wrote:
> Currently ocelot_set_rx_mode calls ocelot_mact_learn directly, which has
> a very nice ocelot_mact_wait_for_completion at the end. Introduced in
> commit 639c1b2625af ("net: mscc: ocelot: Register poll timeout should be
> wall time not attempts"), this function uses readx_poll_timeout which
> triggers a lot of lockdep warnings and is also dangerous to use from
> atomic context, potentially leading to lockups and panics.
> 
> [...]

Here is the summary with links:
  - [v4,net-next] net: mscc: ocelot: install MAC addresses in .ndo_set_rx_mode from process context
    https://git.kernel.org/netdev/net-next/c/ca0b272b48f3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


