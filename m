Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAA52FDA50
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbhATUAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:00:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbhATT7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 14:59:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C23023442;
        Wed, 20 Jan 2021 19:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611172707;
        bh=sJrsipKcyjTNhTXOo+6NjwclKY+/xMhpMfKAeYEW9pA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=aO/wSWjKXxhHrAk7d4E5PqxWSTvkX68FpeDxOIyPoElTylvpH+iM56cCeLT8Ty8wo
         0Z+0Zx6P9NvyWqKmKjH82NPsT6NdLfMWeIOeGkBrId6QUWBn5cYMYapxaLIbX+n6zc
         E/cbLMwUCDmF2+zbTbhq9JNG4kYjH6YKpAAGEyltS/eKMAs5/gpdAm7xW+if6gN+cE
         KA2TEVCd2RfQmbvbXKjxAORCQ+DU87jptdevYvfMIck3UbilK8AN1TpNfpBrtjYzA+
         VDpTh63zktsr64zBfHmZOZ/sTiRvrE7hpCgkN/fQdJztoQnuX97fAksk1lfpcD/hnO
         z5FjJVwJp3Tgg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id EECE460591;
        Wed, 20 Jan 2021 19:58:26 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.11-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210120180913.514293-1-kuba@kernel.org>
References: <20210120180913.514293-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210120180913.514293-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc5
X-PR-Tracked-Commit-Id: 535d31593f5951f2cd344df7cb618ca48f67393f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 75439bc439e0f02903b48efce84876ca92da97bd
Message-Id: <161117270697.2860.6081133087029247295.pr-tracker-bot@kernel.org>
Date:   Wed, 20 Jan 2021 19:58:26 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 20 Jan 2021 10:09:13 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/75439bc439e0f02903b48efce84876ca92da97bd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
