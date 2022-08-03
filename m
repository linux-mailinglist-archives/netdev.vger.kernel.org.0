Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB9B589503
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 01:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239134AbiHCXuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 19:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240103AbiHCXuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 19:50:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8672920F44;
        Wed,  3 Aug 2022 16:50:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2379A616F8;
        Wed,  3 Aug 2022 23:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD031C4347C;
        Wed,  3 Aug 2022 23:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659570604;
        bh=p81fgwBjbPb8uVVyB6MRrJSwVUnyGoDRu/sw5qX05Zs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AxDvmItQfYm2ykhpNbpUAvmfUxE5X+ND0IT2mYDnFhLJOe82d86Y5PQ9vJrO9dO32
         BMZVkBEipMo8k/UYeWaIY5MNd2nqJ/3nRHwCBpZ6vb860Nqy8Juj4/P2iNKIsZ9MjS
         2Q5EWspRNmd80EtLtWJpE7EzxNYDnnXRbbRYDgwrP3ZNYV/n7MU1w7igB7Vw5SvVoW
         /TFFU19/qnNhbYAhs5TfyXwLj2qYo9KwLSDuxk2cpM3LIhVzNJhlc9yroFIxdnCwiP
         UVKzqzcpSgIqaNVYUOH3egFylu6nWj4eXfgI/Sk4afLncfHPfg974kt/mDH7UCuzOM
         zcBj4YuFXIseA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8F33C43142;
        Wed,  3 Aug 2022 23:50:04 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.0
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220803101438.24327-1-pabeni@redhat.com>
References: <20220803101438.24327-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220803101438.24327-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.0
X-PR-Tracked-Commit-Id: 7c6327c77d509e78bff76f2a4551fcfee851682e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f86d1fbbe7858884d6754534a0afbb74fc30bc26
Message-Id: <165957060480.14354.3231458726803608940.pr-tracker-bot@kernel.org>
Date:   Wed, 03 Aug 2022 23:50:04 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed,  3 Aug 2022 12:14:38 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.0

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f86d1fbbe7858884d6754534a0afbb74fc30bc26

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
