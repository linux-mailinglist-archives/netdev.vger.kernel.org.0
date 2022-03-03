Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DE34CC5E3
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 20:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbiCCTS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 14:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235985AbiCCTS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 14:18:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EACA4186;
        Thu,  3 Mar 2022 11:18:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8990B8267E;
        Thu,  3 Mar 2022 19:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57AA0C340EF;
        Thu,  3 Mar 2022 19:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646335085;
        bh=K5IOr4Wzr1MpOVg6L2fgbRxtxn8B3rD1Bt8crLRDvbM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=iA6LwuvK4Ixr20kT6IU4rLUFR59TJH6SWpzFztNHHOcq6tANsz88dDvrwtwLtW/t5
         mtzqs3HMcLYFty7muu2bblh/Hv1GArCyknOsIlaZqFxRo8r8AGNLpinN7E0wXl4Y1Y
         WhsAr3U+9XoX2pwfuFXWLOv33lVWcHSdZE2mAdp1BZVGe/BRsOzU3LtwvZBDFNJn/N
         ju45M0c1qIFqEfkbgp0h1y1M7MhjrRXN464TSq6RivonGoFcN0ywuzZIs8l4EM+bgo
         DJp3VmpkP/IIqjS15euIkJ2OJ1M/z/L30BB+zfUt3qBtYl4ZVK5UNZVpmLdbzTbauL
         sItzbsFAktiuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 45375E5D087;
        Thu,  3 Mar 2022 19:18:05 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.17-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220303185419.1418173-1-kuba@kernel.org>
References: <20220303185419.1418173-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220303185419.1418173-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc7
X-PR-Tracked-Commit-Id: 2d3916f3189172d5c69d33065c3c21119fe539fc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b949c21fc23ecaccef89582f251e6281cad1f81e
Message-Id: <164633508527.14270.3235061392061878042.pr-tracker-bot@kernel.org>
Date:   Thu, 03 Mar 2022 19:18:05 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  3 Mar 2022 10:54:19 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b949c21fc23ecaccef89582f251e6281cad1f81e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
