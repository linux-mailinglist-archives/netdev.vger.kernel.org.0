Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E73201080BC
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKWVKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:10:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfKWVKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Nov 2019 16:10:04 -0500
Subject: Re: [PULL] virtio: last minute bugfixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574543404;
        bh=tPLd1xVP7HkeCNRMMZFLexLDaHyo3UVyGY7DeCnDV/U=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=W5UIl7bsRlUUmcch1NKirmYya0Vld2PXT2Lv4WMByRSawXZ61a1uTroR+fknfZWPR
         HQxQW6vWxZi5iX2LXyp+rxaAG+JHXuJMhM4NraNACEwGiHliHCjc1PlxhO2OF8FTSq
         /g6ki+pJy19kgKir9X2RfVXulxvN6dErpdjags80=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191123115552-mutt-send-email-mst@kernel.org>
References: <20191123115552-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191123115552-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: c9a6820fc0da2603be3054ee7590eb9f350508a7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6b8a794678763130b7e7d049985008641dc494e8
Message-Id: <157454340405.11312.14684199337068886948.pr-tracker-bot@kernel.org>
Date:   Sat, 23 Nov 2019 21:10:04 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, khazhy@google.com, lvivier@redhat.com,
        mimu@linux.ibm.com, pasic@linux.ibm.com, wei.w.wang@intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 23 Nov 2019 11:55:52 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6b8a794678763130b7e7d049985008641dc494e8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
