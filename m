Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2FE531097
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbiEWKuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbiEWKuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535264C795;
        Mon, 23 May 2022 03:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2476B81056;
        Mon, 23 May 2022 10:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73FC2C385A9;
        Mon, 23 May 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653303012;
        bh=vL0av8qajrbUGlMbyUnN70gRfBZlR5Yqly8QGb2oG2M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IG+Bg4LfjKRYYCcrYzNmHl8FhniYOqinrTPwxi2C99a9c5G3kY/bgIy20gfrVg9R6
         Ue+fgPyn34GPcvX+W9KcYKmdgSe1GqLMU+HKIJw8IxuY8td0BZVhz9EzvWEwyrGl5S
         SPJDUdDEjMeD9wIx7WWaCouWmZGG++XZnb0Wvg/yqb8Y8ezPcu2Rn3NosVn2yk2+UM
         eb6sXUeD349/P5a7LgM1hNI/lm7UznXBQNQKRhyqWP1lTCbV068qZdSvQhTFq3fVHU
         wYLkFbpqj7uX3V7TvXsSY23yGRBl2ug/0crg00FE+4iYky3MGt6oAwUHT9CmEgkGx/
         2hvBAlKI3Pjfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 550AFF03938;
        Mon, 23 May 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: fix error code in
 mtk_flow_offload_replace()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165330301234.7594.6324399945658700644.git-patchwork-notify@kernel.org>
Date:   Mon, 23 May 2022 10:50:12 +0000
References: <YoZPQNFPTQI/6ZhP@kili>
In-Reply-To: <YoZPQNFPTQI/6ZhP@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 19 May 2022 17:08:00 +0300 you wrote:
> Preserve the error code from mtk_foe_entry_commit().  Do not return
> success.
> 
> Fixes: c4f033d9e03e ("net: ethernet: mtk_eth_soc: rework hardware flow table management")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> The original code used to preserve the error code.  I'm pretty sure
> returning an error is the correct thing.  I guess please double check
> this patch.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: mtk_eth_soc: fix error code in mtk_flow_offload_replace()
    https://git.kernel.org/netdev/net-next/c/0097e86c8ec5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


