Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DFA6DA035
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 20:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240402AbjDFSqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 14:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240371AbjDFSqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 14:46:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8D17A8F;
        Thu,  6 Apr 2023 11:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CAC2649E1;
        Thu,  6 Apr 2023 18:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A58B6C433D2;
        Thu,  6 Apr 2023 18:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680806771;
        bh=gH2Hfw59jo0O0eoLB193R4+5j0GSAytS8W/ZYCRSudQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=OGY4Vz1Za8fxEgnba1OM4zINfGRYojIEiOWUGtrQ8BF6MrUMgTcUNtLMH4eztN8WX
         j8iNcPNK1gQzlsyeynUrDRFLY0a/aXXEhtLCLuHr7Ll4T4dUDYoDmZDZln1YFAKOnR
         8aLVaRAvFqe7cB2CkYzyGqVJl8owGsYgudRDr+qeLhV2CPpNZc7z8phZb1dj+Ka3bc
         parxypVQqBgUCwKMEPIeebuav2Bv5fht8C/W7S6Iz/YdBRrkLqeOejloYDPSuIuIss
         pHYUt5z1AG1eAn2V49HSGZpaQ0yjYQWAO0DtL/o6NHN3S9NtLg/wwoF+q95zAOoUWu
         CbrQsrEGHM5Ew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92631C4167B;
        Thu,  6 Apr 2023 18:46:11 +0000 (UTC)
Subject: Re: [PULL v2] Networking for v6.3-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230406152037.897403-1-kuba@kernel.org>
References: <20230406152037.897403-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230406152037.897403-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc6-2
X-PR-Tracked-Commit-Id: 8fbc10b995a506e173f1080dfa2764f232a65e02
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f2afccfefe7be1f7346564fe619277110d341f9b
Message-Id: <168080677157.24406.10512913281065702613.pr-tracker-bot@kernel.org>
Date:   Thu, 06 Apr 2023 18:46:11 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  6 Apr 2023 08:20:37 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc6-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f2afccfefe7be1f7346564fe619277110d341f9b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
