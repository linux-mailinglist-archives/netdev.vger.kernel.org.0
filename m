Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0CF2EB510
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbhAEVy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:54:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729248AbhAEVy0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 16:54:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0BB9F22D71;
        Tue,  5 Jan 2021 21:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609883626;
        bh=kNBRJ/aYElKhpZB7C2UbcKqb2wXkZAMaMM77Gk3XDSQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=HmNwYF6TQtua/muVF6OsQfV0fKaR4+E2K6/aHXQ26zu+OwlSOcTw88T9RIHV6bTun
         CtESrkScGVvZEEBtRetIM33xaztogp0I5dD7GWBgCUMNQrRpByqei06SF3YBaERCjT
         AjbCCabU+qnwgYhAjDKwoLRup6HsA7Jmkpn5dJEW7UCv15xVieJlPvHsLqRA7aSE9G
         YrqUY/HsGL3JnWhV+3unPlBreYkr1Fv6XmXN2tb7EB1v5+fsU7QmNgDzDEBnMu4b1u
         MEcvmW5hDlCJSGjnoABthpqMwBfPmuMggzsrYGh7HL5KYnh+WLFVOzEVO2+LEJZxVU
         5Hf0AB1skjFcQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id E51F06012A;
        Tue,  5 Jan 2021 21:53:45 +0000 (UTC)
Subject: Re: [GIT PULL] vhost: bugfix
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210105072145-mutt-send-email-mst@kernel.org>
References: <20210105072145-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210105072145-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: e13a6915a03ffc3ce332d28c141a335e25187fa3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9f1abbe97c08ba7ed609791627533a805a1b2c66
Message-Id: <160988362586.4244.11494741917772052343.pr-tracker-bot@kernel.org>
Date:   Tue, 05 Jan 2021 21:53:45 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, mst@redhat.com, sgarzare@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 5 Jan 2021 07:21:45 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9f1abbe97c08ba7ed609791627533a805a1b2c66

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
