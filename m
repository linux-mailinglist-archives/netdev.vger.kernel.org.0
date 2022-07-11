Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5758570065
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiGKL0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiGKLZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:25:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E86EF586
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 04:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3543B80EB8
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 11:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6315FC341C0;
        Mon, 11 Jul 2022 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657537213;
        bh=PhOOv8uKgZHnSzUiyhjxLskG/VAVOLAuQAy1Ij6UaAM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MEpEbrCs8noyz14JdHmv02NsEBDVq/AXoWOGxmyyJWsePIV5GjacC/kqoJp0DQX8E
         0lD4o2CbM1u07RSE+gvwO7RaMiShteVWTwbCkCRyW/x1j5KN8ok5YFuGIWTh8d7rAO
         SKtXgfi9kctRTHzQ0FO1c7pTxigIQPIPdNPdCZVW4iUkSE2ytqkvFtjDB1j3e8Jxk3
         HP+CbkBffU1WiKeSHaA1N+4fjtOchYWft4dzR0TelRKFO+3zvQK+W/vl+POFGoCPwr
         59yeMqHtV/fuW6xZ32ELEZEzVK+9jKTiTGt25EdQO1avKZNWYx/PZPlE5pdbBvFTeU
         d45oEy3OZhFxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48243E4521F;
        Mon, 11 Jul 2022 11:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mptcp: Disconnect and selftest fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165753721328.18044.8546633791151784612.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Jul 2022 11:00:13 +0000
References: <20220708233610.410786-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220708233610.410786-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kishen.maloor@intel.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Jul 2022 16:36:08 -0700 you wrote:
> Patch 1 switches to a safe list iterator in the MPTCP disconnect code.
> 
> Patch 2 adds the userspace_pm.sh selftest script to the MPTCP selftest
> Makefile, resolving the netdev/check_selftest CI failure.
> 
> Matthieu Baerts (1):
>   selftests: mptcp: validate userspace PM tests by default
> 
> [...]

Here is the summary with links:
  - [net,1/2] mptcp: fix subflow traversal at disconnect time
    https://git.kernel.org/netdev/net/c/5c835bb142d4
  - [net,2/2] selftests: mptcp: validate userspace PM tests by default
    https://git.kernel.org/netdev/net/c/3ddabc433670

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


