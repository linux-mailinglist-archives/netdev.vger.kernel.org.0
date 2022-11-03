Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030AF61878C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 19:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiKCSco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 14:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbiKCSc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 14:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02783167FD;
        Thu,  3 Nov 2022 11:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32A1161FBA;
        Thu,  3 Nov 2022 18:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 844EEC433C1;
        Thu,  3 Nov 2022 18:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667500296;
        bh=qv3zaArLfTU4h8vaecY6ebDc9sKBz7murt/wreut4Sk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AHoAbrRNhcYQCXy6CkstV6VFsStqgDYYWLL5kGssYP+V4PFgEj9xa5xngldGbKJo0
         t5Xf7VKvtJnLKh/D07vRSwiT2fU08brIfVIUxq0YZQsQ3uDBbtYCp9AbbdW+BDSeiC
         gNn7g2AkDY1xMnaEiNTzwBSG20HPzh135nVWIdw9xqpjklneiGBTl17f9tMCb5v66k
         8E75zWNLLiss/o6UZWmaDGJBSDt24doedFR5DBE/MbHKLiQUpgTyBQ0wDQPjO0baH0
         lFoL1zQVBxD4Rdi6SfR6FUkLXrumIkWej0uqVk/pJ7bJGq76iA0MwtIfbwIIKbVevZ
         8fsZct8UcWKBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72CF7C41621;
        Thu,  3 Nov 2022 18:31:36 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.1-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221103111303.57385-1-pabeni@redhat.com>
References: <20221103111303.57385-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221103111303.57385-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc4
X-PR-Tracked-Commit-Id: 715aee0fde73d5ebac58e2339cef14f2da42e9e3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9521c9d6a53df9c44a5f5ddbc229ceaf3cf79ef6
Message-Id: <166750029646.3912.12435289598867565901.pr-tracker-bot@kernel.org>
Date:   Thu, 03 Nov 2022 18:31:36 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  3 Nov 2022 12:13:03 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9521c9d6a53df9c44a5f5ddbc229ceaf3cf79ef6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
