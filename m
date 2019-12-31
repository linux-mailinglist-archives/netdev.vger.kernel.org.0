Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7018D12DB37
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 20:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfLaTpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 14:45:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbfLaTpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 14:45:07 -0500
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577821507;
        bh=9lhfAuVwn5VWbmAS9YbOnvH6byYwWBYhtau5r1YENNo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=hPdjPyZk+fRdc7tmWfBJtULujTOCQrhC0n5wblRyYRzn1mNVx6T9U6h5tk6nGLRjR
         K0T8cNFTCl7spGrAxAtQE7Z8WYSOH53K23NmchTVnxv3xd6eP8xvgbKuil+GX7Jk56
         wRIHucz0BmJr8MPTQnye+Xsc0Dy3nEVrUfYQxqzU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191231.005747.1636874751558818158.davem@davemloft.net>
References: <20191231.005747.1636874751558818158.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191231.005747.1636874751558818158.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
 refs/heads/master
X-PR-Tracked-Commit-Id: 04b69426d846cd04ca9acefff1ea39e1c64d2714
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 738d2902773e30939a982c8df7a7f94293659810
Message-Id: <157782150715.7858.10239208945599786451.pr-tracker-bot@kernel.org>
Date:   Tue, 31 Dec 2019 19:45:07 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 31 Dec 2019 00:57:47 -0800 (PST):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/738d2902773e30939a982c8df7a7f94293659810

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
