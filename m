Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2837F635EE1
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238612AbiKWNHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238858AbiKWNHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:07:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D663E0DD8
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2831B81DEB
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64F95C43147;
        Wed, 23 Nov 2022 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207815;
        bh=CEzpdciQIJG8QoKM1w0NBjka1UaJe0l8agua8+CgzKg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RgftSqRwdBTroYXQg5mqJ+CN44N1KVvIE5CCqk3V0CGmDhpnHKuECN1u/5BH+0YKE
         Wo7IAZtPfl573jDowl5Z4YxLEd0yeRM3SlVKuQIdFwDpzEHOdMkReRrPCQ8rI6DAq7
         eAyVQ7UmzrNJGADu6TgKQtnWwMa8HacF1FZIKc/nQlFM32LM7z4sLyLKK9tRSzWwfU
         zI7Hth76C4//aPYBrffidDv+uCpxkx8CL+CtVi6+FOAc1QdiOweWficnCjGJmdH4fn
         Rm0VbpASVNQjrG0yJuF+5us3Ehlf1OHyNzspugJ3NcE7/vjaA0O5ZZy5vdunmIwT2z
         pF52Zi9cNTVbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44603E270E3;
        Wed, 23 Nov 2022 12:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dm9051: Fix missing dev_kfree_skb() in dm9051_loop_rx()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166920781527.7047.1981638432352081834.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 12:50:15 +0000
References: <20221121033226.91461-1-yuancan@huawei.com>
In-Reply-To: <20221121033226.91461-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sfr@canb.auug.org.au, error27@gmail.com,
        bigeasy@linutronix.de, colin.i.king@gmail.com,
        yang.lee@linux.alibaba.com, josright123@gmail.com,
        netdev@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Mon, 21 Nov 2022 03:32:26 +0000 you wrote:
> The dm9051_loop_rx() returns without release skb when dm9051_stop_mrcmd()
> returns error, free the skb to avoid this leak.
> 
> Fixes: 2dc95a4d30ed ("net: Add dm9051 driver")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/net/ethernet/davicom/dm9051.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - net: dm9051: Fix missing dev_kfree_skb() in dm9051_loop_rx()
    https://git.kernel.org/netdev/net/c/bac81f40c2c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


