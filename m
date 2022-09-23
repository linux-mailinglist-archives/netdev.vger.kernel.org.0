Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBEA5E7133
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 03:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbiIWBLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 21:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiIWBLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 21:11:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B73E2370;
        Thu, 22 Sep 2022 18:10:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C50CB83548;
        Fri, 23 Sep 2022 01:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA9A8C433B5;
        Fri, 23 Sep 2022 01:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663895422;
        bh=kYtLy0RfBCu/9Oa3T3cLbgInqbCO5+T7ZqKOA7sUjnk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tWPmdaF5veNhkLcV+8KcZDv/8DeMQRky6E1O3swV+ql2Ok65hMTxuBFo+NZU4/SvM
         0grf6RxT/WColoP79UK1rVKhoqIZbmnk1Qn6H7NglX0jOUch68OQkQrunYhcFYprKf
         uymR+FMACU9yZSsgWn5dl+oyHek1R5dxcEcMInaQyjspFs4mk3oAeaQCvmkehfiNPa
         ls7pdRaiT1d12vguFwGgEhlqYmf/JswnO71BzSB8V2X1pDdYDYU7OO7/PPK793iOfX
         gSYsNlCXONuZ/PishMGBhJowAfmiXmAcgMnhIRP3cAPYgZUGaimp/KIJDJV0hWUkPe
         wF/Q7QFIvQSWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93DDDE4D03F;
        Fri, 23 Sep 2022 01:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v3 00/18] refactor duplicate codes in the qdisc class
 walk function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166389542260.15244.14188534167080882429.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 01:10:22 +0000
References: <20220921024040.385296-1-shaozhengchao@huawei.com>
In-Reply-To: <20220921024040.385296-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        linux-kselftest@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        toke@toke.dk, vinicius.gomes@intel.com, stephen@networkplumber.org,
        shuah@kernel.org, victor@mojatatu.com, zhijianx.li@intel.com,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Sep 2022 10:40:40 +0800 you wrote:
> The walk implementation of most qdisc class modules is basically the
> same. That is, the values of count and skip are checked first. If count
> is greater than or equal to skip, the registered fn function is
> executed. Otherwise, increase the value of count. So the code can be
> refactored.
> 
> The walk function is invoked during dump. Therefore, test cases related
>  to the tdc filter need to be added.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/18] net/sched: sch_api: add helper for tc qdisc walker stats dump
    https://git.kernel.org/netdev/net-next/c/d7a68e564e29
  - [net-next,v3,02/18] net/sched: use tc_qdisc_stats_dump() in qdisc
    https://git.kernel.org/netdev/net-next/c/e046fa895c45
  - [net-next,v3,03/18] selftests/tc-testing: add selftests for cake qdisc
    https://git.kernel.org/netdev/net-next/c/b68d9c330eef
  - [net-next,v3,04/18] selftests/tc-testing: add selftests for cbq qdisc
    https://git.kernel.org/netdev/net-next/c/6c1ef8f00f9a
  - [net-next,v3,05/18] selftests/tc-testing: add selftests for cbs qdisc
    https://git.kernel.org/netdev/net-next/c/3bec7e2910b8
  - [net-next,v3,06/18] selftests/tc-testing: add selftests for drr qdisc
    https://git.kernel.org/netdev/net-next/c/9b1edbc1c58f
  - [net-next,v3,07/18] selftests/tc-testing: add selftests for dsmark qdisc
    https://git.kernel.org/netdev/net-next/c/5d93f04d681d
  - [net-next,v3,08/18] selftests/tc-testing: add selftests for fq_codel qdisc
    https://git.kernel.org/netdev/net-next/c/965a25e34550
  - [net-next,v3,09/18] selftests/tc-testing: add selftests for hfsc qdisc
    https://git.kernel.org/netdev/net-next/c/265b9adcc4c6
  - [net-next,v3,10/18] selftests/tc-testing: add selftests for htb qdisc
    https://git.kernel.org/netdev/net-next/c/68135f636218
  - [net-next,v3,11/18] selftests/tc-testing: add selftests for mqprio qdisc
    https://git.kernel.org/netdev/net-next/c/8ab00f8b5e29
  - [net-next,v3,12/18] selftests/tc-testing: add selftests for multiq qdisc
    https://git.kernel.org/netdev/net-next/c/e4c4bcb0e4ee
  - [net-next,v3,13/18] selftests/tc-testing: add selftests for netem qdisc
    https://git.kernel.org/netdev/net-next/c/779f966f16db
  - [net-next,v3,14/18] selftests/tc-testing: add selftests for qfq qdisc
    https://git.kernel.org/netdev/net-next/c/856359c0d067
  - [net-next,v3,15/18] selftests/tc-testing: add show class case for ingress qdisc
    https://git.kernel.org/netdev/net-next/c/5ca72fbeabed
  - [net-next,v3,16/18] selftests/tc-testing: add show class case for mq qdisc
    https://git.kernel.org/netdev/net-next/c/dfbadd7f9945
  - [net-next,v3,17/18] selftests/tc-testing: add show class case for prio qdisc
    https://git.kernel.org/netdev/net-next/c/1c15eb2a03c6
  - [net-next,v3,18/18] selftests/tc-testing: add show class case for red qdisc
    https://git.kernel.org/netdev/net-next/c/d3f832547bb2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


