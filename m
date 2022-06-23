Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00858557DBC
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 16:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiFWO10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 10:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbiFWO1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 10:27:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6091F3EAB8;
        Thu, 23 Jun 2022 07:27:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24637B823EB;
        Thu, 23 Jun 2022 14:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D78EBC3411B;
        Thu, 23 Jun 2022 14:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655994429;
        bh=dEOyYfdNzAzZvVNocxTUJRtffCEYseV6RWOZpLthmmw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=r6mVUbvwSZQtRnNKyIo/OtfwovkD5YsJGSltu32k0344n7e37GbmLRgLGe2bGh4XW
         Uej4r/4mHNRXjtW4wRoo6+ZDm4nSTCz4X2gk/iAC+WB+nmyJxWy0gcWki1VwA8crP0
         4jIKk9qtclFj+K7aRvAl8JsouPQ290B/YHazmwJsWLsY4YupJWqgQHR7ZS6WKKO0bA
         cyoeD8AyHtPDThWiOf1KNY1lEoDJ76ZduY8ELLyplrKsJezNtHrosZxI5tmVrKtav6
         q1EadV2PWLd76P3fpX5RNR2H56U4x1hi8ERVN4NkYSgIgjZJyLECFt22P6cELlBb1C
         vAU6H7BrEvSrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3A38E737F0;
        Thu, 23 Jun 2022 14:27:09 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.19-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220623111711.25693-1-pabeni@redhat.com>
References: <20220623111711.25693-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220623111711.25693-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc4
X-PR-Tracked-Commit-Id: 12378a5a75e33f34f8586706eb61cca9e6d4690c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 399bd66e219e331976fe6fa6ab81a023c0c97870
Message-Id: <165599442979.515.8579195917863560918.pr-tracker-bot@kernel.org>
Date:   Thu, 23 Jun 2022 14:27:09 +0000
To:     Paolo Abeni <pabeni@redhat.com>
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

The pull request you sent on Thu, 23 Jun 2022 13:17:11 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/399bd66e219e331976fe6fa6ab81a023c0c97870

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
