Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00930425917
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243207AbhJGRRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243031AbhJGRRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 13:17:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0656961139;
        Thu,  7 Oct 2021 17:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633626919;
        bh=y//8214AVK9KLhfo9dKtPdUieyAPUG44nxKBZcjYeOY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mmQ2wFNNSsg7MKy6m3cdOWFCG/Pmjt8zGGhW598Yhcb8zrlRqjGvlcyPMDzxMIe/X
         wW2PMpmQwM9ohchpaJQOvJqBcUgcsTNi/xbygB7XH+jajlsKBP7+DJ+aYBgoLUrD8S
         losH61SO2YTgIvL/A7L/vAXqt26jGUKcuvGmpf7hXTWQeIUNCcz4bBpgSWga9gtAR7
         u54upW+lETdAWSLhDx2FMlztwrrJHmpiYe0f76vk3atQ9HtMdMFcKdGpiYBx9/14Lf
         KzjCiT/fnfWlVw/GO72TDMEX1Br4h4w9iN+3ozWF4wbsn7YVSzWrVgdhILJ0bv2du9
         cp2QroGiBquVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F360B60A23;
        Thu,  7 Oct 2021 17:15:18 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.15-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211007154520.3189432-1-kuba@kernel.org>
References: <20211007154520.3189432-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211007154520.3189432-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc5
X-PR-Tracked-Commit-Id: 8d6c414cd2fb74aa6812e9bfec6178f8246c4f3a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4a16df549d2326344bf4d669c5f70d3da447e207
Message-Id: <163362691899.23492.14703576253670668434.pr-tracker-bot@kernel.org>
Date:   Thu, 07 Oct 2021 17:15:18 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel@iogearbox.net,
        steffen.klassert@secunet.com, kvalo@codeaurora.org,
        pablo@netfilter.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  7 Oct 2021 08:45:20 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4a16df549d2326344bf4d669c5f70d3da447e207

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
