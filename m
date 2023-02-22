Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E879C69ED16
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 03:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjBVCwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 21:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjBVCwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 21:52:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1552E1E1C3;
        Tue, 21 Feb 2023 18:52:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B75866157E;
        Wed, 22 Feb 2023 02:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E8D5C433D2;
        Wed, 22 Feb 2023 02:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677034205;
        bh=+3OjSNjLJLk/BP+RVXKtxCHtybVuRwzMmx+lYjjSU28=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=tw4Vw6h+Pd6jg3SN5yF80XcbFdvLkgVgefFN42SHbdfsUEInffM6mysuNqTq2S6e/
         FZodt2xecWNpHZbqyxIpZyHcE7U4H6QQ13aAb5gN7Aoo4LTvUEO7kawY0ChDxAbYW6
         KsL+DsTQCoVGX2fCvnJXt5N9/tZldVqUdSCktUliflknkYcjAYLBMFcPh3myJEifHg
         8ZT95N9ZomBd9qBmFYxKS49IRv+mVzITz6AQNgbXZmvBArEhocRAXMd376qjd2za2J
         uAyEr4WMo5od1lUSBQnaKYGGcu/frv19amlxNIxC7x6QlrnYWuZleDm9wiviJ560Ig
         rOR1EzzQtElbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07260C43159;
        Wed, 22 Feb 2023 02:50:05 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230221233808.1565509-1-kuba@kernel.org>
References: <20230221233808.1565509-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230221233808.1565509-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.3
X-PR-Tracked-Commit-Id: d1fabc68f8e0541d41657096dc713cb01775652d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5b7c4cabbb65f5c469464da6c5f614cbd7f730f2
Message-Id: <167703420500.17986.2490029586661606499.pr-tracker-bot@kernel.org>
Date:   Wed, 22 Feb 2023 02:50:05 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com,
        bpf@vger.kernel.org, ast@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 21 Feb 2023 15:38:08 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5b7c4cabbb65f5c469464da6c5f614cbd7f730f2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
