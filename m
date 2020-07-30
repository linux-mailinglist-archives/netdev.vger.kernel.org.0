Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6466B233C0A
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbgG3XUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730291AbgG3XUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 19:20:04 -0400
Subject: Re: [GIT PULL] virtio, qemu_fw: bugfixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596151204;
        bh=6+2lX73nW5UcKr93op0BObKpUW/HGBjFgSErTy2Tqf8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=XuQjCo6GkzM2EmF2FevkPLAT+vLyZNIU7urr1x0iEIBREBKuwkfHRo1TjWlr2Ta7e
         8J1pclEEe/Cv18yjUltiI2q4Wxn8agFitrxLbs/1fOHYxBVvkdK8z2y2v0UriM1eyv
         FI9pyPX0jjyJeFwTShcmDCHrAA09uBX7sx9iJ4kM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200730152958-mutt-send-email-mst@kernel.org>
References: <20200730152958-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200730152958-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: a96b0d061d476093cf86ca1c2de06fc57163588d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 417385c47ef7ee0d4f48f63f70cca6c1ed6355f4
Message-Id: <159615120411.31670.16532591701270206400.pr-tracker-bot@kernel.org>
Date:   Thu, 30 Jul 2020 23:20:04 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexander.h.duyck@linux.intel.com, chenweilong@huawei.com,
        david@redhat.com, jasowang@redhat.com, mst@redhat.com,
        rdunlap@infradead.org, stable@vger.kernel.org, wu000273@umn.edu
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 30 Jul 2020 15:29:58 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/417385c47ef7ee0d4f48f63f70cca6c1ed6355f4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
