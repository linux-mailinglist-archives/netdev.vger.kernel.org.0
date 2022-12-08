Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77AE647A64
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 00:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiLHX5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 18:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiLHX5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 18:57:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5AB2C10D;
        Thu,  8 Dec 2022 15:57:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE599620DF;
        Thu,  8 Dec 2022 23:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D0C7C433D2;
        Thu,  8 Dec 2022 23:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670543860;
        bh=wHlrvddxp86FlD0qGWJmfJxG8uK4aK2mx0VWiEW3AWg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=R/pZUZ6E9cYT74XkXkihIxM5yRYsGlUX7Jdk0gRE/Ohw6ztBPNrQh+pfwvti+o0yN
         UdZdyKJ0pRtVaNH8MGjedJtKPFqnXyGQRp/4M0ewCvP7lC0UOzvro3scFzz7rgxHQD
         8oZUmwPTQ5JQ4qSO7bnu6ZXu6mbQi4rOy+QQbgwg3lYJgcsjH8UMIJcnmuJwsGj7Ub
         UZzg16/TWpQN2CTkYaWRY6+HDZcd+VHNEtLyp9+NXUa4ZTzOpjnCiTa5prczcIwxHm
         jY1ODNzz3XuXsaWXAt0NHS4fenU2jzsHyBBZ+skcC6tcxMEeApNg3Z5cPm2S/6WS7W
         HvvUQGW9pf0Wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09E19E1B4D8;
        Thu,  8 Dec 2022 23:57:40 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.1 final / v6.1-rc9
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221208205639.1799257-1-kuba@kernel.org>
References: <20221208205639.1799257-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221208205639.1799257-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc9
X-PR-Tracked-Commit-Id: f8bac7f9fdb0017b32157957ffffd490f95faa07
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 010b6761a9fc5006267d99abb6f9f196bf5d3d13
Message-Id: <167054386002.21053.6125954924188621558.pr-tracker-bot@kernel.org>
Date:   Thu, 08 Dec 2022 23:57:40 +0000
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

The pull request you sent on Thu,  8 Dec 2022 12:56:39 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc9

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/010b6761a9fc5006267d99abb6f9f196bf5d3d13

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
