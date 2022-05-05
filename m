Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1505F51C859
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 20:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355108AbiEESu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 14:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384477AbiEESuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 14:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110D341607;
        Thu,  5 May 2022 11:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF2C1B82EA6;
        Thu,  5 May 2022 18:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6664DC385A4;
        Thu,  5 May 2022 18:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651776361;
        bh=ZTD9yqTcnhcMu2NFgj57FtYzXLvNcaHR2x8/aLYUXkE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=qDsyR25rYbG8uaz4fGVFffpMMwHhGgenacAZm0eYzSaXXgv1OKei/2uXMCI6ug4yf
         lKwhOrWnBufsDKlr6zIRCPOdHVTa12paxtY8ykibwByfRnTZuJwyc/JjZhzSouKCgz
         TAsquA2U4CSWoM7PKw4mmNYIWlOp1zin4CjGKbm4JJIZQSJwojBpX8KI6CbEg0jD3W
         qlALbRyXOBbu9QZfuNPW3bg6PeagX57fbrUM+fE6Al5pmpTCYlv0BRquFeyeSNrJYN
         7KSO6ePMwn1+bW+74pHoDkRha0PcKt+zkLGziLMc1Gup1nvbzFpOEP/iseEGutwXq9
         K05AdV5OUV2Dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54884E8DBDA;
        Thu,  5 May 2022 18:46:01 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.18-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220505103111.20628-1-pabeni@redhat.com>
References: <20220505103111.20628-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220505103111.20628-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc6
X-PR-Tracked-Commit-Id: 4071bf121d59944d5cd2238de0642f3d7995a997
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 68533eb1fb197a413fd8612ebb88e111ade3beac
Message-Id: <165177636133.18464.12327185524394525927.pr-tracker-bot@kernel.org>
Date:   Thu, 05 May 2022 18:46:01 +0000
To:     Paolo Abeni <pabeni@redhat.com>
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

The pull request you sent on Thu,  5 May 2022 12:31:11 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/68533eb1fb197a413fd8612ebb88e111ade3beac

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
