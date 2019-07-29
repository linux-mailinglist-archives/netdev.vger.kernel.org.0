Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6976179332
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387992AbfG2SkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbfG2SkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 14:40:19 -0400
Subject: Re: [PULL] vhost,virtio: cleanups and fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564425618;
        bh=pOrk3tU71dZX+Rcd0VhYhQmj36JdpwLj+USN8H0R2RQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=iS/iiZeCxsWwHuTw4DA+P/VSujfoGU7q3H2maGCYU4rW0DUUmdvtoIqgX+ezb2yjS
         t+d/qQh1X/esvCv/CpXu8K3On1g0lf5/nLj7/sviPpMhsC7VU6YdTdF6oKOOTrzCv2
         b8NkV0O/NqpG/r9gTGfYVTuCiBivyIzHPdMXkNms=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190729121605-mutt-send-email-mst@kernel.org>
References: <20190729121605-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190729121605-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 73f628ec9e6bcc45b77c53fe6d0c0ec55eaf82af
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2a11c76e5301dddefcb618dac04f74e6314df6bc
Message-Id: <156442561858.16864.7993993619692997992.pr-tracker-bot@kernel.org>
Date:   Mon, 29 Jul 2019 18:40:18 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.auger@redhat.com, jean-philippe@linaro.org, jroedel@suse.de,
        mst@redhat.com, namit@vmware.com, wei.w.wang@intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 29 Jul 2019 12:16:05 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2a11c76e5301dddefcb618dac04f74e6314df6bc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
