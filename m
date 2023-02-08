Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1507768EBCE
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjBHJkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBHJkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33E510F3;
        Wed,  8 Feb 2023 01:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 787CFB81C68;
        Wed,  8 Feb 2023 09:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0B6FC433EF;
        Wed,  8 Feb 2023 09:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675849219;
        bh=ElasMeDokDNZfOfG/B6ALSY5xiD21dxk0E3Ku7VBZ6w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EtdNjztdGpJ/f681qbphxR6KchUxxbdUjfHxniMpNEXnLeKn0I4bK8hotVirtPevO
         eV/NNqMkjSYVlcU8dOIVA0ileX78ouqvfk4rn/odoR1cgjTM2yNREYVPJGwWPUi98n
         eOdNTczVFDprbHzluGdViNh8i4YoQjufomj6Cs8cgPZ8IlJGQIJiypvHYk1yOJn2Py
         ELGyjKQ85EA86Feo6CLxbRudEcYwsJy7aENzT5NA1Xvs2Ezvr+ckiZ/39Vo9zLQYWy
         m3IQtTphfU1qj4HISAWrFO/IZN8ZU11T0Qa/glzjvPUeA22mztjAtvI0h8lYwSN0mh
         IcEIvsM1a6+mQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D52DCE4D032;
        Wed,  8 Feb 2023 09:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] mptcp: fixes for v6.2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167584921886.28651.15884792835750696627.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 09:40:18 +0000
References: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
In-Reply-To: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     mptcp@lists.linux.dev, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dcaratti@redhat.com,
        mathew.j.martineau@linux.intel.com, benjamin.hesmans@tessares.net,
        geliangtang@gmail.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        stable@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 07 Feb 2023 14:04:12 +0100 you wrote:
> Patch 1 clears resources earlier if there is no more reasons to keep
> MPTCP sockets alive.
> 
> Patches 2 and 3 fix some locking issues visible in some rare corner
> cases: the linked issues should be quite hard to reproduce.
> 
> Patch 4 makes sure subflows are correctly cleaned after the end of a
> connection.
> 
> [...]

Here is the summary with links:
  - [net,1/6] mptcp: do not wait for bare sockets' timeout
    https://git.kernel.org/netdev/net/c/d4e85922e3e7
  - [net,2/6] mptcp: fix locking for setsockopt corner-case
    https://git.kernel.org/netdev/net/c/21e43569685d
  - [net,3/6] mptcp: fix locking for in-kernel listener creation
    https://git.kernel.org/netdev/net/c/ad2171009d96
  - [net,4/6] mptcp: be careful on subflow status propagation on errors
    https://git.kernel.org/netdev/net/c/1249db44a102
  - [net,5/6] selftests: mptcp: allow more slack for slow test-case
    https://git.kernel.org/netdev/net/c/a635a8c3df66
  - [net,6/6] selftests: mptcp: stop tests earlier
    https://git.kernel.org/netdev/net/c/070d6dafacba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


