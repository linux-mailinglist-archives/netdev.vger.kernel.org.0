Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462A06EFE04
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 01:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241233AbjDZXab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 19:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241134AbjDZXaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 19:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B969940C6;
        Wed, 26 Apr 2023 16:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A67EB639B0;
        Wed, 26 Apr 2023 23:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DE73C433EF;
        Wed, 26 Apr 2023 23:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682551806;
        bh=n6CRRjP3ifGsofgs3GVRPugFYexjOZ18gnxBDkq7RxE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Vmc3JcdlGDr2nSBc5Gl9+ctCkisQeGQCD93SnB/WRQ9CD4ge7xKNN0j/hGT4ncomq
         6KiEtq+y3jTZMBMtw+Vk/1f0mby5Kq+x6guJKTkCU619IMotoFjdG/4IVLIBdyyded
         3jTFvqNv1kl5Wr9zu73JXwwc7GqzFrQRQILhH0bfBBN/D1HM97tS5IJsGGFOAoAMMA
         SSzoy0gbtUHcNCLcWPCuU/oVmKZ8UH8u5+chaVldp01HshbnSGpxABalnOQ97SeRo1
         lDn9I7sEhC2UX9tz991QDKulKRDlGE79MI+R5LSTKI6EmSQN8e7hNSygFWX7LJzWPu
         FB4qkOAlB2iwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0850E5FFC9;
        Wed, 26 Apr 2023 23:30:05 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230426143118.53556-1-pabeni@redhat.com>
References: <20230426143118.53556-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230426143118.53556-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.4
X-PR-Tracked-Commit-Id: 9b78d919632b7149d311aaad5a977e4b48b10321
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6e98b09da931a00bf4e0477d0fa52748bf28fcce
Message-Id: <168255180589.9335.10582697171231926829.pr-tracker-bot@kernel.org>
Date:   Wed, 26 Apr 2023 23:30:05 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 26 Apr 2023 16:31:18 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6e98b09da931a00bf4e0477d0fa52748bf28fcce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
