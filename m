Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464B335A779
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhDIT7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234361AbhDIT7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 42BDE611AF;
        Fri,  9 Apr 2021 19:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617998365;
        bh=pJ7c657VoLqpI/8XU9Khru6I80F9QWhd7I0r2ySUqlk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cJWeYJoKPIy4RKvyJx9JgZ8w1qYfKvC1Q958gU8xF3kj/fUn0wFcO0s/Fipan2Q4b
         4yRubMzJezjPgcFKtGwpc1FALJ2fA40H4B3DDNPxzOpH8ypp1uxXbqsawkJIpaQiHc
         uNUnz/paxQFMm83uIluqDIcgUfQgQ7LAzsL40QHoisOKluUcosYwBKNLLmj5OFAWQY
         thrISi3HSXEVkwACnhUtqIg7lvvWXyuL0fLSXXpuCgLoVfWHg2y9IvpW5HmNO+Euet
         x8pB2pUUqQ9Y1lbIoscnu+Pe7WbqMN9Dk0D+VUUljvVZzYtDoMmViDmKPs1enmS4cS
         M3Ciirdi9InfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D25D60A71;
        Fri,  9 Apr 2021 19:59:25 +0000 (UTC)
Subject: Re: [GIT PULL] vdpa/mlx5: last minute fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210409124816-mutt-send-email-mst@kernel.org>
References: <20210409124816-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210409124816-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: bc04d93ea30a0a8eb2a2648b848cef35d1f6f798
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 189fefc7a4f0401d0f799de96b772319a6541fc1
Message-Id: <161799836524.7895.6127535602829010878.pr-tracker-bot@kernel.org>
Date:   Fri, 09 Apr 2021 19:59:25 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, mst@redhat.com,
        si-wei.liu@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 9 Apr 2021 12:48:16 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/189fefc7a4f0401d0f799de96b772319a6541fc1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
