Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F90C44B338
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 20:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243263AbhKITe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 14:34:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231390AbhKITe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 14:34:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 53B7A61360;
        Tue,  9 Nov 2021 19:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636486301;
        bh=dnXj0CKluQKLZKn9owkzkWpD13pbNKDaQ6RrQPX2muk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=l01Q5ggXuA6OHCib8jNzhVl8XvtrMO/pxp36PqhEAYPam3NCov2uOrE1b6JynjupB
         H/o/DaDVOHhZk3pJ13AjD/y14juoR/MqeF2kdZ9aNOdjnAjQVxXDdDJLgZK3XyEhaJ
         JJB9TgetLdny5Tr7d9iuNIIQFzCxRHgrb/MG/CNYBP7+gDtrbSBLcL5lqJoi3QL4fg
         WTF3r68QYBNUq6DcCajFrFlCyxpOHAbNq6qte5q2O8g/QYIGi/lyPXnwjbvC8pLBSh
         mfRbUSz9ABJI10Ew+xABRZZAGF5T2Ue/vRUq5FwAsQz646jYNuT1dA+eimrDTCz0o+
         38x0oAKGhcpcQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4D34C60985;
        Tue,  9 Nov 2021 19:31:41 +0000 (UTC)
Subject: Re: [GIT PULL] 9p for 5.16-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YYkuBxbTYS2ANFnK@codewreck.org>
References: <YYkuBxbTYS2ANFnK@codewreck.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <YYkuBxbTYS2ANFnK@codewreck.org>
X-PR-Tracked-Remote: git://github.com/martinetd/linux tags/9p-for-5.16-rc1
X-PR-Tracked-Commit-Id: 6e195b0f7c8e50927fa31946369c22a0534ec7e2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f89ce84bc33330607a782e47a8b19406ed109b15
Message-Id: <163648630130.13393.17965204101604959929.pr-tracker-bot@kernel.org>
Date:   Tue, 09 Nov 2021 19:31:41 +0000
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 8 Nov 2021 23:02:47 +0900:

> git://github.com/martinetd/linux tags/9p-for-5.16-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f89ce84bc33330607a782e47a8b19406ed109b15

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
