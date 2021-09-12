Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A551407B1B
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 02:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbhILAn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 20:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234543AbhILAnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 20:43:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4119A6113E;
        Sun, 12 Sep 2021 00:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631407331;
        bh=vO0yrHPLOkBrN8r9NE9CEpKY1uqNKyqDslzxg6dly5I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=llqY7opjf1DkVtb4Knt9eX2p3++OGRtteKL7MlYSRb2FbcYnoTxbnqmvOf1rAoKgw
         R6g2SwbDnXwWGX1tnbM2yc97urzvNX8JtvGuOqUcX6bWTGd8CgwkI8LlfUPBEoPygV
         xIgcgFuPI95pWjTrpdHIGsj/Tz2m7XcXESPv/xMROOwUuNOmxGfXlWnwRL75dDNhLp
         Q0TUv+t5f8+hMucJx5DB02gdL7xR+aicVPihMj6FgnN9r+j+13ng5rjiAZF/JDKJ1K
         7U+1zxHOc2oZn9IIyBQScT9j1AUVsbo2wqNvUvij1WxIJmGxS55ZP8MDIpv1iACQuZ
         tXrPoLEC9LaIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3A54660A0D;
        Sun, 12 Sep 2021 00:42:11 +0000 (UTC)
Subject: Re: [GIT PULL V2] virtio,vdpa,vhost: features, fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210911200504-mutt-send-email-mst@kernel.org>
References: <20210911200504-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210911200504-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus_v2
X-PR-Tracked-Commit-Id: 6105d1fe6f4c24ce8c13e2e6568b16b76e04983d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a93a962669cdbe56bb0bcd88156f0f1598f31c88
Message-Id: <163140733123.30830.10283487707815357982.pr-tracker-bot@kernel.org>
Date:   Sun, 12 Sep 2021 00:42:11 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arseny.krasnov@kaspersky.com, caihuoqing@baidu.com,
        elic@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        mgurtovoy@nvidia.com, mst@redhat.com, viresh.kumar@linaro.org,
        wsa@kernel.org, xianting.tian@linux.alibaba.com,
        xieyongji@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 11 Sep 2021 20:05:04 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus_v2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a93a962669cdbe56bb0bcd88156f0f1598f31c88

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
