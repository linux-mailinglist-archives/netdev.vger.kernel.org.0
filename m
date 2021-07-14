Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B2E3C88D7
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 18:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbhGNQpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 12:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhGNQpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 12:45:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C2D6F6100C;
        Wed, 14 Jul 2021 16:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626280978;
        bh=T8mqkKygrYZvIpwHDod+nT5H+CCrERZ3658bVnE845E=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=e/RBwqi5vdRS1Zju1sWSJBPi0j7IQ75ThD/bUq3REUxvkb+9aMZgeeAFwTQNzoOjz
         +zH51BkkguGULoZLI7XwgJEu+9rL8HNUVUKvd/WqwF3IQeUSJHfFlX8KfyEYmO843c
         h8uJz5akMMvkXZVjlMYP/CzY0b+Kx/AcQft/7it7eE8RL2C2jQCro2cIa1vOc09jFi
         wETC29dg5eOvMng7Al7CKA50IwIeQLEG266BAWH7iCwGpO8jI+Joozca9fCG2ZI8zY
         HGuTGOQRqbcN2EfJdfdxvwZkiUfj9JYjxp0SwZz0g/UT1/SegM9s0ObEY+eJi1lO73
         dwzI5qesbtjUA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF9E0609CD;
        Wed, 14 Jul 2021 16:42:58 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.14-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210714130001.3799721-1-kuba@kernel.org>
References: <20210714130001.3799721-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210714130001.3799721-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc2
X-PR-Tracked-Commit-Id: bcb9928a155444dbd212473e60241ca0a7f641e1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8096acd7442e613fad0354fc8dfdb2003cceea0b
Message-Id: <162628097865.10383.5183370000051728204.pr-tracker-bot@kernel.org>
Date:   Wed, 14 Jul 2021 16:42:58 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 14 Jul 2021 06:00:01 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8096acd7442e613fad0354fc8dfdb2003cceea0b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
