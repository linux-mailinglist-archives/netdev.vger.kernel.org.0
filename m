Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6F0109850
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 05:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfKZEZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 23:25:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727430AbfKZEZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 23:25:13 -0500
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574742313;
        bh=sRhAKmjhRtThVrUK8jTLDaOtav0++el3x2YSI1NFU9E=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=tRa0je8KqMcDBHSfoRUMUf92jjC/rGskTnLTv9AV2L4JQdzRgdcB5P+PF4FQZqpVN
         iEupGC1hCvxTeyqiaAK/xN5Ar/kIXAa1D6Yx0QsriaHoSvceqhS8D2IRxjkF6LxCw1
         UAViQUNbr0QQNHFR3YiVbRKhK5uCYEIoa0zor05k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191125.160113.1695634327047749358.davem@davemloft.net>
References: <20191125.160113.1695634327047749358.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191125.160113.1695634327047749358.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 refs/heads/master
X-PR-Tracked-Commit-Id: 622dc5ad8052f4f0c6b7a12787696a5caa3c6a58
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 386403a115f95997c2715691226e11a7b5cffcfd
Message-Id: <157474231313.2264.6064984677202893016.pr-tracker-bot@kernel.org>
Date:   Tue, 26 Nov 2019 04:25:13 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 25 Nov 2019 16:01:13 -0800 (PST):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/386403a115f95997c2715691226e11a7b5cffcfd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
