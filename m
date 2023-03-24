Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6206C6C825B
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 17:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjCXQbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 12:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjCXQbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 12:31:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C55CDDA;
        Fri, 24 Mar 2023 09:31:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A9FB62BD5;
        Fri, 24 Mar 2023 16:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3DCBC4339B;
        Fri, 24 Mar 2023 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679675467;
        bh=pAiFB5Z0Tuotiqc9S603vt9Nz6mo1xgJ44TmalUFbfw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VEMjwcIX9vchXSnrpt/HHobVn0IKw4fERVH3S4SJ77eJrhvwiK8U5wn3oorTTvTnZ
         sn5xUwOQkw3Qv1zHmdfGMo3PtvAGkiLhBS51hivxuiFGDjl6c5BUDRIdIbzm4erifh
         VeZ+LAQ18vjtRqcDwkD2SIAGsqBnGaQVKMvnIqNn1UkzeUCAhmtOn3qalWyLQeNdL5
         YXvMPflCKG90RIaoKwFB6DZfQ0x2KFdg059rk+OkkqPAaIhU/y5oKuK5DCk4L7Bbcd
         ytr075/siUL4AhhVk3y7rCzdKznOh3VcAHpH0gxoSl2DTawDa/plZY3VxuQitS0ebj
         +IKRifnHKthJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AEA57E43EFD;
        Fri, 24 Mar 2023 16:31:07 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.3-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230323235106.51289-1-kuba@kernel.org>
References: <20230323235106.51289-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230323235106.51289-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc4
X-PR-Tracked-Commit-Id: 1b4ae19e432dfec785d980993c09593cbb182754
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 608f1b136616ff09d717776922c9ea9e9f9f3947
Message-Id: <167967546770.8924.10338385995177495241.pr-tracker-bot@kernel.org>
Date:   Fri, 24 Mar 2023 16:31:07 +0000
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

The pull request you sent on Thu, 23 Mar 2023 16:51:06 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/608f1b136616ff09d717776922c9ea9e9f9f3947

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
