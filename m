Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57ADE563DFA
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiGBDU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiGBDUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEF9326E5;
        Fri,  1 Jul 2022 20:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23003B832C0;
        Sat,  2 Jul 2022 03:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98040C341DA;
        Sat,  2 Jul 2022 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656732015;
        bh=T/cCDojsKoVk5TqGmKMPGsMNtNEvl7sLqSiKl+7Ebms=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RTMnT7a5E3iwZyMUcMCilAbhOKk3f+/IbYGREUwWpWarbpmsxLHYJutNHzR1cyJjN
         1Ps1gKoChPsaJxuyI0Ipw5PGXswNdSxBQOHVIfLSnvdCYlooFlPawF0KNgmO3P3zJ5
         /n9UbigY5gw7q3wwn/aZkBh4pHmfb9rGemFxq8pMBKLywtv3HqmeO6W8kPHks062jP
         93nj5gDwJcIK5HIF70Uqaxee22Byb06MaNXgMej4DycR4HszA373t7tQKiwiTZXh0y
         aGIm/yrU8qVJ4qRg+F2vv6LD2pB8A7BD3//qgNknltoNXblUDtfaFbPCHAN5n7aGHU
         DA/jeV3v8muLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 80AD3E49BB8;
        Sat,  2 Jul 2022 03:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] samsung/sxgbe: fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165673201551.6297.6022608710322233509.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Jul 2022 03:20:15 +0000
References: <20220630124639.11420-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220630124639.11420-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bh74.an@samsung.com, netdev@vger.kernel.org,
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

On Thu, 30 Jun 2022 20:46:39 +0800 you wrote:
> Delete the redundant word 'are'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - samsung/sxgbe: fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/abf1efb6ae78

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


