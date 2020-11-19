Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A142B9DEC
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 00:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgKSXAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 18:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbgKSXAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 18:00:52 -0500
Subject: Re: [GIT PULL] Networking
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605826852;
        bh=efuhHv2rxYYpqdOmtUxi/7BLJUitz0AvShJTCzcnlKU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=EF/UdR231TzsJNc1iXW7eBz6lJJqAPn7APuatDmG4UAcGfXELPNAPuJZQjSmPZZLm
         MPLW0b4eIePQfhHAjqyqCdGAo8F3IFvSjQ1eUAvrmTlkIjK2X3eV0TmMLmoHLMbEWb
         JDvQqtALdwbLgWH4kBAo+Jl4zbH5RGqbvd3kbiZg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201119211531.3441860-1-kuba@kernel.org>
References: <20201119211531.3441860-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201119211531.3441860-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc5
X-PR-Tracked-Commit-Id: e6ea60bac1ee28bb46232f8c2ecd3a3fbb9011e0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4d02da974ea85a62074efedf354e82778f910d82
Message-Id: <160582685211.24786.15812085597956202355.pr-tracker-bot@kernel.org>
Date:   Thu, 19 Nov 2020 23:00:52 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 19 Nov 2020 13:15:31 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4d02da974ea85a62074efedf354e82778f910d82

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
