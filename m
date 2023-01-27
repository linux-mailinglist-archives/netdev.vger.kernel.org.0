Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D191567EFCA
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 21:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjA0Ulk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 15:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjA0Uli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 15:41:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC44F7D98E;
        Fri, 27 Jan 2023 12:41:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDB69B821E1;
        Fri, 27 Jan 2023 20:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9BF79C4339E;
        Fri, 27 Jan 2023 20:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674852045;
        bh=PBVwUIWzbi9TkFlduHt6qjJ4GnSHPl/m/20UDFHZx6A=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=pLZwGDkDutswm4gXbFF5VJXI9tL3sn6IIYhFHcZSbYdo65qze4GKtrk5bhKUFZcvC
         X/fbhp+PIMJ4G+ee84tS5PF8G/uH3YYK7bV19FdByFEuztZXrIMT2S/DDqH5TxHNff
         t/VTS+Y8sQD/v1tAVTy4tjfBiERevNPy/t4j03K/yhfJLBk/M6B1TnnD+SD2Z7rwBM
         PtPn1TXDQMyZaKsAqeP8JzlIyUjfVTliXbWATLHoeWutC+1VDRR/CQQ2yKbBQm5r6v
         9TpoM7ytQA2VH902jvD3Ur9BopwLiPRkMg7ZPmzUrXEaDCstpB8gCISy6GlAEyM20j
         9RPd03brIVXxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8BAF1E52504;
        Fri, 27 Jan 2023 20:40:45 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.2-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230126122643.379852-1-pabeni@redhat.com>
References: <20230126122643.379852-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230126122643.379852-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc6
X-PR-Tracked-Commit-Id: 7083df59abbc2b7500db312cac706493be0273ff
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 28b4387f0ec08d48634fcc3e3687c93edc1503f9
Message-Id: <167485204556.30356.9364047974308011102.pr-tracker-bot@kernel.org>
Date:   Fri, 27 Jan 2023 20:40:45 +0000
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

The pull request you sent on Thu, 26 Jan 2023 13:26:43 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/28b4387f0ec08d48634fcc3e3687c93edc1503f9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
