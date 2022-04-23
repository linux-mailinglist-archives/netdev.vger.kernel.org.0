Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E95550C98C
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 13:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiDWLXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 07:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiDWLXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 07:23:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952091725C3
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 04:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2958160FF9
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 11:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79EC5C385A8;
        Sat, 23 Apr 2022 11:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650712812;
        bh=sHvgYwFF+jetDLV+QfjJhsvA23gSwwlu8OsZYsHFZlQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YGt47C5SqGGYyuLp+1DLowJdRKizR+lvvisb1wYiby5+LSnnZZu6bpHXz2duQUu7T
         n3ytNIzr3UnDunZSp48bVOQmaXF970psaXlyvOAMss2aIc/kQOmeiEnQKZW/AoPcoC
         jzO6BkFiImbAg++oafUHjTKOzsDXw7tiG0sQQf+gG3snIfQAQvFYBGCUuHCeNKr0mA
         g2nXpHnNPm/J0QBPQe33PgNQTPr8K8S1NYNDKkbSDdzbG+lv16rPzm4egUi4tiCdTo
         TDtI9UO+Pg88p0xDiicTfB7WkuhzP1yYo/KHwIDp06qhHGwIVUK5OmuNzLMNsf42pr
         PO8HKG0J0rsCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58FC7EAC09C;
        Sat, 23 Apr 2022 11:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] DSA selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165071281235.17561.4364983512951885860.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Apr 2022 11:20:12 +0000
References: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, tobias@waldekranz.com,
        mattias.forsblad@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        jiri@nvidia.com, idosch@nvidia.com, troglobit@gmail.com,
        kabel@kernel.org, ansuelsmth@gmail.com, dqfext@gmail.com,
        kurt@linutronix.de
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Apr 2022 13:14:56 +0300 you wrote:
> When working on complex new features or reworks it becomes increasingly
> difficult to ensure there aren't regressions being introduced, and
> therefore it would be nice if we could go over the functionality we
> already have and write some tests for it.
> 
> Verbally I know from Tobias Waldekranz that he has been working on some
> selftests for DSA, yet I have never seen them, so here I am adding some
> tests I have written which have been useful for me. The list is by no
> means complete (it only covers elementary functionality), but it's still
> good to have as a starting point. I also borrowed some refactoring
> changes from Joachim Wiberg that he submitted for his "net: bridge:
> forwarding of unknown IPv4/IPv6/MAC BUM traffic" series, but not the
> entirety of his selftests. I now think that his selftests have some
> overlap with bridge_vlan_unaware.sh and bridge_vlan_aware.sh and they
> should be more tightly integrated with each other - yet I didn't do that
> either :). Another issue I had with his selftests was that they jumped
> straight ahead to configure brport flags on br0 (a radical new idea
> still at RFC status) while we have bigger problems, and we don't have
> nearly enough coverage for the *existing* functionality.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] selftests: forwarding: add option to run tests with stable MAC addresses
    https://git.kernel.org/netdev/net-next/c/b343734ee265
  - [net-next,2/8] selftests: forwarding: add TCPDUMP_EXTRA_FLAGS to lib.sh
    https://git.kernel.org/netdev/net-next/c/fe32dffdcd33
  - [net-next,3/8] selftests: forwarding: multiple instances in tcpdump helper
    https://git.kernel.org/netdev/net-next/c/6182c5c5098f
  - [net-next,4/8] selftests: forwarding: add helpers for IP multicast group joins/leaves
    https://git.kernel.org/netdev/net-next/c/f23cddc72294
  - [net-next,5/8] selftests: forwarding: add helper for retrieving IPv6 link-local address of interface
    https://git.kernel.org/netdev/net-next/c/a5114df6c613
  - [net-next,6/8] selftests: forwarding: add a no_forwarding.sh test
    https://git.kernel.org/netdev/net-next/c/476a4f05d9b8
  - [net-next,7/8] selftests: forwarding: add a test for local_termination.sh
    https://git.kernel.org/netdev/net-next/c/90b9566aa5cd
  - [net-next,8/8] selftests: drivers: dsa: add a subset of forwarding selftests
    https://git.kernel.org/netdev/net-next/c/07c8a2dd69f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


