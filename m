Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7623019E2
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 06:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbhAXFaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 00:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbhAXFau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 00:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D5CE222C9C;
        Sun, 24 Jan 2021 05:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611466209;
        bh=6YS7BK19FbcgqwVE0tJdZXqmyTJdkVrxbGJMYIsTvAg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sdDzsGMeIiULqyqeo88DpjP2nfm7IsMkewZ/nFBKwoAQE1xgplb5f4DBny8Jih0KC
         nbbA+rk/KaNwoNobQke3+kdoJbWUw5CTg55j4Fl1ReJEAcwECWwuX8PBlaijYXpqfS
         U813fTIUYAbeZoeddfooE32Ll+7qyvOLkYeHJBmfV19LOEwA8yJY+N32wRpvdulDcR
         syCds6dgTVt+rQ7N+kI9tl2thblugFC/w/OTxNKnwALQHZkhzCXg41kasS5l8Oszq3
         BfF9dDTkKwzE6NO8ejNXzqyLYoHQFbd567lN+M/4rto9l553AOTs3ncQf7HDud7I9u
         Lc7zeTBK3clkw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C69C6652F1;
        Sun, 24 Jan 2021 05:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/1] net: dsa: hellcreek: Add TAPRIO offloading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161146620980.4942.8008335595942531105.git-patchwork-notify@kernel.org>
Date:   Sun, 24 Jan 2021 05:30:09 +0000
References: <20210123105633.16753-1-kurt@linutronix.de>
In-Reply-To: <20210123105633.16753-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        vinicius.gomes@intel.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 23 Jan 2021 11:56:32 +0100 you wrote:
> Hi,
> 
> The switch has support for the 802.1Qbv Time Aware Shaper (TAS). Traffic
> schedules may be configured individually on each front port. Each port has eight
> egress queues. The traffic is mapped to a traffic class respectively via the PCP
> field of a VLAN tagged frame.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/1] net: dsa: hellcreek: Add TAPRIO offloading support
    https://git.kernel.org/netdev/net-next/c/24dfc6eb39b2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


