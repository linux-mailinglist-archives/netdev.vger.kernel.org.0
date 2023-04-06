Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76C96DA037
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 20:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240383AbjDFSqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 14:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240364AbjDFSqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 14:46:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914837A9D;
        Thu,  6 Apr 2023 11:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CA4C64A84;
        Thu,  6 Apr 2023 18:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 925F9C433EF;
        Thu,  6 Apr 2023 18:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680806771;
        bh=EP2gyAHnJbuCRkBdG2iDNDm/Mc7wI0GTsRV9POV0yU8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=QsB7LcViqtPCIITawnBt7dpJGFrBEsfsCQGFOleyD2qzNiQTxBycOdFGEuF876sG0
         1x5pYxghMQGt+YEC2oa+GEwPhWdf59jpGm5LHD3tTyLLh+o37O/l/QyNnZiI+gIK+k
         LeZ0c6WmpkCJwEi2mxCd26iqJqrk5RwxDeI2xdYkRBPTFhcpLNCxen0DTPO3p5i749
         cBMn/KnIb5gHwIiKwipUIXUVLTmYYMV/KsKeefFNy8G/dp2Y1eDqaA3JdP48yRBpmu
         9IDhOfN38z7Lq/11C3Q8aSUissfjUCfDgDVrnzkouwAROsaco3nP+opqwCj5ByFRX5
         t47Rluk6+LHxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B724E4F14C;
        Thu,  6 Apr 2023 18:46:11 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.3-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230406115058.896104-1-pabeni@redhat.com>
References: <20230406115058.896104-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230406115058.896104-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc6
X-PR-Tracked-Commit-Id: 24e3fce00c0b557491ff596c0682a29dee6fe848
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8fbc10b995a506e173f1080dfa2764f232a65e02
Message-Id: <168080677149.24406.25483152844060552.pr-tracker-bot@kernel.org>
Date:   Thu, 06 Apr 2023 18:46:11 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  6 Apr 2023 13:50:58 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8fbc10b995a506e173f1080dfa2764f232a65e02

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
