Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423AA4AA80C
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 11:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359814AbiBEKUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 05:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBEKUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 05:20:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5AFC061346
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 02:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 130C160B1D
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 10:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6508EC340E9;
        Sat,  5 Feb 2022 10:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644056409;
        bh=ypYtQo1pSLUuzFoFZEcU0keJI4jSb/ZZ/CcXOXufBSY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZOXltDsLBs7HCSY44wuWrCUi9zCkm0tV5FYzO76eysB4wDMOGE/zeG+8bKVpXSptW
         ZIa/SxAFOLC+jLFb6Dfn8LzC9CXGEINlqYYGNaONq1K0NSoH/oEttysFlmYORRcuet
         Ms0r60fnT4qylfFZEmq+yDjjB6LhiGPXPCnrpgt07o0xi/SH06vlPP56lQEVom22tY
         qFhxgABItNfRbrD80O9yjm2u0BK8Ho2F7DsEUoN6aVG+5k9oJXJuSeQRxEdy8OeUEQ
         i6aSlo7IKj1CnpCY2JqwJ++ZOi7wzfBACTjvjROY/YZHmOimYmhVUFBDWtS3ZJeGGC
         suzkalwxMwlHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A23BE5D07E;
        Sat,  5 Feb 2022 10:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 1/1] net/sched: Enable tc skb ext allocation on
 chain miss only when needed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164405640929.30996.579134906117911198.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 10:20:09 +0000
References: <20220203084430.25339-1-paulb@nvidia.com>
In-Reply-To: <20220203084430.25339-1-paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jhs@mojatatu.com, pshelar@ovn.org,
        davem@davemloft.net, jiri@nvidia.com, kuba@kernel.org,
        daniel@iogearbox.net, saeedm@nvidia.com, ozsh@nvidia.com,
        vladbu@nvidia.com, roid@nvidia.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 3 Feb 2022 10:44:30 +0200 you wrote:
> Currently tc skb extension is used to send miss info from
> tc to ovs datapath module, and driver to tc. For the tc to ovs
> miss it is currently always allocated even if it will not
> be used by ovs datapath (as it depends on a requested feature).
> 
> Export the static key which is used by openvswitch module to
> guard this code path as well, so it will be skipped if ovs
> datapath doesn't need it. Enable this code path once
> ovs datapath needs it.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/1] net/sched: Enable tc skb ext allocation on chain miss only when needed
    https://git.kernel.org/netdev/net-next/c/35d39fecbc24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


