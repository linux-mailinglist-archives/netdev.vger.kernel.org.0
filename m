Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8F9531A94
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbiEWUmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbiEWUmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:42:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D46BA5A9A;
        Mon, 23 May 2022 13:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D535F614D8;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46290C36AE3;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653338522;
        bh=9hxhxfGkMFJ6qy6aa69bsE40o85uipOqX3Vf8Mj7jFg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=DX7TjvmzZoDUQzYfoN4XbRUCkvheM9Nf5g1pTtl/ATaCQ8oGLgo4bpvrbs7sP4bMl
         Mh3bPbqxRngX+QiiIAxEI2WcsXs5twTj/Sh+Y3VNzLcR4FVCGHIVUG+SzmN5601Pvi
         5j7qtuP3luKF2Vpx6QKJ/uUGmiB+7mch3KhyjSPp0juOe2+lP3tbQlltWlB42SWzst
         gcZqk+nxI01CvikkgwQyEyERrUb7qDiBmiQtFFJl3a+5+zcmDzFdARLQ3PteezTdHv
         /lmZh5b75tNY2nKRt2ply91NTtQQAN9zwCyRaru6Uf/6VLtAV9UZuDzU5prZ7sqQYC
         RreF7sk8Ml+6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 306B5EAC081;
        Mon, 23 May 2022 20:42:02 +0000 (UTC)
Subject: Re: [GIT PULL] io_uring 'more data in socket' support
From:   pr-tracker-bot@kernel.org
In-Reply-To: <6fd7e1ff-7807-442b-3c4a-344e006e0450@kernel.dk>
References: <6fd7e1ff-7807-442b-3c4a-344e006e0450@kernel.dk>
X-PR-Tracked-List-Id: <io-uring.vger.kernel.org>
X-PR-Tracked-Message-Id: <6fd7e1ff-7807-442b-3c4a-344e006e0450@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-net-2022-05-22
X-PR-Tracked-Commit-Id: f548a12efd5ab97e6b1fb332e5634ce44b3d9328
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e1a8fde7203fa8a3e3f35d4f9df47477d23529c1
Message-Id: <165333852219.17690.6808443350402394488.pr-tracker-bot@kernel.org>
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

The pull request you sent on Sun, 22 May 2022 15:26:13 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-net-2022-05-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e1a8fde7203fa8a3e3f35d4f9df47477d23529c1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
