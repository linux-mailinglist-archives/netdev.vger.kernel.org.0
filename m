Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68B627D4AF
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgI2RoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728897AbgI2RoI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 13:44:08 -0400
Subject: Re: [GIT PULL] virtio: last minute fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601401448;
        bh=03GvkImuXPeydQHobuE6Tvmyjh05QhbS/bF0LvHvOSc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=G1KlPn+A/P/OU48SFCU8AEqmnPajLsFfhy1vgH9tcYTF/orapMWS7+W5rGhKLlyDo
         i6RB1ZK04Ruxyb43bA+Kncn8jtrlM0mDAptVpEMbru1opGXBVUugo8pgX/c3khMD+H
         117IDBtyd2RGXfYmI0Ne3L1H8GCJbKFEskM76cfQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200929035034-mutt-send-email-mst@kernel.org>
References: <20200929035034-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20200929035034-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: a127c5bbb6a8eee851cbdec254424c480b8edd75
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1ccfa66d94cf65d3e89eeb95676a03e8f90edd99
Message-Id: <160140144806.29614.17781182961923244998.pr-tracker-bot@kernel.org>
Date:   Tue, 29 Sep 2020 17:44:08 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, eli@mellanox.com,
        elic@nvidia.com, lingshan.zhu@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 29 Sep 2020 03:50:34 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1ccfa66d94cf65d3e89eeb95676a03e8f90edd99

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
