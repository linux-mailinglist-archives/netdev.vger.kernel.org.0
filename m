Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B234742C6
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhLNMkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhLNMkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:40:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B868C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAFA3614A2
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56D78C34606;
        Tue, 14 Dec 2021 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639485610;
        bh=h8V7zXX+upGWCiSmZdX9Mv0fkIwrT5zALRr/nQXpHfo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B522xN9Hviu+kuYoqoo6wXCWIcXjzgvQbzIoUI+G7teuEfFxcw3lFre4CySiHkA8k
         MIgB3tB05H3X87gJVAZbNTYkdsV6yolZ+OxQsBw2tFW/ym9uB5jZNmFtHWrMuhlP2O
         6sNRe6zxRDrA1mz/lfpTe9dq/4j5NxOC+ww8lzA5ZH4b6eT5/AE/aQp6CSfZdWPb5Z
         xsNytCtaF0w+8lj5sNeaJRwR0gyKgFKVWOA/qshkmR6exJPQ1QFyQ5WQuCgC9r0oHL
         fM7qSVotdJUco5Q+SVmZSy8rc9wJTdHglRXr46KTOKKw9kFdhNAmtTFusL01Spbua5
         nMqSUvBsWFe1w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4384C60A2F;
        Tue, 14 Dec 2021 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] net: stmmac: fix tc flower deletion for VLAN
 priority Rx steering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163948561027.12013.1168434953133030170.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 12:40:10 +0000
References: <20211211145134.630258-1-boon.leong.ong@intel.com>
In-Reply-To: <20211211145134.630258-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        kurt@linutronix.de, bigeasy@linutronix.de,
        yannick.vignon@oss.nxp.com, olteanv@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Dec 2021 22:51:34 +0800 you wrote:
> To replicate the issue:-
> 
> 1) Add 1 flower filter for VLAN Priority based frame steering:-
> $ IFDEVNAME=eth0
> $ tc qdisc add dev $IFDEVNAME ingress
> $ tc qdisc add dev $IFDEVNAME root mqprio num_tc 8 \
>    map 0 1 2 3 4 5 6 7 0 0 0 0 0 0 0 0 \
>    queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
> $ tc filter add dev $IFDEVNAME parent ffff: protocol 802.1Q \
>    flower vlan_prio 0 hw_tc 0
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] net: stmmac: fix tc flower deletion for VLAN priority Rx steering
    https://git.kernel.org/netdev/net/c/aeb7c75cb774

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


