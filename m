Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235D929774E
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755079AbgJWSxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbgJWSxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 14:53:10 -0400
Subject: Re: [GIT PULL] vhost,vdpa,virtio: cleanups, fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603479190;
        bh=Fut4z9JGmD3maTcbN0fyqQYAM6FFJ60UFXb6vsO1lrQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=1rYV7y8L4fqyq9/Y6Bnv1MRUN5CH9C1NVdDlnXKwc+pHbTGwO+qs9nuzXdqbcqgQ2
         iK879U4YmweY6ZAB3WKs5YSBOBm357iHtVfUFwj6qAaBElopHUrBpO3aA07Cyr9mpu
         +ORWDuaAJduX+3FjpxGUBUrHT/szHvvNtSoosSfs=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201023113832-mutt-send-email-mst@kernel.org>
References: <20201023113832-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20201023113832-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 88a0d60c6445f315fbcfff3db792021bb3a67b28
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9313f8026328d0309d093f6774be4b8f5340c0e5
Message-Id: <160347919010.2166.1997610625454370758.pr-tracker-bot@kernel.org>
Date:   Fri, 23 Oct 2020 18:53:10 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        pankaj.gupta.linux@gmail.com, pmorel@linux.ibm.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, mst@redhat.com,
        linux-kernel@vger.kernel.org, rikard.falkeborn@gmail.com,
        virtualization@lists.linux-foundation.org, li.wang@windriver.com,
        borntraeger@de.ibm.com, stable@vger.kernel.org,
        tiantao6@hisilicon.com, elic@nvidia.com, lingshan.zhu@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 23 Oct 2020 11:38:32 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9313f8026328d0309d093f6774be4b8f5340c0e5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
