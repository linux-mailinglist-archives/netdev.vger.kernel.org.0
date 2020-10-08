Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70745287E16
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbgJHVhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725952AbgJHVhp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 17:37:45 -0400
Subject: Re: [GIT PULL] vhost,vdpa: last minute fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602193065;
        bh=XS1HskSXLJf+LYLFsE6ajUTo2eQzDoEdbBf1YNqM7u0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=dKd3zSsHJYrGMRpDprCyOmqOGWFqmVGEky+iBm1QOIEw0lEtQGcSURQxkhbaX7gCd
         SWcv1qdUriNz1P7DtyBBBJ8mz5FeDVQOVb2Y/eaJRjhjLMzEpNoz+P4slsU3FbaPwu
         dPxQ/Ey04e7ACH0NKFFWLNCC8f9R6C64aXaaradg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201008163051-mutt-send-email-mst@kernel.org>
References: <20201008163051-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20201008163051-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: aff90770e54cdb40228f2ab339339e95d0aa0c9a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3fdd47c3b40ac48e6e6e5904cf24d12e6e073a96
Message-Id: <160219306497.23094.13564756320158233179.pr-tracker-bot@kernel.org>
Date:   Thu, 08 Oct 2020 21:37:44 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, lkp@intel.com,
        kvm@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        si-wei.liu@oracle.com, elic@nvidia.com,
        virtualization@lists.linux-foundation.org,
        michael.christie@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 8 Oct 2020 16:30:51 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3fdd47c3b40ac48e6e6e5904cf24d12e6e073a96

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
