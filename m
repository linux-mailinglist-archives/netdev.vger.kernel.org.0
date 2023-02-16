Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6405698F37
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 10:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBPJA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 04:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjBPJAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 04:00:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8691D3E09F
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 01:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 322B9B82692
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 09:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1187C4339B;
        Thu, 16 Feb 2023 09:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676538019;
        bh=EFTcCYyjRSJ7aP5K2uInswHY43KAlJQRjiMfL49pH2c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y4BOLhX8SKMilJkM7CfFqjUHGLsq4DeJPDEdTTYEp8LjFwPxPH+sejzPHR6RzKUwO
         rvfpyrvbIYfTg409D9JceJVal/a6W2w4EktV08U/PeeW2IXKRNpz6ywpHd/G9ilwNL
         IAyNEe+yt+Vx2r3yaHo3DJ1on90mBbNcxTxityKStyoXNsyXUNH4OHoZPoimqqJaVY
         uIb2NQH+lJswIzfx7B0hqVwKZBjBbzMTI4Xr4JZU27dyvnGR16wfJiaT4QVkvjBRpz
         csLnnVsQO/g7JocHrDehYlMGKbRqj9hEszFQoz2yCyBN3gpIqYfd+tlR64EavkRyYg
         S7KNF7so+8omg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1640E29F3F;
        Thu, 16 Feb 2023 09:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and classifiers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167653801965.11562.1845303984766011675.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 09:00:19 +0000
References: <20230214134915.199004-1-jhs@mojatatu.com>
In-Reply-To: <20230214134915.199004-1-jhs@mojatatu.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, stephen@networkplumber.org, dsahern@gmail.com
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

On Tue, 14 Feb 2023 08:49:10 -0500 you wrote:
> The CBQ + dsmark qdiscs and the tcindex + rsvp classifiers have served us for
> over 2 decades. Unfortunately, they have not been getting much attention due
> to reduced usage. While we dont have a good metric for tabulating how much use
> a specific kernel feature gets, for these specific features we observed that
> some of the functionality has been broken for some time and no users complained.
> In addition, syzkaller has been going to town on most of these and finding
> issues; and while we have been fixing those issues, at times it becomes obvious
> that we would need to perform bigger surgeries to resolve things found while
> getting a syzkaller fix in place. After some discussion we feel that in order
> to reduce the maintenance burden it is best to retire them.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net/sched: Retire CBQ qdisc
    https://git.kernel.org/netdev/net-next/c/051d44209842
  - [net-next,2/5] net/sched: Retire ATM qdisc
    https://git.kernel.org/netdev/net-next/c/fb38306ceb9e
  - [net-next,3/5] net/sched: Retire dsmark qdisc
    https://git.kernel.org/netdev/net-next/c/bbe77c14ee61
  - [net-next,4/5] net/sched: Retire tcindex classifier
    https://git.kernel.org/netdev/net-next/c/8c710f75256b
  - [net-next,5/5] net/sched: Retire rsvp classifier
    https://git.kernel.org/netdev/net-next/c/265b4da82dbf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


