Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AF5536C97
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 13:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbiE1LkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 07:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234741AbiE1LkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 07:40:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15318167DD;
        Sat, 28 May 2022 04:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC5A7B80EAE;
        Sat, 28 May 2022 11:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68A31C34118;
        Sat, 28 May 2022 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653738011;
        bh=ZHpRnFQkeQtmCAXLllnoeiBMgN6AR5loMUWSyWMqj38=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tHv4xzJIVLE7nNzO8MQ4KGbhH82tAQSNStVEI4ylZaL0oP9YoGTqZAz6VvqImcHpg
         lusq22zRSMJ0Uha/huKJPtrh+cZR6tDWc+yRnOSZlmcmLOgOmBoqHCut0lBiKUJAoQ
         UDfblPV9QptlLSDsKJzxyopjgbDHhvIMAOSIVmKR0hH+7yhpyPRccwUz17Qaqr6ZMA
         QBwNRKdHt39j469HA2IIDmnkAm9ksLBZ6lZ8HjR2LChznS7x4aqrzS9XdoVDjmr+HX
         McxoonhcxUB+gDbEisyZbxlxzQnQeSvVysWx9Bw7QX40gGYSJRRlqf9ApmJBuG7lXT
         eakuXHko9XsHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 515ACF03942;
        Sat, 28 May 2022 11:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: fixes for converting from "struct
 smc_cdc_tx_pend **" to "struct smc_wr_tx_pend_priv *"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165373801132.32245.12112811414781251794.git-patchwork-notify@kernel.org>
Date:   Sat, 28 May 2022 11:40:11 +0000
References: <20220528065457.93676-1-guangguan.wang@linux.alibaba.com>
In-Reply-To: <20220528065457.93676-1-guangguan.wang@linux.alibaba.com>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 28 May 2022 14:54:57 +0800 you wrote:
> "struct smc_cdc_tx_pend **" can not directly convert
> to "struct smc_wr_tx_pend_priv *".
> 
> Fixes: 2bced6aefa3d ("net/smc: put slot when connection is killed")
> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> ---
>  net/smc/smc_cdc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net/smc: fixes for converting from "struct smc_cdc_tx_pend **" to "struct smc_wr_tx_pend_priv *"
    https://git.kernel.org/netdev/net/c/e225c9a5a74b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


