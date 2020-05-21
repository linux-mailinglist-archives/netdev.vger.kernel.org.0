Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9321DD8F7
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730526AbgEUUzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729626AbgEUUzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 16:55:04 -0400
Subject: Re: [GIT PULL] vhost/vdpa: minor fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590094503;
        bh=+/719HmcyCCId615mpvh5nFpL+AjayClp/EMvyvl+hY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=adFr5lHvsH3c/p6knnuwnihJODjKWPY4IxfYpgEwjSzL+/T7Juid2L93wtgVUvZQn
         OqwFRwhzpSa9YhuPpHK2e8d73gKjwz6z8MHtrSQABaIHd5mJAP43tiopR/uxpLN/Lk
         iGu3a7aXCSiGfYveFFLNMzWKxC3zlYibxRuRs4Qw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200521140835-mutt-send-email-mst@kernel.org>
References: <20200521140835-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200521140835-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 1b0be99f1a426d9f17ced95c4118c6641a2ff13d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d2f8825ab78e4c18686f3e1a756a30255bb00bf3
Message-Id: <159009450386.9071.3699018741484442265.pr-tracker-bot@kernel.org>
Date:   Thu, 21 May 2020 20:55:03 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, lkp@intel.com, mst@redhat.com,
        yuehaibing@huawei.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 21 May 2020 14:08:35 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d2f8825ab78e4c18686f3e1a756a30255bb00bf3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
