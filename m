Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E137443E749
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 19:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhJ1R14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 13:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229645AbhJ1R1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 13:27:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 50C3E60C40;
        Thu, 28 Oct 2021 17:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635441928;
        bh=zUb4Gzz37GpbFqY7ZqohiEI/HBvNyHCiwsAMcYZ9fSI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=NAK2Z83brbtImMs6OspSndZ1LKJiBdX32HAzP/KMhDEsVOgYpYbiPMRmoUES4FGUv
         3CTID0hv8Ijl9T5GczXyk29OEfTc6ZpKvoo8BLfC6GOnVvXv6GwSF9qFnmCZm2NJ4o
         TsGgU4JqXFVF4iWoNMMJ+mDGHaA5mXItOl8y84XeuP0+9BWtdPMxF5PUPr4fNh8ABB
         1Mven7gnZxf15JTSWCArMIpa98Sdih0VTAbUDnALXd0CTqO03lnbx/rUjlrRBrbMsK
         FyT3GU4q39W9F1hHJKkJ6puo0LYtVpCxZtNJBJ1QqOmciNNy+Xl0+lZWsHzU22BPjm
         NkLgjmErcD/3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 40658609D2;
        Thu, 28 Oct 2021 17:25:28 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: last minute fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211027160829-mutt-send-email-mst@kernel.org>
References: <20211027160829-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211027160829-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 890d33561337ffeba0d8ba42517e71288cfee2b6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9c5456773d79b64cc6cebb06f668e29249636ba9
Message-Id: <163544192820.14282.4874283985914408651.pr-tracker-bot@kernel.org>
Date:   Thu, 28 Oct 2021 17:25:28 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, mst@redhat.com, vincent.whitchurch@axis.com,
        xieyongji@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 27 Oct 2021 16:08:29 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9c5456773d79b64cc6cebb06f668e29249636ba9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
