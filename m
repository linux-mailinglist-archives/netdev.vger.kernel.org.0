Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C3231C456
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 00:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhBOXWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 18:22:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230014AbhBOXVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 18:21:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D75964E07;
        Mon, 15 Feb 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613431209;
        bh=y2FO7J8OAZm/P3cKF2FxDZTTkePflXehKcvsU8ZacMc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DYmNMoLV73Z0bvSMx9sz1kTGtNpJsgAvdAa1qNG9Mr0el4iZq+L7X05ygzZO2mspf
         +1RSP55JQ7J3QtOv+kEZ3qczNDwTmAyoBreKljwIHl63m2AECzCIFl3simCNy2kShb
         9NMzbKVzHxrIsETofB+UHtVx1Zhk3g9ItIQVlKsMI2qswzFivsS4eTiCGm/wKlvZFL
         RuL7uOYfxmeGV1RT8UYCxYKkTT/mpuwI/MQsozGzDMXVihRC320gmxTefCk5yTLUTZ
         DDz7h9QemBy9KDra0I7za7GjLBHeIX7ixYfDJoTAnKrxxeAtVX9UQg4ExW6fwSW/6g
         sAfmls3rW2epw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 06445609ED;
        Mon, 15 Feb 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] i40e: Fix incorrect use of ip6src due to copy-paste coding
 error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161343120902.10830.1258291646017278044.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 23:20:09 +0000
References: <20210215161923.83682-1-colin.king@canonical.com>
In-Reply-To: <20210215161923.83682-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        przemyslawx.patynowski@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Feb 2021 16:19:23 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> It appears that the call of ipv6_add_any for the destination address
> is using ip6src instead of ip6dst, this looks like a copy-paste
> coding error. Fix this by replacing ip6src with ip6dst.
> 
> Addresses-Coverity: ("Copy-paste error")
> Fixes: efca91e89b67 ("i40e: Add flow director support for IPv6")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - i40e: Fix incorrect use of ip6src due to copy-paste coding error
    https://git.kernel.org/netdev/net-next/c/7f76963b692d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


