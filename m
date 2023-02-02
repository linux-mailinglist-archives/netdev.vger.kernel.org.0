Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4865D687D57
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBBMau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjBBMat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:30:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059E7790A2
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 04:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AB1DB82601
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12B29C433EF;
        Thu,  2 Feb 2023 12:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675341018;
        bh=XR6bYxvCaIu3SxBfjOjw4lnOIZoTgTeR22C+GmuCbs4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a8msvQTpIdmIvZLFEI3xr7pBWWKDYR3esrpE6TglNkuS2+aBognjg8LpwSATeQ5xV
         Q4jzjcL3kmjIQjExJWQCsBhLBlUBCDvoMZwQAZzA0leWaZ04z4u35MJ2C9BaKAshig
         UFaWvpAffpYR4iYr0YihiWfWKEB3hV6oinKZinWHnN3SajQbFmzI34++XlnVPj29qT
         +lEd38xdSv24B2+ZsSheGQNb9xchYz0zgZodQw6uIkGEiPODtCtR8vyQTEJ/bbCyjH
         rW9LLLMMARxhWHtDndOeaHAqTPvDUEh+ZO01w6vCoGZCjDWri+5Yy8FOUol50SDa4E
         inPjE2KBhHXzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7FE6C0C40E;
        Thu,  2 Feb 2023 12:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/2] net/sched: transition act_pedit to rcu and
 percpu stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167534101794.10789.13408926333152362818.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 12:30:17 +0000
References: <20230131190512.3805897-1-pctammela@mojatatu.com>
In-Reply-To: <20230131190512.3805897-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 31 Jan 2023 16:05:10 -0300 you wrote:
> The software pedit action didn't get the same love as some of the
> other actions and it's still using spinlocks and shared stats.
> Therefore, transition the action to rcu and percpu stats which
> improves the action's performance.
> 
> We test this change with a very simple packet forwarding setup:
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/2] net/sched: transition act_pedit to rcu and percpu stats
    https://git.kernel.org/netdev/net-next/c/52cf89f78c01
  - [net-next,v6,2/2] net/sched: simplify tcf_pedit_act
    https://git.kernel.org/netdev/net-next/c/95b069382351

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


