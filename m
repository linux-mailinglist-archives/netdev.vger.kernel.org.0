Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9C25EB217
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiIZUa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiIZUaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9DD80F7A;
        Mon, 26 Sep 2022 13:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE02F61342;
        Mon, 26 Sep 2022 20:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A828C43140;
        Mon, 26 Sep 2022 20:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664224215;
        bh=26cxVseDMcXyLsYbdUxywb6jSfROZ6xJMykODO3A0Qg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tmbaEpjP6Yh0UZMrvHYIFLAxsJ4toEqS8bBYnMdy2/TGw81msw+/XZMumhy3CZNBv
         HXySCQWDBKiV1PmIZBak42TSxFvls1ZngQUSg2IN5c2Brof35roaXhb+lLln4QZ63L
         qsKej7786Qw4iijryEgd0drff5/8vFXc8TIGbCYubg596A70gupRxWKblskEA4/4vf
         3GdQyVRst7+9iFyXh5gQfgUKNEMdIVaLVX7UTQup/UmDHO5nNOVZlwZ4jZzkY7phko
         62zxW9CxkHh0bOtX1S7m2XUzBqnWd89WF7IQvJJRy8nkMSeDGiD8sSl935VuoqHkfQ
         VA7/c/0uAMnXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07FAAE21EC6;
        Mon, 26 Sep 2022 20:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] drivers: net: hippi: Add missing pci_disable_device()
 in rr_init_one()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166422421502.13925.16645750292891244425.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 20:30:15 +0000
References: <20220923094320.3109154-1-ruanjinjie@huawei.com>
In-Reply-To: <20220923094320.3109154-1-ruanjinjie@huawei.com>
To:     ruanjinjie <ruanjinjie@huawei.com>
Cc:     jes@trained-monkey.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-hippi@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 23 Sep 2022 17:43:20 +0800 you wrote:
> Add missing pci_disable_device() if rr_init_one() fails
> 
> Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
> ---
>  drivers/net/hippi/rrunner.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [-next] drivers: net: hippi: Add missing pci_disable_device() in rr_init_one()
    https://git.kernel.org/netdev/net/c/0dc383796f9c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


