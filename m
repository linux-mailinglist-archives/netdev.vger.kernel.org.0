Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E92C25CF4A
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 04:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgIDCJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 22:09:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbgIDCJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 22:09:27 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599185366;
        bh=0SQTrPqaETtsx26pY6baic68APqmXzTLQK62VPbIZC8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=hgd5nRKYQ2q6N+3DlSxfuEZ033PjE5QE1K5YqmJ/ScN++DTVtKbdvb14JM22ReFMW
         iTQdrnlSSvQOwFMZU+XMCnoziT8FMbJzNrkujFGl+cEXdrKsLirsDw17kcdlhsIvsd
         gkktNvoy9tC1Fgp0IT2Kh4SnTM+aflBpfn/Btp5E=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200903.170319.1154686215820482016.davem@davemloft.net>
References: <20200903.170319.1154686215820482016.davem@davemloft.net>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200903.170319.1154686215820482016.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master
X-PR-Tracked-Commit-Id: b61ac5bb420adce0c9b79c6b9e1c854af083e33f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3e8d3bdc2a757cc6be5470297947799a7df445cc
Message-Id: <159918536675.12725.8036407456847792468.pr-tracker-bot@kernel.org>
Date:   Fri, 04 Sep 2020 02:09:26 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 03 Sep 2020 17:03:19 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3e8d3bdc2a757cc6be5470297947799a7df445cc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
