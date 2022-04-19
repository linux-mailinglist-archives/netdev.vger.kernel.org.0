Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB643506941
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350464AbiDSLC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242912AbiDSLC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:02:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422B513F58
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2DECB811D2
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 11:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91661C385A8;
        Tue, 19 Apr 2022 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650366011;
        bh=vnCVLJI95AI31jJZmrbJnQnpT+qnT7yepDSCLs8HxQ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=teEju2Q/s6KxGbYFGeOXEZGk82mWUS1xOgs6NR7KRoQTTHCuKhTC0xJWjm0j5vGhn
         G/q+6QOWm4r2J3qzujQuRA1kjyd5Av24JEgjYOYabdp4bw9Y/tUW4BrFVzGGuuWxdp
         zAlmUw0Sq7CZ/h274kwu4jNNv0eAZvk4Qk+0DHp7tAi2ycBDk6hEHcIC68OG4wn9pI
         pJCkKjN3ordeHbRH6h65fati2Lc2vztJudLcGim6+H2mnYXAh0rDhRkc09fYgBPOFg
         dRL+fyWMA828JL1mLYyAjO4M3l0siW7fDGnK8hQECHB5YtXmcnqq0xw8hmzPK0nsRe
         Xpl/Mgr7mkzpg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68419F0383D;
        Tue, 19 Apr 2022 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next RESEND v11 0/2] net: sched: allow user to select txqueue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165036601142.4081.6388400074478655013.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Apr 2022 11:00:11 +0000
References: <20220415164046.26636-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20220415164046.26636-1-xiangxia.m.yue@gmail.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        jonathan.lemon@gmail.com, edumazet@google.com, alobakin@pm.me,
        pabeni@redhat.com, talalahmad@google.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, keescook@chromium.org,
        memxor@gmail.com, atenart@kernel.org, weiwan@google.com
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

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 16 Apr 2022 00:40:44 +0800 you wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Patch 1 allow user to select txqueue in clsact hook.
> Patch 2 support skbhash to select txqueue.
> 
> Tonghao Zhang (2):
>   net: sched: use queue_mapping to pick tx queue
>   net: sched: support hash selecting tx queue
> 
> [...]

Here is the summary with links:
  - [net-next,RESEND,v11,1/2] net: sched: use queue_mapping to pick tx queue
    https://git.kernel.org/netdev/net-next/c/2f1e85b1aee4
  - [net-next,RESEND,v11,2/2] net: sched: support hash selecting tx queue
    https://git.kernel.org/netdev/net-next/c/38a6f0865796

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


