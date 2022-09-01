Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749B15A9E93
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 20:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbiIASGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 14:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbiIASFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 14:05:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959AC40E10;
        Thu,  1 Sep 2022 11:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B012D60F5A;
        Thu,  1 Sep 2022 18:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EBA1C433B5;
        Thu,  1 Sep 2022 18:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662055518;
        bh=LXQtTE0NZzpZOQgdX6qkAwIt/jShkXEuYK1Q3F/U454=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ZiguOAhsmYmLcRXvB1Ww3gITF4LR2ljww+iVDmTesaBjW9Ve22QrGHe0MVh77WCCD
         Wbx8rspYuuatS1AFBYGGcA8kXL/2a4EKxXcLKkxnqsS/E7dWBy0Cv1of4MeZg0yjWd
         9Wc9c4L40B3RkZz9McNe53DJBCMboHYQCnL6h6r7TziOe2jvVCA6mlbYtLKOmPhUQn
         uzQeD7YwPEH6xGYTAF8EUW7hFjw0/jy15VeHiJ4WVHP7FoBDVB1gLEaqS+6+JHXZOd
         rQ0PgE230INkgUX2m3BtfRt76CvO8hw3Fn+CEiPPCl/2qMseVAB2wr7KnC/KT94vF5
         D1KV+Gwle3IGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09486C4166E;
        Thu,  1 Sep 2022 18:05:18 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.0-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220901095047.19518-1-pabeni@redhat.com>
References: <20220901095047.19518-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220901095047.19518-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc4
X-PR-Tracked-Commit-Id: a8424a9b4522a3ab9f32175ad6d848739079071f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 42e66b1cc3a070671001f8a1e933a80818a192bf
Message-Id: <166205551803.13559.2668583976121461826.pr-tracker-bot@kernel.org>
Date:   Thu, 01 Sep 2022 18:05:18 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  1 Sep 2022 11:50:47 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/42e66b1cc3a070671001f8a1e933a80818a192bf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
