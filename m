Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B1B5FE01B
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiJMSEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiJMSDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:03:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87992157F58;
        Thu, 13 Oct 2022 11:03:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1379861943;
        Thu, 13 Oct 2022 18:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7464AC433C1;
        Thu, 13 Oct 2022 18:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665684009;
        bh=Fe7d0Zn2chLLmPzOexN099gWKHr/nuc+bPn9sa6xGrE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=MJwKEsc2KYYmKxjxm9JoAcOBVauyxTd/2m5uQkwKthdphd5Xzj/1AClF9tYju8D/D
         ziw2YWuyhDW45WBiXi3QMsZzAFKB1M+NRJ0yLY8u7mvm5l09yiMnY5jrMstjHwAu/0
         FiM8p5SbdDIPyiAFaeW91lHGcQHr4lakW7vB6L2BMVEFWMff+liyYi/JXP7Qi1FpEN
         SJ/qWbv+BONbGA74qF93cjeRIVbty2GnYEp8coy4wwJZ88qSOYnJrTiBZp9q7v2R6e
         Ka30mIntngJurdepbjH9HIo8FdFFfpyHVHRCG/Pk6Xr/XWeFwG/zLEkw7WmEFOo15d
         cZvBapYzLv+2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57F3AE29F31;
        Thu, 13 Oct 2022 18:00:09 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: bugfix, reviewer
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221013094021-mutt-send-email-mst@kernel.org>
References: <20221013094021-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221013094021-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: be8ddea9e75e65b05837f6d51dc5774b866d0bcf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d6f04f26e25242898959b1758432e4076fabc0c0
Message-Id: <166568400929.7515.1599489627533192092.pr-tracker-bot@kernel.org>
Date:   Thu, 13 Oct 2022 18:00:09 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        angus.chen@jaguarmicro.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, mpe@ellerman.id.au, mst@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 13 Oct 2022 09:40:21 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d6f04f26e25242898959b1758432e4076fabc0c0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
