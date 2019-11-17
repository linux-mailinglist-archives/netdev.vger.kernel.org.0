Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61E2FF62C
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 01:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfKQAAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 19:00:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbfKQAAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 19:00:05 -0500
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573948805;
        bh=ZS7JA3osEYhfl6TCzf9jHmlhenQTJslSV1ztJrwyJ0k=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=SEDHMWs5YtoGoK1A5A/XGcDKG+ardcg44sHc4nZ3s+95VZBfuC2Y/KRfYhA+026js
         8cInm0vn16TzkwVl47wq2YVUV7tftRLznSakY1DTnB933TZbg6LCRmGLnhANU/hvrg
         vb3o6RiPv9+2yacb3LWl97bp1rB9GWY6UuuixMFc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191116.133321.709008936600873428.davem@davemloft.net>
References: <20191116.133321.709008936600873428.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191116.133321.709008936600873428.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
 refs/heads/master
X-PR-Tracked-Commit-Id: 7901cd97963d6cbde88fa25a4a446db3554c16c6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8be636dd8a43d4b980c1590afb5a8f5306ac5d31
Message-Id: <157394880508.17187.6457814459607418411.pr-tracker-bot@kernel.org>
Date:   Sun, 17 Nov 2019 00:00:05 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 16 Nov 2019 13:33:21 -0800 (PST):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8be636dd8a43d4b980c1590afb5a8f5306ac5d31

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
