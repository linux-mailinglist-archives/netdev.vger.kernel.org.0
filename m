Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E805637FEE
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 20:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiKXT6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 14:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiKXT6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 14:58:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55391D6;
        Thu, 24 Nov 2022 11:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2886BB828FD;
        Thu, 24 Nov 2022 19:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB423C433D6;
        Thu, 24 Nov 2022 19:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669319927;
        bh=mymdoExkjq+5y4hBgN2w5HMQUK6B/z/2e3XyoFCd5Q0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AGfbcy9XisZdfAoeQfgbDXkSo9S78za+Rq47nSoY/DXVDV1ZpKEv0evjb5F3sFGO2
         2oYDFX0jAoHLspFJjOB6XaS1r8WOSnE8YwypyMFHfPPB5y9l9hnArbutrqMnuPq1Vr
         2YShb6VWMMm+TLwmzAMDX8j1s1mrBs1sGY2YDDozE/L6LoT80EksXb7Ujx9syPw6PM
         QxR+iD9mORAA0oeq7/EOsVRCR0GsvqKSXM8p40CBKaXlqwSlvxt2ONnnqZR13nY/pf
         /qjgvs2OBv2KKv4JYbNaEisThdLvPfaxZzYKSbD0L5zoYj128UOksp5srXI39yFfgj
         nraXVpvr6y07g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B90DAE21EFD;
        Thu, 24 Nov 2022 19:58:47 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.1-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221124112557.17960-1-pabeni@redhat.com>
References: <20221124112557.17960-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221124112557.17960-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc7
X-PR-Tracked-Commit-Id: 661e5ebbafd26d9d2e3c749f5cf591e55c7364f5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 08ad43d554bacb9769c6a69d5f771f02f5ba411c
Message-Id: <166931992774.6133.798666579816786723.pr-tracker-bot@kernel.org>
Date:   Thu, 24 Nov 2022 19:58:47 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 24 Nov 2022 12:25:57 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/08ad43d554bacb9769c6a69d5f771f02f5ba411c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
