Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006DF699D9B
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 21:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjBPUX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 15:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjBPUXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 15:23:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AB552CDC;
        Thu, 16 Feb 2023 12:23:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B342060A27;
        Thu, 16 Feb 2023 20:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EDB7C433EF;
        Thu, 16 Feb 2023 20:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579031;
        bh=V8AoGpPLZzYFpoRU0CBsX04iGH3Wh0f1EjIB8Ppa/F8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=PGJdrlE/JIVsXPskLeKLve+ib1kWQW7hqzfC9BMgXGLlo2cYA1nZ0FISg/d6RbjWN
         yhRUYAFTlYBkYoAWnmOSSp/OL0IYYky+kiTZ189/pe5QS5AeEuhTGVIJM79HQiLGJw
         RcfCSvVeNv0jH7b2MLGr2rhZmUj8l6CcTo73TySFcJt1nJ7JUVQf0PTGIGx7uveSBT
         EUtMKdonABqQtbd61r9Q42WhbDhkDrmNHCgPayK1GakEgzFYUe58MXFhXtN/3ZZz7g
         UcKV/2Y3HQhssEWfq8kKWDVP1hcbfpMfy6i340nku3mb06+e/qLJrTeILQHvrGxBy1
         PhjG6WzkyKTPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 087F4E21ED0;
        Thu, 16 Feb 2023 20:23:51 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.2 final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230216185912.804993-1-kuba@kernel.org>
References: <20230216185912.804993-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230216185912.804993-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-final
X-PR-Tracked-Commit-Id: b20b8aec6ffc07bb547966b356780cd344f20f5b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3ac88fa4605ec98e545fb3ad0154f575fda2de5f
Message-Id: <167657903102.10840.9453959109131440463.pr-tracker-bot@kernel.org>
Date:   Thu, 16 Feb 2023 20:23:51 +0000
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

The pull request you sent on Thu, 16 Feb 2023 10:59:12 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-final

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3ac88fa4605ec98e545fb3ad0154f575fda2de5f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
