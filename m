Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B0E20AA30
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 03:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgFZBkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 21:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727876AbgFZBkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 21:40:13 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593135613;
        bh=beYuIkBrEoofipnvOmAietw6vi3LuAOh/sMwvuTHaI0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Jiek5QFEn1Oek+uE+b19aY1+/zx1FSSlqQsAEpxYGVErmF5z3FOOv4cSZlUzDcT0L
         InyqVsUC6G8hDB0NH/htZkBdv+J2BMc5X9lnQ+vTcLCqQ6/hn+ShuNtGZk2XFXUDXi
         dAz/RAjjSS5GQYFZvZdpQac+NHN1GwMN0AtZNIGc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200625.164348.1339174087524887583.davem@davemloft.net>
References: <20200625.164348.1339174087524887583.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200625.164348.1339174087524887583.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
 refs/heads/master
X-PR-Tracked-Commit-Id: 4c342f778fe234e0c2a2601d87fec8ba42f0d2c6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4a21185cda0fbb860580eeeb4f1a70a9cda332a4
Message-Id: <159313561341.23337.16523414484163945062.pr-tracker-bot@kernel.org>
Date:   Fri, 26 Jun 2020 01:40:13 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 25 Jun 2020 16:43:48 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4a21185cda0fbb860580eeeb4f1a70a9cda332a4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
