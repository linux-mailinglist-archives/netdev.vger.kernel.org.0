Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202CD3EEDF1
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 16:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237552AbhHQOAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 10:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235092AbhHQOAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 10:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DFB7460E09;
        Tue, 17 Aug 2021 14:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629208805;
        bh=dCRWIl/PGCx8+O8TXnNtR0qy28pSlWm/9WEhSwHcdDM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BwRlYnkI+nrBgSMMZ0xKeIHF2KH6mIN1J0g+GrN3QwVLN41Wj2XTWYC8yDbgeNAl/
         TGSdJAte1SAFYmLSrHsVt6WRRrOEU4GNugYQglmib84aBAzQbC8G7mBRQa+2uME6FC
         8JGW3/T69TJZ/8RW7BrnOvncdK799E52WStbgnEamfokcy2xeRFahCyV4w3kU2ABDz
         oK2kvIe6NC7nSmqVPduFZo+E/W3fNYJqSc24RC9SZdG3/2M21y6PPkjbzguu+2r3zz
         OFdRagD157Qk7gx6Xyge35EQhcqb4gg1ZxYJpf18GB/twIDRGBlTA/QqlqA26J6ZSL
         mtao3TIO0uKjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D2AD860A25;
        Tue, 17 Aug 2021 14:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mac80211: fix locking in ieee80211_restart_work()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162920880585.21796.10051805264087210953.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Aug 2021 14:00:05 +0000
References: <20210817121210.47bdb177064f.Ib1ef79440cd27f318c028ddfc0c642406917f512@changeid>
In-Reply-To: <20210817121210.47bdb177064f.Ib1ef79440cd27f318c028ddfc0c642406917f512@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        johannes.berg@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 17 Aug 2021 12:12:22 +0200 you wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Ilan's change to move locking around accidentally lost the
> wiphy_lock() during some porting, add it back.
> 
> Fixes: 45daaa131841 ("mac80211: Properly WARN on HW scan before restart")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> [...]

Here is the summary with links:
  - [net] mac80211: fix locking in ieee80211_restart_work()
    https://git.kernel.org/netdev/net/c/276e189f8e4e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


