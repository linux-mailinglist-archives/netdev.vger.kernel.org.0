Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590D74F455F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357277AbiDEUDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573062AbiDERu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 13:50:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26D4D4C81;
        Tue,  5 Apr 2022 10:48:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DD98616C5;
        Tue,  5 Apr 2022 17:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1934C385A0;
        Tue,  5 Apr 2022 17:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649180937;
        bh=+1O856swZ0z6MyxA17arCGEyqFnENo2NE4LLuIMWiQk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=B3i5mDiLzPCFJVHSLcYE8l7AFBLzBhcryxnkLtKhyMA55ds2LiVRcYIJjE8X3a/Dj
         6znJt7exe5G+LbwfrI8FCJTMnQZRNYAkIOvoLAqcPN9KxIzPjngf+ouYVvFdzg7om/
         bPVtTAaV/IE6BC2/ISXh9k4Ec8AI63B9M4iEC2DoqV8QbEZn5nfBdFubMHsS2/FOgC
         QSHRdCvaTHPz4rOiDla75dX/RlEWAi4rR1PuF//fFhPmW64Kc7lQHIWQcGuxXkQ4hN
         rimGX3fA2ZZGw6H4LmdGklbj+rK9AjbU3EBluM/mDkk9Z7FVyIEX/gkEC1J9FJXpNb
         +8qYI1DKgMjfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC033E6D402;
        Tue,  5 Apr 2022 17:48:56 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: fixes, cleanups
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220404063128-mutt-send-email-mst@kernel.org>
References: <20220404063128-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20220404063128-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 1c80cf031e0204fde471558ee40183695773ce13
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3e732ebf7316ac83e8562db7e64cc68aec390a18
Message-Id: <164918093688.27639.685715483194892648.pr-tracker-bot@kernel.org>
Date:   Tue, 05 Apr 2022 17:48:56 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, elic@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 4 Apr 2022 06:31:28 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3e732ebf7316ac83e8562db7e64cc68aec390a18

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
