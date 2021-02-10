Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF4731712F
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhBJUU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:20:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233353AbhBJUUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 15:20:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F1D4D64EDF;
        Wed, 10 Feb 2021 20:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612988363;
        bh=GvmDyAd4JObio+94SF0DADk7u+lFPBSCoeBKnB7LDD8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=sePBIE2u/s4DXeDA1KhYnewG+sQgk19FgeRL6Zvk2r5nzUksTYQPRba/IxGxPNZwK
         t6AA12/ghzZCD8ProeW9s8419n6plx8KPZr5GFE4KGWrQTEU5k7KF/fqfZ1OdcTVUx
         ggvIUfnn3bQKyHzsuW1+Zfj7JEvtDVkKJCDCPMHGNHq7Ho9BM6x5S58Kun0HaX5ZJX
         EZTOYO8z3+Ta9ghpotjE8yLo/tF871NTyU5QHmZXChdZ9nDmZ/icYPgePCYkgYkmB4
         TrFUsLZeOos8BV0C46018fgPgovteeIgpG6DF5er4ml4EY9FA1QceGXDC+7Lc8ajaf
         Ex63oVp7dhnhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ED121609E9;
        Wed, 10 Feb 2021 20:19:22 +0000 (UTC)
Subject: Re: [GIT] Networking 
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210209.193611.1524785817913120444.davem@davemloft.net>
References: <20210209.193611.1524785817913120444.davem@davemloft.net>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210209.193611.1524785817913120444.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master
X-PR-Tracked-Commit-Id: b8776f14a47046796fe078c4a2e691f58e00ae06
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6016bf19b3854b6e70ba9278a7ca0fce75278d3a
Message-Id: <161298836296.25163.4791202972773784695.pr-tracker-bot@kernel.org>
Date:   Wed, 10 Feb 2021 20:19:22 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 09 Feb 2021 19:36:11 -0800 (PST):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6016bf19b3854b6e70ba9278a7ca0fce75278d3a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
