Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B596688A7
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 01:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240472AbjAMAsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 19:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbjAMAsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 19:48:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA78261457;
        Thu, 12 Jan 2023 16:48:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AF16B81FBC;
        Fri, 13 Jan 2023 00:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33BE8C433EF;
        Fri, 13 Jan 2023 00:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673570899;
        bh=b/BJfLRs8VAbdV/axuG7VWFBNV3AC7RHW4mugu7gmZM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=X9JHBUREvJmZCvziehgwEPTyFqGvnLB/aOYABvP0CW/45GvjrkukhTQ17iiSd+Rs+
         GHeijq2c5BGQ3iLawZDNGaczBrOnORPnQtw7lFwP+FX6ZHk5QMlV+P7LlyPz6baiMo
         4nKIIicIVLkP7hf6rcTpxDkN55+REkEpPHd3RUr5NudvxNIalnUdgDrK15My0k5j28
         PHtFbmIla+uf4ldIQ8GiTi0BvvbPLm8wlsbOH0NsAYzbKC0ANWFpbmwrO/G2TblEMB
         vDI+e1kFDWGaY3XroyyAMDE08KllcL20NivtxCY0bjuMOcm9jS/xO6gtztWw2PLKpY
         OSAsezXOslkkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 232E4C395C8;
        Fri, 13 Jan 2023 00:48:19 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.2-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230112150009.473990-1-pabeni@redhat.com>
References: <20230112150009.473990-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230112150009.473990-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc4
X-PR-Tracked-Commit-Id: be53771c87f4e322a9835d3faa9cd73a4ecdec5b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d9fc1511728c15df49ff18e49a494d00f78b7cd4
Message-Id: <167357089913.28490.7331035127993102307.pr-tracker-bot@kernel.org>
Date:   Fri, 13 Jan 2023 00:48:19 +0000
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

The pull request you sent on Thu, 12 Jan 2023 16:00:09 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d9fc1511728c15df49ff18e49a494d00f78b7cd4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
