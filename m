Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4571415D61
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbhIWMBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240781AbhIWMBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 08:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D3E06121F;
        Thu, 23 Sep 2021 12:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632398409;
        bh=5sC9aphyx/AvbD4jw23ILZU1e5Pv41H5EL6kPGnd9sc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C52Sf+bYBKOsu+TcxyrERdv4nVKxY4KYTbbgMcAI+ZSOvWDt6Brcom/0TvW5f/VlY
         8iX3y9tXXKnRjmBIYajPB3YzjcFAu+fsRCBRJOGnd4X/fHtvBt4ogFOH11e11nbey6
         gqjJVXyZ/hBTJCbEfnbU+4gRAAUroIkrjKFacwiiLcVngFV03HVLNORMLbJDGhvbXO
         yIwSnHjCoBtQEFuokcB3K2+Vk/RegHYZgaATXz5woZ6+pkmjLCj4G0VF7bS/tXYpdN
         IdZxCZWfkykwCqanj5Q/j5V3W9uyTOjhP9nee4jkglRo2kVCDrfPL5uPWhGdBFnkr0
         gEH7OsTK1hG4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 06B6160A88;
        Thu, 23 Sep 2021 12:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: stop using priv->vlan_aware
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163239840902.772.1257187755849525778.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Sep 2021 12:00:09 +0000
References: <20210922183655.2680551-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210922183655.2680551-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 22 Sep 2021 21:36:55 +0300 you wrote:
> Now that the sja1105 driver is finally sane enough again to stop having
> a ternary VLAN awareness state, we can remove priv->vlan_aware and query
> DSA for the ds->vlan_filtering value (for SJA1105, VLAN filtering is a
> global property).
> 
> Also drop the paranoid checking that DSA calls ->port_vlan_filtering
> multiple times without the VLAN awareness state changing. It doesn't,
> the same check is present inside dsa_port_vlan_filtering too.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: dsa: sja1105: stop using priv->vlan_aware
    https://git.kernel.org/netdev/net-next/c/9aad3e4ede9b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


