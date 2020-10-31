Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15B62A1ADC
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 22:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgJaVpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 17:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgJaVpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 17:45:53 -0400
Subject: Re: [GIT PULL] vhost,vdpa: fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604180753;
        bh=K1pHC+h1KmbMEQrr0pjOapUULKG871SA5i/eGG5pEnA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=e3a3E3ALw7FxGXqXJf9uLhhvh28wO9qKWyyXoHJY1JhuEcINp0Ozlls0gutouAxxj
         EQinLecNxQRfQta/7NdOdEoj2m4CjjveGfNKUbvBEnunf0jEHqnjcjezpswCJJBDx0
         x892mviiUhRBq7mwbx/jZBrizaycQPVj/q98Rt6g=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201031155940-mutt-send-email-mst@kernel.org>
References: <20201031155940-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201031155940-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 0c86d774883fa17e7c81b0c8838b88d06c2c911e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c2dc4c073fb71b50904493657a7622b481b346e3
Message-Id: <160418075297.5586.994529741826670733.pr-tracker-bot@kernel.org>
Date:   Sat, 31 Oct 2020 21:45:52 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, elic@nvidia.com, jasowang@redhat.com,
        jingxiangfeng@huawei.com, lingshan.zhu@intel.com, lkp@intel.com,
        lvivier@redhat.com, mst@redhat.com, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 31 Oct 2020 15:59:40 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c2dc4c073fb71b50904493657a7622b481b346e3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
