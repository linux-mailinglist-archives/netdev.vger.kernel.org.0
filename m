Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE498367416
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbhDUUUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 16:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239205AbhDUUUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 16:20:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2064F613D1;
        Wed, 21 Apr 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619036409;
        bh=qxmroyGwDgPuhsbjdoMnzFuRRfxLwsCEul9fsJmqj3s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RVNh3i2VShUffSzKrxQRwFd68l7pTDFWPKE0MSFJSz4NO0zlPr1PkjaNlJyke+5DX
         St1MnNm0fuPZul4JeUWG4umtC28ArOqvqvNnDk97z6D2UFJCy5ujRq33rQXkSazD/x
         uYhLdYjMjRf6Zn/K3kLMG+p0me2Eyhp/rpgkEzXqKVbxoqueM5PX7bcYn60gLyDz/l
         8w5zYY7vEowJiZcZZ9H2ToRrdoLOkjjuiqn9b+yO38kBuz8PjK4iI+tP0Y+CpSY3XE
         og+sIJBeDBMTHdeCEEs7Iw2JaUVk3O3KL+sNYnF9zIx74RjjG20MpprCcnJzBY9GAb
         wW2eKGQyiM7gw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1330F60A3C;
        Wed, 21 Apr 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: fix error in br_multicast_add_port when
 CONFIG_NET_SWITCHDEV=n
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161903640907.20364.4893224583811850885.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 20:20:09 +0000
References: <20210421184420.1584100-1-olteanv@gmail.com>
In-Reply-To: <20210421184420.1584100-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, borntraeger@de.ibm.com,
        netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        jiri@resnulli.us, idosch@idosch.org, roopa@nvidia.com,
        nikolay@nvidia.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Apr 2021 21:44:20 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When CONFIG_NET_SWITCHDEV is disabled, the shim for switchdev_port_attr_set
> inside br_mc_disabled_update returns -EOPNOTSUPP. This is not caught,
> and propagated to the caller of br_multicast_add_port, preventing ports
> from joining the bridge.
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: fix error in br_multicast_add_port when CONFIG_NET_SWITCHDEV=n
    https://git.kernel.org/netdev/net-next/c/68f5c12abbc9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


