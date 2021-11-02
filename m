Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91364430BD
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhKBOtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 10:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230336AbhKBOtB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 10:49:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3FB62610E5;
        Tue,  2 Nov 2021 14:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635864386;
        bh=BTmNc4j+6WSH2JmjhXNPtnxpJxeOBqN3231jn4TnPpY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=oiMCY4X+12b69r0gQxAU2grncH2rXfFl3Oc6jX/nBTCNNvupkzKY0/wfVYNZqQX9e
         zgEzf8lZA5l5edz+DO5MbvYsK2qUpg8ktgj+5bejKLPS2n2igdPm5H8HFMcKU7WdZu
         gKFKxsOawWJr1E4egvIHQ+iyo+IrAGldk53PhFUlBGC3k/vXE9MaCj6glAIqtBDCS/
         uEtK32zqyLBKadrHNCKytoNgajQudyQEiUfRgZjzRyvP6l2oxRh6gxUmG4Gc4TZMTB
         nxLiIyBnWPgIv5NWLcbPTU/W4fLop1y2PjltZ1Hckx5b/RIUEvtQpsnbjRNhcdb/tx
         ht3/K03h/KE0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2AEDD609F7;
        Tue,  2 Nov 2021 14:46:26 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.16
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211102054237.3307077-1-kuba@kernel.org>
References: <20211102054237.3307077-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211102054237.3307077-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-for-5.16
X-PR-Tracked-Commit-Id: 84882cf72cd774cf16fd338bdbf00f69ac9f9194
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fc02cb2b37fe2cbf1d3334b9f0f0eab9431766c4
Message-Id: <163586438611.5257.10464350684036071454.pr-tracker-bot@kernel.org>
Date:   Tue, 02 Nov 2021 14:46:26 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        kvalo@codeaurora.org, miriam.rachel.korenblit@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon,  1 Nov 2021 22:42:36 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-for-5.16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fc02cb2b37fe2cbf1d3334b9f0f0eab9431766c4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
