Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E80407B1A
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 02:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhILAnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 20:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhILAnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 20:43:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AD88460F6F;
        Sun, 12 Sep 2021 00:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631407330;
        bh=VFXZCk3XZhvij+Ap8YQQTHyW1mEu+S5NTlxJu6sdc8Y=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=KHkcCH/YDRCmsKDUTEo0I7IeyKqyTtB6/meY0aHZgjgC+2epBw1Yua0TBo6im67q1
         kmNKmtqHLF00Sy1d3d1JMBOHX6dr88Gm7pPRBAAGcZgXtcVp73wPsPyN0DOjkcEEOS
         wD4veNhvvic6+QcdIo9AxalJUaXtADEyCTdn6nuJWqPS1D9gChrOyn5spU7ok5THml
         sQWOvLrgz0OtBhkc9ypuTmbnNDtXZP836kcQ1vXWE3TJOszOB4pjxHxlyz23IVQoNW
         7FUXE7oUh420YuQ5qHRGyuEsAfAd+65FexoYCQUwRL+DWqff3aGI2GOzaUGp2Amhu3
         5nSSmuJ2lKsfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A0EDE60A0D;
        Sun, 12 Sep 2021 00:42:10 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vdpa,vhost: features, fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210909095608-mutt-send-email-mst@kernel.org>
References: <20210909095608-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210909095608-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 7bc7f61897b66bef78bb5952e3d1e9f3aaf9ccca
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 78e709522d2c012cb0daad2e668506637bffb7c2
Message-Id: <163140733059.30830.12622166761669415888.pr-tracker-bot@kernel.org>
Date:   Sun, 12 Sep 2021 00:42:10 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arseny.krasnov@kaspersky.com, caihuoqing@baidu.com,
        elic@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        mgurtovoy@nvidia.com, mst@redhat.com, viresh.kumar@linaro.org,
        will@kernel.org, wsa@kernel.org, xianting.tian@linux.alibaba.com,
        xieyongji@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 9 Sep 2021 09:56:08 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/78e709522d2c012cb0daad2e668506637bffb7c2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
