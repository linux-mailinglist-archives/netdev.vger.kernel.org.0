Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAE43DE21D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 00:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhHBWKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 18:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231987AbhHBWKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 18:10:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6AAE260F41;
        Mon,  2 Aug 2021 22:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627942205;
        bh=e5HDMNUVxVAnWFs/XGtwxzLKoFESQ+SzcrhLxmZo8zg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=InovInF8f2mareLTbC6Wt0YD97o8jR6KgUl6sKw2lvgXEdSQfKeJow7A7OV3yeeXD
         b7gvxSZtE3F2Tqnp9x71oVjtzswPEHg1YNnOYwaW+7RiKIBv+UfTVMX7gsLsZGOyNe
         VjDn7FK4FdFP//qRsXue8VJFX7EeX6WaHknB6xOyGBCxOiD5Ai0Dfyee3oLvR2CzPx
         14B8yrHBNcSjp21XzoD8HO4LI6T9d3D79hYt/B0NHa7kpfCtBZ3s3FWKMHTyPqmLIX
         bp9UKpdH6/4VayzCe5hU/cLWxBTpdpgkTbkEeaonMmrU6DjPaYAYz1wu5AzMsgTO7b
         v5mnSL8q2FASQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5A44C60A44;
        Mon,  2 Aug 2021 22:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when adding
 an extern_learn FDB entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162794220536.7989.3987115619010185604.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 22:10:05 +0000
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210801231730.7493-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        jiri@resnulli.us, idosch@idosch.org, roopa@nvidia.com,
        nikolay@nvidia.com, bridge@lists.linux-foundation.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  2 Aug 2021 02:17:30 +0300 you wrote:
> Currently it is possible to add broken extern_learn FDB entries to the
> bridge in two ways:
> 
> 1. Entries pointing towards the bridge device that are not local/permanent:
> 
> ip link add br0 type bridge
> bridge fdb add 00:01:02:03:04:05 dev br0 self extern_learn static
> 
> [...]

Here is the summary with links:
  - [net] net: bridge: validate the NUD_PERMANENT bit when adding an extern_learn FDB entry
    https://git.kernel.org/netdev/net/c/0541a6293298

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


