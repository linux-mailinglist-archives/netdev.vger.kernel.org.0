Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F75C54C82D
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 14:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344868AbiFOMKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 08:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244316AbiFOMKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 08:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58EC527EB;
        Wed, 15 Jun 2022 05:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 486E8B81D91;
        Wed, 15 Jun 2022 12:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C276DC3411C;
        Wed, 15 Jun 2022 12:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655295013;
        bh=bTou62QWZdbZMc3bBGGn2RsEUYdnLH3B0MG5HhHnQEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uvMs1Y39Z0nQXHAyn1E+FCkU4Ti0pRtFm7FKgNDCJgw7vW0Xnr2vrAmNIvzjuElah
         eInaeH5HmGGodBGGF58Pj7zikaupvi/jf85KeEbHoWT2Kh8yZfxkiuxo2+3kdol3Cz
         dnBmwsRBxxBaLvPyyuAqutKG7npFWeTgo0763ZKEU7gdwt1NnS2DQqgXoKbgbwh/5j
         f8O48OFU7STgtxu7MN0VsNfZIL7dGtjkYPRH+ssURrEJqM8/Eg4m/c8wfjVmmVA6ZB
         OkjzDZTLCfZggEn4D4Hi04hqI5RZ8wfhgCGmc06s4QNUIAinL+w9fBnOyyDi0Oy9C2
         mFf6A4p+7g4+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A990EE73854;
        Wed, 15 Jun 2022 12:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] bcm63xx_enet: switch to napi_build_skb() to reuse
 skbuff_heads
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165529501369.14672.6535099604436772744.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 12:10:13 +0000
References: <20220615060922.3402-1-liew.s.piaw@gmail.com>
In-Reply-To: <20220615060922.3402-1-liew.s.piaw@gmail.com>
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 15 Jun 2022 14:09:22 +0800 you wrote:
> napi_build_skb() reuses NAPI skbuff_head cache in order to save some
> cycles on freeing/allocating skbuff_heads on every new Rx or completed
> Tx.
> Use napi_consume_skb() to feed the cache with skbuff_heads of completed
> Tx so it's never empty.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [V2] bcm63xx_enet: switch to napi_build_skb() to reuse skbuff_heads
    https://git.kernel.org/netdev/net-next/c/c63c615e22eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


