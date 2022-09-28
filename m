Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAAF25ED696
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 09:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbiI1HoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 03:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiI1HnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 03:43:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA6D1138C6;
        Wed, 28 Sep 2022 00:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C616661C2C;
        Wed, 28 Sep 2022 07:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1572FC433D7;
        Wed, 28 Sep 2022 07:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664350819;
        bh=2oXepY+kJ5EmQKTE4f8lyro0vonBwLtTDrSU9LwLHMU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RuhzEopZePXB52+e4734tH4+3i6qadG1syhVuP/ewTZpobJb2woX+ePqGoatc5TqI
         dsZWzsTFnjBd3FWd8Okbi5CKqZl1S5JaHpOFkhbX8YzVssiayQE7/IB63AFHPQ9W37
         pFvdFIGTBNsmXbFClNOTTqtzwvXWti8jLy8aWBrOO4l2x2rE4/WPXuTO99IBcnsSVP
         NKOsiaY4Ph2/E+dK6XAx5orH1dRQrZ3Fr+IbjewBlrbaNbLhoc/KHf9KCqgvLwE/0N
         sDnuGNZRTRLUZM8/AuVA5QScMvisulgoCt+6IGdZMI5AP7LMfzgVcPRqWVCiKFCMAE
         /y1INZPGpd6nw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EACDFE4D035;
        Wed, 28 Sep 2022 07:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v3 00/15] add tc-testing qdisc test cases
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166435081895.7457.3548028612225858722.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 07:40:18 +0000
References: <20220924025157.331635-1-shaozhengchao@huawei.com>
In-Reply-To: <20220924025157.331635-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 24 Sep 2022 10:51:42 +0800 you wrote:
> For this patchset, test cases of the qdisc modules are added to the
> tc-testing test suite.
> 
> Last, thanks to Victor for testing and suggestion.
> 
> After a test case is added locally, the test result is as follows:
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/15] selftests/tc-testing: add selftests for atm qdisc
    https://git.kernel.org/netdev/net-next/c/0335833b10cd
  - [net-next,v3,02/15] selftests/tc-testing: add selftests for choke qdisc
    https://git.kernel.org/netdev/net-next/c/99e0f78d6bdd
  - [net-next,v3,03/15] selftests/tc-testing: add selftests for codel qdisc
    https://git.kernel.org/netdev/net-next/c/412233b1f7e7
  - [net-next,v3,04/15] selftests/tc-testing: add selftests for etf qdisc
    https://git.kernel.org/netdev/net-next/c/fa4b3e9f057b
  - [net-next,v3,05/15] selftests/tc-testing: add selftests for fq qdisc
    https://git.kernel.org/netdev/net-next/c/9e274718cc05
  - [net-next,v3,06/15] selftests/tc-testing: add selftests for gred qdisc
    https://git.kernel.org/netdev/net-next/c/a4a8d3562b07
  - [net-next,v3,07/15] selftests/tc-testing: add selftests for hhf qdisc
    https://git.kernel.org/netdev/net-next/c/225aeb62fe58
  - [net-next,v3,08/15] selftests/tc-testing: add selftests for pfifo_fast qdisc
    https://git.kernel.org/netdev/net-next/c/379a6509452e
  - [net-next,v3,09/15] selftests/tc-testing: add selftests for plug qdisc
    https://git.kernel.org/netdev/net-next/c/7d0b4b0ccb15
  - [net-next,v3,10/15] selftests/tc-testing: add selftests for sfb qdisc
    https://git.kernel.org/netdev/net-next/c/6ad92dc56fca
  - [net-next,v3,11/15] selftests/tc-testing: add selftests for sfq qdisc
    https://git.kernel.org/netdev/net-next/c/0158f65bfbdd
  - [net-next,v3,12/15] selftests/tc-testing: add selftests for skbprio qdisc
    https://git.kernel.org/netdev/net-next/c/c5a2d86b9228
  - [net-next,v3,13/15] selftests/tc-testing: add selftests for taprio qdisc
    https://git.kernel.org/netdev/net-next/c/8a3b3667ddbd
  - [net-next,v3,14/15] selftests/tc-testing: add selftests for tbf qdisc
    https://git.kernel.org/netdev/net-next/c/10835be3f0f7
  - [net-next,v3,15/15] selftests/tc-testing: add selftests for teql qdisc
    https://git.kernel.org/netdev/net-next/c/cc62fbe114c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


