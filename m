Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C867951285C
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 03:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbiD1BDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 21:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238601AbiD1BDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 21:03:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2263013DC0;
        Wed, 27 Apr 2022 18:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D00D6B82B46;
        Thu, 28 Apr 2022 01:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CB20C385AD;
        Thu, 28 Apr 2022 01:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651107612;
        bh=Pjjgj1qW5hN2kuLyxha6b/2j3HMOPvEusI19sA57MgY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jim23m1gBgvIzz9oX/nxiUV6bxPwkAZNjKNQj1WtUYcdGvwzxR3fH8Seu8ImfmnIm
         +8qGsaBxjRYFalKp0aUrBRMjaQ5fBAPOCZZkmwnanIel8yyn9oIfKzTubMAyFPakIA
         4PmDmV5ew6f+KAOFDeryIP1SatRtrqpEK6+5JZCpscG1ErfmkrTg1wIOvzSlgi/txE
         28UCmo3i5YKXUn9U7ySuxp9duJKsbHAKeEvCrupbUTbpJkJytpnVFQYbDMCBypxqJJ
         kYhk+AnmHZEUm+QKExRrQovPYC3e0JGsZcOxQxw4tqVFXFgf8ktzdXlJLztFD08lBj
         m3tqbQnQvdFZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6978FE8DD67;
        Thu, 28 Apr 2022 01:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fec: add missing of_node_put() in
 fec_enet_init_stop_mode()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165110761242.23759.9505223259706964605.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 01:00:12 +0000
References: <20220426125231.375688-1-yangyingliang@huawei.com>
In-Reply-To: <20220426125231.375688-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, fugang.duan@nxp.com, davem@davemloft.net,
        kuba@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Apr 2022 20:52:31 +0800 you wrote:
> Put device node in error path in fec_enet_init_stop_mode().
> 
> Fixes: 8a448bf832af ("net: ethernet: fec: move GPR register offset and bit into DT")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: fec: add missing of_node_put() in fec_enet_init_stop_mode()
    https://git.kernel.org/netdev/net/c/d2b52ec056d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


