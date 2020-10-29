Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F9E29F609
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 21:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgJ2USr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 16:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726375AbgJ2USr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 16:18:47 -0400
Subject: Re: [GIT PULL] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604002726;
        bh=ZQk/5YodXySDBnHXCeavq5/iIqOatEKxdv7k2lSgQ20=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=dTE8bKUbIhFMrGrei/+quTItjT31Fp2g/twlqIDUWXztmkRrRLwAEhS3WHHydoWyn
         bYX4+9f4YrK1aKWaFHE/VN2VE9HJ5fj38TDO6vHWHKM3H+9InO1g0Gp1vQcO+WlT6p
         eopdU8321JGAxuYx6eisooX8R0nXLvqyZb4uVzs0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201029124335.2886a2bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201029124335.2886a2bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201029124335.2886a2bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc2
X-PR-Tracked-Commit-Id: 2734a24e6e5d18522fbf599135c59b82ec9b2c9e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 934291ffb638f2785cc9587403df4895f5c838ac
Message-Id: <160400272677.31914.8205588736340487039.pr-tracker-bot@kernel.org>
Date:   Thu, 29 Oct 2020 20:18:46 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 29 Oct 2020 12:43:35 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/934291ffb638f2785cc9587403df4895f5c838ac

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
