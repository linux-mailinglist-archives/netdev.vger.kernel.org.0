Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFB06F0F99
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 02:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344655AbjD1Abc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 20:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344458AbjD1Aba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 20:31:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBEA30F7;
        Thu, 27 Apr 2023 17:31:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FF3B64096;
        Fri, 28 Apr 2023 00:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 772CCC433EF;
        Fri, 28 Apr 2023 00:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682641886;
        bh=Zi4kwNpK3pmjKReSeLMI8z1sNRFh0A4YXwF2UGLX3h0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=H5yOeknIL76bDURzilnRvk4gAZsh5tiT1EUeR6IBS5s+J5DVcytRjLAmPoI/uEVkD
         aSd3QE6FCJg1P5QLtXSWX1bOuLI3v/Um2a8+cD86zzGaSN/+2HHuekDim9CHt9GbOI
         vxgTtBMrJxK2O/4tUQJOCyrXitdVJdasPFnIb8S6PtJ1tHRwIK8SSEm2L74LEJVGL5
         83UCOm5WisTVWmlsDUEWoSmJodoqscrT26pRUWN0Q4KcHq2qFSYkcL5PUqFJNu6W3J
         5LtjHEKzMLaalQQs4+LCgwgzaF2EHOHOwJkEi6PUpszTnetChdMwp+Dk6V7w7kAIVa
         FUMkzbvg0ldHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60F52E5FFC8;
        Fri, 28 Apr 2023 00:31:26 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes, cleanups
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230424174842-mutt-send-email-mst@kernel.org>
References: <20230424174842-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230424174842-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: c82729e06644f4e087f5ff0f91b8fb15e03b8890
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8ccd54fe45713cd458015b5b08d6098545e70543
Message-Id: <168264188639.7031.14210946422047570698.pr-tracker-bot@kernel.org>
Date:   Fri, 28 Apr 2023 00:31:26 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, christophe.jaillet@wanadoo.fr,
        elic@nvidia.com, eperezma@redhat.com, feliu@nvidia.com,
        fmdefrancesco@gmail.com, horms@kernel.org,
        huangjie.albert@bytedance.com, jacob.e.keller@intel.com,
        jasowang@redhat.com, lulu@redhat.com, michael.christie@oracle.com,
        mie@igel.co.jp, mst@redhat.com, peter@n8pjl.ca, rongtao@cestc.cn,
        rtoax@foxmail.com, sgarzare@redhat.com, simon.horman@corigine.com,
        stable@vger.kernel.org, viktor@daynix.com, xieyongji@bytedance.com,
        xuanzhuo@linux.alibaba.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 24 Apr 2023 17:48:42 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8ccd54fe45713cd458015b5b08d6098545e70543

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
