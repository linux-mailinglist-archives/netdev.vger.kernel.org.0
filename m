Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02982415E38
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241022AbhIWMVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240874AbhIWMVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 08:21:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E9CF061248;
        Thu, 23 Sep 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632399608;
        bh=7Dn1m/WquBO+/nQ4qhEL1e/bHnXVfgwZKIrc7iuaGOk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ab2LsqJWjrgjyMW72WydsSc1heND+Vgl9kfkNcskaVtSOQpBHmYrquUYwSNl4KBwm
         oAN75atDNlGBQumO0813jf1S7sm9I7mVzxVCOYNJoYZ8OVUDqjl4SkNZGdLMZrpNQe
         yKjGMUwSn8vP7/2beh/X2glTO35/THUknESPmjiH8Mm3jgRbzHpE0q53jot/UwxuRU
         Kf+vo0bJ4TpBoh2tsfaW+0OOUiJfoqayA2q/RXO1NYH4NQPYfA5U7fNSZHxfWH8jsz
         n6cfljF6rsgcCTUgFl4pjh2PIqnmTtyjaJCJd6dPdSybWljtUciuWaoyNHjWNdEJqq
         VjNbBTAlaSeFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E05C360952;
        Thu, 23 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 0/1] net: mscc: ocelot: broadcast storm fixup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163239960791.10392.14381330842241900586.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Sep 2021 12:20:07 +0000
References: <20210923020338.1945812-1-colin.foster@in-advantage.com>
In-Reply-To: <20210923020338.1945812-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 22 Sep 2021 19:03:37 -0700 you wrote:
> Ocelot ports would still forward out ethernet broadcasts when they were
> in the LEARNING or BLOCKING state. This is due to the
> ocelot_get_bridge_fwd_mask, which would tell disabled ports to forward
> packets out all FORWARDING ports. Broadcast storms would insue.
> 
> This patch restores the functionality of disabling forwarding for ports
> that aren't in the FORWARDING state. No more broadcast storms.
> 
> [...]

Here is the summary with links:
  - [v1,net,1/1] net: mscc: ocelot: fix forwarding from BLOCKING ports remaining enabled
    https://git.kernel.org/netdev/net/c/acc64f52afac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


