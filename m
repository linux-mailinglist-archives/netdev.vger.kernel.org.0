Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A31618FBB
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 06:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiKDFAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 01:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiKDFA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 01:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334FA165BA;
        Thu,  3 Nov 2022 22:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1E0B6202D;
        Fri,  4 Nov 2022 05:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 789D3C43155;
        Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667538027;
        bh=ZHfBYU+UqBBWzQCD0LvBgUi3WgENgVy3SC2izp4q7l4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G3K6QJ4DzKMuNQpDA5CwL9jjZOlepXsX8K8If1AkJHDPd4hbsxtTsGhv76izWofdB
         ysOfH3q8ehqipKSpCTZGWzs+UA6qZhQtZMStIQnYXkm5pIw2KBfe/sbCFMLWKTtH1j
         Hhk3aOPC2n9VPcPA79IZaoJAYIefqz9s/Tjh075T7S+Xmr4tclCQfxPijJzXTzJbUt
         gGaZqxB2ogqadpzARPKRb2ZVISVmJrOHCbUqxGVZyzFuZTef7NWhAzOtuZfzbP4+ar
         o2ol7Y7HEyr1s7iYuFG0uLODkA2CMyuDIl5mk1lCU6Tpsr3dIBGaaONAiY73+TeffQ
         hlzztRIm6moLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13179E5250A;
        Fri,  4 Nov 2022 05:00:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next RESEND] net: usb: Use kstrtobool() instead of
 strtobool()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166753802707.27738.6412621287669031939.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 05:00:27 +0000
References: <d4432a67b6f769cac0a9ec910ac725298b64e102.1667336095.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <d4432a67b6f769cac0a9ec910ac725298b64e102.1667336095.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     oliver@neukum.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, bjorn@mork.no,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  2 Nov 2022 07:36:23 +0100 you wrote:
> strtobool() is the same as kstrtobool().
> However, the latter is more used within the kernel.
> 
> In order to remove strtobool() and slightly simplify kstrtox.h, switch to
> the other function name.
> 
> While at it, include the corresponding header file (<linux/kstrtox.h>).
> 
> [...]

Here is the summary with links:
  - [net-next,RESEND] net: usb: Use kstrtobool() instead of strtobool()
    https://git.kernel.org/netdev/net-next/c/c2cce3a6e8eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


