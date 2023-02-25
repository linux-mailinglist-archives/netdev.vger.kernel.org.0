Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFC26A2B91
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 20:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjBYT6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 14:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjBYT6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 14:58:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE354C27;
        Sat, 25 Feb 2023 11:58:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B974D60A7C;
        Sat, 25 Feb 2023 19:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A61FC433D2;
        Sat, 25 Feb 2023 19:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677355091;
        bh=Af4EZS9W1eJNBY7oPlsoCzaKOu1YTZ46uihFnYYeYRU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=rZa9AL21mN13eeFBKwQ+Letv3Y/gvtWCqg8kJC8gi3yRZt1UATneWida+0s6RhoZv
         1A1wOd6asQaW3RuMkGuoawKL6JxjSlkRZvumEQ1ZYQOJ8aLGUpGrh+HrtVu0H0pwe7
         ++3taeUJ32iHHnuTF0u3cNBjxBZljQ1N6VOneYLLpiR3mJ7PUr+Oq6BU7X5v3mQCsa
         LEd8x2T4TKcd2GMkBoETJjX7KtB2N2R+DKAfPpE4VDhL9cCUE9GBUV0s1TnsBKDzRp
         9hoAEmYYOYxczcyiaArk9JnUkFdcnAyLL/Q7FCuaIRReGECQPANBThVAepycikirSX
         8nlzBMEHPu+qA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13E9AE68D26;
        Sat, 25 Feb 2023 19:58:11 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230220194045-mutt-send-email-mst@kernel.org>
References: <20230220194045-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230220194045-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: deeacf35c922da579637f5db625af20baafc66ed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 84cc6674b76ba2cdac0df8037b4d8a22a6fc1b77
Message-Id: <167735509107.12970.18167182731534923756.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Feb 2023 19:58:11 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        almasrymina@google.com, alvaro.karsz@solid-run.com,
        anders.roxell@linaro.org, bagasdotme@gmail.com,
        bhelgaas@google.com, colin.i.king@gmail.com,
        dmitry.fomichev@wdc.com, elic@nvidia.com, eperezma@redhat.com,
        hch@lst.de, jasowang@redhat.com, kangjie.xu@linux.alibaba.com,
        leiyang@redhat.com, liming.wu@jaguarmicro.com,
        lingshan.zhu@intel.com, liubo03@inspur.com, lkft@linaro.org,
        mie@igel.co.jp, mst@redhat.com, m.szyprowski@samsung.com,
        ricardo.canuelo@collabora.com, sammler@google.com,
        sebastien.boeuf@intel.com, sfr@canb.auug.org.au,
        si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@gmail.com,
        suwan.kim027@gmail.com, xuanzhuo@linux.alibaba.com,
        yangyingliang@huawei.com, zyytlz.wz@163.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 20 Feb 2023 19:40:45 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/84cc6674b76ba2cdac0df8037b4d8a22a6fc1b77

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
