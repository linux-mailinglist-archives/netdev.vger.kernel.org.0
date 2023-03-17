Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A1D6BF4BB
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjCQVzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjCQVzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:55:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7501DCD654;
        Fri, 17 Mar 2023 14:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AAD6B82739;
        Fri, 17 Mar 2023 21:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD4EBC4339B;
        Fri, 17 Mar 2023 21:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679089917;
        bh=SxWvhozu8QTSruN4nAyU6Qo1A7cdcFSb6b2oH0LqNPk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=clAN4XKCIx30q81UZ/tTTRAeaPf5usrn3sgOAnB4+7XAmdVKRr/RGkSBRKwKFKmIJ
         EIkKI6/6aNABSEwkae1pU4wC9+U0lWmIfRtFIo7DBuhzyAPR16mS+1pPe4SCZQB8W+
         03rzBJDqeCOCK3X8brJEgF595L0gOrylbEulg02l1Zh/UQpA67ayNp/8igOYBm6fXY
         h7qeX0q+lK9z9CseQC3jZNhPwfuAu+lQlhYDgUvV9iyqosWu6Qc0cYEjZZ0f07b7s2
         au1wYWvQjxpZKcr43xICH5OZbJBYxBIxgkBGrs9ny0SMOw1iub/ZxN74v0lKjLYmNY
         LyPpyDFXmpdbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA109C43161;
        Fri, 17 Mar 2023 21:51:57 +0000 (UTC)
Subject: Re: [PULL v2] Networking for v6.3-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230317202922.2240017-1-kuba@kernel.org>
References: <20230317202922.2240017-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230317202922.2240017-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc3
X-PR-Tracked-Commit-Id: f5e305e63b035a1782a666a6535765f80bb2dca3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 478a351ce0d69cef2d2bf2a686a09b356b63a66c
Message-Id: <167908991775.6577.13827891704675755860.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Mar 2023 21:51:57 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 17 Mar 2023 13:29:22 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/478a351ce0d69cef2d2bf2a686a09b356b63a66c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
