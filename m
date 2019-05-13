Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9B51BFAF
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 00:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfEMWzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 18:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfEMWzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 18:55:15 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557788114;
        bh=+zPRW+JURo3C0YMHDioMJatKoaiK50hC5/k8DnkRSUw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=VMWWuvMhL26hpLsRKlAwx+Z9WmZPh1rw0MvF3jC0tyP7dNoC4J5dUO7vOveIdHB1t
         5eLTHI81jl2Xq/jKK8UbEo0jR+bbR6QOJSpZvPKQR2/FOpJB44BcVOjcLZdwVEuV5z
         tOXydfmOUvHQ/8CDE6Sv6cYtARuQ659b5cgsHdLk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190513.100808.446548500573250493.davem@davemloft.net>
References: <20190513.100808.446548500573250493.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190513.100808.446548500573250493.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git refs/heads/master
X-PR-Tracked-Commit-Id: d4c26eb6e721683a0f93e346ce55bc8dc3cbb175
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a3958f5e13e23f6e68c3cc1210639f63728a950f
Message-Id: <155778811450.1812.5325827211696422391.pr-tracker-bot@kernel.org>
Date:   Mon, 13 May 2019 22:55:14 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 13 May 2019 10:08:08 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a3958f5e13e23f6e68c3cc1210639f63728a950f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
