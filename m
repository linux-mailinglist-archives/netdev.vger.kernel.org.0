Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4795B0814
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiIGPKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiIGPKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B273C8F8;
        Wed,  7 Sep 2022 08:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E65ACB81DEE;
        Wed,  7 Sep 2022 15:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3C75C433D7;
        Wed,  7 Sep 2022 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662563414;
        bh=y3vev92uf2aRQIN78o3qvAAHssrNc8oo+5GpspII1uE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oZKpsaGYEPHeJG3FzASD+1KmAIbVAi17hzb96TaAbfeqP8r7npOU6jb3D2n7ByG6q
         QV3OmbTcTrIHgiOLc2Q464l9zF975+h60jp7dLNt7V8xHTPeW5nSofu99N2r1dtS/n
         U3vkIIYPx2COAwCF3gmxCJPtUpRo4Z3BDTO+0/X5glEwVBbttNKtKt2jou2lAISmtD
         MV94lnR/Gm6ob+FwPx00L9nxU6YGOTeppgX3lJ7//cAui1VLa5zMJOeTDpVMRkKxHG
         6483CDdL+xLhSmUGHboJ6gZmczFPxjps7oYEFPDv3ah9rbvEwNvg9zaTU3tDlTcoIq
         yDnA8pFon9w5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 80102C73FE7;
        Wed,  7 Sep 2022 15:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v5] net/smc: Fix possible access to freed memory in link
 clear
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166256341452.32760.12403709624294959610.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 15:10:14 +0000
References: <20220906130139.830513-1-liuyacan@corp.netease.com>
In-Reply-To: <20220906130139.830513-1-liuyacan@corp.netease.com>
To:     None <liuyacan@corp.netease.com>
Cc:     wenjia@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kgraul@linux.ibm.com, kuba@kernel.org, tonylu@linux.alibaba.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        ubraun@linux.vnet.ibm.com, wintera@linux.ibm.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  6 Sep 2022 21:01:39 +0800 you wrote:
> From: Yacan Liu <liuyacan@corp.netease.com>
> 
> After modifying the QP to the Error state, all RX WR would be completed
> with WC in IB_WC_WR_FLUSH_ERR status. Current implementation does not
> wait for it is done, but destroy the QP and free the link group directly.
> So there is a risk that accessing the freed memory in tasklet context.
> 
> [...]

Here is the summary with links:
  - [net,v5] net/smc: Fix possible access to freed memory in link clear
    https://git.kernel.org/netdev/net/c/e9b1a4f867ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


