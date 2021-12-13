Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE784737F4
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 23:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243932AbhLMWuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 17:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243924AbhLMWuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 17:50:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFA7C061574;
        Mon, 13 Dec 2021 14:50:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67E7BB816CF;
        Mon, 13 Dec 2021 22:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24235C34600;
        Mon, 13 Dec 2021 22:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639435799;
        bh=kn8oxVkJ6yPEUpS8v7x4XjZ+luhJ//RD7OwzUBU08GE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=FJHAUSVplX9ssZzTKkrdlWgZDn5urUEhpHLspLu0tFD+iwkj6mAsz6CsF6hqbWifn
         3dHfusbpeJatnLm8ZhTcc+Br0X31isNLqRkqLzZCmYneC9Nb2tFC+wGwNsYa7LzVNj
         dSiRJggs7Cm8vJJxSY1c30N8h5iwONAiWCjFY6qiDGa3aWPL9aCPOFmg62cQjoSoJw
         tOcwCzXU0JL+CJKILmIx1Y5kj8rqWhLl6oASrB10nIuQf+oKhdSjdh4ANreMqiT3i9
         sCAhJgYbrg0yAy8PtF9IBFwyOjw73JT9P+pyW6iZk5SyakGwKTY8DCwcAb+Tlb6o4H
         vFbMDBNDOsTYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 00536609D6;
        Mon, 13 Dec 2021 22:49:58 +0000 (UTC)
Subject: Re: [GIT PULL] vhost: cleanups and fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20211212175951-mutt-send-email-mst@kernel.org>
References: <20211212175951-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20211212175951-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: bb47620be322c5e9e372536cb6b54e17b3a00258
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5472f14a37421d1bca3dddf33cabd3bd6dbefbbc
Message-Id: <163943579893.4494.7297461004032490348.pr-tracker-bot@kernel.org>
Date:   Mon, 13 Dec 2021 22:49:58 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, dan.carpenter@oracle.com, hch@lst.de,
        jasowang@redhat.com, jroedel@suse.de, konrad.wilk@oracle.com,
        lkp@intel.com, maz@kernel.org, mst@redhat.com, parav@nvidia.com,
        qperret@google.com, robin.murphy@arm.com, stable@vger.kernel.org,
        steven.price@arm.com, suzuki.poulose@arm.com, wei.w.wang@intel.com,
        will@kernel.org, xieyongji@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Sun, 12 Dec 2021 17:59:51 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5472f14a37421d1bca3dddf33cabd3bd6dbefbbc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
