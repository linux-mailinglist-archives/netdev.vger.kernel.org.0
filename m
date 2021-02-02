Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999D330CA84
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbhBBSve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:51:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238913AbhBBStU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 13:49:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 692B064E51;
        Tue,  2 Feb 2021 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612291718;
        bh=aUnEQIfvzMXhPUXnNM+qC1XZqHg2A60B6eut7OZ6ZUo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=KUc7WTnyvX53dgaZrc8HswAxJTg7sg8XVhbQPCqPsOyzi2ZgZYZdAZUBw1mFnvrOB
         r0kM19+g5UgydvFhR9OiGRSwSRedEgYDHcxCJccSxYr67xH8hmWpWVSg4v459ycBGq
         njZCL4QDcry/ORshbPLnF6hXpbFLkoy48GL6613KSepcHrO3kHOwaDLN9oa+XqfpUQ
         D/51PUJLYqRLGJSaY4hLoEQdgNHaN25z5wFuD1+BtsDyjBt9BDHOngDeIUup5Xhz9T
         +Mc1YjxprginXjTb3OBHColL+kaGekhDulnSHnMG9RINa2ysdg0Q+yVAZsJAWFowpw
         M/VpL4D4yrjHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5537060987;
        Tue,  2 Feb 2021 18:48:38 +0000 (UTC)
Subject: Re: [GIT PULL] vdpa: bugfix
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210201182510-mutt-send-email-mst@kernel.org>
References: <20210201182510-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20210201182510-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 710eb8e32d04714452759f2b66884bfa7e97d495
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2e02677e961fd4b96d8cf106b5979e6a3cdb7362
Message-Id: <161229171829.14515.1965140964811542808.pr-tracker-bot@kernel.org>
Date:   Tue, 02 Feb 2021 18:48:38 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, elic@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 1 Feb 2021 18:25:10 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2e02677e961fd4b96d8cf106b5979e6a3cdb7362

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
