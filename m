Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101375B1D01
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiIHMbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiIHMar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:30:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B902F6BA0;
        Thu,  8 Sep 2022 05:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2701261CD8;
        Thu,  8 Sep 2022 12:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81637C433C1;
        Thu,  8 Sep 2022 12:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662640245;
        bh=qIDrASnAtXBXsAI/i5d4nk0Lak7e4pzMrmfG6Dj+rSU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Z9XbFMiz81yyTtBaSY8FQKQF513UNG2+TCdJptI5jMh0TtXCsI7B9Q/lsha7nWINc
         FJO9V0303AWUJGTddgDBE4RrBmDyTucCBPynBfIu670nzfiKH+rxaviSW6DER02NXS
         89Mx/YLZiLq2xysEjQ7dUFnDPUsAyfztgjrIulGxr+4tD44aJaSr6PoEcNX8hnnaxf
         pHd5kT08KLyT2Cl03SJsFqBiEk2HbS/4IZ/kVgs8hAjOIITh4zsXnZCM4RtG4SrHu3
         8V2ETBVfBjyk7iiap9XLUyQLNL+dC9U43Wc4nwf24x5WqcVxMjlXwV4d+JtBDwFBIh
         xgEkZG6uJb6yA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E205E1CABD;
        Thu,  8 Sep 2022 12:30:45 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.0-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220908110610.28284-1-pabeni@redhat.com>
References: <20220908110610.28284-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220908110610.28284-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc5
X-PR-Tracked-Commit-Id: 2f09707d0c972120bf794cfe0f0c67e2c2ddb252
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 26b1224903b3fb66e8aa564868d0d57648c32b15
Message-Id: <166264024544.22641.5187521338314565439.pr-tracker-bot@kernel.org>
Date:   Thu, 08 Sep 2022 12:30:45 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  8 Sep 2022 13:06:10 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/26b1224903b3fb66e8aa564868d0d57648c32b15

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
