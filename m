Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBBDA627C58
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236447AbiKNLaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbiKNLaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3952F5F4D;
        Mon, 14 Nov 2022 03:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0B8FB80E2A;
        Mon, 14 Nov 2022 11:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 377FFC4347C;
        Mon, 14 Nov 2022 11:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668425416;
        bh=aOH4MGwvdLyzHucsaBj3VMD/VmEWnedOzoLnOdLon8o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mIirX1OgKvi6T/devwH44uESM+66TxhXSA+4S58HqQ463LlQ2AR6VcN8NS16+yo2h
         nSpq/jPwRFmUz9Yb16SxFVGQyLBW5X+id06p9+hKRHphbnzPzjUF+LoiGWkynqPPCz
         koi3vwpaP/jEOKe/AX9mZnOZG1Tx2pqIuIpnDluHq0KsRJHXict+rzy1uTXdH3l8lG
         OdXG+XKYFCtYovlLualIyh67pcKXd5NO4CTUjV7A1KAP43wFbKx98LueJ/qcd2sv3C
         D/nX/jQHZuM3xc4MZ9BOWfDAnnlE8mqK/grxQyYq9beK84Ed2CMrgJUUJ8AFWkz5mF
         qRcjg1iDwod1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1760DC395FE;
        Mon, 14 Nov 2022 11:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next] ipasdv4/tcp_ipv4: remove redundant assignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842541609.32199.16555388041801965552.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 11:30:16 +0000
References: <20221111090419.494633-1-xu.xin16@zte.com.cn>
In-Reply-To: <20221111090419.494633-1-xu.xin16@zte.com.cn>
To:     xu xin <xu.xin.sc@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.xin16@zte.com.cn
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

On Fri, 11 Nov 2022 09:04:20 +0000 you wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> The value of 'st->state' has been verified as "TCP_SEQ_STATE_LISTENING",
> it's unnecessary to assign TCP_SEQ_STATE_LISTENING to it, so we can remove it.
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [linux-next] ipasdv4/tcp_ipv4: remove redundant assignment
    https://git.kernel.org/netdev/net-next/c/2fd450cd83e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


