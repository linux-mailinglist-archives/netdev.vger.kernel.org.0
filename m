Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662D24DBDD7
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 05:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiCQE4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 00:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiCQE4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 00:56:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CFF76672;
        Wed, 16 Mar 2022 21:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 551FC61772;
        Thu, 17 Mar 2022 04:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF5E0C340EF;
        Thu, 17 Mar 2022 04:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647491410;
        bh=7a+f7L0oz8IEDDEvR4RPVhJ+O5RpuwZPbYxAKeJ6eRU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rA/UegHcJdeGWwJLThyGDABLsFV3iVDG2zLN0AA7jdyfVq3/cuB2M0+76vRGfUWV9
         e5kd569c+9nZAZOdrMC5zio22abVWc/gjo5kdrfFhFxKCYWUTKPAQK5/yQftZChPJr
         lxr/m5dOtYnWpxvutTVln7GlmM4O/p+ym611Qi2C7+e+U9Pgzb822yw54AE8xbriZO
         M+ju4W/0DzQCs/FQ1RWeiRYTR2F3oH2d2P3dLuexFDX2GynaOtbBdLEqjBt2XlyVJh
         Mt1HhUJbH3m1dhuU7fv8qmJi8WjWSeFMwCCDNLMu5hR8UWm41FGi3My3Tm+2jc3Uje
         9y/7YTWnlxEpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C39AE6D3DD;
        Thu, 17 Mar 2022 04:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: handle ARPHRD_PIMREG in dev_is_mac_header_xmit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164749141056.16049.16131083554740518822.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 04:30:10 +0000
References: <20220315092008.31423-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20220315092008.31423-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, stable@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Mar 2022 10:20:08 +0100 you wrote:
> This kind of interface doesn't have a mac header. This patch fixes
> bpf_redirect() to a PIM interface.
> 
> Cc: stable@vger.kernel.org
> Fixes: 27b29f63058d ("bpf: add bpf_redirect() helper")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: handle ARPHRD_PIMREG in dev_is_mac_header_xmit()
    https://git.kernel.org/netdev/net/c/4ee06de7729d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


