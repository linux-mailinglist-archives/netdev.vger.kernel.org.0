Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436614360CB
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 13:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhJULwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 07:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhJULwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 07:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B378061208;
        Thu, 21 Oct 2021 11:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634817018;
        bh=sVZhOdim6P0Tvyp+gwrfDL7NI8I/xu0bMvIoOHGBp1U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XPJETXqnbn9oFCknqpTSseI3rSTRtCKIt1uq/tG5pV8R/XdY+3jgdA9rgIAeO+Pob
         rqgQFN3nVTEsoKIbB/moouJ4QBuFKQT7ivbXQcG0noO7kh9vxW3ZBr7Ds3mE9HGBHh
         Q90BvRz39j83Nal0k+7zEW4X0kBgTpiL/tAStmoOWXrHro2xkD2OgChrjZaOf3OqPs
         dmrTaZ+wCWwPshyyhYx53+YGCtBxElkOR9gYHG26CxUPsyLSDyIZF7UhRiPW5dlCSm
         TJrAegsq6iYyiinA/IxCqgJMuqor1LIaBdJvbMDm5Nod1pfRcTEKA2/Zab7e5BDqpX
         ehpIXzwJAYpSg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A920B609E2;
        Thu, 21 Oct 2021 11:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND v3 net-next 0/7] Remove the "dsa_to_port in a loop"
 antipattern
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163481701868.17414.100686950748332359.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 11:50:18 +0000
References: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 20 Oct 2021 20:49:48 +0300 you wrote:
> I noticed that v3 was dropped with "Changes requested" without actually
> requesting any change:
> https://patchwork.kernel.org/project/netdevbpf/list/?series=565665&state=*
> I suppose it has to do with the simultaneous build errors in mlx5, so
> I'm just resending now that those are fixed.
> 
> v1->v2: more patches
> v2->v3: less patches
> 
> [...]

Here is the summary with links:
  - [RESEND,v3,net-next,1/7] net: dsa: introduce helpers for iterating through ports using dp
    https://git.kernel.org/netdev/net-next/c/82b318983c51
  - [RESEND,v3,net-next,2/7] net: dsa: remove the "dsa_to_port in a loop" antipattern from the core
    https://git.kernel.org/netdev/net-next/c/d0004a020bb5
  - [RESEND,v3,net-next,3/7] net: dsa: do not open-code dsa_switch_for_each_port
    https://git.kernel.org/netdev/net-next/c/65c563a67755
  - [RESEND,v3,net-next,4/7] net: dsa: remove gratuitous use of dsa_is_{user,dsa,cpu}_port
    https://git.kernel.org/netdev/net-next/c/57d77986e742
  - [RESEND,v3,net-next,5/7] net: dsa: convert cross-chip notifiers to iterate using dp
    https://git.kernel.org/netdev/net-next/c/fac6abd5f132
  - [RESEND,v3,net-next,6/7] net: dsa: tag_sja1105: do not open-code dsa_switch_for_each_port
    https://git.kernel.org/netdev/net-next/c/5068887a4fbe
  - [RESEND,v3,net-next,7/7] net: dsa: tag_8021q: make dsa_8021q_{rx,tx}_vid take dp as argument
    https://git.kernel.org/netdev/net-next/c/992e5cc7be8e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


