Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7315F53A5D1
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 15:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346949AbiFANUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 09:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349877AbiFANUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 09:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AAA427D5;
        Wed,  1 Jun 2022 06:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FCCC61597;
        Wed,  1 Jun 2022 13:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FAFDC3411D;
        Wed,  1 Jun 2022 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654089612;
        bh=xFLEubiyifM6V8QcdqT81e+dQpNxVYM6vnU7/+58nZ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h9CCbuCM737rNDvyFsbiqlMxGnYWwVs4dJzE1GNE1JpOQEfCddYPCZJN4Ium74SKT
         QebeE5yrGqlIQcSXHwwuyGmjhktw1FNLvxJC7dka6E08HM/CP+q65Zl8oPglplo79V
         TYbqHli6XjvClR6UYBqKLRdFuJx0gfZKg/Tx+Dvbr1eyvywnE6y0hfmVsDen1nxfTt
         4DXoFxb3Po5C61Zl8faDL6fOOS8U6As7q83FTVdkiyxQfMGTD/u5iEQWWl1Aco+tVv
         Vntq/Zv1iZN867rl2Vzj4cENPWwzecyCm0nqdB1PdVHK3bXraKG2BWSbCMgIcVH5kP
         nZfGsobO/SYQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70D07F03944;
        Wed,  1 Jun 2022 13:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: act_api: fix error code in
 tcf_ct_flow_table_fill_tuple_ipv6()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165408961245.18360.13013856288748164007.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Jun 2022 13:20:12 +0000
References: <YpYFnbDxFl6tQ3Bn@kili>
In-Reply-To: <YpYFnbDxFl6tQ3Bn@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     jhs@mojatatu.com, toshiaki.makita1@gmail.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        paulb@nvidia.com, pablo@netfilter.org, netdev@vger.kernel.org,
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 31 May 2022 15:10:05 +0300 you wrote:
> The tcf_ct_flow_table_fill_tuple_ipv6() function is supposed to return
> false on failure.  It should not return negatives because that means
> succes/true.
> 
> Fixes: fcb6aa86532c ("act_ct: Support GRE offload")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net] net/sched: act_api: fix error code in tcf_ct_flow_table_fill_tuple_ipv6()
    https://git.kernel.org/netdev/net/c/86360030cc51

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


