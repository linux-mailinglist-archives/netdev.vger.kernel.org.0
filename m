Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C2A3B3984
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 00:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhFXWwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 18:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232922AbhFXWwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 18:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BF6C1613C8;
        Thu, 24 Jun 2021 22:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624575003;
        bh=x74HSHcfNTqdHgsDVdw5qq/uJbv5T71LaJjvAuUe2ig=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AW10HSH6aCxt0YlaYUZJIo9VbjoHjhzhxng+rUO5irk0lTrgomVGthQmhBRkT8n/9
         7eGVzDBYJU2R3tHHDRtywhfPkwjaMGVSchAIu9KhohEoqr+ALqPg6NZUx0phPflghv
         siUS/xiUCn5axwiWUgSAPIFwGGPIHJxtDt5oT+PRbhvRX8hSgISBeRmR2VlZMe8Gx9
         Pg+D3B3JxZo4eSFbjSoTnvFxK8YLaS0tCDMv+Taee/z5prvlwzkRo2/NT60CoWzG32
         5alO/29w1q2c25k7sKRND83ytlHW6gdQN0idxerZHE8UJCWDmIwPTY1Rvress2eejQ
         N4hHmT0Kxjcmw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB69160A47;
        Thu, 24 Jun 2021 22:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: sja1105: fix NULL pointer dereference in
 sja1105_reload_cbs()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162457500369.3017.3504936095805089983.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 22:50:03 +0000
References: <20210624155207.1005043-1-olteanv@gmail.com>
In-Reply-To: <20210624155207.1005043-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 24 Jun 2021 18:52:07 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> priv->cbs is an array of priv->info->num_cbs_shapers elements of type
> struct sja1105_cbs_entry which only get allocated if CONFIG_NET_SCH_CBS
> is enabled.
> 
> However, sja1105_reload_cbs() is called from sja1105_static_config_reload()
> which in turn is called for any of the items in sja1105_reset_reasons,
> therefore during the normal runtime of the driver and not just from a
> code path which can be triggered by the tc-cbs offload.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: sja1105: fix NULL pointer dereference in sja1105_reload_cbs()
    https://git.kernel.org/netdev/net/c/be7f62eebaff

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


