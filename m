Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515143EDB11
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 18:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhHPQlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 12:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhHPQlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 12:41:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BD79F60BD3;
        Mon, 16 Aug 2021 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629132034;
        bh=A1t/Z5jL6guB6cSSzNC8PKIYow9T3ryW5fNaPG350RM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=DELH67EHML32fwu3iniCKLvZcMJyOtGrAm24p0wtsGlP1Lit8knMIDfsst0vurXCh
         d5R48IPdFycnOwahpVois64EO7PI2DPCEzL+c5XSfIue1QBAhrDqbUOrsqDsmwRbHM
         clnSbtV4xVjvC/g58MCVfnOzm9OkAaTjJ15gMg+YjekVNXLHVBGbBOFPYQUldLFVNT
         K6pGDjKPw4jdBZUD1Rw9iJHz9ZIsgOBBHx7QXxmt/71Fe2VLCedPlbVT39/T5vKIdv
         MrKTg2bhhQGKU8+zq3carA6bb19Vu9YJ6r9HN7pGkaL+83R3lCqPVvFXJODLuEzMYN
         RuMnIrtcYmKPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B20B7609CF;
        Mon, 16 Aug 2021 16:40:34 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost,vdpa: bugfixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210816005054-mutt-send-email-mst@kernel.org>
References: <20210816005054-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210816005054-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 879753c816dbbdb2a9a395aa4448d29feee92d1a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 94e95d58997f5234aec02f0eba92ee215b787065
Message-Id: <162913203472.19716.9875992701958753677.pr-tracker-bot@kernel.org>
Date:   Mon, 16 Aug 2021 16:40:34 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, elic@nvidia.com, jasowang@redhat.com,
        mst@redhat.com, neeraju@codeaurora.org, parav@nvidia.com,
        vincent.whitchurch@axis.com, xieyongji@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 16 Aug 2021 00:50:54 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/94e95d58997f5234aec02f0eba92ee215b787065

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
