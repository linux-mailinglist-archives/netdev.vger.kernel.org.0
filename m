Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2A153D1D7
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349139AbiFCSu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349134AbiFCSuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:50:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD09027FF0;
        Fri,  3 Jun 2022 11:50:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CD7A619C2;
        Fri,  3 Jun 2022 18:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 030BCC385B8;
        Fri,  3 Jun 2022 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654282210;
        bh=bOriYyJek/0gWTzeUpshNdx4hLR6hEcL+erxtFQ1q6Q=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Evqa9V+gShN4CKTki1Qc95yc8OQ6s9PLcauHwWuQWN/qHkuUNZ3Ib2o0b29gwpynZ
         FRgXrSMXOhDap47vgkuQWBTzhhSlqdXRt/x0Mm2Q7px6ynj/GTJtEY2YI8lCMm0foC
         tCzxlmZLw9mQEMDl6Ck+F4hfp9+VRvbgfh+AG/b1ERk5aKSf0lA34orC2kL0heSbP1
         KSyyYSWbqd8GlD1k7CqRTvyLLEhZbKDqDUFqCXaJU3Zqven3aHo0fD3BqHSRRQ0IbI
         Wvb9n5mPF5ea0BrsoYqVv8cJ4usD9SvY/gvd0zrWD7kgkOyV3Ja5WW7Y3ZE+OzLFsv
         SHtKdUIA0I91g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E093BF03953;
        Fri,  3 Jun 2022 18:50:09 +0000 (UTC)
Subject: Re: [GIT PULL] vhost,virtio,vdpa: features, fixes, cleanups
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220602161124-mutt-send-email-mst@kernel.org>
References: <20220602161124-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220602161124-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: bd8bb9aed56b1814784a975e2dfea12a9adcee92
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6e5f6a86915d65210e90acac0402e6f37e21fc7b
Message-Id: <165428220991.10974.157104839485276628.pr-tracker-bot@kernel.org>
Date:   Fri, 03 Jun 2022 18:50:09 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arbn@yandex-team.com, arei.gonglei@huawei.com,
        christophe.jaillet@wanadoo.fr, cohuck@redhat.com,
        dan.carpenter@oracle.com, dinechin@redhat.com, elic@nvidia.com,
        eperezma@redhat.com, gautam.dawar@xilinx.com, gdawar@xilinx.com,
        helei.sig11@bytedance.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, linux-s390@vger.kernel.org,
        liuke94@huawei.com, lkp@intel.com, lulu@redhat.com, maz@kernel.org,
        michael.christie@oracle.com, mst@redhat.com, muriloo@linux.ibm.com,
        oberpar@linux.ibm.com, pasic@linux.ibm.com, paulmck@kernel.org,
        peterz@infradead.org, pizhenwei@bytedance.com, sgarzare@redhat.com,
        solomonbstoner@protonmail.ch, stable@vger.kernel.org,
        suwan.kim027@gmail.com, tglx@linutronix.de, vneethv@linux.ibm.com,
        xianting.tian@linux.alibaba.com, zheyuma97@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 2 Jun 2022 16:11:24 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6e5f6a86915d65210e90acac0402e6f37e21fc7b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
