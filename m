Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA2B4CC285
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 17:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbiCCQVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 11:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiCCQU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 11:20:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1824199D7C
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 08:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60AD2B82663
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 16:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE94FC340E9;
        Thu,  3 Mar 2022 16:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646324411;
        bh=XYu4WOl9rcPCE8qghH4BLdRHBa33yWJaUrfe1ZOFWl4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YOSy7HAoLRHVqC4b1EJlQnSbjkvrabiXfWfyjS8UDTMCiw1DK7n4z/dDQPRp83RIx
         t3yXlAt1DfeTxq1vi8YPnfTJL09ns/LjCqmxnDC+8bM6j/ig84rHKVJj0GuQClUpBn
         qWOa7kw7QYBaUhsE1VaeVf4mdB0d8CIwBmImHxZ7junc2tJE+fK2+Esle2Wc9lZ/iT
         YlRqEGEMejUVOOJ6xUG6YkTtLnJKKtzZvycPSomTibin6HvDdjz0NYKMHn/xzhfwBJ
         wjVxfvnEgdagjMyyxQ4pEQAQ5xv6FzlFT1Md/NnfALRW83R1X+BM3UomiBj4X5Q0CP
         Ns9tfRUsyindg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D35C4EAC096;
        Thu,  3 Mar 2022 16:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dcb: disable softirqs in dcbnl_flush_dev()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164632441086.16147.7200522822745526359.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 16:20:10 +0000
References: <20220302193939.1368823-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220302193939.1368823-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        john.fastabend@gmail.com, petrm@nvidia.com, idosch@nvidia.com,
        idosch@idosch.org
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

On Wed,  2 Mar 2022 21:39:39 +0200 you wrote:
> Ido Schimmel points out that since commit 52cff74eef5d ("dcbnl : Disable
> software interrupts before taking dcb_lock"), the DCB API can be called
> by drivers from softirq context.
> 
> One such in-tree example is the chelsio cxgb4 driver:
> dcb_rpl
> -> cxgb4_dcb_handle_fw_update
>    -> dcb_ieee_setapp
> 
> [...]

Here is the summary with links:
  - [net] net: dcb: disable softirqs in dcbnl_flush_dev()
    https://git.kernel.org/netdev/net/c/10b6bb62ae1a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


