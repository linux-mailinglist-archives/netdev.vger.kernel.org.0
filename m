Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B4157FCAF
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 11:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbiGYJuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 05:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbiGYJuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 05:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38115FCB
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 02:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EBB8B80E2E
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 09:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10EB5C341C7;
        Mon, 25 Jul 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658742614;
        bh=7KgDUam99vWAh7RjWX40VFff7LVefNo5IqM99eHy+co=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SfrkY7ptB8ytcxOVKXXq9/r+2u9pjGXlILX3FKmyK7+bhyLkmNE9X2v4PMxJFbCkW
         Grh65bC/v3ZYZWn0p/2mZmQvTqcOQhOI4cJXEhIzrLMJ7nS4thfuzpuYJ8+ca/NUqV
         LAhhe6OedCZZ0egMkzJKkWvq/KswBg/8yU7vbBJ1Iyp7Pjfrv1LqX62RAj3Z0y/Gnb
         3SkJ27+HeGHgAae7WVwP+fw1kqBdokca6qeO29t5hP2Sh+FNOqiO89t/8mKyCoskM7
         r5cxsOfC8ugt8cUvXg4bru7khgGoMsI+JntAueaoTpA88h98Hx/ccOhObJvpy52R/C
         HFSF+CXftcC5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E9BFFE450B5;
        Mon, 25 Jul 2022 09:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/5] mtk_eth_soc: add xdp support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165874261395.3948.10032831276100096007.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jul 2022 09:50:13 +0000
References: <cover.1658474059.git.lorenzo@kernel.org>
In-Reply-To: <cover.1658474059.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Jul 2022 09:19:35 +0200 you wrote:
> Introduce XDP support for mtk_eth_soc driver if rx hwlro is not
> enabled in the chipset (e.g. mt7986).
> Supported XDP verdicts:
> - XDP_PASS
> - XDP_DROP
> - XDP_REDIRECT
> - XDP_TX
> - ndo_xdp_xmit
> Rely on page_pool allocator for single page buffers in order to keep
> them dma mapped and add skb recycling support.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/5] net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers
    https://git.kernel.org/netdev/net-next/c/23233e577ef9
  - [v4,net-next,2/5] net: ethernet: mtk_eth_soc: add basic XDP support
    https://git.kernel.org/netdev/net-next/c/7c26c20da5d4
  - [v4,net-next,3/5] net: ethernet: mtk_eth_soc: introduce xdp ethtool counters
    https://git.kernel.org/netdev/net-next/c/916a6ee836d6
  - [v4,net-next,4/5] net: ethernet: mtk_eth_soc: add xmit XDP support
    https://git.kernel.org/netdev/net-next/c/5886d26fd25b
  - [v4,net-next,5/5] net: ethernet: mtk_eth_soc: add support for page_pool_get_stats
    https://git.kernel.org/netdev/net-next/c/84b9cd389036

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


