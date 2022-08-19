Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB7C5993DA
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 06:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345788AbiHSEBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 00:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237247AbiHSEA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 00:00:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84E3C9256
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 21:00:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AE8A61505
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9FA4C433C1;
        Fri, 19 Aug 2022 04:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660881656;
        bh=Mi88JNUIm06sZH6TJFwbkFdAcMiiOAxRt6mUAh0OcWU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CL4wEBuumdmqIuofvYxPRhp/77N5uEWsVvkWZWAl4ri8NXjCWUuiaIeK7L2CVgfx1
         PIJg7XmmOV5OwK02lKgcxHrNpjlnBr6J877Z24Iu8oDy6yiW8bDcqujADXLQhw528A
         U5jDv7ll0B66GcwaOYd54qcrp9XkyiMcpXur41Qgq/yfLdMfM+jMqkFfh4mBdGylzx
         ifbTSHptZsuVKPZpOpDGMtsodJ5rYbG+w8tJduiT4l2Q47fAVscMHsrj2mcA7foJc/
         EwJ7XQC2fYdr1eaCn/sDaIDDe28O8BXLUK4pESeq8KuIjwYrz2keMlazrWY9eclROQ
         9xSoJxp/NBe5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86DACC00444;
        Fri, 19 Aug 2022 04:00:56 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: remove unused txd_pdma
 pointer in mtk_xdp_submit_frame
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166088165653.14408.940092514189359177.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Aug 2022 04:00:56 +0000
References: <2c40b0fbb9163a0d62ff897abae17db84a9f3b99.1660669138.git.lorenzo@kernel.org>
In-Reply-To: <2c40b0fbb9163a0d62ff897abae17db84a9f3b99.1660669138.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 Aug 2022 19:14:30 +0200 you wrote:
> Get rid of unnecessary txd_pdma pointer in mtk_xdp_submit_frame for loop
> since it is actually used at the end of the routine using latest mtk_tx_dma
> consumed pointer as reference.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: mtk_eth_soc: remove unused txd_pdma pointer in mtk_xdp_submit_frame
    https://git.kernel.org/netdev/net-next/c/a64bb2b08623

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


