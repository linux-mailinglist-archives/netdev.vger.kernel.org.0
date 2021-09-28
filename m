Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FE541B222
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241337AbhI1Ocy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241219AbhI1Ocx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 10:32:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 26C8B61209;
        Tue, 28 Sep 2021 14:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632839474;
        bh=EgMsATwK+z9MklT81mtu/IjIQhMpyFPQe+UMism4VLk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=f/5Y24zMJ1LapGxcHoUpqdLXv5tvZZBgxqVmW2isV5lvPQNOCgii/3gP2VpUQyoiJ
         H7dGW1p9tAuyHEWMy0RuVhmVJcEyFYuq3Np4epmqM90+PP75wFbT1lB+Ltgf9ppRoY
         Bgkdy/MGv7vYhMjFC0NTMorDr9BTmVOGpEsiHGvlWx2LUVmQeHOUHUDLlkfxp0/8Zr
         ITJd8DkAHw9ucfX10YO4ELDdmQIvLbeOU7Miaw1S933DSIMuHczNjBcBopuHJTTE8C
         3n2PNQyHlLrk0v4yqcth6IWq4Bk0lasm5ClfLATQ1aJoZiBGXgkpWxmHFk8FPVWMJS
         zy0iLbY/FJ1Rg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1F66960A59;
        Tue, 28 Sep 2021 14:31:14 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vdpa: fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210927183003-mutt-send-email-mst@kernel.org>
References: <20210927183003-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20210927183003-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: be9c6bad9b46451ba5bb8d366c51e2475f374981
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d33bec7b3dfa36691ed53ccaaf187d90b53be852
Message-Id: <163283947412.32258.5234903356989794369.pr-tracker-bot@kernel.org>
Date:   Tue, 28 Sep 2021 14:31:14 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, arnd@arndb.de, mst@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, xieyongji@bytedance.com,
        linux@roeck-us.net, viresh.kumar@linaro.org, elic@nvidia.com,
        dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 27 Sep 2021 18:30:03 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d33bec7b3dfa36691ed53ccaaf187d90b53be852

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
