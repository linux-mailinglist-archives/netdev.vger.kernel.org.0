Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DE04EEC0D
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiDALMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345344AbiDALMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:12:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DAB270842
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 04:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 512956188A
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A30EBC3410F;
        Fri,  1 Apr 2022 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648811412;
        bh=h8BAs0+kCL9E7w7Dx4vQiYssn5QyRStntuHRvDGXLVs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sMJRNlFkauY9qmkO7YCizBPczRt1IVu/18TFrKCjomMXggusdXUClJJu+X+RXLS76
         4z/bHtbksE7Zgy6pt1aKNc3i1+cfGdGYusp4miXoMjY/DB0bwk4FLY6zBa6YwqMLf3
         xQ3NAabyuXFvut9B8biqssqcoiCMx2y6nW+eLoGcfACT+WU51I8jsXOlYlZkmGgsjL
         5s1TQuFB2wyUDrNDp/3MGzQFVmRTnB1GN7p+tml6twXhMMHEWvscvqyRhw148/JFkZ
         tenKLR4qhKcQnekzt3XBGvDDERdhOSOdnGd5XV0rj06HkYrbM2gRMW4296uIMh2bbb
         wwSoZlJ2bsLjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83958F03849;
        Fri,  1 Apr 2022 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: micrel: fix KS8851_MLL Kconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164881141253.17879.12567802570323705088.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Apr 2022 11:10:12 +0000
References: <20220401054244.18131-1-rdunlap@infradead.org>
In-Reply-To: <20220401054244.18131-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 31 Mar 2022 22:42:44 -0700 you wrote:
> KS8851_MLL selects MICREL_PHY, which depends on PTP_1588_CLOCK_OPTIONAL,
> so make KS8851_MLL also depend on PTP_1588_CLOCK_OPTIONAL since
> 'select' does not follow any dependency chains.
> 
> Fixes kconfig warning and build errors:
> 
> WARNING: unmet direct dependencies detected for MICREL_PHY
>   Depends on [m]: NETDEVICES [=y] && PHYLIB [=y] && PTP_1588_CLOCK_OPTIONAL [=m]
>   Selected by [y]:
>   - KS8851_MLL [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICREL [=y] && HAS_IOMEM [=y]
> 
> [...]

Here is the summary with links:
  - net: micrel: fix KS8851_MLL Kconfig
    https://git.kernel.org/netdev/net/c/c3efcedd272a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


