Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1014675CF6
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 19:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjATSq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 13:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjATSq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 13:46:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279615421A;
        Fri, 20 Jan 2023 10:46:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9DAFB82952;
        Fri, 20 Jan 2023 18:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E61CC4339B;
        Fri, 20 Jan 2023 18:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674240415;
        bh=/2Z76LYFMgpKZbKnU3RK3NmFhoVE7DAmzKLt3L5AOns=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=HQg88MrjRb3hsQ2X+ps0GldJf6HOTJTKTRnPu7TQB6WHYFzvQ6Q4osQVPh0idD0AG
         JVSIx0DUFTgWVy3NnUWhB2zzxtvJBwYZ/i55434zjg4UwVHQk4HImxJodG/5BJdjXM
         ueO75QxSIx9JqZpkt1qF8Ui39JGZWzedS+wqNpD6zgEog3MhML2bSdMIzDb9ZcAojc
         pRqI0VM5pWBXc/Iy1BYDsOISKLLYn5DB0SNkwxeYzwAE7otnJRS/sEYl+4HnITQWWa
         4nz8oB8MsFg7WYK/WVrmFm+MK+heskiuEuea4DYYeoCEX0a7y/k0QVBcfGnX3o2HJX
         GP5NVDUOch1TQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E733E54D2B;
        Fri, 20 Jan 2023 18:46:55 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.2-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230119185300.517048-1-kuba@kernel.org>
References: <20230119185300.517048-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230119185300.517048-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc5
X-PR-Tracked-Commit-Id: 6c977c5c2e4c5d8ad1b604724cc344e38f96fe9b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 07ea567d84cdf0add274d66db7c02b55b818d517
Message-Id: <167424041544.21297.3731198681374042481.pr-tracker-bot@kernel.org>
Date:   Fri, 20 Jan 2023 18:46:55 +0000
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

The pull request you sent on Thu, 19 Jan 2023 10:53:00 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/07ea567d84cdf0add274d66db7c02b55b818d517

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
