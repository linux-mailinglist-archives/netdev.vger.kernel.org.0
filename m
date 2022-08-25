Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EE95A0F70
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240248AbiHYLkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239263AbiHYLkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4EE4D4EB
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D2D1B8288B
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39911C43141;
        Thu, 25 Aug 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661427615;
        bh=H+NOmaWZR86ntcxoWX0UShHEUJazXfL6KCc0YJjq2j8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E1u1IsT7u83jGEJGpS/mzcmB8k//ajrPR3JrqmKDYp2g3uSX4ySRdE2SmOyRFSd9W
         aCF7YKWlsuI/6RGTIiAq6jfOTkNArCmRqvqo7vb7BckRc2+hraYcWVPPV9YBPtKsWh
         +pBxlOYjUvLwd3xBuTymmbR8YMGviPkw8hzxYTP67mO3KWKzi8cjwOQn9JAw6OBlT2
         BZygLDjInjuejlCWZsYj6n1PL+upi8e4XkB5eYiuOyjAQhylZT0AgzTEq+lYDwLDpd
         B0z/GLeiI1qbPwaYCg7vzvXMYTtosIzuf339V356RWru7dsJ3Dk8MMC0iIG9GPXwi7
         8i1hiFjF29iPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18498E1CF31;
        Thu, 25 Aug 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: ethernet: mtk_eth_soc: fix hw hash reporting for
 MTK_NETSYS_V2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166142761509.23802.7187869473014741631.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 11:40:15 +0000
References: <091394ea4e705fbb35f828011d98d0ba33808f69.1661257293.git.lorenzo@kernel.org>
In-Reply-To: <091394ea4e705fbb35f828011d98d0ba33808f69.1661257293.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 23 Aug 2022 14:24:07 +0200 you wrote:
> Properly report hw rx hash for mt7986 chipset accroding to the new dma
> descriptor layout.
> 
> Fixes: 197c9e9b17b11 ("net: ethernet: mtk_eth_soc: introduce support for mt7986 chipset")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - fix typo in a comment
> - target net tree instead of net-next
> 
> [...]

Here is the summary with links:
  - [v2,net] net: ethernet: mtk_eth_soc: fix hw hash reporting for MTK_NETSYS_V2
    https://git.kernel.org/netdev/net/c/0cf731f9ebb5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


