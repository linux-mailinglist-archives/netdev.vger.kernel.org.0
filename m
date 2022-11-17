Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0A362E2B1
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 18:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbiKQRP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 12:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240200AbiKQRPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 12:15:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9390A16586;
        Thu, 17 Nov 2022 09:15:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32D92621C2;
        Thu, 17 Nov 2022 17:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E37AC433D6;
        Thu, 17 Nov 2022 17:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668705347;
        bh=P1n5qNuQbEQGE1/dAUJa/5m+AGcru7jZ50+Mdbr4Ax8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=k4v7m5TT74mlYcSG4WZFy5SiY/YE1csfEB4bOAiHm48KUdocvEhslaMPle6jorXbG
         3FYMYIYqJpOmFpthmsYqQCF+mFekEWtR/GLBgvXCC3NJ6lE0NBSQ9zE+A0ShXRCS3U
         UA+JlFXx5fw8U2LhXRi0i1xSyYloP+9Knz2FnWo9+wSrpf3MQluLpvPptuNBkQ308A
         FHyNhj3bgUBCfjDP1Y/DjWKZcQx34ywMQEJGSoFH/IcH7Nb5Pre4WhfH3L0yD5CjDf
         unV0KaW4iGYhv408PMDDnyuypxEKhZKMyyArWOwdE7zBuFLlJPwkNdCaeem4Rr/HWI
         KGoKDlJbJfm5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7AD71E270D5;
        Thu, 17 Nov 2022 17:15:47 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.1-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221117120017.26184-1-pabeni@redhat.com>
References: <20221117120017.26184-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221117120017.26184-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc6
X-PR-Tracked-Commit-Id: 58e0be1ef6118c5352b56a4d06e974c5599993a5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 847ccab8fdcf4a0cd85a278480fab1ccdc9f6136
Message-Id: <166870534749.19027.2331840091834304165.pr-tracker-bot@kernel.org>
Date:   Thu, 17 Nov 2022 17:15:47 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 17 Nov 2022 13:00:17 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/847ccab8fdcf4a0cd85a278480fab1ccdc9f6136

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
