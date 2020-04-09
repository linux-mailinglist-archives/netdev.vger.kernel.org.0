Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5571A2E2C
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 06:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDIEFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 00:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725271AbgDIEFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 00:05:25 -0400
Subject: Re: [GIT PULL] vhost: fixes, vdpa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586405125;
        bh=xXKU+vo8zx0ukwRuksAohJp2Z+Nfi2jcadpfaRnvV2E=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ZfdVDZPewcVPexmajh1trV4EH2g0schk8vx7bplfikfvnKqKFQR9TCf34g5Ra71Jt
         4mAHrAOG+EUwZ8EPfvFJQin9KOqt/o+v+lqo5SrbGPCgx7CWUHuswMklFVVsaSvH9S
         cjJ0R3h7yZQevwRuDkCFhxcyq6ZpQaTqMwDCt+vg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200406171124-mutt-send-email-mst@kernel.org>
References: <20200406171124-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200406171124-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: c9b9f5f8c0f3cdb893cb86c168cdaa3aa5ed7278
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 835a6a649d0dd1b1f46759eb60fff2f63ed253a7
Message-Id: <158640512513.12302.5687148234965008608.pr-tracker-bot@kernel.org>
Date:   Thu, 09 Apr 2020 04:05:25 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexander.h.duyck@linux.intel.com, david@redhat.com,
        eperezma@redhat.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        mhocko@kernel.org, mst@redhat.com, namit@vmware.com,
        rdunlap@infradead.org, rientjes@google.com, tiwei.bie@intel.com,
        tysand@google.com, wei.w.wang@intel.com, xiao.w.wang@intel.com,
        yuri.benditovich@daynix.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 6 Apr 2020 17:11:24 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/835a6a649d0dd1b1f46759eb60fff2f63ed253a7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
