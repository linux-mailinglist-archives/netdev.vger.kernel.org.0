Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276531F85EC
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 01:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgFMXfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 19:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbgFMXf2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 19:35:28 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592091328;
        bh=Fc/GaaN41E+ehfgoEP/OdJG6GY72ZitQBWprDeSw1mA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=l37t3okrz1pGpnXF5THadZp6jg2x5Fq/sbRdkqkrGYAYqfmCBHJHzr0sGEpDlUJri
         mX0c209MX3zh/JHP/hSZ6bfvr33VTt5GfRUhXqV8mCYyizBaskanNVhEpsDwUPShnP
         AqkH0sCc8XfAj2Ew+JAlpAzlIyoEUFkd8hep1rKU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200613.155403.1649160651516402937.davem@davemloft.net>
References: <20200613.155403.1649160651516402937.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200613.155403.1649160651516402937.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
 refs/heads/master
X-PR-Tracked-Commit-Id: bc139119a1708ae3db1ebb379630f286e28d06e8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 96144c58abe7ff767e754b5b80995f7b8846d49b
Message-Id: <159209132795.16133.12750961895993725989.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Jun 2020 23:35:27 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 13 Jun 2020 15:54:03 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/96144c58abe7ff767e754b5b80995f7b8846d49b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
