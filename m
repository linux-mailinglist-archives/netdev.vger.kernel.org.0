Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24F059081A
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 23:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbiHKVcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 17:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236863AbiHKVcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 17:32:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBE46A484;
        Thu, 11 Aug 2022 14:32:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF38E614A1;
        Thu, 11 Aug 2022 21:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 581F8C4347C;
        Thu, 11 Aug 2022 21:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660253534;
        bh=ykcLoTfOrFiZ0kPyhlH07MUHCbEjDuw6ues/qtAfAAE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Pijd1Uq0GuUwwgeUDRGSqLR0g3mBGNa5JSyt89r2orSA1QIiKFttaN2pOdf/NNw9t
         nHy9MYhT+pevqdsMzVBaqZ3bmbNDgyagxNsMWlaQ+lh2WpTIVGz4c0SJc4FSBkoTZJ
         6St+egL9IBRGisiXNar0Q9WHKZ++fMqyS70nLn90QOr/8we/qUm63jJnGm8d/xy5h+
         0bMCrGDlkq9ZVanQUmexmXRsxX8a/JW695qgUa4CaHUQ2YjHygUeRQoJFZxEVReNUC
         dXXw02W/MO4gWvNazCFgAWd1SnZ6g2lZIoAMJ6j0XP59mzwM/YVVUcNwuiCDdh4Pns
         dd5vdyyA5W9AQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43F68C43143;
        Thu, 11 Aug 2022 21:32:14 +0000 (UTC)
Subject: Re: [PULL] Networking for 6.0-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220811185102.3253045-1-kuba@kernel.org>
References: <20220811185102.3253045-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220811185102.3253045-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc1
X-PR-Tracked-Commit-Id: c2e75634cbe368065f140dd30bf8b1a0355158fd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7ebfc85e2cd7b08f518b526173e9a33b56b3913b
Message-Id: <166025353427.15191.2894879759209830677.pr-tracker-bot@kernel.org>
Date:   Thu, 11 Aug 2022 21:32:14 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 11 Aug 2022 11:51:02 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7ebfc85e2cd7b08f518b526173e9a33b56b3913b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
