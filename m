Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63D23081FA
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 00:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhA1XeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 18:34:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231283AbhA1Xcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 18:32:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C911464DFB;
        Thu, 28 Jan 2021 23:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611876715;
        bh=1ZHNqO1UVnXHD7zWMMeGJ5BViV0QetJ/PwxVHeTnLcs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=dy70nCEt67A0ucPyBBqIdqtQJeqG/m6/58QiCedwTxZJiF4I6AgA5sdyjirpLWzWJ
         XWFKSR+kYtefx1WV2rAX9hK0Emg7Jm8k98TGYqkjcA73Ub5nO3g6QIxe+BgOrs97wq
         4XHJZSdEtRBQYl4wGUWim0CVqH0ADTOkujxZGqfObqxMl6gbANkqfBW4L7cavXqxp0
         xy19Y3UuRxEwJ/QLt3tIgQtdcvGk04gyG3wlUWVKzqXseExf5P4xTkl+J28wnXPbYK
         u1kQ2ud8zV0zpKqrLXFmrXD4DgVMFb1v1+0kn6/mU07hgDxVPILkPyqQHkI6V+/USB
         TYMDnmpe5dKyA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B8B3A65307;
        Thu, 28 Jan 2021 23:31:55 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.11-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210128232210.1524674-1-kuba@kernel.org>
References: <20210128232210.1524674-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210128232210.1524674-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc6
X-PR-Tracked-Commit-Id: b8323f7288abd71794cd7b11a4c0a38b8637c8b5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 909b447dcc45db2f9bd5f495f1d16c419812e6df
Message-Id: <161187671567.10016.10214640642636140545.pr-tracker-bot@kernel.org>
Date:   Thu, 28 Jan 2021 23:31:55 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 28 Jan 2021 15:22:10 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/909b447dcc45db2f9bd5f495f1d16c419812e6df

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
