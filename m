Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4A147431C
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhLNNAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbhLNNAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:00:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49027C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 05:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12BC8B819A3
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 13:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8790C34608;
        Tue, 14 Dec 2021 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639486812;
        bh=N5HEEtxrnVMkS8kgZk5D+37gy4sLA/IkXQkmTsz5zcg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lc6nv0OW5LUcPo+3GMXPGB8AkUF560c6oe3SABfWx7EX9QdXJQZy1SPUOdkwPtOT3
         9fa/lV+fXH1oFJabFQRi9UqB2f4u6M9P3jNhD5dG3b24YLE7KeTFcrpDQSViFocviI
         c8HuNHmcL0BG4FKRmRK9cz/JllA3HURVfKUrqvISh6WuKtvEU/P7/SB3vyqOaF65t6
         1enj7dneU8hioKDstsEeh+RB2SFCiLPaYEFq+a9FMPa9xpTqkQZ11m/sIOOmjSoNct
         DOY8V2XBBMdh94fvgzxi8VRmvCq7ZDnw91xjfqTVQubsgt6yEH3DYz9YZ0zN1FDrhl
         9r2BbGHZqphCw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C638760984;
        Tue, 14 Dec 2021 13:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] DSA tagger-owned storage fixups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163948681280.21223.16560273283811595367.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 13:00:12 +0000
References: <20211214014536.2715578-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211214014536.2715578-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        ansuelsmth@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 03:45:33 +0200 you wrote:
> It seems that the DSA tagger-owned storage changes were insufficiently
> tested and do not work in all cases. Specifically, the NXP Bluebox 3
> (arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts) got broken by
> these changes, because
> (a) I forgot that DSA_TAG_PROTO_SJA1110 exists and differs from
>     DSA_TAG_PROTO_SJA1105
> (b) the Bluebox 3 uses a DSA switch tree with 2 switches, and the
>     tagger-owned storage patches don't cover that use case well, it
>     seems
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: dsa: tag_sja1105: fix zeroization of ds->priv on tag proto disconnect
    https://git.kernel.org/netdev/net-next/c/e2f01bfe1406
  - [net-next,2/3] net: dsa: sja1105: fix broken connection with the sja1110 tagger
    https://git.kernel.org/netdev/net-next/c/c8a2a011cd04
  - [net-next,3/3] net: dsa: make tagging protocols connect to individual switches from a tree
    https://git.kernel.org/netdev/net-next/c/7f2973149c22

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


