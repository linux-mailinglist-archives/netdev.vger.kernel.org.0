Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7DD58839C
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 23:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiHBVaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 17:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiHBVaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 17:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB03A647D;
        Tue,  2 Aug 2022 14:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3705E6154D;
        Tue,  2 Aug 2022 21:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05726C433C1;
        Tue,  2 Aug 2022 21:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659475815;
        bh=kXeZ2ZbCwBh2pcSCS+H83PASuCSnrhm7s/Z6WlYiUhI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ZAhIOvetld1cww+DIwRRDKfRPvzCCMovlnvpRjN1WEn2wVItAIqyIq5Acz/rnHhyd
         BP0cCe8e6F9uI7/bzjjRvnbPby8fdDXd0Y1TgpV8VvO3xa8TMo31kRTdI5rdVsHWS9
         zg8IqzYsDoNIBbuOlhTpM35uNdu9046I0Hm/tc/LANfoAWV7z7Fp7Uiarsxacu0/Yx
         xrOvzTqPQmOmJydEFSe/BuISredVMSeM+a5O93R3vsESm7IC61iLhb4d0jeKj/Ailo
         gCxGQsphb+vwLm8IFUpeqtVV+781OE9ZY01O2yBh7Ob8GUgH8H138IbryHylWcDv89
         RuDoySJIieglA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E3CB5C43142;
        Tue,  2 Aug 2022 21:30:14 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring support for zerocopy send
From:   pr-tracker-bot@kernel.org
In-Reply-To: <d5568318-39ea-0c39-c765-852411409b68@kernel.dk>
References: <d5568318-39ea-0c39-c765-852411409b68@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <d5568318-39ea-0c39-c765-852411409b68@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.20/io_uring-zerocopy-send-2022-07-29
X-PR-Tracked-Commit-Id: 14b146b688ad9593f5eee93d51a34d09a47e50b5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 42df1cbf6a4726934cc5dac12bf263aa73c49fa3
Message-Id: <165947581492.30731.192012146995093526.pr-tracker-bot@kernel.org>
Date:   Tue, 02 Aug 2022 21:30:14 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 31 Jul 2022 09:03:36 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.20/io_uring-zerocopy-send-2022-07-29

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/42df1cbf6a4726934cc5dac12bf263aa73c49fa3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
