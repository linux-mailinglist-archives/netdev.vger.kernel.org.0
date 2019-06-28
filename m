Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6883258EFB
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 02:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfF1AaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 20:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfF1AaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 20:30:05 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561681804;
        bh=VVcIGry/JFAOME8xVYDO/JMOARqybIAT2+oQDPKn37M=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=NdMaOGIkBpGzhQAmpDZFJENkJO97O5cpasUXMO8ndZLKyWwAp94AYejXOlEOIb/lg
         tZa7z1JDBIAvYzqQcgIHzGqaeePLTGsXFrBgWNdRYnVmWdBs+h0Y8sk2SACNCVYxTv
         EbYpB1fXhcxyNFiNHcN6+g33cWbUg+M+0XhAJlSU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190626.195006.2073691861982062351.davem@davemloft.net>
References: <20190626.195006.2073691861982062351.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190626.195006.2073691861982062351.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
 refs/heads/master
X-PR-Tracked-Commit-Id: 89ed5b519004a7706f50b70f611edbd3aaacff2c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c84afab02c311b08b5cb8ea758cc177f81c95d11
Message-Id: <156168180428.19070.2360267794874347386.pr-tracker-bot@kernel.org>
Date:   Fri, 28 Jun 2019 00:30:04 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 26 Jun 2019 19:50:06 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c84afab02c311b08b5cb8ea758cc177f81c95d11

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
