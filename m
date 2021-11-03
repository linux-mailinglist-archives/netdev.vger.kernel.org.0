Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6555B444A9B
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 23:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhKCWHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 18:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhKCWHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 18:07:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5EE4A610FD;
        Wed,  3 Nov 2021 22:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635977077;
        bh=U252dDDHz3ceWBRZWZCdLxN7k8HFZDRcyZtnZO5anv8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=W21gCAY9OeiCvKViVJqMyTBirgsurySJQ2Ebv2gv6xI5OWu53iFNdKpI8CBATUunw
         Z1U3H2xa4LrUmW2o/QT9T9Mq+HON+RUZ5Y5XGZU3njNF3dDcJ/yvTvjhASi+7Y9yxZ
         pRcSaURC36qpqlG9MOHsZtDutSan7SDJZvrmksA8MSvBYYvCWzevDKiSoe0uOqIiDF
         DHT12h/W16CbBkuARKTYwNKYVX5azEjK4WWxrcnTr3UDKpRa8LvllHpfB/I8bHljL+
         zXe/VS+zwU08lLieNvMWEdCF+5N5/F4VuAS4wpXJqWUTlYv7Kej/LB+lozAC/mce4v
         i+a1SO5+2+YkQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4ACA160723;
        Wed,  3 Nov 2021 22:04:37 +0000 (UTC)
Subject: Re: [GIT PULL] vhost,virtio,vhost: fixes,features
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211103164332-mutt-send-email-mst@kernel.org>
References: <20211103164332-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211103164332-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 540061ac79f0302ae91e44e6cd216cbaa3af1757
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 43e1b12927276cde8052122a24ff796649f09d60
Message-Id: <163597707724.8098.177160565800108525.pr-tracker-bot@kernel.org>
Date:   Wed, 03 Nov 2021 22:04:37 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit@kernel.org, arnd@arndb.de, boqun.feng@gmail.com,
        colin.i.king@gmail.com, colin.i.king@googlemail.com,
        corentin.noel@collabora.com, elic@nvidia.com,
        gustavoars@kernel.org, jasowang@redhat.com, jie.deng@intel.com,
        lkp@intel.com, lvivier@redhat.com, mgurtovoy@nvidia.com,
        mst@redhat.com, pankaj.gupta@ionos.com,
        pankaj.gupta.linux@gmail.com, parav@nvidia.com, paulmck@kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, sgarzare@redhat.com,
        stefanha@redhat.com, tglx@linutronix.de, viresh.kumar@linaro.org,
        wuzongyong@linux.alibaba.com, xuanzhuo@linux.alibaba.com,
        ye.guojin@zte.com.cn, zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 3 Nov 2021 16:43:32 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/43e1b12927276cde8052122a24ff796649f09d60

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
