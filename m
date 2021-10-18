Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C3243101D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 08:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhJRGEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 02:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhJRGEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 02:04:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 11FAB60F25;
        Mon, 18 Oct 2021 06:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634536947;
        bh=jHc1ArAsX9ODB5TiB6eugodCntdFiZx9IqtuY32ULKo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=GDcEJoEBz9v3chMkrtpy7KO6QCYQu/NNF2Lu0s0OG4o+1po6ituIq8i2SWfiEVsBG
         m0BVQurg8oivKsp8wfC3L3q/K2u+xdRlUxD9M7ek2bgimekWa4DgDuIIQMY+WV24Sb
         PiRvF9Je/EMBjrONLgqiLQSr2pPxYlkQsBf3vXE1fn6jmBIkdzCvYhP8usaU19apD2
         z1RtkFEZh+jtrJLxqr/MGn8FKj3FUZ2JiGWnEkUfetneeS6QpneSYi2Vi2jd/G8Fr/
         a1JPK9V1PUxtj4mGeRLepWqBPzT0dEBEP6VqsoIXWXcKON5HJp3QZ2rteezL/1peHO
         RaPQcG3CJdSBw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EBBFC600E6;
        Mon, 18 Oct 2021 06:02:26 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vdpa: fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211017104900-mutt-send-email-mst@kernel.org>
References: <20211017104900-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211017104900-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: bcef9356fc2e1302daf373c83c826aa27954d128
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3bb50f8530c9cb5ec69c0744b7fd32d0ca404254
Message-Id: <163453694690.9773.12279094571248426582.pr-tracker-bot@kernel.org>
Date:   Mon, 18 Oct 2021 06:02:26 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        corbet@lwn.net, jasowang@redhat.com, linux-doc@vger.kernel.org,
        lulu@redhat.com, markver@us.ibm.com, mst@redhat.com,
        pasic@linux.ibm.com, rdunlap@infradead.org, stable@vger.kernel.org,
        wuzongyong@linux.alibaba.com, xieyongji@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 17 Oct 2021 10:49:00 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3bb50f8530c9cb5ec69c0744b7fd32d0ca404254

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
