Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77DEC196A92
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 04:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgC2CFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 22:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgC2CFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 22:05:07 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585447507;
        bh=sGGF1qpIVGtH7JOkMnEUSTR6IqlLrRGRMdtQfBPtb54=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=VbLJUWnV1BwXYvzjv3YrdZsKok/fxISXnPcL4oxnraf51w+sD/QzrXNePLz7wKmSS
         ZbsW3/Ro/bQZ6G/i77MzSvTidS9pqPVPywNoZ4VHGVXO1n4H1zREqMm0xaQgcVIi4I
         M0I5jFCB3Yt+Lt+Kolc1S75adNfE0mnNdYcZPJ70=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200328.183923.1567579026552407300.davem@davemloft.net>
References: <20200328.183923.1567579026552407300.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200328.183923.1567579026552407300.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: a0ba26f37ea04e025a793ef5e5ac809221728ecb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e595dd94515ed6bc5ba38fce0f9598db8c0ee9a9
Message-Id: <158544750697.14300.9472742816968297242.pr-tracker-bot@kernel.org>
Date:   Sun, 29 Mar 2020 02:05:06 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 28 Mar 2020 18:39:23 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e595dd94515ed6bc5ba38fce0f9598db8c0ee9a9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
