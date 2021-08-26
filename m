Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0843F8FAF
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 22:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243541AbhHZUep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 16:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229916AbhHZUeo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 16:34:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC9A260F91;
        Thu, 26 Aug 2021 20:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630010036;
        bh=HcJnSY3xITwzNO2duOVAGRP0zMYM1V/J9YMW/ut7EuE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=L6jEDJ62hPX8QqgmBTbgddsn/DMCkC3os2G2/Wx1yJ4uzmXZ+TdYY44Q3BJbdn0Z+
         /sBO7H7WcrM0xAhMmjbTfXJaL/wP4mJwPvl4Cn6TKE2JhIZIktiYTyFUGFf31cx0g9
         6csU6VVSS+irlqo2fBO8Zu9aZNTQuESJp5bxxloIFVg4ykmMJVdVpzWX9QDLkj1VcR
         0IjfvWvOUO0bi+m48AGFPC4Jm/II4YoyOhwpHCRDdRBojTEXhUrsQm345maXbbaAE/
         saG0I75w1fOfiTeB0LPsednG2B8uyAw/Q1NAD5np2M+rqrad7MaynCcRgAU0gZSDxv
         iWjnX5GSWmAfA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D0F7260972;
        Thu, 26 Aug 2021 20:33:56 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.14-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210826191017.1345100-1-kuba@kernel.org>
References: <20210826191017.1345100-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <bpf.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210826191017.1345100-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc8
X-PR-Tracked-Commit-Id: 9ebc2758d0bbed951511d1709be0717178ec2660
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8a2cb8bd064ecb089995469076f3055fbfd0a4c9
Message-Id: <163001003679.31497.10308151113469684476.pr-tracker-bot@kernel.org>
Date:   Thu, 26 Aug 2021 20:33:56 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-can@vger.kernel.org, kvalo@codeaurora.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 26 Aug 2021 12:10:17 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8a2cb8bd064ecb089995469076f3055fbfd0a4c9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
