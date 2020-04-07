Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7428A1A1645
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 21:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgDGTzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 15:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgDGTzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Apr 2020 15:55:23 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586289323;
        bh=ZKtUtUcLPY2Rnw+fGZW0MOHZxsF/t0ZHV6+DHbpeYPQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=oVpiUnHvKJ2HwrY8xneBAndldpccaQNa0ocdat2hFmpuURDEQx1NYcaGNwyOrBIxC
         cpWKZQr9SUj+D85DDl0dpT0P1ctZf7jAhcuuYr+adrDfRdQJ5Q1BP6R52NYtPJcVD1
         kLeTXyOxnFApimlxsB9r4cpI78bCX+mdQ46Fcu/4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200406.112258.20998915860758260.davem@davemloft.net>
References: <20200406.112258.20998915860758260.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200406.112258.20998915860758260.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: aa81700cf2326e288c9ca1fe7b544039617f1fc2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 479a72c0c6d7c24aa8b8a0a467672b6a6bac5947
Message-Id: <158628932298.3792.2129697418644763415.pr-tracker-bot@kernel.org>
Date:   Tue, 07 Apr 2020 19:55:22 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 06 Apr 2020 11:22:58 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/479a72c0c6d7c24aa8b8a0a467672b6a6bac5947

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
