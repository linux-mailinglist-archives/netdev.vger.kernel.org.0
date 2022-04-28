Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025D8513C31
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 21:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351590AbiD1Tou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 15:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351494AbiD1Tot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 15:44:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C612E5A5BC;
        Thu, 28 Apr 2022 12:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 871E3B82C97;
        Thu, 28 Apr 2022 19:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38FF2C385A9;
        Thu, 28 Apr 2022 19:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651174891;
        bh=y4Cc6cqQY1HadzSDIcZayf/poMhf9TXDXmdbQJZkBlY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=B1xHv+HLghwO+VM6I1eMTiJPPDSXHmJgooDb6y8Hnuf+8oLAP/FqNZHuTHuvV0W4p
         T26p5yZ6x04oGnXorKrBe48ds8XoT/NebZYP/EZhsnQP7I4FdC728bfcxoAU0N+PGj
         WG3BMnn/hdZF9ogLNh9/u4Ocl/lsoDSWoe5BcY7vktZ5d0+8XVyiBU8zgqMf2wMlwc
         DX5UoapLITjruVhxlBus7BRuuymH+iJ3qYKArnaxSr4A8KLQSnwHhaSB78e9hKctoE
         1iB/1ACZ1GINv9hxoYv2z0er58JY4jXbRsoLf3YFdFIh23NgimkAdUtmX0CNCVQP73
         FK3NBmoa+C+Lw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2635DE85D90;
        Thu, 28 Apr 2022 19:41:31 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.18-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220428182554.2138218-1-kuba@kernel.org>
References: <20220428182554.2138218-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220428182554.2138218-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc5
X-PR-Tracked-Commit-Id: d9157f6806d1499e173770df1f1b234763de5c79
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 249aca0d3d631660aa3583c6a3559b75b6e971b4
Message-Id: <165117489114.1505.12951073752854060589.pr-tracker-bot@kernel.org>
Date:   Thu, 28 Apr 2022 19:41:31 +0000
To:     Jakub Kicinski <kuba@kernel.org>
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

The pull request you sent on Thu, 28 Apr 2022 11:25:54 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/249aca0d3d631660aa3583c6a3559b75b6e971b4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
