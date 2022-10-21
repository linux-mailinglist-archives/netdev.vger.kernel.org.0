Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75981606C91
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 02:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJUAli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 20:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJUAlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 20:41:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E008C1905DF;
        Thu, 20 Oct 2022 17:41:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8764CB82A07;
        Fri, 21 Oct 2022 00:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38172C433C1;
        Fri, 21 Oct 2022 00:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666312875;
        bh=Q50p4JIcJ/8as09SO3LEbYhem9K0aoaH/P9z+61DN9A=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=bzGhdPuIkfQqesRgH3oiOS1zBOUxl/9IO4wDPfFHZwbriKla3YJpv6lCX2YH/jvs9
         NNQqu5fxr93yk9pARKHPbwV51BFA8c3Hwr03IQjcI/JlXWP9cXlekMUpzvhag8QTRC
         TcuCh+QUreirvoHobjBBSQhEEDhRfK83KlO1yVty2xwD4sTIG56geT0cAp3FCL64ax
         E+AZmZ461NYolnI4ExGnfHHVoo351vUjtmpi9WSPTbyMc9jDc7tNJse/wm1gslHHwv
         n3kgxfPqAmEldJiQ5/5zHSrim1UMyeBr901inqEf4dqNluSDE8wK3Vq32vN0cdx1oY
         P44aECXRy63Bw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25049E270E3;
        Fri, 21 Oct 2022 00:41:15 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.1-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221020130114.34410-1-pabeni@redhat.com>
References: <20221020130114.34410-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221020130114.34410-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc2
X-PR-Tracked-Commit-Id: 7f378c03aa4952507521174fb0da7b24a9ad0be6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6d36c728bc2e2d632f4b0dea00df5532e20dfdab
Message-Id: <166631287514.10394.5130973453682128292.pr-tracker-bot@kernel.org>
Date:   Fri, 21 Oct 2022 00:41:15 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 20 Oct 2022 15:01:14 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6d36c728bc2e2d632f4b0dea00df5532e20dfdab

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
