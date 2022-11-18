Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02D662ED56
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 06:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240994AbiKRFuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 00:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241005AbiKRFuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 00:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EB297AA7
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 21:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AB37B821F6
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 05:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05B09C43150;
        Fri, 18 Nov 2022 05:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668750616;
        bh=OBni7kSkvJ9NVTurCAl06y5VxseAiRMPxJV8IfTT4Z0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=giA0JAxSqxO6iqD2fhTqukhw2KbvuY1665/Ka32MQyIwSPicR7xOjoDwRuyQvR5tB
         ddixnCgvYrnSMxBYRzSoOTOUnCpn9oH2SlGS41kq4RGqK5uGjqYE3sXwJxTPJFWMmC
         tiIeW5ptcFS+36Y2Xg2rbl6Ml0bNPFOtoF2njx6hXfvcDl+4v1f7Cx7mppUIrUzor5
         rPJGfw+dB8mSrKChYOkR8yIjAOaDNAQfeX6IhMqkOheOMnDw9uYC1fw+67EwwHgf0N
         C5tg2z8r9WimzcB/WqqCGXU9kbofk6/H1cJKmXznU8nKZ5HaGuxUpfak76X3V4LNTy
         2kFRacusND/LA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDF5EE270D5;
        Fri, 18 Nov 2022 05:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] mptcp: selftests: Fix timeouts and test isolation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166875061590.17881.7118032525132376110.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 05:50:15 +0000
References: <20221115221046.20370-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20221115221046.20370-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
        geliang.tang@suse.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
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

On Tue, 15 Nov 2022 14:10:43 -0800 you wrote:
> Patches 1 and 3 adjust test timeouts to reduce false negatives on slow
> machines.
> 
> Patch 2 improves test isolation by running the mptcp_sockopt test in its
> own net namespace.
> 
> Matthieu Baerts (2):
>   selftests: mptcp: run mptcp_sockopt from a new netns
>   selftests: mptcp: fix mibit vs mbit mix up
> 
> [...]

Here is the summary with links:
  - [net,1/3] selftests: mptcp: gives slow test-case more time
    https://git.kernel.org/netdev/net/c/22b29557aef3
  - [net,2/3] selftests: mptcp: run mptcp_sockopt from a new netns
    https://git.kernel.org/netdev/net/c/7e68d31020f1
  - [net,3/3] selftests: mptcp: fix mibit vs mbit mix up
    https://git.kernel.org/netdev/net/c/3de88b95c4d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


