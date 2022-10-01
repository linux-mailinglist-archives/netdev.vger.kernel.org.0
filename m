Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721145F1884
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 03:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiJABu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 21:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbiJABuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 21:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B92C14A3;
        Fri, 30 Sep 2022 18:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55DA7B82AFE;
        Sat,  1 Oct 2022 01:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E959DC4347C;
        Sat,  1 Oct 2022 01:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664589019;
        bh=g/fmvJQ96I21QWYtz7rgrzEHz71okhsbh1uHsnts1uM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U5xvTQF4+XR8/Eu3xnbGCKQoOauzh2PvyoN4ZGPTpNACTA1FAzUSvvZQ8PlqT4izq
         0u4gViEyITLsEqOag8e8yXf2xfFleuuM8YFSnnu1ZkqbpIdjPtK1ZVFIhJHDT6DHlT
         m2gNItxqdQko/4isDpY9ZI4rZuKPVoM1eMqCUsosr8SSETbiJzG/LjQnnTy46ZzRCw
         tCkZ0RJHInHmNk36E93rDRD26UrneUt2vWwlSwpsPCeNHh1w72T1YowswtTasSN9Z1
         6zIMtJEVDXIOP3h2Twc2XZsCZRT2yeL3cqkoYwQnGbf6IXCTGJd2AdTwHR7cKk4V+m
         naKShy00JfRvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4AEDE50D64;
        Sat,  1 Oct 2022 01:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2] selftests/tc-testing: update qdisc/cls/action
 features in config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166458901880.12957.16544448645380385670.git-patchwork-notify@kernel.org>
Date:   Sat, 01 Oct 2022 01:50:18 +0000
References: <20220929041909.83913-1-shaozhengchao@huawei.com>
In-Reply-To: <20220929041909.83913-1-shaozhengchao@huawei.com>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        shuah@kernel.org, victor@mojatatu.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 29 Sep 2022 12:19:09 +0800 you wrote:
> Since three patchsets "add tc-testing test cases", "refactor duplicate
> codes in the tc cls walk function", and "refactor duplicate codes in the
> qdisc class walk function" are merged to net-next tree, the list of
> supported features needs to be updated in config file.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] selftests/tc-testing: update qdisc/cls/action features in config
    https://git.kernel.org/netdev/net-next/c/f77a9f3cd1e6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


