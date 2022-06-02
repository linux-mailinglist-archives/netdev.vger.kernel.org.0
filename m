Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A124653BF2D
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 21:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239174AbiFBT6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 15:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239145AbiFBT57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 15:57:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEA217058;
        Thu,  2 Jun 2022 12:57:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A3BA617EC;
        Thu,  2 Jun 2022 19:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3588C3411C;
        Thu,  2 Jun 2022 19:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654199876;
        bh=v8Kci/+0h7zF7qy2K9umI1THzoCrhjgrlHZwflFqVww=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cX8jmY13qqzk9OydEljA1WMrzFnXgNuu4q+yJyaFGnp/N9rlNqh0k8I1rSEBFF77x
         MFWeUxcckIAYzDLYeTxI4VpfEhicncwbd217eYxk5wblDiSkN2pQmf7sLmYPJc/Sys
         39W0smlW2wDgSVRNLmUC023LvEpkV0SqyWIXpAv+MpxA9eCWnl93BOaGeJKMFfKMM2
         LjwS6YSNzCt/zOcGBjh0hOU2V3s5J1UEQPooV/JoNksvQjlIKejG0y8uwOebkK7tlb
         62i7ZzAXtkRJyNtTowl/Xdry3OlW4AXNn60scVyYNyB5PkTB54mdvN/W83b1HnWTik
         gT4T8XPLsi35g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1406F03945;
        Thu,  2 Jun 2022 19:57:56 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.19-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220602185358.4149770-1-kuba@kernel.org>
References: <20220602185358.4149770-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220602185358.4149770-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc1
X-PR-Tracked-Commit-Id: 638696efc14729759c1d735e19e87606450b80a8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 58f9d52ff689a262bec7f5713c07f5a79e115168
Message-Id: <165419987678.9476.16827261181487020554.pr-tracker-bot@kernel.org>
Date:   Thu, 02 Jun 2022 19:57:56 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  2 Jun 2022 11:53:58 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/58f9d52ff689a262bec7f5713c07f5a79e115168

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
