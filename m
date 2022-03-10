Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6432A4D4084
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239503AbiCJFBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239480AbiCJFBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:01:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E71712D913
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19918B824CE
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC324C340E8;
        Thu, 10 Mar 2022 05:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646888411;
        bh=CpFuCUXilrHLEnZpuCwsm5RcgvjJph9Qqom0jAVDqc8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D+9r6lIvJMezaUo3V3Uhkcer4UgQcJcS6/1C6nrau4n4gorASt0sCnbRh5Dk8FC7q
         iGSV/ibKeDadOlvdymyTHr2mOG72uyi/icotuAKwA5tBSdQJ6G67nExqZBEeA2PJ0d
         fIrlCTmlgT5MzZ/k1TdvHb9bKY0E0W69c3auGO4RXxKcZx24W8yrPneOYCg2PZNiFg
         4FUlITWbIRe2mmnUe422x85ID3BWvTCjPfalt52qjQR5jw/S/oq4rHwgvrZ6gzS+OB
         0A0mK00ejLQxZ9P/lumswP/iDx94AnuesfGQaM2tnzKi3nTxCi9K2M+3lTjKsxP/hi
         7xuXkLuqFT1bg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2E86E6D3DE;
        Thu, 10 Mar 2022 05:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: dsa: tag_rtl8_4: fix typo in modalias name
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688841166.28597.3294933372445104828.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 05:00:11 +0000
References: <20220309175641.12943-1-luizluca@gmail.com>
In-Reply-To: <20220309175641.12943-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Mar 2022 14:56:42 -0300 you wrote:
> DSA_TAG_PROTO_RTL8_4L is not defined. It should be
> DSA_TAG_PROTO_RTL8_4T.
> 
> Fixes: cd87fecdedd7 ("net: dsa: tag_rtl8_4: add rtl8_4t trailing variant")
> Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: dsa: tag_rtl8_4: fix typo in modalias name
    https://git.kernel.org/netdev/net-next/c/3126b731ceb1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


