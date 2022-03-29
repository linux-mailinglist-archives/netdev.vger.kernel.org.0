Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABB14EA436
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 02:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiC2Ag7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 20:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiC2Ag6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 20:36:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD01B1F42E3;
        Mon, 28 Mar 2022 17:35:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FB4461163;
        Tue, 29 Mar 2022 00:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2777C3410F;
        Tue, 29 Mar 2022 00:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648514115;
        bh=SIkznNoc/nbX2BbwK39sAMdXvHH8pG+PpdJYKoTB3iQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ig9X0nFdBc6u3mVF39/fysmvHZTWpwZjYroo5Nz69Sat4vlUx7/G3D/JTu/fmQ6bf
         EcAnmMjtgUNc1XaW6BPyZOGJT0jRCrgnuDXvIUgPRGQx26bu2rymG8YY1PAxPhiCHW
         z1axzTrunpszs7kHfTF6UNeX8hqFE/Vdzru1HosGHKyEFVzpgs3sXGZukivYPNXGl0
         foymL3MMfSK3GMgbokVYRl14ygVDdgI89g0R505CcwY0mdIPp807p+8B1IQQ3TN9a0
         AtaVUvcWgQSSLvqy8IUgcdwpE4s57UG1K4vxUQz2O0dlS1nol7VEot6yfcEYbiLSGI
         mcbWL5xSn0iNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 970C6EAC081;
        Tue, 29 Mar 2022 00:35:15 +0000 (UTC)
Subject: Re: [GIT PULL] Networking mid-5.18-merge-window tactical update
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220329000014.1509077-1-kuba@kernel.org>
References: <20220329000014.1509077-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220329000014.1509077-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc0
X-PR-Tracked-Commit-Id: 20695e9a9fd39103d1b0669470ae74030b7aa196
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d717e4cae0fe77e10a27e8545a967b8c379873ac
Message-Id: <164851411561.5550.4995181865247418429.pr-tracker-bot@kernel.org>
Date:   Tue, 29 Mar 2022 00:35:15 +0000
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

The pull request you sent on Mon, 28 Mar 2022 17:00:14 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc0

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d717e4cae0fe77e10a27e8545a967b8c379873ac

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
