Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CFA63716C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 05:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiKXEUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 23:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiKXEUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 23:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F099FC6044
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 20:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D43EB826C5
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 04:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58168C433C1;
        Thu, 24 Nov 2022 04:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669263616;
        bh=C5XW/RerBasfuo49b2fh8uPqs181VWIgvPoLCJwA4+4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LBHCPMLlY5aICNt/Mn3QnUhM2V0PtOPClwMfoIgYztLqv2MVnQPvWWUF6aAy4k5dy
         vISfWdD7/XAA2XzhAIU/XgoM86zmsYIvLYFQKh2Leq05gy+bdJ2sLFvO1+HnBu/r/T
         kEAZFnoBue6ttkEa4nncU87gx2qFebzz0HCW+w2juc+44D36209JJ9AJAmXoafJJfY
         La4GCrCCeka6xczYRvsaq/8Nca5JtOZM2VnK2q/JagcAKTW7Bouz2F0eoUVKDL/GWi
         27lb9OQydmic4XnIBoAFX9oy6ipnf2wyW6GO+B4PoBBvUKFsxXaVu//VinVqrM6+qZ
         1KJIZYKtuje5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 447C4C395EE;
        Thu, 24 Nov 2022 04:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] bonding: fix bond recovery in mode 2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166926361627.22792.14683635371904949142.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 04:20:16 +0000
References: <cover.1669147951.git.jtoppins@redhat.com>
In-Reply-To: <cover.1669147951.git.jtoppins@redhat.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, j.vosburgh@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Nov 2022 15:25:03 -0500 you wrote:
> When a bond is configured with a non-zero updelay and in mode 2 the bond
> never recovers after all slaves lose link. The first patch adds
> selftests that demonstrate the issue and the second patch fixes the
> issue by ignoring the updelay when there are no usable slaves.
> 
> v2:
>  * repost to net tree, suggested by Paolo Abeni
>  * reduce number of icmp echos used in test, suggested by Paolo Abeni
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] selftests: bonding: up/down delay w/ slave link flapping
    https://git.kernel.org/netdev/net-next/c/d43eff0b85ae
  - [net-next,v2,2/2] bonding: fix link recovery in mode 2 when updelay is nonzero
    https://git.kernel.org/netdev/net-next/c/f8a65ab2f3ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


