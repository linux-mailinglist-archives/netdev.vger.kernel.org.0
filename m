Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08819D8399
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389875AbfJOWZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732265AbfJOWZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 18:25:08 -0400
Subject: Re: [PULL] vhost: cleanups and fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571178307;
        bh=kvmC4E7L+oeDDz2E8MyZ7vy8vlZuBNRvi0r5zkZQzEw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=bnEMMCiIkY+cceDhVmWI3SwGLOVkTzLzCA/iEbt/KJrqDlApuq1MhEKMRMmJl0rAl
         osldAywju56GIGmKTtqF+C+aeNULWZ94iC2j7vYgpDe4VJhvo7DujiguCdSUN2Kl1R
         7OYLubeq6rVlb+Xn702ULY86zKyVld5Q9SzjvvvU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191015171908-mutt-send-email-mst@kernel.org>
References: <20191015171908-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191015171908-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 245cdd9fbd396483d501db83047116e2530f245f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3b1f00aceb7a67bf079a5a64aa5c6baf78a8f442
Message-Id: <157117830785.470.239830549616573165.pr-tracker-bot@kernel.org>
Date:   Tue, 15 Oct 2019 22:25:07 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@web.de, mst@redhat.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 15 Oct 2019 17:19:08 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3b1f00aceb7a67bf079a5a64aa5c6baf78a8f442

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
