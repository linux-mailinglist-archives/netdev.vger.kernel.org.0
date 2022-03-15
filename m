Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498BB4DA16E
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 18:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbiCORl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 13:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350584AbiCORl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 13:41:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114C558E57;
        Tue, 15 Mar 2022 10:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1F27615AF;
        Tue, 15 Mar 2022 17:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DBB3C340F4;
        Tue, 15 Mar 2022 17:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647366044;
        bh=rD+17gJMM7JyEghFHY4fbvNf02D4yrV+aRzlaYSEAzo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=K8U2+2FCwScxNdJdngA9tTKtkyr7AWwmCXrnKbnYqjj6CsZmwFoddYOTm4YaL8kZ3
         eWJX05yLouDZ6WPaHq9ee+IuaxmAuXY0tQ+5gr3eTf7IXCs8e9wootkXWAtY3ispPv
         r6piu0sS1dFDJPU+ZNotr/mIlOxeGdfIIwVBxuZiSkXSEai2leuaSoKcjlzoxvtQEL
         ou4HIgRLOIf2YeKyQrQGhcvWENcd76nxbd+7ErXaCavp8KHcKGE3FfC3Eln+SobMdF
         UygiEei4QoH+ug6q2V0W4V0xtMzTXEle2YMtEI/QjRjtoFKEiZVFeqLpOIZEZRDMnT
         Z/T72ojyWgUjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB1C6E6D44B;
        Tue, 15 Mar 2022 17:40:43 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: a last minute regression fix
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220314075951-mutt-send-email-mst@kernel.org>
References: <20220314075951-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220314075951-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 95932ab2ea07b79cdb33121e2f40ccda9e6a73b5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6665ca15746dc34606b5d79fae278a101a368437
Message-Id: <164736604395.1904.10708022196014221360.pr-tracker-bot@kernel.org>
Date:   Tue, 15 Mar 2022 17:40:43 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, mail@anirudhrb.com,
        mst@redhat.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 14 Mar 2022 07:59:51 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6665ca15746dc34606b5d79fae278a101a368437

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
