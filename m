Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394F9481FE9
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 20:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242017AbhL3T3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 14:29:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58264 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242013AbhL3T3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 14:29:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7EEB61751;
        Thu, 30 Dec 2021 19:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27A7EC36AE9;
        Thu, 30 Dec 2021 19:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640892554;
        bh=pivf1148wRVylkBxgy5gB3SpBjqP2+jhQOrI2wdGtcc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=L9Gzvq8s6R45FQuDlaci9mynDtugyQf/IsGYKlbq00ZqNa6IGGHuQDnI/WgVFdCWE
         JcU+YnDxS2XeXXcCfXnESgK/AQ1hBpONrkYlvHztGJyoDlbarNokSZNRz691FlptRi
         pF5GKEizPGYeavQNDsFj3x4yyKudhmePWVXyMyVtVN9FexykTgyXwtIVQpEPBp51Ia
         EoHseFQokMCbqHT9SIgJdw3SQSJyY3kso1Xgfs1GZHSuWymAGMLbbrU7PugqJ+axrM
         WCCiKBxqnkpwericPgllW+4FgLDV1PTBEH03ahkA4cQCjQoX6VneUhw8bVV/9KQyu2
         QGA7Q8CdC9QOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16F41C395DE;
        Thu, 30 Dec 2021 19:29:14 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.16-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211230182907.1190933-1-kuba@kernel.org>
References: <20211230182907.1190933-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211230182907.1190933-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc8
X-PR-Tracked-Commit-Id: bf2b09fedc17248b315f80fb249087b7d28a69a6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 74c78b4291b4466b44a57b3b7c3b98ad02628686
Message-Id: <164089255408.6518.8948497756866982356.pr-tracker-bot@kernel.org>
Date:   Thu, 30 Dec 2021 19:29:14 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 30 Dec 2021 10:29:07 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.16-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/74c78b4291b4466b44a57b3b7c3b98ad02628686

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
