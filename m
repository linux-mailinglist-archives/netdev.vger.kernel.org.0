Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466855F103D
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbiI3QsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiI3QsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:48:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A3A18A4BD;
        Fri, 30 Sep 2022 09:48:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CE67622AB;
        Fri, 30 Sep 2022 16:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94C04C433D7;
        Fri, 30 Sep 2022 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664556496;
        bh=sGiZf+frNWqIShRobfgZ454+v/RIz7LdvPSEROhBfII=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=eJUF5nIXS3hdtmsM40BVhWg4TbR02Cke8tLIxTypcG8hCz8vqUaUCb8NVvNl0ykui
         +nfdJkf3/6cwyzfFgfmi90D8XX8emiK0ptCUOx7nVk0nl82SaF9YE6PX2FHwPmPFEq
         3h2fSOaqmQg70KcagedqF+ZI3070K8lw3mLyBQPcJqrFtRHV7PDVcBXTgFviOl6h5W
         DalmlYI7ULn228QDLdy/yQrrnFdD8smfm7JPxpaVkVgZZ7zSjZNKpt70VECoPl81AD
         OzqEa9lVh1pnU+VWo22laI8tsro9orQd+76mVtqo4VR+hN2JS2OiaHd1Hovr1D06nn
         yygrwEz/Hj9jA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 806B9E4D013;
        Fri, 30 Sep 2022 16:48:16 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220930115933-mutt-send-email-mst@kernel.org>
References: <20220930115933-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220930115933-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: a43ae8057cc154fd26a3a23c0e8643bef104d995
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 70575e77839f4c5337ce2653b39b86bb365a870e
Message-Id: <166455649651.20642.18137249565430368472.pr-tracker-bot@kernel.org>
Date:   Fri, 30 Sep 2022 16:48:16 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        acourbot@chromium.org, angus.chen@jaguarmicro.com, elic@nvidia.com,
        helei.sig11@bytedance.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, maxime.coquelin@redhat.com, mst@redhat.com,
        stefanha@redhat.com, suwan.kim027@gmail.com,
        xuanzhuo@linux.alibaba.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 30 Sep 2022 11:59:33 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/70575e77839f4c5337ce2653b39b86bb365a870e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
