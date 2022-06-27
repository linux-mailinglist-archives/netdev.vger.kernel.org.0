Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF30955D21A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbiF0SDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 14:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240041AbiF0SDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 14:03:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF56BE03;
        Mon, 27 Jun 2022 11:03:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D5A7B81A21;
        Mon, 27 Jun 2022 18:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15880C341CA;
        Mon, 27 Jun 2022 18:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656353000;
        bh=8B9WkefZfZA95pa9NIMzvxZQv+FB3th3Osx2mBStgjs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=JRS+N/Nz3GnX/u7TUbD2YKMzIqIu+lKys5NY3gy/AKgRcFr9X1xPk5XpK5c2+p6+P
         8DnrLpZqc54w2zUWuFWuli/FnXQaAxofH4JWWP2KRu3/sgl+cH+NG5VKCwB/Mg8PmQ
         6SgAdkHhLsBuoG664cK9Y+biw1kMBUc4R1EIO40sASIWL/OtEzbuWBRCuCDYYitMPe
         c40+cE9+I4d0gqaR9Mer9xBpP7UJDbECwVNTOB8gKEdgmSnhrSsqUDqoE0WXzn4FDy
         0Sf1LYaGRkaPGMlBlDaoJ8KNSs4k4ONQGMo1lKVYY21hJF10+PpJt9bJcMBQ1OlIkU
         a2N/4j9acdt1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F35DCE49BBA;
        Mon, 27 Jun 2022 18:03:19 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vdpa: fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220627115024-mutt-send-email-mst@kernel.org>
References: <20220627115024-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20220627115024-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: c7cc29aaebf9eaa543b4c70801e0ecef1101b3c8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 941e3e7912696b9fbe3586083a7c2e102cee7a87
Message-Id: <165635299998.10755.3182599712207525309.pr-tracker-bot@kernel.org>
Date:   Mon, 27 Jun 2022 18:03:19 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        stephan.gerhold@kernkonzept.com, kvm@vger.kernel.org,
        mst@redhat.com, huangjie.albert@bytedance.com,
        netdev@vger.kernel.org, wangdeming@inspur.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, eperezma@redhat.com,
        liubo03@inspur.com, elic@nvidia.com, gautam.dawar@xilinx.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 27 Jun 2022 11:50:24 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/941e3e7912696b9fbe3586083a7c2e102cee7a87

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
