Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070D647A8DE
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 12:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhLTLkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 06:40:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57740 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbhLTLkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 06:40:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D54260FF2;
        Mon, 20 Dec 2021 11:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA236C36AE8;
        Mon, 20 Dec 2021 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640000409;
        bh=xhQnf56bsaHJHJcBDmOwBiSBwGs6r1NJVkB3ZlKZuZU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ICMDWwgmY7NiCacD+7UnoSA3elMhtXyLoxU507xVudm5bWyqaEfRQfZZprC5WQ8te
         Co6/79D/Q9Yg+NcterUvuKsPIof7Aws3UMltQ6SLo4P1mq6JFHZIAz0sv+tUED1rqA
         hVSibgOLH6KGsWHqTO8uHBGOwUHMbKyHmusVvHapo/DopLz7P1iD8g9MvSFX2IgFvF
         5KVpPxVOWaP2OEgOgpHnABkN0I2Geg1U+PezpJlBkxrKky4IEtgTdDna5DUxb1Ax8T
         HSwjWY1A4jiloFmJJMA9Y/GISulDW4AgusV1wGHGrtwhlL6uPEAl017J/RLEvnhLnz
         QeC6GARrDNuIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B333960A6F;
        Mon, 20 Dec 2021 11:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mac80211: fix locking in ieee80211_start_ap error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164000040972.26538.12878058842061474047.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Dec 2021 11:40:09 +0000
References: <20211220092240.12768-1-johannes@sipsolutions.net>
In-Reply-To: <20211220092240.12768-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        johannes.berg@intel.com, stable@vger.kernel.org,
        syzbot+11c342e5e30e9539cabd@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 20 Dec 2021 10:22:40 +0100 you wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> We need to hold the local->mtx to release the channel context,
> as even encoded by the lockdep_assert_held() there. Fix it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 295b02c4be74 ("mac80211: Add FILS discovery support")
> Reported-and-tested-by: syzbot+11c342e5e30e9539cabd@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/r/20211220090836.cee3d59a1915.I36bba9b79dc2ff4d57c3c7aa30dff9a003fe8c5c@changeid
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> [...]

Here is the summary with links:
  - [net] mac80211: fix locking in ieee80211_start_ap error path
    https://git.kernel.org/netdev/net/c/87a270625a89

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


