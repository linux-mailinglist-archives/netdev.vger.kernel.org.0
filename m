Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4243F980F
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 12:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244724AbhH0KU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 06:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233204AbhH0KUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 06:20:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 02A8060FE6;
        Fri, 27 Aug 2021 10:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630059607;
        bh=/l5d8juEeqiYK/KEiSZ5FKobIhaxog4kQirW3hionhQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jWqCwkZY7rsxM8AlgXb5EH1GVlfWJLgC6yI9WJUkhCXX4jTK6wryYv5u/voQSgbiE
         9nOWJ2lYuG/apyICHaJ5nDbLT9E6MqDpnjYS4PBhF/GIcqBzOmc29ZyjXRzpDOzQ+S
         AZEC67Y8cGPtWBA87+urGUDwLWgeo5piAuYFDiBNhZghTC71M38kzt8CUr2IzqRITB
         pf1yTGbb0BkwCqY00doagq2CwHkS6SI0p/txo4mnkCEwvj/D8ZN0ApSsRrkMZst881
         IfzkbKzToUbxSc69+5eagVXzsuUhbNFQlve4Ma7w5y5arWB5Lg9/k87hBTbrZCrsx9
         UF1lh6JMPxgPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB7B0609D2;
        Fri, 27 Aug 2021 10:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net-next): ipsec-next 2021-08-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163005960695.4453.11461822658020938423.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Aug 2021 10:20:06 +0000
References: <20210827075015.2584560-1-steffen.klassert@secunet.com>
In-Reply-To: <20210827075015.2584560-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Aug 2021 09:50:12 +0200 you wrote:
> 1) Remove an unneeded extra variable in esp4 esp_ssg_unref.
>    From Corey Minyard.
> 
> 2) Add a configuration option to change the default behaviour
>    to block traffic if there is no matching policy.
>    Joint work with Christian Langrock and Antony Antony.
> 
> [...]

Here is the summary with links:
  - pull request (net-next): ipsec-next 2021-08-27
    https://git.kernel.org/netdev/net-next/c/fe50893aa86e
  - [2/3] xfrm: Add possibility to set the default to block if we have no policy
    https://git.kernel.org/netdev/net-next/c/2d151d39073a
  - [3/3] net: xfrm: fix shift-out-of-bounce
    https://git.kernel.org/netdev/net-next/c/5d8dbb7fb82b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


