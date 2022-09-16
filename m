Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B085BAE28
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiIPNaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiIPNaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:30:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2C93AB09;
        Fri, 16 Sep 2022 06:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DC8B8CE1E61;
        Fri, 16 Sep 2022 13:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15B09C433D6;
        Fri, 16 Sep 2022 13:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663335018;
        bh=13EYRbgoJfqB810DYW91+jUD6de99QdJ4UHxA+u/ogM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S0pf8mLhAexZn60Vy3wXLDe8bSqLH07fDqxJATALXBhnSHBhfZBDTwfjA1bOVK42X
         oqkp4wL9RiX16P4UkrawDpTzx7PasCwgWdetqunWqdQILG6SVQTsiQSsUPvsjXWvwk
         eCxKESQque6fns273L374etVyWuytzUWla2pmjATO+1D4nvzWsjft02qJtaxM+iDrr
         OMijvjft3Hi4tkKcRc9m1hnRRXVxPgaqSfS+OnIE9rBi9XxILaX/Z6fF6PjMfCAqkl
         2hv/7YcE9iKpFBvSOv4a1QogdkhIwi9jF62CSrhiv0sk/0ouXfGDYxuvm/I6NLCakH
         3A1VyxmdAzNNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E53EEC73FEF;
        Fri, 16 Sep 2022 13:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] add tc-testing test cases
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166333501793.14457.4751472061963307047.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 13:30:17 +0000
References: <20220909012936.268433-1-shaozhengchao@huawei.com>
In-Reply-To: <20220909012936.268433-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, shuah@kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 9 Sep 2022 09:29:28 +0800 you wrote:
> For this patchset, test cases of the ctinfo, gate, and xt action modules
> are added to the tc-testing test suite. Also add deleting test for
> connmark, ife, nat, sample and tunnel_key action modules.
> 
> After a test case is added locally, the test result is as follows:
> 
> ./tdc.py -c action ctinfo
> considering category action
> considering category ctinfo
> Test c826: Add ctinfo action with default setting
> Test 0286: Add ctinfo action with dscp
> Test 4938: Add ctinfo action with valid cpmark and zone
> Test 7593: Add ctinfo action with drop control
> Test 2961: Replace ctinfo action zone and action control
> Test e567: Delete ctinfo action with valid index
> Test 6a91: Delete ctinfo action with invalid index
> Test 5232: List ctinfo actions
> Test 7702: Flush ctinfo actions
> Test 3201: Add ctinfo action with duplicate index
> Test 8295: Add ctinfo action with invalid index
> Test 3964: Replace ctinfo action with invalid goto_chain control
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] selftests/tc-testings: add selftests for ctinfo action
    https://git.kernel.org/netdev/net-next/c/77cba3879f1b
  - [net-next,2/8] selftests/tc-testings: add selftests for gate action
    https://git.kernel.org/netdev/net-next/c/4a1db5251cfa
  - [net-next,3/8] selftests/tc-testings: add selftests for xt action
    https://git.kernel.org/netdev/net-next/c/910d504bc187
  - [net-next,4/8] selftests/tc-testings: add connmark action deleting test case
    https://git.kernel.org/netdev/net-next/c/0fc8674663f6
  - [net-next,5/8] selftests/tc-testings: add ife action deleting test case
    https://git.kernel.org/netdev/net-next/c/af649e7a6a53
  - [net-next,6/8] selftests/tc-testings: add nat action deleting test case
    https://git.kernel.org/netdev/net-next/c/043b16435f3d
  - [net-next,7/8] selftests/tc-testings: add sample action deleting test case
    https://git.kernel.org/netdev/net-next/c/a32a4fa447f5
  - [net-next,8/8] selftests/tc-testings: add tunnel_key action deleting test case
    https://git.kernel.org/netdev/net-next/c/eed791d3ca95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


