Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEAD25EC6ED
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbiI0OwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiI0OvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:51:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6253961722
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 07:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D57EBB81C22
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 14:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 876C2C433B5;
        Tue, 27 Sep 2022 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664290216;
        bh=ZlV6LPLiWVsIJiMf59cDqov1CVvefjDoNUUzrnkzvfQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LbiBBpj5/A1juKoGTxPMQCf5y2Ai7oF0RddTQ1BqpISYxP+Kl514IYpDoc7hArh32
         V4rApstKg/upBhuHkIhiP9ONkZK/ALcS/7EmlqxJlLCHlxKuKpI22qZjivNztW0JqD
         WFSL+Sbn2Bx+BRnTWk7trdptGQhqGlbNbpa5ZzZazFskVbhxNktAScR5vykuz3VUH4
         /+sRyZGg2HEsQV7B6geGgFst9tvTisKXkDcWn6sWaLf+dw7JG5AVksYsAqkaZo9VDl
         S87xvFZE08kIgVB8LkSEGuYGXbN2zsA4dHRzbHm5AaWXySIpQVFe0du9UmUsLpBHcn
         RbwDl7MV/WjYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71F5EE21EC1;
        Tue, 27 Sep 2022 14:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] net: ethernet: mtk_eth_soc: fix wrong use of new helper
 function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166429021646.22749.6763418787282082138.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 14:50:16 +0000
References: <YzBp+Kk04CFDys4L@makrotopia.org>
In-Reply-To: <YzBp+Kk04CFDys4L@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        lorenzo@kernel.org, sujuan.chen@mediatek.com, Bo.Jiao@mediatek.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        ptpt52@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 25 Sep 2022 15:47:20 +0100 you wrote:
> In function mtk_foe_entry_set_vlan() the call to field accessor macro
> FIELD_GET(MTK_FOE_IB1_BIND_VLAN_LAYER, entry->ib1)
> has been wrongly replaced by
> mtk_prep_ib1_vlan_layer(eth, entry->ib1)
> 
> Use correct helper function mtk_get_ib1_vlan_layer instead.
> 
> [...]

Here is the summary with links:
  - [1/2] net: ethernet: mtk_eth_soc: fix wrong use of new helper function
    https://git.kernel.org/netdev/net-next/c/fb7da771bc43
  - [2/2] net: ethernet: mtk_eth_soc: fix usage of foe_entry_size
    https://git.kernel.org/netdev/net-next/c/454b20e19322

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


