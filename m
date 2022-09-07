Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44CA5B07CA
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiIGPAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiIGPAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:00:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEEE9E684
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 614EFB81DA9
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 15:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05660C43144;
        Wed,  7 Sep 2022 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662562819;
        bh=eB7M5NbEB3N9/PUQtZ8MqWdvyG/Yra/aItVYNkz14MI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DwwdyH6v85sCT0HX0XFMTfuvaIjJptl1nwl3KccL3SyoQSxc73DmStY8W5dsvS2vc
         k405xITuUBqtCpz/MexFB0kKb5cRbJjjpcHen55HGnG4VDaRRlhHbiahc006ziDK9F
         JTuNKNE14TSpeWGFhgmTa4UO50A+k8c15iaAWoDCcN2FZcX0EXeXL/UzD3pFF1vmHD
         MFB/dX5Un+E6qYrr93C026rnSnWzHUT3db/8SkPS3xSed7Cck5FMchMR1VSpdeEKlS
         /blcBJVZAOSNiU+xz0X+uQz187AsREXktV8b2kJT37dSw7BPUADEljDra57xZfho61
         SDRZvEgx6AkMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC7E5C73FEB;
        Wed,  7 Sep 2022 15:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: remove
 mtk_foe_entry_timestamp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166256281889.26447.7824368670296489846.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 15:00:18 +0000
References: <724dc466880787ae099ea037013cf5c9537128b6.1662380540.git.lorenzo@kernel.org>
In-Reply-To: <724dc466880787ae099ea037013cf5c9537128b6.1662380540.git.lorenzo@kernel.org>
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  5 Sep 2022 14:46:01 +0200 you wrote:
> Get rid of mtk_foe_entry_timestamp routine since it is no longer used.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.h | 11 -----------
>  1 file changed, 11 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: mtk_eth_soc: remove mtk_foe_entry_timestamp
    https://git.kernel.org/netdev/net-next/c/c9daab322313

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


