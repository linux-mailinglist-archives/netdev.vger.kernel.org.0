Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50119471B77
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 17:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhLLQAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 11:00:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60750 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbhLLQAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 11:00:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C16F4B80D24
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 16:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43A14C341C5;
        Sun, 12 Dec 2021 16:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639324811;
        bh=4QjrJtJsyAxMFcThjoE2h90T9h3H9k+Sy/UMl5TBPcw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JxXwpIOQBaPQVy2KpBaoBpoJh5rL5upCBp9zq+K6MarW3KeQlZYZF8m4tY0bC5qCN
         Wl7/nrOiIAXWlFPGaupEqgBPZM6HkF8S+VUZR06or+3Kp7eEPSMqhsVFfDDjbouVdE
         HAHHIJfeGdOA+F91FpSenvOd3XHU/bJVHHfeQd4J2hLtTOlicE+/OxN7VRnaBgR6VU
         mN7CUvse5PxAEG3vSzIpXfMgwKUgNY8d3xt5YawcQDn7D0Iup3Fadgp+nVbz2X57o7
         5sfohnQv7AUG66h+gLo3YYK3JrzZ4WfMAtJy1GXqi/qmu/yQ9IhRab0daZnKhIun6F
         hiIa3QtGlMFFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 15C4860BD0;
        Sun, 12 Dec 2021 16:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 00/11] Replace DSA dp->priv with tagger-owned
 storage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163932481108.23253.4998237633289808224.git-patchwork-notify@kernel.org>
Date:   Sun, 12 Dec 2021 16:00:11 +0000
References: <20211209233447.336331-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211209233447.336331-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        martin.kaistra@linutronix.de, kurt@linutronix.de,
        ansuelsmth@gmail.com, tobias@waldekranz.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Dec 2021 01:34:36 +0200 you wrote:
> Ansuel's recent work on qca8k register access over Ethernet:
> https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.7444-1-ansuelsmth@gmail.com/
> has triggered me to do something which I should've done for a longer
> time:
> https://patchwork.kernel.org/project/netdevbpf/patch/20211109095013.27829-7-martin.kaistra@linutronix.de/#24585521
> which is to replace dp->priv with something that has less caveats.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,01/11] net: dsa: introduce tagger-owned storage for private and shared data
    https://git.kernel.org/netdev/net-next/c/dc452a471dba
  - [v2,net-next,02/11] net: dsa: tag_ocelot: convert to tagger-owned data
    https://git.kernel.org/netdev/net-next/c/35d976802124
  - [v2,net-next,03/11] net: dsa: sja1105: let deferred packets time out when sent to ports going down
    https://git.kernel.org/netdev/net-next/c/a3d74295d790
  - [v2,net-next,04/11] net: dsa: sja1105: bring deferred xmit implementation in line with ocelot-8021q
    https://git.kernel.org/netdev/net-next/c/d38049bbe760
  - [v2,net-next,05/11] net: dsa: sja1105: remove hwts_tx_en from tagger data
    https://git.kernel.org/netdev/net-next/c/6f6770ab1ce2
  - [v2,net-next,06/11] net: dsa: sja1105: make dp->priv point directly to sja1105_tagger_data
    https://git.kernel.org/netdev/net-next/c/bfcf14252220
  - [v2,net-next,07/11] net: dsa: sja1105: move ts_id from sja1105_tagger_data
    https://git.kernel.org/netdev/net-next/c/22ee9f8e4011
  - [v2,net-next,08/11] net: dsa: tag_sja1105: convert to tagger-owned data
    https://git.kernel.org/netdev/net-next/c/c79e84866d2a
  - [v2,net-next,09/11] Revert "net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol driver"
    https://git.kernel.org/netdev/net-next/c/fcbf979a5b4b
  - [v2,net-next,10/11] net: dsa: tag_sja1105: split sja1105_tagger_data into private and public sections
    https://git.kernel.org/netdev/net-next/c/950a419d9de1
  - [v2,net-next,11/11] net: dsa: remove dp->priv
    https://git.kernel.org/netdev/net-next/c/4f3cb34364e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


