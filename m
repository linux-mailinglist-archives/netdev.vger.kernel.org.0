Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E95492133
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 09:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344539AbiARI3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 03:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344274AbiARI3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 03:29:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08302C061574;
        Tue, 18 Jan 2022 00:29:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4F28B812A9;
        Tue, 18 Jan 2022 08:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63F39C340E6;
        Tue, 18 Jan 2022 08:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642494551;
        bh=ngfco9m5RC6ysn8lXvCShk4RMg7ryZFXstNW7rRs70s=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=nhcZgJJAwlftay688HihdC7itWdxDr1blrDcqAzbPX8/Tf1XL53dPiTw7SG4tEGiq
         xtQ64e+0ILBF2cQkrSFPxdskWGLfLtxblp4HlLrPb8rnYkvyA88XyKevOyx8zVl2CX
         05YezsFNGU6h31ts6oB7zVpNZuAOZf1YA7JA7FAiG/wjznYGkCjh+9Um/wOVhbV+cm
         7G/ulkcgLqx33iBFCWBuxPLwk8HAkgy3GY/frWa62qHTYNy7+vd54qXonLtynKhgwQ
         bkEMvKrquMmQs97IJO1EI4YVhSvyt5rOmUzUPhoRNmNonbnGw64NwvHz/pGLu8Crnb
         JEsI7gXa4NW+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F20FF60797;
        Tue, 18 Jan 2022 08:29:11 +0000 (UTC)
Subject: Re: [GIT PULL v2] virtio,vdpa,qemu_fw_cfg: features, cleanups, fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220114185734-mutt-send-email-mst@kernel.org>
References: <20220114185734-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20220114185734-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: b03fc43e73877e180c1803a33aea3e7396642367
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3bf6a9e36e441714928d73a5adbc59562eb7ef19
Message-Id: <164249455131.3500.5357538951870066126.pr-tracker-bot@kernel.org>
Date:   Tue, 18 Jan 2022 08:29:11 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        yun.wang@linux.alibaba.com, kvm@vger.kernel.org, trix@redhat.com,
        flyingpeng@tencent.com, virtualization@lists.linux-foundation.org,
        elic@nvidia.com, guanjun@linux.alibaba.com, lkp@intel.com,
        xianting.tian@linux.alibaba.com, mst@redhat.com,
        eperezma@redhat.com, luolikang@nsfocus.com, wu000273@umn.edu,
        lvivier@redhat.com, keescook@chromium.org, somlo@cmu.edu,
        jiasheng@iscas.ac.cn, johan@kernel.org,
        christophe.jaillet@wanadoo.fr, flyingpenghao@gmail.com,
        dapeng1.mi@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, labbott@kernel.org,
        gregkh@linuxfoundation.org, lingshan.zhu@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 14 Jan 2022 18:57:34 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3bf6a9e36e441714928d73a5adbc59562eb7ef19

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
