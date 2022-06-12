Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3253E54780F
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 02:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbiFLAdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 20:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiFLAdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 20:33:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76F93DDC7;
        Sat, 11 Jun 2022 17:33:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ADB1B80B74;
        Sun, 12 Jun 2022 00:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 368F6C34116;
        Sun, 12 Jun 2022 00:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654994020;
        bh=YK+v++7aHXh6ZVsNGPhoQ32la+K/dqkHHmiEfw1ISHg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Hh6uL5u9xn3vFbB7R+vcU+f8l+A2htz8iUC8hP7V9VGu2rmdOC8N8sZ8oXs3LK42M
         QNj0xZyYREMyzdCEYboJOaCxEWkEYZ8JD1ElOEENCEYqGb74xgiTdg1EY4odTQdwbc
         zBGbR+qS0GadrEnC1JQni46mScY/n01yG/I5hmjWcQOpgtc9jl2cInzhZtVmY3uT+1
         T3p0S2BKDXu/6cIeXcdsInzM+bvvTbkcTsJGvm9yMzNZzQl1hJgVlBvwdGNYXeL2t8
         sDGoRWACJMAVz2yoaga6ZP0+Ionzq3Z1viWp7C2+e0X+aPLneP25IKXDRwAjQq3n3l
         5WObU+CphcP4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2315FE737F0;
        Sun, 12 Jun 2022 00:33:40 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vdpa: fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220611034848-mutt-send-email-mst@kernel.org>
References: <20220611034848-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220611034848-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: eacea844594ff338db06437806707313210d4865
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: abe71eb32f3051f461d2975c674c0857549d0b93
Message-Id: <165499402013.23172.7490053891155613764.pr-tracker-bot@kernel.org>
Date:   Sun, 12 Jun 2022 00:33:40 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, elic@nvidia.com, fam.zheng@bytedance.com,
        gautam.dawar@xilinx.com, jasowang@redhat.com,
        johannes@sipsolutions.net, liubo03@inspur.com, mst@redhat.com,
        oliver.sang@intel.com, pilgrimtao@gmail.com, si-wei.liu@oracle.com,
        stable@vger.kernel.org,
        syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com,
        vincent.whitchurch@axis.com, wangxiang@cdjrlc.com,
        xieyongji@bytedance.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sat, 11 Jun 2022 03:48:48 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/abe71eb32f3051f461d2975c674c0857549d0b93

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
