Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886FE63BE41
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiK2Kub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 05:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiK2KuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B8C2B1A0
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 02:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6331EB8125E
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03E0CC433B5;
        Tue, 29 Nov 2022 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669719016;
        bh=GG5Li7PCSZhVOrt8aMqLZLPn+/RbnpjPbWLk1rZ4jAw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AO3sQuYqQoRduMdJd0t+ZbjkVTUJC094zsK9+jGfgO0/fcSdoJmyClenvwrkTo+Zx
         NlUat8MG1URon2sGIe7+w+EyAqror+Wgqu1lQrwnjwYimr13MG92ElAnagNQmAAWG2
         xTqKb5umyxPd9KIs7HRobvl1F4gbZgDdqQm1mKUBQlQ5IgA5uE4amuE35UhpwBqR4r
         iHAao2ltPSR1M5cefltnIkuXDhgQsEMGnrt2MVJuqKlLzMFCRzjOCEp0nQCVPxflFq
         RmL66nqoVxrJCoIsK6MAXLyrb7LTGENSwHQKLDmDF37EMWch0+O4qs3fm2KuNr+jWl
         UdaCLWHUM0n2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA1D9E21EF5;
        Tue, 29 Nov 2022 10:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/5] refactor mtk_wed code to introduce SER
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166971901588.19778.10630700860391594929.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 10:50:15 +0000
References: <cover.1669303154.git.lorenzo@kernel.org>
In-Reply-To: <cover.1669303154.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com, linux-mediatek@lists.infradead.org
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

On Thu, 24 Nov 2022 16:22:50 +0100 you wrote:
> Refactor mtk_wed support in order to introduce proper integration for hw reset
> between mtk_eth_soc/mtk_wed and mt76 drivers.
> 
> Changes since v1:
> - improve commit logs
> 
> Lorenzo Bianconi (5):
>   net: ethernet: mtk_wed: return status value in mtk_wdma_rx_reset
>   net: ethernet: mtk_wed: move MTK_WDMA_RESET_IDX_TX configuration in
>     mtk_wdma_tx_reset
>   net: ethernet: mtk_wed: update mtk_wed_stop
>   net: ethernet: mtk_wed: add mtk_wed_rx_reset routine
>   net: ethernet: mtk_wed: add reset to tx_ring_setup callback
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/5] net: ethernet: mtk_wed: return status value in mtk_wdma_rx_reset
    https://git.kernel.org/netdev/net-next/c/b0488c4598a5
  - [v2,net-next,2/5] net: ethernet: mtk_wed: move MTK_WDMA_RESET_IDX_TX configuration in mtk_wdma_tx_reset
    https://git.kernel.org/netdev/net-next/c/92b1169660eb
  - [v2,net-next,3/5] net: ethernet: mtk_wed: update mtk_wed_stop
    https://git.kernel.org/netdev/net-next/c/f78cd9c783e0
  - [v2,net-next,4/5] net: ethernet: mtk_wed: add mtk_wed_rx_reset routine
    https://git.kernel.org/netdev/net-next/c/b08134c6e109
  - [v2,net-next,5/5] net: ethernet: mtk_wed: add reset to tx_ring_setup callback
    https://git.kernel.org/netdev/net-next/c/23dca7a90017

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


