Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4B564C10D
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 01:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbiLNAMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 19:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237952AbiLNALo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 19:11:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991D027CCD;
        Tue, 13 Dec 2022 16:10:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3954CB81601;
        Wed, 14 Dec 2022 00:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D115CC433F0;
        Wed, 14 Dec 2022 00:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670976607;
        bh=1LX+mnHnnqjKrR5XHodpysvLGdEiCpFeyYbmqhdy5aw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=SNEVJRcjWbZRTORDAArmRT0KubrapdIBsDiGF04vYig0ztvrJW7vzw1uULEItfngZ
         cQ+My6skoAe0aqs48dml0ijLfY0FxZ5TuXkvRY53fszy7PQF33bSNbpF6ExdmQ/9kc
         hBUabwxJVD+3ZcFiYBezYoGOhFiAWx1DqLDJ6R4XLXq1KKX4KULnJDJOoIwUJ9pWfQ
         gB+3P2JvvjSe9iSGihVG3dAqmpYd0IrwnUObL0lS0QfD8BkSVnb5JHeGrmdJb9Okm/
         pz+fe43vepiDg0442Rp1ajmSAhmzN/GSLpiMPc1potstk0Y0zqqTJKym6jezxy5g53
         1Rj4kE2TzkKPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF458C41612;
        Wed, 14 Dec 2022 00:10:07 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221213165444.361342-1-pabeni@redhat.com>
References: <20221213165444.361342-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221213165444.361342-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.2
X-PR-Tracked-Commit-Id: 7c4a6309e27f411743817fe74a832ec2d2798a4b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7e68dd7d07a28faa2e6574dd6b9dbd90cdeaae91
Message-Id: <167097660775.30863.855239824169929279.pr-tracker-bot@kernel.org>
Date:   Wed, 14 Dec 2022 00:10:07 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Tue, 13 Dec 2022 17:54:44 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7e68dd7d07a28faa2e6574dd6b9dbd90cdeaae91

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
