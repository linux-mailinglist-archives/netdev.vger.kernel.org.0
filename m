Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED185BED3D
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiITTAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiITTAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1096581E;
        Tue, 20 Sep 2022 12:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62DCC62D2D;
        Tue, 20 Sep 2022 19:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3404C4314A;
        Tue, 20 Sep 2022 19:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663700419;
        bh=GkzmsJTp0hfWPwbl0qczwI0L/3zKrC9aX6ZutbbnrB0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IICjkc/Ufw5Uze4Kec3/LYEKpnv0wiVwAHnR8huOPr0nAWrN/2lyD+Qsyj5tXcKE/
         bv9CBdk9Ruks4hzv5tVe4F0p64HwTkc0J+kSRQK//6/bOOmIiYXTDdwS+t5MEguxWG
         LLMM07qnP7KKOdjbxnKng/y2Cmti9ZUnWgvg0WbG1EImkINkNDEc4c6bPZ1c8qg9yI
         V+N98ejf886DWOHqGy8I3tsSI1OGEX8UBuX46azGEm0xu6PMaH2TiCKusi/Jl6CrqQ
         drAG6Pn5bpmRCUs2/qnNg4SH3pNidDlmTDO1MXPY+td0ju9R9So1MIIg+RkEbQMVm7
         sdOn6X9Cjv9oQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D022E5250E;
        Tue, 20 Sep 2022 19:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/2] Fixes for tc-taprio software mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166370041957.20640.2207306423479530529.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 19:00:19 +0000
References: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        weifeng.voon@intel.com, olteanv@gmail.com, kurt@linutronix.de,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Sep 2022 13:08:00 +0300 you wrote:
> While working on some new features for tc-taprio, I found some strange
> behavior which looked like bugs. I was able to eventually trigger a NULL
> pointer dereference. This patch set fixes 2 issues I saw. Detailed
> explanation in patches.
> 
> Changes in v2: dropped patch 3/3 (will resend to net-next).
> 
> [...]

Here is the summary with links:
  - [v2,net,1/2] net/sched: taprio: avoid disabling offload when it was never enabled
    https://git.kernel.org/netdev/net/c/db46e3a88a09
  - [v2,net,2/2] net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs
    https://git.kernel.org/netdev/net/c/1461d212ab27

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


