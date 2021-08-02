Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3813DDA50
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbhHBONR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237905AbhHBOKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B60D60F6D;
        Mon,  2 Aug 2021 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627913406;
        bh=5+6Y2+gHmsQYd0A2UG6TrUjDF5d3sMcKjlEVEMpfG+o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L+V4yzcP9gXNUSkRIEbA17nyUfQFvyPAKrJlU9m4Dbl64H18tESHg9KEgOfmLOxgv
         nFo3h/qZd0R7B+BLbSpE9GLaCL2ZKwlbKvgItFRl7CoXMkm328uTmWUgEHp8PlshXs
         yTkv8FZkxDU+i8kdpwIs48XmtehaUD5mwILMYT0WLHueFxAorTBAzfzzSgiJkDVmmF
         VW6aXB5fMEGuRHztl8rCHh0adD8GQkiQs0k1PtIGdN9WFJVRIS6gsfNpxOerRLIXgD
         chMazbiVUhu+qj2hWf/C3LHAw8quYMRjvzwR90vhWitpM2Dn59ULZgQ6zo1ifbouoc
         +yTi1EpEuNMYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 812916098C;
        Mon,  2 Aug 2021 14:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: mt7530: drop paranoid checks in
 .get_tag_protocol()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162791340652.12354.9009743093747341202.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 14:10:06 +0000
References: <20210730225714.1857050-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210730225714.1857050-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com, dqfext@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 31 Jul 2021 01:57:14 +0300 you wrote:
> It is desirable to reduce the surface of DSA_TAG_PROTO_NONE as much as
> we can, because we now have options for switches without hardware
> support for DSA tagging, and the occurrence in the mt7530 driver is in
> fact quite gratuitout and easy to remove. Since ds->ops->get_tag_protocol()
> is only called for CPU ports, the checks for a CPU port in
> mtk_get_tag_protocol() are redundant and can be removed.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: mt7530: drop paranoid checks in .get_tag_protocol()
    https://git.kernel.org/netdev/net-next/c/244f8a802911

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


