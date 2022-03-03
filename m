Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007F74CC56E
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbiCCSvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiCCSvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:51:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D10419CCE5
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B30BBB8268E
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 18:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 712B9C340EF;
        Thu,  3 Mar 2022 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646333410;
        bh=WmeLp9O8VzcUaUr0bS5jvxqsLciPx4BtK1CMtYRY4gY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hRuzUwHW6vW3DV2zITvy6HC04WJHXNeg+2LgWnXWnNuQ/L2YI1qJMD8LTp2jr7d5Y
         eXzq3nJPRwfDzUrhY3l8/5MlBvMwDVD05/fghOAxvZCDAWEe58/KmTaGFPc/+MJPyh
         Ouky4sFILSPQZ3SEWxgNy05abhXfp56pwKq9SuHhz0LiF/dsmGREecMZramOLutnIE
         81INYAaQT2dhZZJ+yGdQigGLYfjYhxFNqJsX0xzAV9Zqi/U2QSAELj9+iFwWA3eEV5
         ZMaD6PzBiyTAsx4m38DKy6poN/Fkj5CjcFyy3yolxVIIXq+rQ13yNEPg5X+SiK1Y+5
         lIFJ46QMIpFXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F2F6E8DD5B;
        Thu,  3 Mar 2022 18:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: fix skb drops in igmp6_event_query() and
 igmp6_event_report()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164633341032.31554.4798926938067177426.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 18:50:10 +0000
References: <20220303173728.937869-1-eric.dumazet@gmail.com>
In-Reply-To: <20220303173728.937869-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, ap420073@gmail.com, xiyou.wangcong@gmail.com,
        dsahern@kernel.org
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

On Thu,  3 Mar 2022 09:37:28 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While investigating on why a synchronize_net() has been added recently
> in ipv6_mc_down(), I found that igmp6_event_query() and igmp6_event_report()
> might drop skbs in some cases.
> 
> Discussion about removing synchronize_net() from ipv6_mc_down()
> will happen in a different thread.
> 
> [...]

Here is the summary with links:
  - [net] ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report()
    https://git.kernel.org/netdev/net/c/2d3916f31891

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


