Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD2583E55
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 02:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfHGAaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 20:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728144AbfHGAaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 20:30:10 -0400
Subject: Re: [GIT] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565137809;
        bh=1L7jH45DxzfNoMd3XdH9LcuQVFlnxperKjR9QMTRNcA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=W8dhFYfso6loQV7SqcOJJrvSKF5QcXAal4FB/isgT21vKX438PGBYfG1kEwUqwEUk
         cZ3fuIxhrXRyV5L8JfhLMc9aLuLp296RFx9qm3sLiiGG6e0QRMM7YAjgIqgCUFXWRp
         GZFlL2qQ3gijY5juyH2s1q6q2DMxpY21QZQFzLH8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190806.163557.192717542972894245.davem@davemloft.net>
References: <20190806.163557.192717542972894245.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190806.163557.192717542972894245.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 refs/heads/master
X-PR-Tracked-Commit-Id: feac1d680233a48603213d52230f92222462a1c8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 33920f1ec5bf47c5c0a1d2113989bdd9dfb3fae9
Message-Id: <156513780964.19141.4150616808616856653.pr-tracker-bot@kernel.org>
Date:   Wed, 07 Aug 2019 00:30:09 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 06 Aug 2019 16:35:57 -0700 (PDT):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/33920f1ec5bf47c5c0a1d2113989bdd9dfb3fae9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
