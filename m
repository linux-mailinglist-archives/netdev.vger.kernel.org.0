Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D2550AADD
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 23:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiDUVka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 17:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442130AbiDUVk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 17:40:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D464BFF7;
        Thu, 21 Apr 2022 14:37:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31931B82975;
        Thu, 21 Apr 2022 21:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3436C385A7;
        Thu, 21 Apr 2022 21:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650577055;
        bh=IFjzHuk5h9dCyJBtcXNPuz7l7hjRk25FR13nx9zL0HY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=olBbHjiG98YExS7Yk9YGAqZ6Sdb+M6hGhGSExFNZou6mwGsj9WR7KDPr9VZ3r2DHx
         frAK/uW/Xu46Tk2F/Yhk5iRlVCcwEiJOlL/hvbN5waE6Va3lXc4/aOLgWWNZeg2jlz
         k/Iw2vX6CD6Z9uX5N03ux/ou1zEgB4If3wH4r9rjHcDcxZFGglUfrYcGRBofAyN2On
         4lb+17nwVn7Jj96J+BLzYZHjFI1q7m99VbClqi5DcD2Gf5gh2TsnmyQVxje8rrdvbt
         y0X8vxTH6WH6Lsy/g7jZ68KOcfPeXq0c3Jvi0N7cp0FxAPigA+9mqUJTvfU/iVCYrT
         sL+xwnLD9A+vw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF36AE85D90;
        Thu, 21 Apr 2022 21:37:35 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.18-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220421105218.18005-1-pabeni@redhat.com>
References: <20220421105218.18005-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220421105218.18005-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc4
X-PR-Tracked-Commit-Id: bc6de2878429e85c1f1afaa566f7b5abb2243eef
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 59f0c2447e2553b0918b4a9fd38763a5c0587d02
Message-Id: <165057705570.12453.7526198717622777838.pr-tracker-bot@kernel.org>
Date:   Thu, 21 Apr 2022 21:37:35 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 21 Apr 2022 12:52:18 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/59f0c2447e2553b0918b4a9fd38763a5c0587d02

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
