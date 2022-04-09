Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEE24FA09C
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 02:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbiDIAW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 20:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240152AbiDIAW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 20:22:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B930BF967;
        Fri,  8 Apr 2022 17:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2154BB82AAC;
        Sat,  9 Apr 2022 00:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3BC8C385A3;
        Sat,  9 Apr 2022 00:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649463618;
        bh=v2axaVR4a7HQL4FTxiQIYTTsQkAsb8MprBbAFMtiGR8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RCC92V/OxeCI53PljEskVqkfSvdx3U8kswAVY68CgkFHBwB+rl4SgzZUX/rs59/wJ
         5CtMX/5H4s5cx4IkOtPcB8/N0X3M3upC91GCqlbrWXe7GUrWwMxwCwT+aDEtJ5jGLc
         LeYHRAPnbY5UMOWuyDR4KQlt8tPFITne4k5pgSD7P6EGzIH5OpIxf1kyUBNSOxlws8
         DA7WMuTE7jf2nVDRI7ttQt8VnR0JiwsUMpCDWXvwJqudUCdBGaF615PAOQsOQAJcvY
         MFBrp0ZOm1YWwyyCOZgerOCjNt5sv49x6MnPi2NPOJEDAHE8BwzkcpL9yIYXgzojzD
         sgHcqUg4Ik1CA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89E3CE8DBDA;
        Sat,  9 Apr 2022 00:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-04-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164946361855.20972.13365187832223537162.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Apr 2022 00:20:18 +0000
References: <20220408231741.19116-1-daniel@iogearbox.net>
In-Reply-To: <20220408231741.19116-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  9 Apr 2022 01:17:41 +0200 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 63 non-merge commits during the last 9 day(s) which contain
> a total of 68 files changed, 4852 insertions(+), 619 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-04-09
    https://git.kernel.org/netdev/net-next/c/34ba23b44c66

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


