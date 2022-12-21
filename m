Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346536534F4
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 18:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbiLURTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 12:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiLURTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 12:19:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43D264F2;
        Wed, 21 Dec 2022 09:18:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81AC6B81A97;
        Wed, 21 Dec 2022 17:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39A94C433F2;
        Wed, 21 Dec 2022 17:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671643108;
        bh=OdrPJw0J5RdrMu7rGvnN/WNtd2o1+LUSt6MLuen+ndU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Ax5ww8ZAJB0+TwcmWSNWJnXodwLKzoJlfN15Si4ewsrXy22/2IlHAe9rqBLXhq++u
         YvGskxdwmF1mu9gCKVkiR+q+K9SVAuMuld/+vkQc4fItey/Uh6EKAxHiyxbs2Yeh4x
         QLSTdzKgUwHclDplNFLcH26VrPPJsp6s+p0Bi65dQ2/2Sf7CaLcxLRof+3FpdoNWFU
         4TQsInndW1EdnEHYpkuHtwsjopIi0BLm4AMYvkYSXqrSqndUtLeOFhrhSEkvZvReUK
         UJeMom0BVI9Wzr0/iEip1gssTp+uzCY7jLrWWC7mCNiKsh7nkLQ9EB4VynD/6VHsoD
         cKbs+tabNLXsQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2685DC43141;
        Wed, 21 Dec 2022 17:18:28 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.2-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221220203022.1084532-1-kuba@kernel.org>
References: <20221220203022.1084532-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221220203022.1084532-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc1
X-PR-Tracked-Commit-Id: 19e72b064fc32cd58f6fc0b1eb64ac2e4f770e76
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 609d3bc6230514a8ca79b377775b17e8c3d9ac93
Message-Id: <167164310815.3046.2847907135887513338.pr-tracker-bot@kernel.org>
Date:   Wed, 21 Dec 2022 17:18:28 +0000
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

The pull request you sent on Tue, 20 Dec 2022 12:30:22 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/609d3bc6230514a8ca79b377775b17e8c3d9ac93

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
