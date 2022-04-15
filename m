Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287C15030B3
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356191AbiDOVx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356189AbiDOVxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:53:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2374B6F4B9
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF73DB82FDE
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 21:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E7A5C385A9;
        Fri, 15 Apr 2022 21:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650059413;
        bh=ijHrUpeWHCppukSPMzVjDmycrDNJYfjMZeOxeemcM7I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g+gdjZxIK/2G2gOvnUQGrmtpLMXaqMiw770q5YFuTo7UO5PjErahFY5kOgiNc5fOB
         pbp2/GqanRVTLynsx1i6y6thsUEEuP10wfSDHqcH/TsYuTgUW61NMXck1CxNW+FKwL
         ctdVfOWDPe0TjQmz9bCOJRijrX61xM8j50LCanjlWHpI/PE4UzELk292qu4vWNDLAD
         IqiDs/ij5uE+zgDk2ANhBNZQsaKcBDYZgQwuo4Hnzn/yrhUjlj6mASSK5LpKdaP+Uz
         YKudNdMr09ijYMAPe85JzfYEOfKMg3MJeeejuQD5AtqbHhkcsrYgOeTtnXodi+AHOR
         OP91om1OoaBkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2EEF8EAC096;
        Fri, 15 Apr 2022 21:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: make ip6_rt_gc_expire an atomic_t
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165005941318.21261.5695810530637959197.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 21:50:13 +0000
References: <20220413181333.649424-1-eric.dumazet@gmail.com>
In-Reply-To: <20220413181333.649424-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        syzkaller@googlegroups.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Apr 2022 11:13:33 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Reads and Writes to ip6_rt_gc_expire always have been racy,
> as syzbot reported lately [1]
> 
> There is a possible risk of under-flow, leading
> to unexpected high value passed to fib6_run_gc(),
> although I have not observed this in the field.
> 
> [...]

Here is the summary with links:
  - [net] ipv6: make ip6_rt_gc_expire an atomic_t
    https://git.kernel.org/netdev/net/c/9cb7c013420f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


