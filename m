Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A122E28F0
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 23:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgLXWAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 17:00:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbgLXWAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Dec 2020 17:00:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4553022AED;
        Thu, 24 Dec 2020 21:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608847171;
        bh=57XCp+HRxi/jkyLBws5d5+r5kabghPGmjpfApkrGQy4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=HL2LOgzE347X2+IxZT0fYzkcnArzEWkvA28TmsIO6NpiEvq4Hut7iTyidOWtsIp4M
         5UjKMNqTBDp/wClTvZ07DRevAdY3q6L2Usdpkq5C/yPb+MFOzXaS1ZhVbr1ERimxnr
         UMb1JKMdpFTfO8LJFEflRm3phUQRNjlOHvtke0x2yfD6Ll9sYrSdnNhtqsuvN6LFyk
         VJcLEufJSdpREQEyVPSfp/ioLtPKT8hyiRVSRAoeWpKIfb9vp3ocejOxKo4SLNyAM4
         VWkN7dB/KHNZYf6OfySA0H6WJM9YmaF4+Av0atjfa+DbnMV2x1tBGymwWbuHh0FUxZ
         evHHQrFforjWw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 369C7604E9;
        Thu, 24 Dec 2020 21:59:31 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vdpa: features, cleanups, fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201223072448-mutt-send-email-mst@kernel.org>
References: <20201223072448-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201223072448-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 418eddef050d5f6393c303a94e3173847ab85466
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 64145482d3339d71f58857591d021588040543f4
Message-Id: <160884717121.31605.12367248989541455981.pr-tracker-bot@kernel.org>
Date:   Thu, 24 Dec 2020 21:59:31 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, christophe.jaillet@wanadoo.fr,
        dan.carpenter@oracle.com, david@redhat.com, elic@nvidia.com,
        file@sect.tu-berlin.de, hulkci@huawei.com, info@metux.net,
        jasowang@redhat.com, mgurtovoy@nvidia.com, mhocko@kernel.org,
        mst@redhat.com, osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        parav@nvidia.com, peng.fan@nxp.com,
        richard.weiyang@linux.alibaba.com, robert.buhren@sect.tu-berlin.de,
        sgarzare@redhat.com, tiantao6@hisilicon.com,
        zhangchangzhong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 23 Dec 2020 07:24:48 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/64145482d3339d71f58857591d021588040543f4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
