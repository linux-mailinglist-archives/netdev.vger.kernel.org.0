Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3C1610394
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbiJ0U7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237397AbiJ0U7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:59:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43373C0998;
        Thu, 27 Oct 2022 13:51:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C4DF62554;
        Thu, 27 Oct 2022 20:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9411BC43142;
        Thu, 27 Oct 2022 20:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666903832;
        bh=S/slFZ1fTJpJixpSKECJdeUa0r+mvQczPiM2IidCHKM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=K981/EKuwm0sySBY07XsA7R+6Vh+5faFvjLThrDCECU/lctjEo2l1HTgzO9lzXVhr
         j1LkFIACCEijvNC/xxqpCzeKpDw+a4rhUjKL2kO33cOLr83r04sJ2HodE2WvqYyiFY
         SU1H2kPuATu2iMJJJf1nWRUHR6NnQtN2aDUJeTb/rwDxJligLCVKRtkwo7lh6csGuS
         Jy6usR0k9XWhaI/oCsgcEHSyoNtI9kKvdptlZtezd+t0HgxhHmqEU56MWyvukgT76v
         iLMWzaXEMlnVhthr9XT4OCOMik9z/rz13kqvwHzMDIFhuxd4u1N/BlrD0I4NzJ63rg
         TV/ptKqtCX4dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E8D3C73FFC;
        Thu, 27 Oct 2022 20:50:32 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.1-rc3-2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221027192442.2855654-1-kuba@kernel.org>
References: <20221027192442.2855654-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221027192442.2855654-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc3-2
X-PR-Tracked-Commit-Id: 84ce1ca3fe9e1249bf21176ff162200f1c4e5ed1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 23758867219c8d84c8363316e6dd2f9fd7ae3049
Message-Id: <166690383251.21870.18338974403440728902.pr-tracker-bot@kernel.org>
Date:   Thu, 27 Oct 2022 20:50:32 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 27 Oct 2022 12:24:42 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc3-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/23758867219c8d84c8363316e6dd2f9fd7ae3049

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
