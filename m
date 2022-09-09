Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732D85B36B3
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 13:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiIILuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 07:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiIILuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 07:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F6A915EA;
        Fri,  9 Sep 2022 04:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A921261FCA;
        Fri,  9 Sep 2022 11:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0AFC6C433B5;
        Fri,  9 Sep 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662724215;
        bh=ORfyzEcDX4IwSylobJ0ywQwAMKie9Jxg2ZBfTRwVofc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IJP1k5BtQVTx6JA39GrWaSHHyMCt81awYDpM837hlD/ItRawd1qH7qTre1lyUT4dT
         3+H+d4VSfSP4Ev0L+2WexMUATc67X3ITugoZ+5p0pyv+rTknJmcFyJ6J4ygBoVsIDg
         FCty1J795pRRi1xNopTFRCV2dJBJIg54WzrKkZCP0KSLn439S9agU6S9zyPgFCYQ1A
         hplcxVqGbFfOPWvnE58N9HkiRixToqLvdo5HVfFrK68tlbNNzxST3gj5/zhVPFbOi3
         5TouWuiCndNyuu6QxcgOJlaG9QFTWYq40VvzeIXNnGhGF/G8te7omHQTof6yE5QUDX
         ovRVtXvboMcnQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DEF6EC4166E;
        Fri,  9 Sep 2022 11:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] net: core: fix flow symmetric hash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166272421490.25944.14658295225546906701.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Sep 2022 11:50:14 +0000
References: <20220907100814.1549196-1-ludovic.cintrat@gatewatcher.com>
In-Reply-To: <20220907100814.1549196-1-ludovic.cintrat@gatewatcher.com>
To:     <ludovic.cintrat@gatewatcher.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, boris.sukholitko@broadcom.com,
        kurt@linutronix.de, vladbu@nvidia.com, wojciech.drewek@intel.com,
        komachi.yoshiki@gmail.com, paulb@nvidia.com, tom@herbertland.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, 7 Sep 2022 12:08:13 +0200 you wrote:
> From: Ludovic Cintrat <ludovic.cintrat@gatewatcher.com>
> 
> __flow_hash_consistentify() wrongly swaps ipv4 addresses in few cases.
> This function is indirectly used by __skb_get_hash_symmetric(), which is
> used to fanout packets in AF_PACKET.
> Intrusion detection systems may be impacted by this issue.
> 
> [...]

Here is the summary with links:
  - [net,v1] net: core: fix flow symmetric hash
    https://git.kernel.org/netdev/net/c/64ae13ed4784

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


