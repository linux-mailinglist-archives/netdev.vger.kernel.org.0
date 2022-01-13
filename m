Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7AD48D866
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 14:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbiAMNAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 08:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbiAMNAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 08:00:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C916C061748;
        Thu, 13 Jan 2022 05:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 982ECCE2023;
        Thu, 13 Jan 2022 13:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAE1AC36AED;
        Thu, 13 Jan 2022 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642078811;
        bh=Pcp2+IA9W2UqzZ3KCK/QZsr41sDDGaYv1iGIzsGnkLs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s8ZP0yPIW7qxXczd2S0UYyU9alNOJpDj7xal5H32hGZOLikRbL6oSOjundaYXguca
         6ECNw+vcRp5DZgPzNmIYJ63V8/K9ECuePte7DoUrzbcfoIrLbvBR102G0W+2CoII5O
         dOOtAfXFPh2ewin57jcaRutJdz+2oOPChOUq5Zxn2skN5SeVTSbh30OiqNC/HyMu/a
         J/fcLVP5n9O8AFm3UgHCKaO6GGUgiBs4tDWXotU1JzlT0rFYGuf7wrei7Ti0Pqp9GE
         qUpw5l747cYcgJmd4pdsLHAWEmnW56HuUEuO0qDUJzw1FFoafGQtE0r/jlDDB5Ixbv
         pSgRgE9hX1dNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B627AF6078E;
        Thu, 13 Jan 2022 13:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atm: iphase: remove redundant pointer skb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164207881173.26897.4543675322027026942.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Jan 2022 13:00:11 +0000
References: <20220112235533.1281944-1-colin.i.king@gmail.com>
In-Reply-To: <20220112235533.1281944-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 12 Jan 2022 23:55:33 +0000 you wrote:
> The pointer skb is redundant, it is assigned a value that is never
> read and hence can be removed. Cleans up clang scan warning:
> 
> drivers/atm/iphase.c:205:18: warning: Although the value stored
> to 'skb' is used in the enclosing expression, the value is never
> actually read from 'skb' [deadcode.DeadStores]
> 
> [...]

Here is the summary with links:
  - atm: iphase: remove redundant pointer skb
    https://git.kernel.org/netdev/net/c/d7b430341102

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


