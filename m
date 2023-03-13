Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695276B807B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjCMS1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjCMS13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:27:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE2584F6D;
        Mon, 13 Mar 2023 11:26:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 740EB6147B;
        Mon, 13 Mar 2023 18:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43BD0C4339C;
        Mon, 13 Mar 2023 18:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678731958;
        bh=Ohid4WW4bE1iYiU0aGgJoySObkAyf67Ea/B4BQVbjnM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=NVCzcmIkQtJwFPXGDf1dscUZxLiG0m86+OdrIZCilckaLjnWwg0De2/7zTcA69CUL
         HlmRNYuv0qPfguryWWvJgZzyFsQvaEp17XK9wqPDUVp3tiClPn7Yga30ODV9AD5uTA
         fDyVOiqTXpLA5lfUgc4cTaJ7NFmZVfNaPqm7O7fvDmgKftNyH/rv2uJbzh6aHnLmJJ
         7j2YdMuYNS7TSMrbjcK/xyhBs0rOX18mMUurPIVzeD1TvEhWGgcX10CVI/opg76Arv
         bor27gZV4jYEhOZf6uDHZcsbkclDRwRyG6wrGhx9o7NN06GVGBCthfjRYkCbITY9Ns
         fYjkxJgDyNRCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D253C43161;
        Mon, 13 Mar 2023 18:25:58 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost,vdpa: bugfixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230313023139-mutt-send-email-mst@kernel.org>
References: <20230313023139-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20230313023139-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: ae43c20da2a77c508715a9c77845b4e87e6a1e25
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fc89d7fb499b0162e081f434d45e8d1b47e82ece
Message-Id: <167873195817.6604.15099339670931730243.pr-tracker-bot@kernel.org>
Date:   Mon, 13 Mar 2023 18:25:58 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, lulu@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org, eperezma@redhat.com,
        leiyang@redhat.com, rongtao@cestc.cn, gautam.dawar@amd.com,
        elic@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 13 Mar 2023 02:31:39 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fc89d7fb499b0162e081f434d45e8d1b47e82ece

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
