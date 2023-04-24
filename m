Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4D46EC9DF
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 12:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjDXKK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 06:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbjDXKK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 06:10:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E360A130
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 03:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3895761FE6
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 904CDC4339B;
        Mon, 24 Apr 2023 10:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682331020;
        bh=eaNEa2Z6j0hsioUrPZs9INqD9YbWTTuzmp0G5RDVIK0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XMGCsM2lCShFWR5ErCIeyU39jGTvbcJ6J8PsGAyihZwC5nQT6HcMw2U9exRkcJoxx
         n9qodbPRCCGROKhgPiAJw6Ddgb9UbpJI8pnu2KNXK1a+8Uxdx69aUgS6KEucpIZvAL
         XA1kBH3quzs8YolKTj0XVjbMa9J7CBwEVBmvyUNAgik+XkCe6+Fl7kWgDqzfYFd3NQ
         d+mWEiXl+gETnIziwpHvEXRTtBc9a8CDfeGQgsMkTFDdxoAN03+Lvmy9tKI8KF5iMD
         oACVaUOCyx5Sr/t8nuAKIKVs/3RpbhtLow2eV/j355sr26+6zBqR73CUuSTVqCGIdM
         d3Uvj3S4m+Sww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6F847E5FFC4;
        Mon, 24 Apr 2023 10:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/4] net/sched: cleanup parsing prints in htb and
 qfq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168233102045.17847.11233756373390799551.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Apr 2023 10:10:20 +0000
References: <20230422155612.432913-1-pctammela@mojatatu.com>
In-Reply-To: <20230422155612.432913-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 22 Apr 2023 12:56:08 -0300 you wrote:
> These two qdiscs are still using prints on dmesg to report parsing
> errors. Since the parsing code has access to extack, convert these error
> messages to extack.
> 
> QFQ also had the opportunity to remove some redundant code in the
> parameters parsing by transforming some attributes into parsing
> policies.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/4] net/sched: sch_htb: use extack on errors messages
    https://git.kernel.org/netdev/net/c/807cfded92b0
  - [net-next,v5,2/4] net/sched: sch_qfq: use extack on errors messages
    https://git.kernel.org/netdev/net/c/c69a9b023f65
  - [net-next,v5,3/4] net/sched: sch_qfq: refactor parsing of netlink parameters
    https://git.kernel.org/netdev/net/c/25369891fcef
  - [net-next,v5,4/4] selftests: tc-testing: add more tests for sch_qfq
    https://git.kernel.org/netdev/net/c/7eb060a51a3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


