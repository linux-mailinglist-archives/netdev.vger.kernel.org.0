Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261D250DDE3
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241588AbiDYKdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241148AbiDYKdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:33:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8436260;
        Mon, 25 Apr 2022 03:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55146CE129F;
        Mon, 25 Apr 2022 10:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A691C385B3;
        Mon, 25 Apr 2022 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650882612;
        bh=wWIX1apbskup/nLGSVf9nbG0MrqeHol19feA6EoDbOo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bL8s6lKWgd4xPZR+ZeyyVUakMCzBy/GnU8eLGFJctb3lEo0DbTuIP7LlwBRVAuGYn
         WiPL3yUeO3YQ/VO/zPrYnUPlbaIxoE/ErV8DOSTxO1c3nZ1WBHQZk2DJNH6vO6GN/p
         n2BqINkW3Z4XPxlZbLbQa+WNpH/DQ7kzu7YzAo8Vvv7VCtbvKnWJr4GdJDbxLLJtt8
         8iQpWiVjnmEC7matftaJXZD8GtZ9MuJsaBF9TSE4dBR/ZdLSV/d/QZtQZq/VY5RB6o
         vvYraZpgy70SeqSNNP7Xh5Pd2vLwdQk5GrVSbCEfS7cE1fRBISU+S4pUj7hSNJs/Rk
         RK4dqsxfbDphw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D145F03841;
        Mon, 25 Apr 2022 10:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: add check for
 allocation failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088261250.604.9330173633100783147.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 10:30:12 +0000
References: <YmF87nnzwiJC71k6@kili>
In-Reply-To: <YmF87nnzwiJC71k6@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, kernel-janitors@vger.kernel.org
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

On Thu, 21 Apr 2022 18:49:02 +0300 you wrote:
> Check if the kzalloc() failed.
> 
> Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_wed.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net-next] net: ethernet: mtk_eth_soc: add check for allocation failure
    https://git.kernel.org/netdev/net-next/c/a00e41bf2f47

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


