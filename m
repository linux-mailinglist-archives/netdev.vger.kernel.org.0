Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47CF6B375F
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjCJHai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjCJHaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A491EE28A;
        Thu,  9 Mar 2023 23:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09F07B821D2;
        Fri, 10 Mar 2023 07:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7576C433A8;
        Fri, 10 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678433419;
        bh=0g1po5dxku95YpbzZSbsKgMgmabVVS/TEi2UvYUPxYo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LDaF8iAGz0laDj7tZXXdP2zeSvdUuPv3nsVSyU7zlcjCvTdqohOKDlkowOYXgqH7y
         CuEQDtanyNm7mxLJ161rBSwBmPi80ByWcpSYyJIUp2Jjs/gN41mTSMiHbXUyMtfqD4
         ZhTcqUHGtYw9J+SbUNcgFGZM7+5wlIUtHaqYEWmPDfoYhoTJCvjOGT7Z/7AQoCv46v
         KIe0B0AwaO60Ib4VqHshM2mOrL9RUpLqKbqKzQebsyTz2Ki4t3zebaQeM3Fi1k5xlS
         4pX4xzFb1LcYqEPHvIQECg4r2PDgjRWc/jyB+sthee16J4m0ubbeInMHjPq7DksloM
         +3PLriLBurcZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82057E270DD;
        Fri, 10 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] lib: packing: remove MODULE_LICENSE in non-modules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167843341952.20837.16454201849686119608.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Mar 2023 07:30:19 +0000
References: <20230308121230.5354-1-nick.alcock@oracle.com>
In-Reply-To: <20230308121230.5354-1-nick.alcock@oracle.com>
To:     Nick Alcock <nick.alcock@oracle.com>
Cc:     netdev@vger.kernel.org, mcgrof@kernel.org,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        hasegawa-hitomi@fujitsu.com, olteanv@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Mar 2023 12:12:29 +0000 you wrote:
> Since commit 8b41fc4454e ("kbuild: create modules.builtin without
> Makefile.modbuiltin or tristate.conf"), MODULE_LICENSE declarations
> are used to identify modules. As a consequence, uses of the macro
> in non-modules will cause modprobe to misidentify their containing
> object file as a module when it is not (false positives), and modprobe
> might succeed rather than failing with a suitable error message.
> 
> [...]

Here is the summary with links:
  - lib: packing: remove MODULE_LICENSE in non-modules
    https://git.kernel.org/netdev/net-next/c/efb5b62d7271

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


