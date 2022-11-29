Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C2063C911
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 21:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbiK2UPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 15:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiK2UPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 15:15:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDB531EDA;
        Tue, 29 Nov 2022 12:15:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C459D618E3;
        Tue, 29 Nov 2022 20:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2912BC433D6;
        Tue, 29 Nov 2022 20:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669752918;
        bh=B+/6IlXcyFGgGEqGwhnbAUvkv+oFvwfd3e0Twf1R7gY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ohQAw30gsSWBsY6/2rZesG7Cl3Cub0Dvf/WHf416qHQihiX0UWqLo4p3LfwFCkW7S
         fPZmFZSrOXoxsOnyRFCLus3oRyysuKNZvEmyW9x3905y1UNxFtG30eJImW1puht4J+
         Pa6vJc0Ng1YOkJKyd+bmeFtCuVWQm6u/kWcd8HgMiB5VEx06E+rHVyEpBq1CcxQVUC
         lQ/1dqpIaijzEVPGqxVKR3G0du03NRKxaBEsBt6sGXLZ5tUMU/+4V7gH6EmOvBeSNx
         33trEtSA0UU06xQ3Fk2Ny5KXt1FT1qjwi5MYeZ8KzInKpco/4eSJfObMb1Je2aUcDw
         DU+Qa5kK4cK7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F8E1E21EF7;
        Tue, 29 Nov 2022 20:15:18 +0000 (UTC)
Subject: Re: [PULL v2] Networking for v6.1-rc8 (part 1)
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221129171234.2974397-1-kuba@kernel.org>
References: <20221129171234.2974397-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221129171234.2974397-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc8-2
X-PR-Tracked-Commit-Id: d66233a312ec9013af3e37e4030b479a20811ec3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 01f856ae6d0ca5ad0505b79bf2d22d7ca439b2a1
Message-Id: <166975291805.22319.5066834877786433142.pr-tracker-bot@kernel.org>
Date:   Tue, 29 Nov 2022 20:15:18 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 29 Nov 2022 09:12:34 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc8-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/01f856ae6d0ca5ad0505b79bf2d22d7ca439b2a1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
