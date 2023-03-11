Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BF16B57D1
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 03:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjCKCaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 21:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjCKCaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 21:30:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6878E14495A;
        Fri, 10 Mar 2023 18:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3A3CB824AA;
        Sat, 11 Mar 2023 02:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 827D6C4339B;
        Sat, 11 Mar 2023 02:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678501818;
        bh=bawXol2V1ppDvIGm18cXYtHBfuB7tDLXh0Rdh/D+70U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GBfO/GRfgkpTvRp4xOmwxLES5A6SNXFanHItCurzXTpk+6PPVC+ktTKGGH1Xe13b3
         /dJ60603DDJ67kHxh5wMC2Bx0Y9CPZ0uB2KS/IA5XLpPB435bbwrfsTpiVh3Rweu+A
         ViJMpgCGRCtV25WQZegfMrQgFp4ETxMCBGk0tLVwTIGX1EjHrHkIvIkGfw92sYZlTV
         vBrSVHV0UB3IWpsnsPqfCh/ma6pMltsoBFx204eHTanOugHs2tpTz3cuUHecj8SVKT
         xozt8CK+jOrhZkdYO9T6fsjdJyC9blxQCHWqGKvRsH15SbfOqjenJw/KCzZnGz87tk
         NmM3ACG5LJdpA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5FD31E21EEB;
        Sat, 11 Mar 2023 02:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2023-03-10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167850181838.1349.14153958336259221499.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 02:30:18 +0000
References: <20230310114647.35422-1-johannes@sipsolutions.net>
In-Reply-To: <20230310114647.35422-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Mar 2023 12:46:46 +0100 you wrote:
> Hi,
> 
> For now in wireless we only have a few fixes for some
> recently reported (and mostly recently introduced)
> problems.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2023-03-10
    https://git.kernel.org/netdev/net/c/27c30b9b449a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


