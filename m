Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8934EE34F
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 23:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241830AbiCaVXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 17:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241826AbiCaVXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 17:23:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365F92359E5;
        Thu, 31 Mar 2022 14:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD3E1B8224F;
        Thu, 31 Mar 2022 21:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EA7FC340EE;
        Thu, 31 Mar 2022 21:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648761700;
        bh=SWQTQYUOdaI/V43RFd409qVyPmra5Qem+nxS4qg9Uhc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=RC2etaL/g3tJBiYTMXy/jZKUXqxU56cI0ZDjY+lMJ0GY1Ic+Mt1aF7ERw2hzczb3p
         RyfJd9NN25nC1971kdvqEAZKgIDYpFkYE1m9Hzkex92oG74LMstosaHCJCHxcfpNpy
         vKeD03PpxIDm8Ag6SJEfqRymhEQ9H9Yx1Q935cX0iLffaK/QvGNooHxR9N52JMq1J8
         XJ9S0EZsBbtmmRLWOnIu25hte6fti8hGe/0Pwjxra628U+trb5brnVjTgQw0j2QUDO
         4Le3nHF3OkfZmMTKy0UOWrS4yEjiiMG8++vyrJRSiqJ8zYzimtEXNYjfweoJS7is8i
         2NerK/c+1PCVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66CCEE7BB0B;
        Thu, 31 Mar 2022 21:21:40 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: features, fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220331094816-mutt-send-email-mst@kernel.org>
References: <20220331094816-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20220331094816-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: ad6dc1daaf29f97f23cc810d60ee01c0e83f4c6b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f4f5d7cfb2e57fafd12dabd971b892f83ce02bfe
Message-Id: <164876170041.29828.8239348717589894864.pr-tracker-bot@kernel.org>
Date:   Thu, 31 Mar 2022 21:21:40 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linmiaohe@huawei.com, andrew@daynix.com, kvm@vger.kernel.org,
        trix@redhat.com, keirf@google.com,
        virtualization@lists.linux-foundation.org, mail@anirudhrb.com,
        willy@infradead.org, elic@nvidia.com, helei.sig11@bytedance.com,
        maz@kernel.org, mst@redhat.com, pizhenwei@bytedance.com,
        longpeng2@huawei.com, gdawar@xilinx.com, nathan@kernel.org,
        qiudayu@archeros.com, Jonathan.Cameron@huawei.com,
        gautam.dawar@xilinx.com, lkp@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lingshan.zhu@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 31 Mar 2022 09:48:16 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f4f5d7cfb2e57fafd12dabd971b892f83ce02bfe

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
