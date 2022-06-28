Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAC255D252
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbiF1Fk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiF1FkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC4813E8B;
        Mon, 27 Jun 2022 22:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32D41B81CA8;
        Tue, 28 Jun 2022 05:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 413BBC341D3;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656394815;
        bh=iJ1YJ/ueThnJRFI/oHc3wie5a9BpEazUh3mHHl4EwmU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CVE93Z3HTtiaq3315VAkFCeyWxQ9hspxrYPzN/dQzdwwQhMaYRdYzMaNQ5p39DBrE
         s4HSe6n9Hhmhqi/9nGBChUzvxCZVvZQrE763FbZrr0JsIjOdfIa9Ma8ML1MxIdjeXQ
         nRAULkfRSRZ9Rk8fMXk9nbfuZL86rw2CtMq9T0xo0FEkyDDMe5QKzWBG9i1FmMC24G
         FEcZaj+fXdOA6KTOOC7FxPmNppUXLSmbQ6x32O2KhfKdvu/2zQCu1uJlejVbeSe7EN
         FjTUSyohwsmXybNwJqsvS5mL3rNcylUVt+prO7J3S+q1iAycLhz8Iel1HsxMEhpF69
         r60toCbIhR7Ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 267B2E49BBA;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: atlantic:fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165639481515.10558.17557355050917116788.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 05:40:15 +0000
References: <20220625071558.3852-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220625071558.3852-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, irusskikh@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Sat, 25 Jun 2022 15:15:58 +0800 you wrote:
> Delete the redundant word 'the'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: atlantic:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/63769819079d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


