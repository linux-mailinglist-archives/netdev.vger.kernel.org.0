Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834181B3090
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgDUTkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgDUTkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 15:40:21 -0400
Subject: Re: [GIT PULL v2] vhost: cleanups and fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587498020;
        bh=EdT/q7UFfZCJ31DJSxP12Wv8fYBVt6LXEKfaUOq3cKk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ksZauvLKnCWKE88mDN9PHb1ELnMSZjfAyUeR5AXARuo99zjbilN/ya1702AYdcM1l
         WFr/a4K6IQ49UcRqh/Y+GLb/yRqOITIctLlddEepYymYB8mQCCjoeW4qspaTJIsd8e
         6Q0kIG/VXukPYsyypOicpW6i97bM40fb+8l3dREU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200420160001-mutt-send-email-mst@kernel.org>
References: <20200420160001-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200420160001-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: d085eb8ce727e581abf8145244eaa3339021be2f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 189522da8b3a796d56d802e067d591d2ffff7f40
Message-Id: <158749802063.25518.14503910452719540577.pr-tracker-bot@kernel.org>
Date:   Tue, 21 Apr 2020 19:40:20 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexander.h.duyck@linux.intel.com, arnd@arndb.de,
        bjorn.andersson@linaro.org, eli@mellanox.com, eperezma@redhat.com,
        gustavo@embeddedor.com, hulkci@huawei.com, jasowang@redhat.com,
        mst@redhat.com, sfr@canb.auug.org.au, yanaijie@huawei.com,
        yuehaibing@huawei.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 20 Apr 2020 16:00:01 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/189522da8b3a796d56d802e067d591d2ffff7f40

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
