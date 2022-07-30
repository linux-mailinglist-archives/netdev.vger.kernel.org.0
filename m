Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E9C585837
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 05:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbiG3DUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 23:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239901AbiG3DUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 23:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0B511C0D;
        Fri, 29 Jul 2022 20:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DEE661E1F;
        Sat, 30 Jul 2022 03:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68BDAC433D7;
        Sat, 30 Jul 2022 03:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659151213;
        bh=BU05k1RmfI27OBNJ0nv7T2zAOgU7pL0n2DHQdEesnNw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OrXRup5D1sSRzfsZ3wKiA1RS5GYo2qcuRx1SvLhLcDjUv7MoF2ukZhbF5X/zkNf1e
         jCGXwf94tEJ6zfPAAR/wpDPNCA7lNt8QybBnRp7RbzPw/b21eP2piOTjGfRJMXSOFU
         krWNwCkM0aHQ+M2+DO23+3Oecyv1k/UAz1H5cfwkGHLNqCu5gkfLVAI+NvAn0Pos1S
         nj7uHma65sqj3XTF8azw5iou9Jgl6GHoOSBwBTKNdzYPKBbd+AbI8w/+m4Xt7ZdP/a
         rhwdh8E0wBcObuTI3Xtpb69dDhwGLHIoD3TQ+1D7AjeLdu5uhSBvXTGU1IrKVfIzmh
         G3+YpWVnJj/XA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E1C5C43143;
        Sat, 30 Jul 2022 03:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] dn_route: replace "jiffies-now>0" with "jiffies!=now"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165915121331.30588.12581008558390777310.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jul 2022 03:20:13 +0000
References: <20220729061712.22666-1-yuzhe@nfschina.com>
In-Reply-To: <20220729061712.22666-1-yuzhe@nfschina.com>
To:     Yu Zhe <yuzhe@nfschina.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-decnet-user@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, liqiong@nfschina.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 29 Jul 2022 14:17:12 +0800 you wrote:
> Use "jiffies != now" to replace "jiffies - now > 0" to make
> code more readable.
> 
> Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
> ---
>  net/decnet/dn_route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [v2] dn_route: replace "jiffies-now>0" with "jiffies!=now"
    https://git.kernel.org/netdev/net-next/c/0f14a8351abd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


