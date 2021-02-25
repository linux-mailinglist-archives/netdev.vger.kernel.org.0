Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0723257B1
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 21:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhBYUbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 15:31:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234087AbhBYUab (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 15:30:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 56FF964F32;
        Thu, 25 Feb 2021 20:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614284990;
        bh=fmzexBSIfWb47JkIPrZNPmcrb7SH3FBEATmvFBYUfD0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=oqcux6qN0uI6LifZYaDpDyY+9BABnFbWj1andck/5elvftav0Kj99uVq2h7CUO+XE
         2VjXZrPkpo8h7+fxHDUlec+DQ2iZzhvivH66DSJeE/c2mkFFdS96Y+hzOlithb4fz2
         YFScToiuY6SoaSPSTcYdLvwttH5sK7XnuxhAHckVIyvW2xgA0tjCvch9XMFxDv2UL4
         f9lmwLr5U8Q/MLov0iaOzWfyvaQpyc9sYxa4GCN3q3d9CQheiAGaVv3ZCrwr6PktSG
         /DghOU+/gxQ6rkyq+b9M1n6KWCTmOkYb5WfN6sWhUu6lma3U5e5j39icHy9pMJumlF
         r8vBrjtWAEdag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43F59609F5;
        Thu, 25 Feb 2021 20:29:50 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: features, fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210225143333-mutt-send-email-mst@kernel.org>
References: <20210225143333-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210225143333-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 16c10bede8b3d8594279752bf53153491f3f944f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ffc1759676bed0bff046427dd7d00cb68660190d
Message-Id: <161428499022.20173.13248373429390310648.pr-tracker-bot@kernel.org>
Date:   Thu, 25 Feb 2021 20:29:50 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        anders.roxell@linaro.org, arnd@arndb.de,
        aruna.ramakrishna@oracle.com, colin.xu@intel.com, david@redhat.com,
        dongli.zhang@oracle.com, edumazet@google.com, elic@nvidia.com,
        gustavoars@kernel.org, jasowang@redhat.com, joe.jin@oracle.com,
        joseph.qi@linux.alibaba.com, linux@roeck-us.net,
        mathias.crombez@faurecia.com, mst@redhat.com,
        naresh.kamboju@linaro.org, parav@nvidia.com, sgarzare@redhat.com,
        stable@vger.kernel.org, syzkaller@googlegroups.com,
        tiantao6@hisilicon.com, vasyl.vavrychuk@opensynergy.com,
        xianting_tian@126.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 25 Feb 2021 14:33:33 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ffc1759676bed0bff046427dd7d00cb68660190d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
