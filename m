Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7BB5ED37F
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiI1DaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiI1DaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27414FAED
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E49E61D08
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 03:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D90D7C433B5;
        Wed, 28 Sep 2022 03:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664335815;
        bh=UdwTebeJWgHsMdLAQxvUhbMNJgKyAJKTBYGq9QhoIRE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r3aYqKsL5cTdOTSE3fvJUqk5gaFGOn9YmdOZCjYYVIa/rI8p/NaFFDFujd/iL9ckF
         eLJlBfpFqUthHIxXIwAT+ZXZIEo6z8OlDDBanyePvSrfzqgv16fLyJoFmwT7dFvMLQ
         PtDEVYGC7wx++JYIUCcMCAMVhffPn0dtPU6gyx6IYZtfpHre/5v3N0eL8o6rrhVKNh
         VQYvrG8jRD21Hq8nud6MBB0uDXIh2lOGMk45Pyc9Z3id+mKAHDpiBqJ2yw0hPYTYGb
         UWcLS62wlVU9+PR6QQwdpPTmJJb0qK90Qyo0bvhCW+Zo6vN5Z7xDvhkRo5DAm5TkjG
         pk5gDm/5SPQKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BEB3AE4D035;
        Wed, 28 Sep 2022 03:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sched: add extack for tfilter_notify
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166433581577.10603.15313432239904664550.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 03:30:15 +0000
References: <20220927101755.191352-1-liuhangbin@gmail.com>
In-Reply-To: <20220927101755.191352-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, marcelo.leitner@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 27 Sep 2022 18:17:55 +0800 you wrote:
> In commit 81c7288b170a ("sched: cls: enable verbose logging") Marcelo
> made cls could log verbose info for offloading failures, which helps
> improving Open vSwitch debuggability when using flower offloading.
> 
> It would also be helpful if "tc monitor" could log this message, as it
> doesn't require vswitchd log level adjusment. Let's add the extack message
> in tfilter_notify so the monitor program could receive the failures.
> e.g.
> 
> [...]

Here is the summary with links:
  - [net-next] sched: add extack for tfilter_notify
    (no matching commit)
  - [iproute2-next,2/2] tc/tc_monitor: print netlink extack message
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=0cc5533b71dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


