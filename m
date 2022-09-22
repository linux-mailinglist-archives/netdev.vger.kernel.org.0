Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A315E6A7D
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 20:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiIVSPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 14:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiIVSPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 14:15:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F759AFB5;
        Thu, 22 Sep 2022 11:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCCFEB839C6;
        Thu, 22 Sep 2022 18:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85B31C433C1;
        Thu, 22 Sep 2022 18:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663870504;
        bh=PO7J5oCQZG+GwZ4Hm221AZ7z5HIgRu7eI+dj9HtGmbk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VRrhm656svMKSpYaDrfjY8dAIPVHZ+sjPhnKKWnvItERC9fHtaHgSKBTpDyIFNANW
         CkN3YAIeZNd46ASxXjcQmypk2OZDLtu8uheo7Rw3v0H6GF+cpb1O9ndG+IZ2AhnUCf
         pv+uhXwVwJXLEMSoxdIXNqqlVtcWMycdnHC8Jz3Y0SoXwBRTaNSHtcWpCn79QOrMBR
         ZN3/oEbon91IBrCI+p5vtrsLWLeAx8ztX7XWh36ycaYlPVS8HCliTzRkBN/uPejl1r
         TrbIlWo7gj65OVKZfqmUH2pTkF43+lkfNFeJIw/8fCFoRXYVyEo4z1YzELTVSRehZ3
         ftmFeSYZrpMmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70E9CE21ED1;
        Thu, 22 Sep 2022 18:15:04 +0000 (UTC)
Subject: Re: [PULL] Networking for 6.0-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220922164040.2751371-1-kuba@kernel.org>
References: <20220922164040.2751371-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220922164040.2751371-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc7
X-PR-Tracked-Commit-Id: 83e4b196838d90799a8879e5054a3beecf9ed256
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 504c25cb76a9cb805407f7701b25a1fbd48605fa
Message-Id: <166387050445.24554.14804567432792251672.pr-tracker-bot@kernel.org>
Date:   Thu, 22 Sep 2022 18:15:04 +0000
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

The pull request you sent on Thu, 22 Sep 2022 09:40:40 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/504c25cb76a9cb805407f7701b25a1fbd48605fa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
