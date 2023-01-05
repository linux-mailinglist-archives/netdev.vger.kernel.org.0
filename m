Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6138A65F663
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 23:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbjAEWHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 17:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235978AbjAEWHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 17:07:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA5867BE8;
        Thu,  5 Jan 2023 14:07:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 695FE61C60;
        Thu,  5 Jan 2023 22:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2698C433EF;
        Thu,  5 Jan 2023 22:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672956428;
        bh=tD3NzGq51uPGVjuea6AbZdKBIEQoFP3lNXFZucmsfCA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jZ8VrA+colS4G2ltyTET/PY/YZ0zi3QO5UH3WlRKc9732LIrZyEFuP4vEHq1KdOBU
         AnJPCkC8Y95k6eFpLsinOG/lZiny6iGDTD0SYZUdSrj4fSz0E2svlg7Y2g89OR/PGi
         Eql6VTVEC0EGI/M78mcKZ11muGktJdB4Bt42JZRsVI/wQDFxmt58dupIfajwOOc+2m
         EodGOhHKpgQmmOkdQFFBpxm+r87K9I+Xl05YJWxGFLETkTZ6Mmy/sbh0OsZxLdplSw
         b4CXlNZwu/FFMT4b9Y6+MrYI/9IkYofWVDhuTQZtEha+1kog2GojriWgpBPD0wiUBm
         /HkBMax8DYGmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B08EBE5724A;
        Thu,  5 Jan 2023 22:07:08 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.2-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230105203742.3650621-1-kuba@kernel.org>
References: <20230105203742.3650621-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230105203742.3650621-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc3
X-PR-Tracked-Commit-Id: fe69230f05897b3de758427b574fc98025dfc907
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 50011c32f421215f6231996fcc84fd1fe81c4a48
Message-Id: <167295642871.2778.6893613365503506535.pr-tracker-bot@kernel.org>
Date:   Thu, 05 Jan 2023 22:07:08 +0000
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

The pull request you sent on Thu,  5 Jan 2023 12:37:42 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/50011c32f421215f6231996fcc84fd1fe81c4a48

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
