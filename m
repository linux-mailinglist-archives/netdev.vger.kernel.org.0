Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4CAEC930
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 20:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfKATkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 15:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfKATkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 15:40:05 -0400
Subject: Re: [PULL RESEND] virtio: fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572637204;
        bh=4s8kkFjDHSBB9ziGWMKgy53QMczI/E5GrCnwYN/RUyQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=hB34jki1umUDR2s6uEc4UODACvC5P/wxEjErnSCcnv+kG75P0sltDXREUoXP+Sefz
         D0sz838gEl1QZtVZfEHzUHN9xbMOq9w8IVOsMTW8AsrdUAj7ib3S2XY0m83M/vsOwb
         8qMcTc7pgBB/onqN4gy6H26RvZbpUXIpSI90CLLY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191028042900-1-mutt-send-email-mst@kernel.org>
References: <20191028042900-1-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191028042900-1-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: b3683dee840274e9997d958b9d82e5de95950f0b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9e5eefba3d098d66defa1ce59a34a41a96f49771
Message-Id: <157263720474.9839.17625724873379326376.pr-tracker-bot@kernel.org>
Date:   Fri, 01 Nov 2019 19:40:04 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, yong.liu@intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 1 Nov 2019 15:33:57 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9e5eefba3d098d66defa1ce59a34a41a96f49771

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
