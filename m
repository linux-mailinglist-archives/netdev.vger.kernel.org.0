Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F464AF2BB
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbiBINaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbiBINaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:30:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82A6C05CB97;
        Wed,  9 Feb 2022 05:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 630E9619EB;
        Wed,  9 Feb 2022 13:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC4A0C340F0;
        Wed,  9 Feb 2022 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644413411;
        bh=0f0mIIp2PVoZ2iZ9BvnhTIYKPtq6j8Y1JLIMf1udPnc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l/+pwIJsjgyjtarNTWkAEtRnpo1C83yo7XdcwOp9iO4HPyHFUmjif3HgLhvDYGFGV
         0teUVYWxYibc2vgPXkUVFckd4v89RoKmooWk45aP9bWQbnoF1JkoHIu+iL+CKNscYP
         t7TkAz52HQTiSdw6qmBpDsMtVfIykbf3VU7YY0lVyt+TkndpaaoaPn/czPwizPMgYU
         8f7CEb0MFRtmaiQPtmfkql4z/2dwlD6MteFGqBmeBDS+3c05iWWq9YdCojWt4u2ToS
         Lgb6He2nf3wjjjg/sCs8ZBYyRSzIIcP7RhbnN2i8oP+WJk/y1VQlCjuAaVsEGYeAqZ
         6DC5vdZ48v3Ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6022E6D458;
        Wed,  9 Feb 2022 13:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [v2,net-next 1/3] net:enetc: allocate CBD ring data memory using DMA
 coherent methods
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164441341167.22778.2861856904847036230.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 13:30:11 +0000
References: <20220209123303.22799-1-po.liu@nxp.com>
In-Reply-To: <20220209123303.22799-1-po.liu@nxp.com>
To:     Po Liu <po.liu@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, tim.gardner@canonical.com, kuba@kernel.org,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        xiaoliang.yang_1@nxp.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 20:33:01 +0800 you wrote:
> To replace the dma_map_single() stream DMA mapping with DMA coherent
> method dma_alloc_coherent() which is more simple.
> 
> dma_map_single() found by Tim Gardner not proper. Suggested by Claudiu
> Manoil and Jakub Kicinski to use dma_alloc_coherent(). Discussion at:
> 
> https://lore.kernel.org/netdev/AM9PR04MB8397F300DECD3C44D2EBD07796BD9@AM9PR04MB8397.eurprd04.prod.outlook.com/t/
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] net:enetc: allocate CBD ring data memory using DMA coherent methods
    https://git.kernel.org/netdev/net-next/c/b3a723dbc94a
  - [v2,net-next,2/3] net:enetc: command BD ring data memory alloc as one function alone
    https://git.kernel.org/netdev/net-next/c/0cc11cdbcb39
  - [v2,net-next,3/3] net:enetc: enetc qos using the CBDR dma alloc function
    https://git.kernel.org/netdev/net-next/c/237d20c208db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


