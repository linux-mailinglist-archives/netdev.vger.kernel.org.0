Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D772057FFB2
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 15:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiGYNUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 09:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbiGYNUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 09:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80BB110F
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 06:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6446161190
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B261DC341CE;
        Mon, 25 Jul 2022 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658755213;
        bh=PxSmYHyAtKoiBMEfhuVUj4+GoPAWpUAOWgcXKXqf5f4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JRNPksy9YGWkWH2b5daWjQmJ8pWGbfEIB3FNq10lUcC17AyY27fY/ISb9fO0QmSxC
         lIIkNrsmQGhFqGehrld2LyCiMHf250/ODzoMc5SvSBWNE9o1lVkfABK6BVGjV5wgmm
         ZUBGys1M1x3bRpBG+FcKk+yVhIHrzYoD4dvTr37kuBjDk75ztkQHNy1WmrUh00lLK5
         SX8Q+Ckk9ifgMdqsgeBGA3ucBt84C8HAbYKZDsDJwKbPLtkaEBCNtO+u/ZdufPgpTr
         6KPpgVD+PBXK0dZfdNbDLrVZBI+B8begi+ceytMcgfFOfxgX7+MvfN0g2B823CdBhP
         yRczoRCPQ2GkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 96670E450B8;
        Mon, 25 Jul 2022 13:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: ethernet: mtk-ppe: fix traffic offload with
 bridged wlan
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165875521361.10499.12473781719497627426.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jul 2022 13:20:13 +0000
References: <c79ed39af42540a6ce2cd145c4ddbcb98491630b.1658473427.git.lorenzo@kernel.org>
In-Reply-To: <c79ed39af42540a6ce2cd145c4ddbcb98491630b.1658473427.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pablo@netfilter.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Ryder.Lee@mediatek.com, Evelyn.Tsai@mediatek.com,
        pvalerio@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Jul 2022 09:06:19 +0200 you wrote:
> A typical flow offload scenario for OpenWrt users is routed traffic
> received by the wan interface that is redirected to a wlan device
> belonging to the lan bridge. Current implementation fails to
> fill wdma offload info in mtk_flow_get_wdma_info() since odev device is
> the local bridge. Fix the issue running dev_fill_forward_path routine in
> mtk_flow_get_wdma_info in order to identify the wlan device.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: ethernet: mtk-ppe: fix traffic offload with bridged wlan
    https://git.kernel.org/netdev/net-next/c/2830e314778d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


