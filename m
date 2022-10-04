Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CC05F4B0B
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 23:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiJDVmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 17:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiJDVll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 17:41:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACEE6D9CA;
        Tue,  4 Oct 2022 14:40:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E63961561;
        Tue,  4 Oct 2022 21:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D393AC433D6;
        Tue,  4 Oct 2022 21:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664919602;
        bh=dPcl3Y/S3l/Fgu4SXaCywlnUadNJrTHPRuf/XuZxz3E=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=dqPrWqxigOjkd2oPHRT5HDzbZq787CAfdgaOkib3OYVC49SV0G93ggedaJ6+RHlDJ
         3Ymx/cKE94gSTkEtllnr6J9yCec6dsnWX4tI1KtWirRHHb0dlPzm3SwW2uLzJJrgWz
         SDBJj+vPmCwr7v9AHpvU22aQtfRkcgxgEbWELtS4BLO5k6NNi1qkFx0+AU3WcOYztp
         /qqiB2Zl6clNn3Ww2QExLzycWxttixwZ1qsH0/5AdF+oKjDa4rAp4ecFU9gLOSadGR
         P3lLLvbxhLMnSvc4pc2n8zN4PWoAYtq8xkqb5xyVuK5i0qjLGwq679oGOjFvAcbkOD
         +eVLsEIo6Bniw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B5370E21EC2;
        Tue,  4 Oct 2022 21:40:02 +0000 (UTC)
Subject: Re: [PULL] Networking for next-6.1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221004052000.2645894-1-kuba@kernel.org>
References: <20221004052000.2645894-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221004052000.2645894-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.1
X-PR-Tracked-Commit-Id: 681bf011b9b5989c6e9db6beb64494918aab9a43
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0326074ff4652329f2a1a9c8685104576bd8d131
Message-Id: <166491960269.29212.4005399594620111358.pr-tracker-bot@kernel.org>
Date:   Tue, 04 Oct 2022 21:40:02 +0000
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

The pull request you sent on Mon,  3 Oct 2022 22:20:00 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0326074ff4652329f2a1a9c8685104576bd8d131

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
