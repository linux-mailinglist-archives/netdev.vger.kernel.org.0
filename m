Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319816A4DD1
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 23:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjB0WPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 17:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjB0WPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 17:15:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61A929E05;
        Mon, 27 Feb 2023 14:15:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7321560F78;
        Mon, 27 Feb 2023 22:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0589C433D2;
        Mon, 27 Feb 2023 22:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677536129;
        bh=X1kuim5Q5f/UN3FcsakYYeRX4yh+jNB3hVlG/CM2Ojo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=qPVOYa7UARtGaH1qNC+RAIg7E5AJcP8666rj1XeIvv8qp2XhVqNxV/hF+N3F8b12C
         LpSTWIfre1kuN0xaLDWYk841If31y1T5T4cZKB4rqdh+liyR6Oc1UQ0I6mU0OcTcxC
         +h5v3BmGXjpprZ2nsmPsIlU063MAtIF8n+yjyqyyidDSefAvPGTRGdTy7TlIUyiU4u
         4pNSGncXeizzzqCVUz/1CAEKSFMeWWvOk1RCYPYlUGQSigLriIVdxeVrPiDYgBu9Kg
         0Z3EeInEeGFHCDzz38Ufd6HfWiSV8WVT+H0A/sej8/lDaq4GRuy0/3F0Qu41tfTUZz
         JdAXuoZoSCJDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BCE61E68D2D;
        Mon, 27 Feb 2023 22:15:29 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.3-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230227215743.747911-1-kuba@kernel.org>
References: <20230227215743.747911-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230227215743.747911-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc1
X-PR-Tracked-Commit-Id: 580f98cc33a260bb8c6a39ae2921b29586b84fdf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5ca26d6039a6b42341f7f5cc8d10d30ca1561a7b
Message-Id: <167753612976.30896.6082884119946860820.pr-tracker-bot@kernel.org>
Date:   Mon, 27 Feb 2023 22:15:29 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 27 Feb 2023 13:57:43 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5ca26d6039a6b42341f7f5cc8d10d30ca1561a7b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
