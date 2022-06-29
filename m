Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4457555F54B
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiF2EaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiF2EaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:30:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F8C2A429;
        Tue, 28 Jun 2022 21:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 20A94CE2302;
        Wed, 29 Jun 2022 04:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57A52C3411E;
        Wed, 29 Jun 2022 04:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656477013;
        bh=WN30lWt4WHGe3tcb6R/6Elf8r9QBqst8EuhMqtSlM/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tMOp3KkCDSm4CAIqic8V5L4V9MSaEpoRSOC3EzFG+/Ji+gQwKJs+BQW9EftQU9UsU
         Xqa2EOYGx0xnpGnGmizf7yFRHPFDl6fOPcwuPjl1ssNZ2y+yxnU5yW2GbLRIVYNhHb
         XSGX89NRpAtbuBGShB8yzwyxc9gVJ9ZDRPfRyfw5EX1XcdPsY4wsHnue/OBWFDMq3k
         X2vvB97eTt32jGPNZ9skCaFpn+KsQtAHvclxIdEcB8e8NtCzZsTqHW95KyGRv31BuE
         gA2VCLHITAF4nwPmaF6mR5lwie0d/kJNeU2w4NOoJvsy4KahMBSdQ60LODi3eOuCp0
         O5r+fx3T6MwyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39DDDE49BBA;
        Wed, 29 Jun 2022 04:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: ipv6: unexport __init-annotated
 seg6_hmac_net_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165647701323.29806.17686038162908371252.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 04:30:13 +0000
References: <20220628033134.21088-1-yuehaibing@huawei.com>
In-Reply-To: <20220628033134.21088-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shjy180909@gmail.com, david.lebrun@uclouvain.be,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Jun 2022 11:31:34 +0800 you wrote:
> As commit 5801f064e351 ("net: ipv6: unexport __init-annotated seg6_hmac_init()"),
> EXPORT_SYMBOL and __init is a bad combination because the .init.text
> section is freed up after the initialization. Hence, modules cannot
> use symbols annotated __init. The access to a freed symbol may end up
> with kernel panic.
> 
> This remove the EXPORT_SYMBOL to fix modpost warning:
> 
> [...]

Here is the summary with links:
  - [-next] net: ipv6: unexport __init-annotated seg6_hmac_net_init()
    https://git.kernel.org/netdev/net/c/53ad46169fe2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


