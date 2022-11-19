Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3229C630B94
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiKSDyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiKSDx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:53:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEF8C7221
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 19:50:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95059B8270A
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41FB3C4347C;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668829818;
        bh=BSAu+2s2PAYaODqLvKk9kbx/7WwQq7m+WZPP9j73cLc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hxsctMeSELcPjEoZrkpTgT/Usialyu61JzhBTT93qfj9EYmEmxDeIAIf3EEZyIkU+
         wuNl1+rQj2Fl+9QtheURaw8HRwlkIAlxFQxtfDbtdw18zw/iAZq2bhQitJtweP7qhv
         seHlHbGCai380XzaczDm+uhLnEv79U4/bOhB0LJvVFNN5hOVOsEEGwDHTU1YtccSaA
         zpXWQMw9tv+PuL+KyUie52ELGsdOmW1NLZTuh+K6DabueCk+OiqD25hy7pOyY2uCPg
         XXdcdA3pCT2N+C8cfogsI6PZI9KyzdZvgBI7qpml97z3GPNBikNngpwHBMlTkZZ1wk
         Dw9T7e1Bpp3lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1D77BE50D71;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix error handling in
 mtk_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166882981811.27279.4909635102411295940.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 03:50:18 +0000
References: <20221117111356.161547-1-liujian56@huawei.com>
In-Reply-To: <20221117111356.161547-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux@armlinux.org.uk, opensource@vdorst.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Nov 2022 19:13:56 +0800 you wrote:
> If mtk_start_dma() fails, invoke phylink_disconnect_phy() to perform
> cleanup. phylink_disconnect_phy() contains the put_device action. If
> phylink_disconnect_phy is not performed, the Kref of netdev will leak.
> 
> Fixes: b8fc9f30821e ("net: ethernet: mediatek: Add basic PHYLINK support")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: fix error handling in mtk_open()
    https://git.kernel.org/netdev/net/c/f70074140524

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


