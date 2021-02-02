Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C4A30CA86
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238958AbhBBSvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:51:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238855AbhBBStW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 13:49:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4836464E9C;
        Tue,  2 Feb 2021 18:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612291721;
        bh=PjZv9DqAhDRdDtvmQC4FjfyVvv4sbEkwbHmrWGcKi7M=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mXUQn5H8FX8PbaoCSQB37FCmmlnbaLdGVfcS3NtsHxGS4yyULxekk3Tt02Un6NFGb
         w3HyCXfvmZqAf9NDc2nqMA+cPxylkpSvZZ0v9X3yqKGQogZKPu0oaENt0eZ9R2IUkg
         RsJyD6Gqy1vEykO9QQbqz3GQfbNpqE9QIvgY3qrMnGe/nQuKbKrM+XM3Mjmd0oQI3n
         JLgUhbI1YQJ+zSoe2ZVC08SJNrKgd30amJUACQ1HRh0sdAnYbxQQARCj1W4jjU6Zlg
         vXkdCZt0N9YnAEB5GedJHuw8+gVXwPOrtsky7lwCaUpEwEJFDj7jVutCBNjXXy3s2L
         4bIxRsj+aQszg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43BD2609CE;
        Tue,  2 Feb 2021 18:48:41 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.11-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210202174524.179983-1-kuba@kernel.org>
References: <20210202174524.179983-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210202174524.179983-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc7
X-PR-Tracked-Commit-Id: 6c9f18f294c4a1a6d8b1097e39c325481664ee1c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a9925628727bbbfbd7263cf7c7791709af84296e
Message-Id: <161229172127.14515.11414582311325365174.pr-tracker-bot@kernel.org>
Date:   Tue, 02 Feb 2021 18:48:41 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue,  2 Feb 2021 09:45:24 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a9925628727bbbfbd7263cf7c7791709af84296e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
