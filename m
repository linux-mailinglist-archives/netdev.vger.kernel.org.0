Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA95255F554
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiF2EkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiF2EkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:40:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79CD2C64D
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 21:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BBF39CE2302
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF059C34114;
        Wed, 29 Jun 2022 04:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656477613;
        bh=7XfvAnucj7e4fCFu8ugtN2fF5Sp3Dr1boAzqGoRnHBw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LKb9o/IybQYiwGRfYb/6bRsjopnkZtVMfpqDQ1VaPBRqbcMIt7s19U7wYB1hGco7m
         rpgH0w23rLpa31GkXwLWGsXTVobWkdWdE7GgcLEIQDwm/05gt0j231gT7ibcO+y6PI
         ThdXygfYmm2IKM6BbFkYFYz1s1o7ITITDAcbZwLD4R7uyamwYu8270LhOIr8H/mc0b
         oMlv2k3H1p94Os/AXbra3kcAw0nLHElOSTCAEBrMU53Wm30r4zl9wzIvQrKOqUT6Oo
         IDLI0hvyA3d85zKFVkVZvZJxeKZ54TpTBCnOVXuMKDYvETj0Lox8LaLkLT1tL0IOmM
         SCsSAcsyu/B6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2D1CE49FA1;
        Wed, 29 Jun 2022 04:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: diag: add support for TIME_WAIT sockets to
 tcp_abort()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165647761286.961.12856503272571960334.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 04:40:12 +0000
References: <20220627121038.226500-1-edumazet@google.com>
In-Reply-To: <20220627121038.226500-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        usama.anjum@collabora.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Jun 2022 12:10:38 +0000 you wrote:
> Currently, "ss -K -ta ..." does not support TIME_WAIT sockets.
> 
> Issue has been raised at least two times in the past [1] [2]
> it is time to fix it.
> 
> [1] https://lore.kernel.org/netdev/ba65f579-4e69-ae0d-4770-bc6234beb428@gmail.com/
> [2] https://lore.kernel.org/netdev/CANn89i+R9RgmD=AQ4vX1Vb_SQAj4c3fi7-ZtQz-inYY4Sq4CMQ@mail.gmail.com/T/
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: diag: add support for TIME_WAIT sockets to tcp_abort()
    https://git.kernel.org/netdev/net-next/c/af9784d007d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


