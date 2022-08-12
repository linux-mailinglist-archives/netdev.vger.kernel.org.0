Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D9A590F9A
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 12:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237850AbiHLKk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 06:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237291AbiHLKkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 06:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1A11CF;
        Fri, 12 Aug 2022 03:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1DD8616C6;
        Fri, 12 Aug 2022 10:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15135C433B5;
        Fri, 12 Aug 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660300814;
        bh=6KT4pab0sSZtxp5EluswxZ9JlwS3DXqQ+L8sCMstgeo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kALZibqJciyy1CE2tq6b0VN5RJPppDhohrCcpVeL8arLT2OjkYVBZ9LKATnjegK8l
         W8ZQ2TRZB2mzKNfqIGDNLfdnIEd+LRxs2riqeAt4alixX93rr+7d/7ISwtO/R/8+7d
         ru/THuAEEM/NV4Hzm0JqFWoMdsW0+P2me+680wbLi5QblbVXoWGTi9/JE2bvaHuJcZ
         Uw/aSPXsMugU7GglasL6el4DEXlIHlOYhU/AvGNqzO5tQd4FOr5SvfZ7q1MGBkdLkv
         2ai5KFIAs+qh7Ej2twGdmWfp3qJW89qYEE00BPu76kEjEUCZSovQa+RX1atqrGcGOW
         bAAVfplCriBsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF62EC43143;
        Fri, 12 Aug 2022 10:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: lan966x: fix checking for return value of
 platform_get_irq_byname()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166030081397.15777.15613376655712609091.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Aug 2022 10:40:13 +0000
References: <20220812030954.24050-1-liqiong@nfschina.com>
In-Reply-To: <20220812030954.24050-1-liqiong@nfschina.com>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuzhe@nfschina.com,
        renyu@nfschina.com, jiaming@nfschina.com,
        kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 Aug 2022 11:09:54 +0800 you wrote:
> The platform_get_irq_byname() returns non-zero IRQ number
> or negative error number. "if (irq)" always true, chang it
> to "if (irq > 0)"
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - net: lan966x: fix checking for return value of platform_get_irq_byname()
    https://git.kernel.org/netdev/net/c/40b4ac880e21

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


