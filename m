Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CFD624FA1
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiKKBfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbiKKBft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:35:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FF551C24;
        Thu, 10 Nov 2022 17:35:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 360C061E07;
        Fri, 11 Nov 2022 01:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 946B6C433D6;
        Fri, 11 Nov 2022 01:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668130547;
        bh=NdvT2wnkr1r2umk7UPyNV7j2p6JGFhId+2otiiTlT2c=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jEtf9kw8VM6eYZ1IcX/6KcHe2WT7c/jzpXKgESZyiOrVR0Hh74vvokNc7LozhmWjz
         hUpDI5A5BIXlc+PIVLbHATTRjaL8AG7802PZEiB53JSq+0qe71QtAl54VJYGDMBJ59
         64BD20PZ+dstMxYfnKxN7yyPwdMYvOHR5lGaAGSQRwk9yNUGu0isoqrNZqRJf0kPM/
         HveyMTbaiydQ0cIkWub85skqwwesLuL/J4yvzOYP03GudXPIGWDZtF9mE1mXB7y1Jx
         B76pXmb1TmHoo97I4ojO+Q4WgUQFcbimz7HiXcaJHKVCG279HBAHaWdltqlOSxVpNV
         jCn5CpL1twz1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84609C395FD;
        Fri, 11 Nov 2022 01:35:47 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.1-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221111010520.3435537-1-kuba@kernel.org>
References: <20221111010520.3435537-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221111010520.3435537-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc5
X-PR-Tracked-Commit-Id: abd5ac18ae661681fbacd8c9d0a577943da4c89e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4bbf3422df78029f03161640dcb1e9d1ed64d1ea
Message-Id: <166813054753.15450.14052222102987592804.pr-tracker-bot@kernel.org>
Date:   Fri, 11 Nov 2022 01:35:47 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 10 Nov 2022 17:05:20 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4bbf3422df78029f03161640dcb1e9d1ed64d1ea

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
