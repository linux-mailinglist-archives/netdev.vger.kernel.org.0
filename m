Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13EF52240D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348950AbiEJSbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348947AbiEJSbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:31:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820D04477E;
        Tue, 10 May 2022 11:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 209E260C6E;
        Tue, 10 May 2022 18:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84BC3C385C2;
        Tue, 10 May 2022 18:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652207470;
        bh=3wbzCdPUumedt6nbcJr9g77t66aOTyWH8eo5PuqqxVE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=nqWLoZl9vJr1KxzD/0pITSLnadScln1XYcfvJHAZIQbRzFZxyNXF2qdq9rvW4fOIW
         uWwyzEKfuS1sZJz4aDKYnJDuwu8A/MgS68uHevLpg4tRWFGBQv59Qepf/OyI9/K/BK
         mbV2ktT12rRdF6G/jLDk93cZ4PXsTALmgR1AJR6cn+cyHfm1Aap003PMESq3Vk0XxJ
         n9Xr2DzVrvHX4/aZO+1RR/lLPSFGvV1Q5XoHeMo2IK/mF8C3XascdfRVEjm/xxltcq
         O3pvzzErxiUcIvG0c3SD/V7G9QoJyuTkgx97IPKlTOTKKy/93Bkora1oVyUiCc+OSQ
         +cll+nIMUHuew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70595F0392D;
        Tue, 10 May 2022 18:31:10 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: last minute fixup
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220510082351-mutt-send-email-mst@kernel.org>
References: <20220510082351-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220510082351-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 7ff960a6fe399fdcbca6159063684671ae57eee9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: feb9c5e19e913b53cb536a7aa7c9f20107bb51ec
Message-Id: <165220747045.23919.144863447335101428.pr-tracker-bot@kernel.org>
Date:   Tue, 10 May 2022 18:31:10 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mie@igel.co.jp, mst@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 10 May 2022 08:23:51 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/feb9c5e19e913b53cb536a7aa7c9f20107bb51ec

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
