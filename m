Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80385E7922
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 13:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiIWLKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 07:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiIWLKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 07:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A877FA98CE;
        Fri, 23 Sep 2022 04:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C2C9622DE;
        Fri, 23 Sep 2022 11:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 757BFC43140;
        Fri, 23 Sep 2022 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663931418;
        bh=NqnuDVIMt1oSUij9cX7Jo76nv6rsncgNTT8nqoi6nWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QR6bWB+LLqQ7e7liox14c+xnJGt7kLml6Su/A9Z6wrxPV1EJLysPATe5NN1ZOPKG3
         aK3uNeuDSCn6QFBbVz1FEnbQsiWZnXjlQPoFuVGKOdHozOF3aRRbhcDL+DK9GxUp2Z
         8C8JQ+gqlP5H5Ur0T1f3cFnY+CIcXrBQZwAWkkEPe2CiBkd9LwPnBof15mQHd4v3ZC
         ox5KpLE97gtLO1mM8k9Wl6O8Jhi4TwO4sCe/+XQ9O9aWBc9oTQ4Wre9Lckqs0g0Rt/
         pusFfkmlJAB0/jj7xWfBiMWtbI6xn2JhTGciCJ9Bb+HCRgWtTuhOEX9sdlDKQ3WFf1
         qAiZ8cbu8jR0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A4AEE50D6E;
        Fri, 23 Sep 2022 11:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] xen-netback: use kstrdup instead of open-coding it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166393141836.14679.4668814171587024778.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 11:10:18 +0000
References: <20220921021617.217784-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220921021617.217784-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi.minghao@zte.com.cn,
        zealci@zte.com.cn
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 21 Sep 2022 02:16:17 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> use kstrdup instead of open-coding it.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - xen-netback: use kstrdup instead of open-coding it
    https://git.kernel.org/netdev/net-next/c/f948ac231333

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


