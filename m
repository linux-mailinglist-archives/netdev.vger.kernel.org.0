Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DBF66DB83
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 11:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbjAQKu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 05:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbjAQKuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 05:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C902FCF0
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 02:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2D27B812A5
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4CE10C433F0;
        Tue, 17 Jan 2023 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673952617;
        bh=/IEm6wvtsrOpUNV1HKFCxX4chsm/uHwtx2yt9ZmwEFM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FrErKYkx7oKG+/LB/qn8vt6gssfLNeaIEaEaX9iXDka/sB6V4PUwFeUrIDAiHEQBQ
         sSIoXkSJ7zGFMt7Jh6w7X/QHqd+Ot/c8DOaEbqScUH4PITYJWKiCACa3mXFbJvIFQG
         /Ho5voCfky6Od2bHQp2Q/m+hJegE2tSFyoboN+0dYf6TcmOtYJIRo4g820VWTtiR4A
         LLl6xk61gKNHfu3HMxg8aRfLT/jvjVCsyF56wcI8E60xsPpvS2YRJ/WsPGiUHwX4MH
         HtdqctAs4iDkeX8BPAnk70ARWhYSec9l1RgC8aEVvKwNx5K5o7EdLvCbP5fqV/L0eh
         k981B8/cVVc7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32F22C43159;
        Tue, 17 Jan 2023 10:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 net-next 0/5] net: ethernet: mtk_wed: introduce reset
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167395261720.2304.3313123106989727184.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Jan 2023 10:50:17 +0000
References: <cover.1673715298.git.lorenzo@kernel.org>
In-Reply-To: <cover.1673715298.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com,
        daniel@makrotopia.org, leon@kernel.org, alexander.duyck@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 14 Jan 2023 18:01:27 +0100 you wrote:
> Introduce proper reset integration between ethernet and wlan drivers in order
> to schedule wlan driver reset when ethernet/wed driver is resetting.
> Introduce mtk_hw_reset_monitor work in order to detect possible DMA hangs.
> 
> Changes since v5:
> - log error reported by reset callback
> - convert reset_complete callback from int to void
> 
> [...]

Here is the summary with links:
  - [v6,net-next,1/5] net: ethernet: mtk_eth_soc: introduce mtk_hw_reset utility routine
    https://git.kernel.org/netdev/net-next/c/bccd19bce0b6
  - [v6,net-next,2/5] net: ethernet: mtk_eth_soc: introduce mtk_hw_warm_reset support
    https://git.kernel.org/netdev/net-next/c/a9724b9c477f
  - [v6,net-next,3/5] net: ethernet: mtk_eth_soc: align reset procedure to vendor sdk
    https://git.kernel.org/netdev/net-next/c/06127504c282
  - [v6,net-next,4/5] net: ethernet: mtk_eth_soc: add dma checks to mtk_hw_reset_check
    https://git.kernel.org/netdev/net-next/c/93b2591ad0d0
  - [v6,net-next,5/5] net: ethernet: mtk_wed: add reset/reset_complete callbacks
    https://git.kernel.org/netdev/net-next/c/08a764a7c51b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


