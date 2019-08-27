Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A201A9F26C
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbfH0SfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:35:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfH0SfH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 14:35:07 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566930907;
        bh=Cu/U9uPqMhWluyz3+nl6gAQbJCiHIIQ6v2svaE2dbk8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=jXs1vdElxQL3IrnQNlYyCzcGvmkZylzbm5YS10bKAWCV85Js+IF+yw0y4m00XQiCt
         fZatelBWUglWGFsG/K29s6nZyyx+QDngHgZlYE/gipFxsVlswyCHaSsVFqnM3Maw57
         eZTNUmYaupZVxa2gUbYsJpugwQs/IhwIdiL0hle0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190825.232902.493461685673378789.davem@davemloft.net>
References: <20190825.232902.493461685673378789.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190825.232902.493461685673378789.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: f53a7ad189594a112167efaf17ea8d0242b5ac00
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 452a04441b4d0d2d567e4128af58867739002640
Message-Id: <156693090698.10894.2881959253070085295.pr-tracker-bot@kernel.org>
Date:   Tue, 27 Aug 2019 18:35:06 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 25 Aug 2019 23:29:02 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/452a04441b4d0d2d567e4128af58867739002640

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
