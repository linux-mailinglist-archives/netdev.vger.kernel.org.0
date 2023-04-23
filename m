Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336DB6EC167
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 19:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjDWRkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 13:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDWRkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 13:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BF41A7
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 10:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0F3C61311
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 17:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 255FCC4339B;
        Sun, 23 Apr 2023 17:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682271619;
        bh=SUODQAEl2E3JBOp+oqSoF9toNBsq8akfE5/XpzfPxEA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CQWhP9P7PVCwNeAHCjFJ3oNl15m/R/xTgcGMlr1uTi2AATZmwKRbb2YfHBYT4wVqY
         ius0HXCdsfBTqrRKzzwWiVtO3lzObh9H5ZcodNQVfSfpMPOwUVmz47I3pSfARd3yGH
         aFNE1acHwsd5TKg6cJpPRBJ48lM4fLv+msym1HQ8qwUgGe8ZlNeHnNhZKBrobH+i0E
         oSU1YPFEuL28OdmEZZG/3kDKrYYRfCV3o4MD9m/hr4fAG/N+sgW+eLCkJm9CFtRX4c
         xJF1GRfWJkPCOR+UPdkhl6JJIDhTrJlw8olHx5xymrq9YN1nQmhCnWYG9xLKuF6ASI
         dAuosZ+ymjmLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07D5CE4D000;
        Sun, 23 Apr 2023 17:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/5] net/sched: act_pedit: minor improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168227161902.13607.15005287783913046062.git-patchwork-notify@kernel.org>
Date:   Sun, 23 Apr 2023 17:40:19 +0000
References: <20230421212516.406726-1-pctammela@mojatatu.com>
In-Reply-To: <20230421212516.406726-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Apr 2023 18:25:12 -0300 you wrote:
> This series aims to improve the code and usability of act_pedit for
> netlink users.
> 
> Patches 1-2 improves error reporting for extended keys parsing with extack.
> 
> Patch 3 checks the static offsets a priori on create/update. Currently,
> this is done at the datapath for both static and runtime offsets.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/5] net/sched: act_pedit: use NLA_POLICY for parsing 'ex' keys
    https://git.kernel.org/netdev/net-next/c/5036034572b7
  - [net-next,v5,2/5] net/sched: act_pedit: use extack in 'ex' parsing errors
    https://git.kernel.org/netdev/net-next/c/0c83c5210e18
  - [net-next,v5,3/5] net/sched: act_pedit: check static offsets a priori
    https://git.kernel.org/netdev/net-next/c/e1201bc781c2
  - [net-next,v5,4/5] net/sched: act_pedit: remove extra check for key type
    https://git.kernel.org/netdev/net-next/c/577140180ba2
  - [net-next,v5,5/5] net/sched: act_pedit: rate limit datapath messages
    https://git.kernel.org/netdev/net-next/c/e3c9673e2f6e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


