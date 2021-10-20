Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED644434272
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 02:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhJTACY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 20:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhJTACU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 20:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 178A26103D;
        Wed, 20 Oct 2021 00:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634688007;
        bh=fKDJWlzE7Bp7ndKEwD3DVfQzifMAVb6YVU5tP6uNR/E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jlJU3k9wtM21ARRb/e6RueRqeeiVzZGHqs05bMplmwNkok0+1gB32WctEr0arPmI1
         lW+WsoCB2VN0bRFgrOBxA9kSwmzH4gF1B8UbRWhbZOGFB9utzV5ho9rs9VUlABs9Q0
         f4vVqhrO/AR5txF3lo9+UdPYjEbOeGzYg/aSLusdVEM8/nkDkGTgJUKbHdZE8wyBFc
         RfezCrHUPNcnvSLe5IncCdTqMRj4q6woNBB66JHlIQHhRCX/09pEVHmmcM/pht339F
         OTW46SdCczkj5PHQpz2EcDtO97LALXZ+oGmxy7s7NR17OO5jvzFHGzvTqFwBM8s6jz
         Xx8ml6deZ23xA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C5B1609E7;
        Wed, 20 Oct 2021 00:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: Fix an error handling path in
 'dsa_switch_parse_ports_of()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163468800704.13259.18394781870151332123.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 00:00:07 +0000
References: <15d5310d1d55ad51c1af80775865306d92432e03.1634587046.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <15d5310d1d55ad51c1af80775865306d92432e03.1634587046.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 18 Oct 2021 21:59:00 +0200 you wrote:
> If we return before the end of the 'for_each_child_of_node()' iterator, the
> reference taken on 'port' must be released.
> 
> Add the missing 'of_node_put()' calls.
> 
> Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: dsa: Fix an error handling path in 'dsa_switch_parse_ports_of()'
    https://git.kernel.org/netdev/net/c/ba69fd9101f2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


