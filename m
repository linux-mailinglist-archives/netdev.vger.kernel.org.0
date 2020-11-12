Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD902B1117
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgKLWLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:11:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbgKLWLA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 17:11:00 -0500
Subject: Re: [GIT PULL] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605219059;
        bh=tDnelSokgyFv6vqNdHc/8hCG8D/aBVH6YfW9yGYzY7o=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=T9kiFEe0PXeeUcl6+mdzvdKA8jKbisWYp1KFZmNXz0bsR8mpy75WFn3a5le9tjkEX
         /zro9Q/dgJHucGZ7JiRpXk4JXlw7uLDEVpvejLRPlDmJEyasQFnJl1odOGg8P+TyBl
         5JLGsLzyJ1mBL508IIIwbIoif2xIZPKlw3DHuO6k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201112190245.2041381-1-kuba@kernel.org>
References: <20201112190245.2041381-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201112190245.2041381-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc4
X-PR-Tracked-Commit-Id: edbc21113bde13ca3d06eec24b621b1f628583dd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: db7c953555388571a96ed8783ff6c5745ba18ab9
Message-Id: <160521905965.29533.6738615353491198428.pr-tracker-bot@kernel.org>
Date:   Thu, 12 Nov 2020 22:10:59 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 12 Nov 2020 11:02:45 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/db7c953555388571a96ed8783ff6c5745ba18ab9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
