Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1957B6C0F2
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 20:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388876AbfGQSaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 14:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727229AbfGQSaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 14:30:04 -0400
Subject: Re: [PULL] virtio, vhost: fixes, features, performance
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563388203;
        bh=SsgEQ229BFDzVjWE4Rfd94cxbm2rr6++cJP0jupJNlI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=1OMBw+NNcoYT1euAQa76cEb1EnJLTbURZO01B9VLtWDbz6o2ygQuSEU/k5bwly/JN
         I9WKTyRViJihLBuveQwr15VdePBK/oENdwCbcZIOCueP649B9L4SUwnKWdXebZmJ3r
         0AOCFDDnCBkwuFhQ3rgUh397M2+y0SfUzso6xWjs=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190716113151-mutt-send-email-mst@kernel.org>
References: <20190716113151-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-parisc.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190716113151-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 5e663f0410fa2f355042209154029842ba1abd43
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3a1d5384b7decbff6519daa9c65a35665e227323
Message-Id: <156338820366.716.10416228849149522179.pr-tracker-bot@kernel.org>
Date:   Wed, 17 Jul 2019 18:30:03 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, bharat.bhushan@nxp.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-parisc@vger.kernel.org, davem@davemloft.net,
        eric.auger@redhat.com, gustavo@embeddedor.com, hch@infradead.org,
        ihor.matushchak@foobox.net, James.Bottomley@hansenpartnership.com,
        jasowang@redhat.com, jean-philippe.brucker@arm.com,
        jglisse@redhat.com, mst@redhat.com, natechancellor@gmail.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 16 Jul 2019 11:31:51 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3a1d5384b7decbff6519daa9c65a35665e227323

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
