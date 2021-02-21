Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35685320823
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 04:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhBUC6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 21:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhBUC6E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Feb 2021 21:58:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E61136148E;
        Sun, 21 Feb 2021 02:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613876243;
        bh=W0JbepVhCnw+N0xtYI5vzps9IiFZIRd+aoKe0beI4HI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=PLWxKNaKomDXoJ6GyrubODLLa+3wAGpaYnc2uox6B99MDpOlxeZdHr/Kec80sLi+Q
         e/dKVc8+xlXPsZK1qHvZ9W39UyhRnwm78rI1SPVQCD2l6FdRm1yUnNNEfBdnMuaCEd
         G7s6BZCLqkCUV1Ug2SE9vWNBcMW41gu0m6edXQK3TdK9An5knjCw8DRshyoq6f6gu/
         taPcwgQ8RyIDpwkVxFZVw4nECirbI8o/Ni2FEuBmM1/oKVmmtG9Re5UjJ4mNKo5CRn
         +xnEZdMPp4km7CzJ+OI0p948fFE1J0awROjyCgv7uygIUMxof2GNIGKaRoS+RFm9zr
         A7C9YpmG3GLqA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C876A60965;
        Sun, 21 Feb 2021 02:57:23 +0000 (UTC)
Subject: Re: [GIT] Networking
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210217.185200.259660673661197378.davem@davemloft.net>
References: <20210217.185200.259660673661197378.davem@davemloft.net>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210217.185200.259660673661197378.davem@davemloft.net>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git refs/heads/master
X-PR-Tracked-Commit-Id: 38b5133ad607ecdcc8d24906d1ac9cc8df41acd5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 51e6d17809c85e1934600ec4cdb85552e9bda254
Message-Id: <161387624375.20427.184533918737420520.pr-tracker-bot@kernel.org>
Date:   Sun, 21 Feb 2021 02:57:23 +0000
To:     David Miller <davem@davemloft.net>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 17 Feb 2021 18:52:00 -0800 (PST):

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git refs/heads/master

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/51e6d17809c85e1934600ec4cdb85552e9bda254

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
