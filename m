Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F8936895B
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239895AbhDVXbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236851AbhDVXbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 19:31:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 904CC61417;
        Thu, 22 Apr 2021 23:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619134236;
        bh=Oag/qHmdRa6QX9ANpkVAVsvFpxx7M8p3mEORxwqYcC4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VV+Jhmqvm45TuZAsdwGuDIzsSSlimGhG35iIwWxas9DDJgMlNrKxQl/RxpXB04gRb
         IFK/HYgkASjCo8H09q+xrOOE3VqPTrJCx9Y9cx9jWfK07WYiVsk5/XZHzXKuTacJAE
         j8uJ30/GvloxHsMmAgcs6Z59ZgwfslXGa/aokvYbSoisJI6qbWhBYLDW97imbzJwhh
         VcqIQnJKoqYM5rQKPAIKEcHlCAwf/PTR9dYVVJ6Bu1vlA0YPetH/mRxFQGSJlwy2S7
         zq3VOqvraueSaSsw1gWNW5MbiXRFwAhyZg7VgMd0H7vyBf+A5ybSBfB3l5IQn5I8h9
         r7dr70NtMez+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 84FB160A37;
        Thu, 22 Apr 2021 23:30:36 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: last minute fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210422182016-mutt-send-email-mst@kernel.org>
References: <20210422182016-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210422182016-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: be286f84e33da1a7f83142b64dbd86f600e73363
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 18a3c5f7abfdf97f88536d35338ebbee119c355c
Message-Id: <161913423647.3750.12332768319066444186.pr-tracker-bot@kernel.org>
Date:   Thu, 22 Apr 2021 23:30:36 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, elic@nvidia.com, jasowang@redhat.com,
        lkp@intel.com, mst@redhat.com, stable@vger.kernel.org,
        xieyongji@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 22 Apr 2021 18:20:16 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/18a3c5f7abfdf97f88536d35338ebbee119c355c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
