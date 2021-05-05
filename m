Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DCC3749A6
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 22:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhEEUuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 16:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhEEUuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 16:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B2405613BA;
        Wed,  5 May 2021 20:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620247755;
        bh=fIBnzCoLd7WFpaxwVmmrRv7I6zOzGgD4l9SQolYykqw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=SGV+dXVMsmxu7ZS5APC452PYA81R0UlZ9lE8ZEgbaJ4JzcKvWsTEaH3GEWKyOO23v
         94NvIGUiXFq0Z2rV7lPpFGnwXkOkCIqZK7fsfOOgnixrW81XOR1LC5agd2nM6DEHFp
         MSY7iCrQ+iszzeH7lsCUhbVUfW0QLEGHrN1hI99l+FnTY8Px2ytmrVLQ+lf8OO/xXl
         E3azMDLxbPkbF4onk5bfVoyR2VDdbgfc++jQBH2PCw/Lj2J78iCvM6pwmZ+g6g78XL
         yfoignsYM3122879hHRGG0lsZX8Xt5o+injOhz8nLSM58maLJqfDjl7V1k6FH+3tzI
         7hRJgze6IrDFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9CF59609E8;
        Wed,  5 May 2021 20:49:15 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210505161135-mutt-send-email-mst@kernel.org>
References: <20210505161135-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210505161135-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: d7bce85aa7b92b5de8f69b3bcedfe51d7b1aabe1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 16bb86b5569cb7489367101f6ed69b25682b47db
Message-Id: <162024775557.12235.13272630963086835800.pr-tracker-bot@kernel.org>
Date:   Wed, 05 May 2021 20:49:15 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        liu.xiang@zlingsmart.com, lkp@intel.com, mgurtovoy@nvidia.com,
        mst@redhat.com, parav@nvidia.com, sgarzare@redhat.com,
        stable@vger.kernel.org, xieyongji@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 5 May 2021 16:11:35 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/16bb86b5569cb7489367101f6ed69b25682b47db

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
