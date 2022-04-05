Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0CD4F40C7
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiDET7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 15:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457634AbiDEQWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:22:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783EA68FB8;
        Tue,  5 Apr 2022 09:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33847B81E76;
        Tue,  5 Apr 2022 16:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1895C385A5;
        Tue,  5 Apr 2022 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649175648;
        bh=9P0bvPQE7TMYUDS1QHIUxX2gPSQ2fjCXf7+fuJtJhZk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DuxV52lKFd1sgfEeUDu9tOfV6G4bvXzk2hAfEUif0dtsVbADNdPFBYFfsMNXTfLkv
         VPz+SSuWPJiz/2Pt29cWiLakeKR0SIbLT84b2Pt3E8GKMocCT6NBf1+gMiUYSpZR1U
         5ZrQH2eFiZTVw6Hwf/VR+BVKI8oRuthYG7GkA2B8QeH761kRvg1kukLjz/SiXVMT8k
         ogt3jYFymRus/NVEDcAyE5tQwCYaN4j3V/CVD6nPyHAEBZ/PbhYFUHS/ZELeTrdjLp
         4eNyIQomhhBu43ddy3oWEs94w4OA/uuD9XExE+t+c0XbjFvAE88gftmwPdqD5hhn7h
         wLsEkzxX4J6Ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9972CE85D15;
        Tue,  5 Apr 2022 16:20:48 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tracing: Move user_events.h temporarily out of include/uapi
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164917564862.18481.12734568923836492201.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Apr 2022 16:20:48 +0000
References: <20220401143903.188384f3@gandalf.local.home>
In-Reply-To: <20220401143903.188384f3@gandalf.local.home>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        beaub@linux.microsoft.com, mhiramat@kernel.org,
        linux-trace-devel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, alexei.starovoitov@gmail.com,
        torvalds@linux-foundation.org, michal.lkml@markovi.net,
        ndesaulniers@google.com, linux-kbuild@vger.kernel.org,
        masahiroy@kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Steven Rostedt (Google) <rostedt@goodmis.org>:

On Fri, 1 Apr 2022 14:39:03 -0400 you wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> While user_events API is under development and has been marked for broken
> to not let the API become fixed, move the header file out of the uapi
> directory. This is to prevent it from being installed, then later changed,
> and then have an old distro user space update with a new kernel, where
> applications see the user_events being available, but the old header is in
> place, and then they get compiled incorrectly.
> 
> [...]

Here is the summary with links:
  - tracing: Move user_events.h temporarily out of include/uapi
    https://git.kernel.org/netdev/net-next/c/5cfff569cab8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


