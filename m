Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045E236F09B
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 22:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhD2TbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhD2TbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 15:31:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4068B6142A;
        Thu, 29 Apr 2021 19:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619724625;
        bh=A1mukU4trUFDCSyu43vEpDdjoH9acfRJG6n3Wz/gxj0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=XthmSD40W48wbhJtgBR/Se5g2qR5uS7W+Zl12A3Z/KFLQDQQdkcyZRD75XnE43kQk
         zvgHNWCIhzXv/5Wv+BdtPsI2PnRAops/4RAsnhRrbzJ5pLEsb6pUosBDDXjhJJIEN7
         ffACyCpE+YUm74T81zulj9m30GCs8xQ3frfcG4Ph0I/giM96NCzNr2JCtl/hg2JPfL
         tEu3cl5XcnLDyWthYvEAiC9YvyWZmgOalyd0AuOEiaP9fcmB8PyOtDQlXCz0FGhzX9
         e6uENZkysjYhUJYymFKv/K8yTIgeHbQUBBcRq0rNRkfswKEuXb2DX7/d31+6t9fv+A
         TCkoRmEaUUiLA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3471260A1B;
        Thu, 29 Apr 2021 19:30:25 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.13
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210429023712.2011727-1-kuba@kernel.org>
References: <20210429023712.2011727-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210429023712.2011727-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.13
X-PR-Tracked-Commit-Id: 4a52dd8fefb45626dace70a63c0738dbd83b7edb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9d31d2338950293ec19d9b095fbaa9030899dcb4
Message-Id: <161972462514.25798.5039273411134868006.pr-tracker-bot@kernel.org>
Date:   Thu, 29 Apr 2021 19:30:25 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 28 Apr 2021 19:37:12 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9d31d2338950293ec19d9b095fbaa9030899dcb4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
