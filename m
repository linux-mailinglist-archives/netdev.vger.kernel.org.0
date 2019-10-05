Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502CDCCC96
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 22:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbfJEUFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 16:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730028AbfJEUFN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 16:05:13 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570305912;
        bh=iDnyCqEc8/PYO5d9jv0EqKSArcwIeB3pbB3c8NSB6Mo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=SsBsN77F3Efc+33thCUjRI5cSJuHadZloaV9G1rkI0lJ5VV6qvu/ndmu73TxtG/Je
         8o9rWbkwS1ty7AxJoYZKQt38FkABOpL5aUWbeTX+xd65L7gEApNbMbkf2TivjiGZ5n
         I4gnfQPx9ZI9zdkY2EN0BOSYQ1Nn3pNO3IwUlc30=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191004.184716.781001651692902038.davem@davemloft.net>
References: <20191004.184716.781001651692902038.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191004.184716.781001651692902038.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
 refs/heads/master
X-PR-Tracked-Commit-Id: ef129d34149ea23d0d442844fc25ae26a85589fc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9819a30c11ea439e5e3c81f5539c4d42d6c76314
Message-Id: <157030591291.15791.18026864473099728230.pr-tracker-bot@kernel.org>
Date:   Sat, 05 Oct 2019 20:05:12 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 04 Oct 2019 18:47:16 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9819a30c11ea439e5e3c81f5539c4d42d6c76314

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
