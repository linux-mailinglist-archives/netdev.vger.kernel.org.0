Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3009263C912
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 21:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237280AbiK2UPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 15:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236885AbiK2UPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 15:15:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281FE2EF0E;
        Tue, 29 Nov 2022 12:15:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B705A618DC;
        Tue, 29 Nov 2022 20:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09303C433C1;
        Tue, 29 Nov 2022 20:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669752918;
        bh=YzMWuzk7EH5qFD9fOJWo6Y4/AMxRoPiWzfR3FB2r7Ow=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jDsgWdukduKmvOdr9AAtBoJIBBWvMNYPTN/GJqzEutCo2qmWl1v34BPcLz6MCl/1w
         rCXcaIqivxWMFN3f6gbhnFhsFikPV1ED+5IIG32YI1gVqnho1zhgqF39RFt97rs+N3
         skRcZFIktSZP4/GhU1HbZvM24IuD1dxieh5FmOvKa4AoyZ80iU5hwuZys7McMYTN3L
         foCqPGh51ta10eBQoIPGvjuNeZeMCDLW869jPPH2YcRIK52MrE32r+/6MmqDedlPPj
         hTli290EGECJTgvI9n1nGzEN+jMd65KVRrvALjZ6FSnUeA9aWg7DSrzWjcQE1dq0zU
         jmra1llWtupjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8CC5E21EF5;
        Tue, 29 Nov 2022 20:15:17 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.1-rc8 (part 1)
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221129025219.2374322-1-kuba@kernel.org>
References: <20221129025219.2374322-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221129025219.2374322-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc8-1
X-PR-Tracked-Commit-Id: cdde1560118f82498fc9e9a7c1ef7f0ef7755891
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5daadc86f27ea4d691e2131c04310d0418c6cd12
Message-Id: <166975291794.22319.11580527982284217458.pr-tracker-bot@kernel.org>
Date:   Tue, 29 Nov 2022 20:15:17 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 28 Nov 2022 18:52:19 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc8-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5daadc86f27ea4d691e2131c04310d0418c6cd12

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
