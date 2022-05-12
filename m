Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD7A525730
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 23:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358863AbiELVmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 17:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358806AbiELVmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 17:42:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791D9116643;
        Thu, 12 May 2022 14:42:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B504B82B61;
        Thu, 12 May 2022 21:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF7D0C385B8;
        Thu, 12 May 2022 21:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652391770;
        bh=jcN2BdwJlS8kZV/tVVtut53Xpu/HkOhesxjaCe2RQlk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=g4tP8YjWhiLe+sfL6VHH8YOJ/MMBnap2X4Ec7FsNNeNdCgIqkiDEDkdA9Ok6iqZkG
         ITfa4pPYAhw3g2LoG5tcO8uH9VhImRLeT/0JFmbc5ws68zIXQ720E6fV2c2o1TDJSe
         nzlJLFWv6wmLs1XbdRk1Z4UcpFogJREmKx9gSbpZUM2bdEGriW26Wr4c1jqVpeiH3Y
         PXSVaXLBFj/Q8KRwA07x4osn7yqNYV8xQyKyDM7U7Li00jbngap+2ArlR3sUIebIbi
         Syc5nZBKJn0mxKXNFN7vN3zKvBepBCzFJEQBF0x25GwYxkrkSonp+cvdIK+Hs5Q3Fn
         IsxiK+RWJly4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABC65F0392C;
        Thu, 12 May 2022 21:42:50 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.18-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220512183952.3455585-1-kuba@kernel.org>
References: <20220512183952.3455585-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220512183952.3455585-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc7
X-PR-Tracked-Commit-Id: 3740651bf7e200109dd42d5b2fb22226b26f960a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f3f19f939c11925dadd3f4776f99f8c278a7017b
Message-Id: <165239177069.21368.3082088414672987973.pr-tracker-bot@kernel.org>
Date:   Thu, 12 May 2022 21:42:50 +0000
To:     Jakub Kicinski <kuba@kernel.org>
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

The pull request you sent on Thu, 12 May 2022 11:39:52 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f3f19f939c11925dadd3f4776f99f8c278a7017b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
