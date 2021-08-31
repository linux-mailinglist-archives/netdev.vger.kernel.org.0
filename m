Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB113FD011
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240774AbhHaX5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhHaX5q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 19:57:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A018D60EE3;
        Tue, 31 Aug 2021 23:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630454210;
        bh=j2WYyb+6keMeIVfNgpkTXMoKBeCkjiO5E0neAsCApJo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tqbcr9k4f+/rW7+dJbwb/RmL5Y2jGrLTMHBzbFBCOKGmjRbTY47YMy6IhR2Ub2CHK
         2qEcL5EonFpoKPsxDr5/uE0+nTuq4yVC5WKxIGwiXl7Mr/Matz2b22cPQEmVjcprOp
         Ph1ovO6yURxzVUo6ExRAJO0zq0WWn/iE/6pupE6qiHPh2jGKO/wDHzqMQRZmVbkZ8i
         TaEIiteUePJfA97eJKHs2KkWj34LyCcOA9aCuPNZh8EELgdX8l0kKXDIEn2lz03olB
         QxMinnEYA54Fxpr+s6iaFMH1ieCkVryHB2EdTZ60IZGZz78jhUcSjFHT+BmqHchrcf
         OuGLFsCXrWguA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 87BFC60963;
        Tue, 31 Aug 2021 23:56:50 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for v5.15
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210831203727.3852294-1-kuba@kernel.org>
References: <20210831203727.3852294-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210831203727.3852294-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.15
X-PR-Tracked-Commit-Id: 29ce8f9701072fc221d9c38ad952de1a9578f95c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9e9fb7655ed585da8f468e29221f0ba194a5f613
Message-Id: <163045421048.32328.14897488306331902664.pr-tracker-bot@kernel.org>
Date:   Tue, 31 Aug 2021 23:56:50 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 31 Aug 2021 13:37:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9e9fb7655ed585da8f468e29221f0ba194a5f613

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
