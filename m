Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649B52A9EE8
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgKFVN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:47210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgKFVNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 16:13:24 -0500
Subject: Re: [GIT PULL] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604697204;
        bh=UD/NfYcT6ottlg205iMJeYmUuh6zeQxwleLJukyVc+w=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Lm1P2KZ0PjEE0RcL5ef9hbwWJFpC36H9YkNFYJun9gPTlbfM9MZvGzjeDqqsWeECu
         /sISH49+uaQY2TAHlFUXgF9wkjiKbNEdDWJYpQnEIeqMZbDryWPI6f4FQKvdnSW3Dt
         Yohkd3h/x0UgLAHlLEI3b7lcLk4taylg2ALzzn3k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201105192508.1699334-1-kuba@kernel.org>
References: <20201105192508.1699334-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201105192508.1699334-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc3
X-PR-Tracked-Commit-Id: 2bcbf42add911ef63a6d90e92001dc2bcb053e68
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 41f16530241405819ae5644b6544965ab124bbda
Message-Id: <160469720429.14190.1784014330540767380.pr-tracker-bot@kernel.org>
Date:   Fri, 06 Nov 2020 21:13:24 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  5 Nov 2020 11:25:08 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/41f16530241405819ae5644b6544965ab124bbda

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
