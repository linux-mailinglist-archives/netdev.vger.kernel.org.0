Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18E756A9ED
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 19:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbiGGRoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 13:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235916AbiGGRof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 13:44:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A43733A2D;
        Thu,  7 Jul 2022 10:44:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 264026208C;
        Thu,  7 Jul 2022 17:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C700C341C0;
        Thu,  7 Jul 2022 17:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657215872;
        bh=u/Oo9mU02At5aXEG5ZhIK/gTXF74aTZaUU2dpQUHiqk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=WwHswfKHv1+2cChh9NQ6U5VdwtbfGAQ7LIFX9fRLYRpJvUx0WHOF4xk8QwpIPRnZK
         twW92ZYmkBdkjQJuH43fKV+TtH13UIj6UJsq2ZreKm3BetVAnQpWoHxUA5E7xbaXA3
         fRCo26eyGPPCvJVAdH7rY/00XRAW+qINBFP9mu8183KW7gSrTbwBqe3EuUVHOhoxhz
         U1tPgc+qYzuIFk4xDB8kWFPf3yDYIKDlP22ao9gxss32kWCWhXG0rS7aR/QYrXRifX
         cFarXyNIvDS9CMweYBhe3ntjax0MOvNdVvMhuTBi3XDQtGsYDJpkvqL2+ErTBY9RpV
         gFVoqRQYr5BZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69D36E45BD9;
        Thu,  7 Jul 2022 17:44:32 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.19-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220707102125.212793-1-pabeni@redhat.com>
References: <20220707102125.212793-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220707102125.212793-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc6
X-PR-Tracked-Commit-Id: 07266d066301b97ad56a693f81b29b7ced429b27
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ef4ab3ba4e4f99b1f3af3a7b74815f59394d822e
Message-Id: <165721587242.16533.4083152459161858756.pr-tracker-bot@kernel.org>
Date:   Thu, 07 Jul 2022 17:44:32 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  7 Jul 2022 12:21:25 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ef4ab3ba4e4f99b1f3af3a7b74815f59394d822e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
