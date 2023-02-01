Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6317D686F80
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 21:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbjBAUCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 15:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbjBAUCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 15:02:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5EA42DCB;
        Wed,  1 Feb 2023 12:02:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27540B822A4;
        Wed,  1 Feb 2023 20:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1835C433EF;
        Wed,  1 Feb 2023 20:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675281766;
        bh=ze7tLLajYxPFA1rmGzEl6JCmS9yt5mfKFDsZEe6n59I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=aH2P6l3eJrPgG0fg5gakMnS5Sk8NF+n3vMDCe6gzXJNEQ5QsjH54CzRhkkI9D3Db8
         zuyTxvCbmwjSWOhMQPgWNMUks31gw9UpX381vXf85S+PocYMDFZ2Mr7IdbQKG4uD3Z
         3o3YWC5LmbrlOwdMlw5MzhLZmGj8YzYpKg5Vly49JgJO2bVbHgf+h5uAyjrk5QBuJG
         Y9GTh7XZRujno7nypg2jUkw+xdUh6pfWzueMAhWUyyw3cobzJpJVw9eMTYvroYg1el
         zfQ2fRYWUaZSX/Hu/1VRA8I848emRFisRq9C4SyzIicu3MCxohn+cm0BzsARvpqnJ1
         8L0w7WR5JEpcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BD547E21ED2;
        Wed,  1 Feb 2023 20:02:46 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost,vdpa: fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230201110640-mutt-send-email-mst@kernel.org>
References: <20230201110640-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230201110640-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 6b04456e248761cf68f562f2fd7c04e591fcac94
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9f266ccaa2f5228bfe67ad58a94ca4e0109b954a
Message-Id: <167528176676.26493.9470166810574496838.pr-tracker-bot@kernel.org>
Date:   Wed, 01 Feb 2023 20:02:46 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        007047221b@gmail.com, bcodding@redhat.com, eric.auger@redhat.com,
        jasowang@redhat.com, lingshan.zhu@intel.com, mie@igel.co.jp,
        mst@redhat.com, nab@linux-iscsi.org, viro@zeniv.linux.org.uk
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 1 Feb 2023 11:06:40 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9f266ccaa2f5228bfe67ad58a94ca4e0109b954a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
