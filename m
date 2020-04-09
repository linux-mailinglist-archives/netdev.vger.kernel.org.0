Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29F91A2E2E
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 06:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgDIEF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 00:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725271AbgDIEF0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 00:05:26 -0400
Subject: Re: [GIT PULL v2] vhost: cleanups and fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586405126;
        bh=7GvQa0HrqqaUPyMzD6HMwdmeFP/jlkvX9MkIeMHYssY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=VuKswTp1GM5Z90B4daadYE1nSkeRAjec81BvpyKR9xmkj84xjyrwfmO/2ZEiboZyh
         iFOtwG1ZLsCdcvJcvI8NLymgQ7Sz1c7ebrLa9USfukfK0ABWl+oZ7ea0ceD8f0sqB2
         cTEdesLwCsgEvZNSDXk7At9MYig6SaqemfvEYgFo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200407055334-mutt-send-email-mst@kernel.org>
References: <20200407055334-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200407055334-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 835a6a649d0dd1b1f46759eb60fff2f63ed253a7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9bb715260ed4cef6948cb2e05cf670462367da71
Message-Id: <158640512623.12302.18379400588057389333.pr-tracker-bot@kernel.org>
Date:   Thu, 09 Apr 2020 04:05:26 +0000
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

The pull request you sent on Tue, 7 Apr 2020 05:53:34 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9bb715260ed4cef6948cb2e05cf670462367da71

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
