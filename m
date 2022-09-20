Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0565BD8F9
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiITBAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiITBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6D34A806
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63FD461FC6
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACC98C433B5;
        Tue, 20 Sep 2022 01:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663635615;
        bh=CEvIJyID+lhqpFo9u173PQMJU+z8UhV4x72NJlvHotw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eGK82ihjclARq4rXCO1XmBsQgwD1q9Lyx8PLp2g3FEp2GEDZ1auLdKnfZoMnUPJG+
         ZwywrEpG5gi3EJCqABraCBODHasA9j9V2pWdlZ0iu1UNg1Q8YSdRNVjghx3ACSfA5E
         r8UKUrjNrqRiusmEXChT68GzG95hcH/A/vd4FCJkSYzZavkrw6+neYMM9zFfrWXVj1
         JsmL2VVZ5TiSvpri8sIwPvMa76sJUO+0X8ed83ovLLDHGBgf7b6C7RTm2pLKPDxwn2
         R6Gr3u+hEuRwSlFfgAizoKW6o4zc0l2zntri3NvgmynikoQuJqb9Kpx7beYiX7FS0V
         c8D3wVKkJnPFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94A76E52536;
        Tue, 20 Sep 2022 01:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netdevsim: Fix hwstats debugfs file permissions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363561560.18776.8219751409513328097.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:00:15 +0000
References: <20220909153830.3732504-1-idosch@nvidia.com>
In-Reply-To: <20220909153830.3732504-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        jie2x.zhou@intel.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Sep 2022 18:38:30 +0300 you wrote:
> The hwstats debugfs files are only writeable, but they are created with
> read and write permissions, causing certain selftests to fail [1].
> 
> Fix by creating the files with write permission only.
> 
> [1]
>  # ./test_offload.py
>  Test destruction of generic XDP...
>  Traceback (most recent call last):
>    File "/home/idosch/code/linux/tools/testing/selftests/bpf/./test_offload.py", line 810, in <module>
>      simdev = NetdevSimDev()
>  [...]
>  Exception: Command failed: cat /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex
> 
> [...]

Here is the summary with links:
  - [net] netdevsim: Fix hwstats debugfs file permissions
    https://git.kernel.org/netdev/net/c/34513ada53eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


