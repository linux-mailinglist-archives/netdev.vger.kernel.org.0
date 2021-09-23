Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031D7415D10
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240719AbhIWLvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240697AbhIWLvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 07:51:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A811F61216;
        Thu, 23 Sep 2021 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632397807;
        bh=WC8J4fCV+i0UgzMcp98iWmv1Rq3SPVYV7fkZ1TPikEc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pEgwPR39qGclZlmUrWFlgU+i1v6ti6CnZdZTjawPR+52PfIJF7bz+qOw7mRSB6LJD
         3rP4ad9LZM/LldmUanR0OTKC9MyqdbGVcHjvgFRoV+RdxLPbbzfP1C2O2p3YgTBh2R
         6JKvdIN/jMObs0B1utyKsN4bPzlWgupPMwdxi2VsoTiIlagM84kBM3sdA6z5XOAzg4
         CMRk/WceVs1Ew3AS9G4d7Nb1ssPmMLL29OTAHG9g0bvLCaQPX7s++KKeGcirx2ahos
         jd3Wp6ny1kv6KpIuRWxX7/CjxhaJDHZqfic3DBwzkhEvzbH/+OnUB/p1iZDgDayXV3
         RDsLGIguu9npQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E6C760BBF;
        Thu, 23 Sep 2021 11:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: sja1105: don't keep a persistent reference
 to the reset GPIO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163239780764.29089.9746743283000917805.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Sep 2021 11:50:07 +0000
References: <20210922151029.2457157-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210922151029.2457157-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 22 Sep 2021 18:10:29 +0300 you wrote:
> The driver only needs the reset GPIO for a very brief period, so instead
> of using devres and keeping the descriptor pointer inside priv, just use
> that descriptor inside the sja1105_hw_reset function and then let go of
> it.
> 
> Also use gpiod_get_optional while at it, and error out on real errors
> (bad flags etc).
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: sja1105: don't keep a persistent reference to the reset GPIO
    https://git.kernel.org/netdev/net-next/c/33e1501f5a5f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


