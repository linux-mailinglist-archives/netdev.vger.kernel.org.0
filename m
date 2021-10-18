Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EA2431A06
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhJRMwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229833AbhJRMwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:52:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F62B60FD9;
        Mon, 18 Oct 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634561407;
        bh=Ds0JNRtVk6u3hGs8FEGVHgmbZ7RmfBbS2aG3v6pF0iM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gZbVE0F3A2TkbMJeLCMs7OGgUI8KSPlwG8puLlzVqszlEbRK58chHV4oa/cAF+vOM
         78a5aE53kJx9E4SuXhLGGH0+IIaXwHwqzNmNApTlbxFAlbdQn/To1L6fP2G+6R9wLW
         iI6H8vkstwpLd4qvqGqat5mGXHE21SIFq9FUi/LXNVulzKMouKqec6b2Rxrwr2ASLr
         KhL+CC6jGhOpa9KdKDKv/0p1c59JWGzo3adUr576NR97FDnxYbAuhTa/52ga1Gmg33
         t52Rx+6sR+Rj7ZoUkbBbvyn4ADquS9WZNm+Vd5SfpyCUES/03dqxFp0LlWkJpS1haA
         uNEl3FUa22CQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 32AA6609AD;
        Mon, 18 Oct 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mscc: ocelot: Add of_node_put() before goto
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163456140720.28486.17264466971265998997.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 12:50:07 +0000
References: <20211018013232.3732-1-wanjiabing@vivo.com>
In-Reply-To: <20211018013232.3732-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 17 Oct 2021 21:32:32 -0400 you wrote:
> Fix following coccicheck warning:
> ./drivers/net/ethernet/mscc/ocelot_vsc7514.c:946:1-33: WARNING: Function
> for_each_available_child_of_node should have of_node_put() before goto.
> 
> Early exits from for_each_available_child_of_node should decrement the
> node reference counter.
> 
> [...]

Here is the summary with links:
  - net: mscc: ocelot: Add of_node_put() before goto
    https://git.kernel.org/netdev/net/c/d1a7b9e46965

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


