Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45367460997
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 21:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357762AbhK1UIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 15:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240202AbhK1UGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 15:06:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E8EC061748;
        Sun, 28 Nov 2021 12:03:25 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E453B80D5F;
        Sun, 28 Nov 2021 20:03:23 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B6C160041;
        Sun, 28 Nov 2021 20:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638129801;
        bh=fYzzj/FusNSnStGNweaI1Lw8LCCnN3s3U2QDq7fynns=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=hnHAXLGBgmVZhy/VoZyzTYKSEtw0/KzamE2erN0j33Uuv8MypNvJrP7NOojYeW9er
         9+qgvQ9dIWyDEssNjBom/Vr14xOlJ9cqElPhxDqJ7elngZgOZnpMXd691lIcgR3E/6
         f/GnNYeoc9i99mRodn52mx6dsCrxOjsSWVXzo6OWMx3nEQ1pgcMx8Cz8zipm3j+zrn
         ppXae04LUIO8/xL8647OU+Yn58lXux+mmitmW1sYg3b7vc7Fhs1JaNCV16roq86ipx
         gOHV6UJ/gopotAUpJ81r0fp/LSNdFsx0TA+pUnDoteqUbNc9xlxwBn1rYbAe7tc2Yj
         eBkj2UrkwZDuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7A64E609DB;
        Sun, 28 Nov 2021 20:03:21 +0000 (UTC)
Subject: Re: [GIT PULL] vhost,virtio,vdpa: bugfixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211128125803-mutt-send-email-mst@kernel.org>
References: <20211128125803-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211128125803-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: bb93ce4b150dde79f58e34103cbd1fe829796649
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d06c942efea40e1701ade200477a7449008d9f24
Message-Id: <163812980144.10783.3903876021175664187.pr-tracker-bot@kernel.org>
Date:   Sun, 28 Nov 2021 20:03:21 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, longpeng2@huawei.com, mst@redhat.com,
        pasic@linux.ibm.com, sgarzare@redhat.com, stable@vger.kernel.org,
        wuzongyong@linux.alibaba.com, ye.guojin@zte.com.cn,
        zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 28 Nov 2021 12:58:03 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d06c942efea40e1701ade200477a7449008d9f24

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
