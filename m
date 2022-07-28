Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F3A5846B0
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiG1Tyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiG1Tyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:54:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83D86E2ED;
        Thu, 28 Jul 2022 12:54:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6406B61DFA;
        Thu, 28 Jul 2022 19:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9A53C433C1;
        Thu, 28 Jul 2022 19:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659038081;
        bh=6twOAmxmh/muG7ET6+1EfXfqla8lNrqvJpZpzAlHDXM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=YGFyWe3Yb3OejgWnMWJC3cNxh7FTf8Cqq/pyFHZdwJ/zaGE85LBT9oZFFv3+ZCBeS
         YqlxU7nYBmHR9Ku61aj+507Vt0FOpKgFu9GSCmhAJrRsCcf12wr2CM5zAurVIsRAGX
         bBgCFhGRBiRGytPdU448z2g5eo7zLtGkwEKKdRG8acDhgZXAW6sMTr2WoUC3yXab8M
         6y/RFF04a8EEGFhYhB0QTofEFWiBDl84gVULtesZmHRt2acBNu08AoeoUEF77aZH0U
         uR68Je3LjkGKTph9SnIBX8y1s0zDJ0lIhXQqU7AQmfzIbzHwvFQfYIdN2WaONZ3bLS
         nt17gPWzlZlxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A7877C43142;
        Thu, 28 Jul 2022 19:54:41 +0000 (UTC)
Subject: Re: [PULL] Networking for 5.19-final
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220728184007.1642187-1-kuba@kernel.org>
References: <20220728184007.1642187-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220728184007.1642187-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-final
X-PR-Tracked-Commit-Id: 4d3d3a1b244fd54629a6b7047f39a7bbc8d11910
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 33ea1340bafe1f394e5bf96fceef73e9771d066b
Message-Id: <165903808167.27063.2870648876969539037.pr-tracker-bot@kernel.org>
Date:   Thu, 28 Jul 2022 19:54:41 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 28 Jul 2022 11:40:07 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-final

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/33ea1340bafe1f394e5bf96fceef73e9771d066b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
