Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE462E005F
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgLUSre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:47:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726757AbgLUSrd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 13:47:33 -0500
Subject: Re: [GIT PULL] 9p update for 5.11-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608576413;
        bh=GZp12ScXFCCTVwNhVTlEl9e0JeMtP67k7DWE6IGoEak=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Qn8mRZeLPj0mrKPbw2BX+N/6FILbEFj/mrbv0i+jWLtcu2kxQ1feSsXiGjufVsnWw
         gR9J17+eTUenLiotZatdPKyIVXuRuge01I84qkdSBunzOf25lcuPJBiCyV8/j7Uwk3
         e79ilddNQvUY0ah7KUt2zAvnxpmkxuSpnIvYYZ2odgMo0RRQKktLwxMfN3Mj/PsB2y
         vbG217ovQZqO4jWXcUXJgV2XKpKohVfk8kvdYSQTo55g72uIfXuBuKUg+owgh2LOt4
         UodJhpirwXpOMCL3UWxVQILd9KNLvvOOyYuIEs3Vw2rqLasJbfdvwcdXYhrwR8oMrf
         b8T6jJ8M0EasA==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201221094828.GA6602@nautica>
References: <20201221094828.GA6602@nautica>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201221094828.GA6602@nautica>
X-PR-Tracked-Remote: https://github.com/martinetd/linux tags/9p-for-5.11-rc1
X-PR-Tracked-Commit-Id: cfd1d0f524a87b7d6d14b41a14fa4cbe522cf8cc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 70990afa34fbac03ade78e2ad0ccd418acecfc04
Message-Id: <160857641312.14812.13290415369966565613.pr-tracker-bot@kernel.org>
Date:   Mon, 21 Dec 2020 18:46:53 +0000
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 21 Dec 2020 10:48:28 +0100:

> https://github.com/martinetd/linux tags/9p-for-5.11-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/70990afa34fbac03ade78e2ad0ccd418acecfc04

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
