Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C6D4C37F1
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 22:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiBXVlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 16:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiBXVlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 16:41:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B327184605;
        Thu, 24 Feb 2022 13:40:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBDF3B829BF;
        Thu, 24 Feb 2022 21:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76A7AC340E9;
        Thu, 24 Feb 2022 21:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645738832;
        bh=ZJXOt+mCcw0Dye3loF6tUNJ5b1ftNgrAhzbM5EqDdus=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=pM8TQJO5BVUeVlj4nnV70rfnvJBCalXELu19l7pJueDnQJmFMYatUX7etpdSP7Ygp
         1IVC2VgKDgg2ZAP3O18+kAZNGS2Zscp2P9MNlbcslbwNFNrPQAU5Lz5hOODxuwFuZq
         Rvsloos9wogQdExtpsGCpm1M/S0lnIhTs0oVqpIdz9BS+IPPk+o2dDoBcaCLu2M+HH
         TgPMrCim/ANILakHtHRpmHO9BCC77fFjd2pwtetUZHtrmHRsd+D/bfwsio8BNXQ0b1
         obtkz3iwL1N54KYojO0yGi3zRsXHsRC7ZpchQSrdolh5d8MOjJQCLUD2pNA1b9wDHA
         mPMkpEIZlZW6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61B20E6D453;
        Thu, 24 Feb 2022 21:40:32 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.17-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220224195305.1584666-1-kuba@kernel.org>
References: <20220224195305.1584666-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220224195305.1584666-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc6
X-PR-Tracked-Commit-Id: 42404d8f1c01861b22ccfa1d70f950242720ae57
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f672ff91236b556da338f477a23b1b4e87b40d23
Message-Id: <164573883239.15008.545605693572241754.pr-tracker-bot@kernel.org>
Date:   Thu, 24 Feb 2022 21:40:32 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 24 Feb 2022 11:53:05 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f672ff91236b556da338f477a23b1b4e87b40d23

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
