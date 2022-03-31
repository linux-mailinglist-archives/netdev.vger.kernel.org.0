Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43E44EE185
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 21:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240641AbiCaTO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 15:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240578AbiCaTOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 15:14:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FE423B3E0;
        Thu, 31 Mar 2022 12:12:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA019619A6;
        Thu, 31 Mar 2022 19:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20397C340EE;
        Thu, 31 Mar 2022 19:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648753975;
        bh=sBcvNGbvK2cYhzTho1GUag2cDtC1NXuLurwPtXH9B8U=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=rR4rZ9glYna+23LMW4uL5gcyylCnPHz7O04ssenWus7kEZJUOfARiUC5hJyZL7NNA
         ExON1Nia+it9BeBvhRS5xqRi2z3bhi3Ecs02lEUQcGK+tJcyT/CUiH45Y6i+V8urKT
         r80oTEUNhsMXSqTsQ5Y3fEJ4GszQ4gR4uLi0zXw9rBGlXn5YUaJ/TlKktzXorWVS7z
         hgHdsZq8zSXEMj5Vmh8eU0+8yCSSTcJkAa2IFTR9prw+NUCbpkcSSFcoc8z8iEmSok
         IUTOlqqzX1H/JbAbhNeaHJUiEp183aI6mew/0dEGekFA8qTNNePanBGX99b1//VIyz
         DeWMnrosQnxkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DA80E7BB0B;
        Thu, 31 Mar 2022 19:12:55 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.18-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220331172423.3669039-1-kuba@kernel.org>
References: <20220331172423.3669039-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220331172423.3669039-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc1
X-PR-Tracked-Commit-Id: 9d570741aec1e1ebd37823b34a2958f24809ff24
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2975dbdc3989cd66a4cb5a7c5510de2de8ee4d14
Message-Id: <164875397505.22373.9429859030593611119.pr-tracker-bot@kernel.org>
Date:   Thu, 31 Mar 2022 19:12:55 +0000
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

The pull request you sent on Thu, 31 Mar 2022 10:24:23 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2975dbdc3989cd66a4cb5a7c5510de2de8ee4d14

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
