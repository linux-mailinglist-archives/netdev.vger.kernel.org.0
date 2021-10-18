Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855A9431A07
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhJRMwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:52:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhJRMwS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:52:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4B80D6103C;
        Mon, 18 Oct 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634561407;
        bh=JnYYRYLbC5Sj+JWdGzdxNR/oyUX3SCHmbG8fqsaFADM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TcDN0R7DW/D984OXRguGlwOelWCUKaOId1iPfheXffhUsSF0KsCtIxct/lPp6FxqY
         laDazJABjKHudn4SZceKJhuFGBKq67xiCpngJNTrgf0xqnUfD1XjzcfCy9iR9BSnGR
         zkEAhEvZ+Dy8r+Rh/5fkP6CCyP/SduSrVV1JEpCmTSDwB7Fbcv1m6VKpkm4m2F4jR3
         2KCiRQugpfRTpKChRjZulUsPDuhsX3qI0kRwssnpPtqI15RZyFIR3ENCnLsh+7exh7
         ubNCxyCkK+IJ9jZONm/XBhmvfi7BYY9nMTpvErZGU2117r1p+fFquLlEYhjkxUHC9w
         +nO5Q/a3KlvmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F5A160A2E;
        Mon, 18 Oct 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sparx5: Add of_node_put() before goto
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163456140725.28486.14644227841066747140.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 12:50:07 +0000
References: <20211018013138.2956-1-wanjiabing@vivo.com>
In-Reply-To: <20211018013138.2956-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        bjarni.jonasson@microchip.com, yangyingliang@huawei.com,
        yang.lee@linux.alibaba.com, nathan@kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 17 Oct 2021 21:31:30 -0400 you wrote:
> Fix following coccicheck warning:
> ./drivers/net/ethernet/microchip/sparx5/s4parx5_main.c:723:1-33: WARNING: Function
> for_each_available_child_of_node should have of_node_put() before goto
> 
> Early exits from for_each_available_child_of_node should decrement the
> node reference counter.
> 
> [...]

Here is the summary with links:
  - net: sparx5: Add of_node_put() before goto
    https://git.kernel.org/netdev/net/c/d9fd7e9fccfa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


