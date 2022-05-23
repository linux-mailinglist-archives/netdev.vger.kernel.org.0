Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05EE531BA6
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbiEWUmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbiEWUmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:42:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E82B0427;
        Mon, 23 May 2022 13:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E26F7614D9;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 532D9C36AE5;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653338522;
        bh=4r3vW4bNVHDCRWFySR0n1O9WAYcjGRAZlHlLlGvpZKw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Ov8WBmHOQZ4HTRES8JVuGE4jtUQ3BnpGQHynLqJjC/nIHdDDopZk8lAlAQ/RrPdmD
         1aPuqabYFsekmsj1LREyqM5ep609Sjj0EaS0SRgxMkRcoQijVQYLc2dRj/85eXdOgY
         9juXWSV5w1mBPWirfa6IS9wM2IKqr09goW2NCtQaTPQjP164ByRpmBJ90xpsp8P7dc
         5y2jkhQ8ly2zz75884iWcmgveZkihvN7H7FX0YYaCFP1OtraWNf0gmWreeiPlcHkM3
         yaKewVQpmiZuzDaHn202mt0sjWZUIZTuFL43qw3awnSU9TM7BDue/nr7ZpSV28dkpj
         ON03YwvySGH0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D36DF03949;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring socket(2) support
From:   pr-tracker-bot@kernel.org
In-Reply-To: <9a8aa863-58a8-c8cd-7d05-80f095cf217e@kernel.dk>
References: <9a8aa863-58a8-c8cd-7d05-80f095cf217e@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <9a8aa863-58a8-c8cd-7d05-80f095cf217e@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-socket-2022-05-22
X-PR-Tracked-Commit-Id: 033b87d24f7257c45506bd043ad85ed24a9925e2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 27738039fcdc6cb63400fe9b820b4027753568b7
Message-Id: <165333852224.17690.16090082417789995413.pr-tracker-bot@kernel.org>
Date:   Mon, 23 May 2022 20:42:02 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 22 May 2022 15:26:09 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-socket-2022-05-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/27738039fcdc6cb63400fe9b820b4027753568b7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
