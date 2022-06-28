Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7341755DCC3
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243460AbiF1FkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiF1FkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F96113E8B;
        Mon, 27 Jun 2022 22:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBC5461804;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21D63C341CB;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656394815;
        bh=ociaOeWFmG/Bz1+H5EcPcmh4cHnZqPF5f/gM/6Wzc0s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qQeYQX5JK/anBOSCpCLVK4C1BkBtD1oDNdddZ4dCbqq4Iv1ORRvA/15Y+1JJFcbD0
         uiGlGD+EbwWPX7xw7stIy2kVyF899tq5u1BmWI02+m/3YwlRdkkx+qHBqb5Fc3afBR
         D4Wexlf0y0G+y6mFINfPefEVvtajyUW2rHXh4OKLg+cS08Y21rfLbLuKmX9RBYTmUl
         mDCTHgKE5lyZ6pUdKl+ITLEWGAA6EMNMGPHEQFQ7hV35TfCuNLAN0NVLhv9ARA7IWS
         zxWmkLNgAWto3tw6FgVLnMPrFCgTfQeBckqvvi/omWuAUPKynrXGMzAP1mAAcjj2N/
         mluYNv3Bfx/Jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05561E49BBC;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] amd/xgbe: fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165639481501.10558.11728512687152837384.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 05:40:15 +0000
References: <20220625070633.64982-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220625070633.64982-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 25 Jun 2022 15:06:33 +0800 you wrote:
> Delete the redundant word 'use'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/amd/xgbe/xgbe.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - amd/xgbe: fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/7eddba1644c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


