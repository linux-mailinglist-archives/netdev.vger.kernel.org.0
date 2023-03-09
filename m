Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64BC6B2D59
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 20:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjCITHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 14:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjCITHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 14:07:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41914FC7F0;
        Thu,  9 Mar 2023 11:07:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C95A661CD3;
        Thu,  9 Mar 2023 19:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32B8BC4339C;
        Thu,  9 Mar 2023 19:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678388829;
        bh=SWQEM1zPB0tTkFKxrhBgVwRH5vNgfvTN5WH7n88HHqA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=JJ3hnnlJOT6fPA70GAha2IlI3mDUn0u2X1tt2ZirB8GbUwFyU7xcmYLfwztZaFTfg
         ncWR8tMQDj/SI8eo27siW3/wdvwNufLUXwARFE//bBa/AmxIjYr8NGNMvG5LuC3iDf
         dSsHfdmpgmVHY1s+gF5idNhtF24pZeScF5V5qEiqJwELsF1G1HwlYlus0dLI/FYJ7F
         glnpmGCJZtNmXA4TD3xEWm14d9PKyg+llK4qF5ynA/Tje/epOLrM6h+SlYt5fI/zcW
         Jse4OE8BfoIJKLHuwfECQtvC0RkNRiuYXa1xrP+wruD338Au4aMLS/01AwujgHrMBS
         Ku1UxronU06JQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1EBA8E61B61;
        Thu,  9 Mar 2023 19:07:09 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.3-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230309144349.52317-1-pabeni@redhat.com>
References: <20230309144349.52317-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230309144349.52317-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc2
X-PR-Tracked-Commit-Id: 67eeadf2f95326f6344adacb70c880bf2ccff57b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 44889ba56cbb3d51154660ccd15818bc77276696
Message-Id: <167838882912.4761.13182920486501082636.pr-tracker-bot@kernel.org>
Date:   Thu, 09 Mar 2023 19:07:09 +0000
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

The pull request you sent on Thu,  9 Mar 2023 15:43:49 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/44889ba56cbb3d51154660ccd15818bc77276696

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
