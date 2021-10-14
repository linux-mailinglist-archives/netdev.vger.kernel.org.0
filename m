Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCFA42E446
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 00:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhJNWkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 18:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230236AbhJNWkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 18:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BA8DF61019;
        Thu, 14 Oct 2021 22:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634251083;
        bh=8UHhF1fG4hrrzMg70W2ismSEYiTBxEoWlBvxb8fw0Ko=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tZXni1uaaKClQm/joa3MkW6DIcGHqUnLsHzyBPwJA4xmP5vXIHI/VRfbmciBS5vm0
         +wFgAhDsS5+4Z5lklKFQCubqqmMNBPn/ZI6eov/KQ9GMx2a4ort3F0d0JCb8gW/EQ+
         7efjwKT6BZN8t892ZkpcBPhLAuxjWQe8x7jOFsITc7ORBh0A2jGeG+W+U7taqMMl/f
         6NWVwQ3aMo0QoeR7h50pJtRjBl6CbnBVaiauCRDcuTteqEopWBO5afKxsxpf4HPREt
         gnU0NpBeJMu1Hgx0TZrOQjxVYGezCObfaj60Fc1VfAmPuiwEX0lsG1DcIS1v76tfTs
         jA38L0bivC04w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A6FD5609E9;
        Thu, 14 Oct 2021 22:38:03 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.15-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211014152355.2109412-1-kuba@kernel.org>
References: <20211014152355.2109412-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211014152355.2109412-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc6
X-PR-Tracked-Commit-Id: 1fcd794518b7644169595c66b1bfe726d1f498ab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ec681c53f8d2d0ee362ff67f5b98dd8263c15002
Message-Id: <163425108362.28241.5063561176804678245.pr-tracker-bot@kernel.org>
Date:   Thu, 14 Oct 2021 22:38:03 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 14 Oct 2021 08:23:55 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ec681c53f8d2d0ee362ff67f5b98dd8263c15002

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
