Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DD62D8A2A
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 22:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407999AbgLLVkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 16:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407975AbgLLVkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 16:40:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607809207;
        bh=BKJvtDa5hSmn11D+3Z5yA4uEBWEtn1uQyA7O98hcttg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pzP8X8Io0sMvX5D9awjuHbDkjjfnHHHq8tvcSwqeFAa+d75RcN+mXFSYPA75vmplF
         4aWNXSdmUcWn7LZciclPQX9Dt8fFOMkITaO6k+EsmR1hgkaNJrJUlgiysR4Rz9i5UL
         ydb7V2gn0nQ7CycN2auE5LBgBJOM6MJgUzamsuFQPJHFHmXbh/g97jZi4CY8qBwF46
         Z6h72nxYH4xRsNx80SOdkvdwyjOq0DBItyfocAFjTN/HzYU4R/aLYn7BsujgjDBB0O
         FrgyOrzzW3RXILNTDpSzYOmTtfDQxGRLFJpBdK9qcm9hmFXSM2oa4ywW5+3Lm0pTqi
         QfkR9tWjEIZ6Q==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] xfrm: redact SA secret with lockdown confidentiality
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160780920694.16761.16740586954309280912.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Dec 2020 21:40:06 +0000
References: <20201212085737.2101294-2-steffen.klassert@secunet.com>
In-Reply-To: <20201212085737.2101294-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 12 Dec 2020 09:57:37 +0100 you wrote:
> From: Antony Antony <antony.antony@secunet.com>
> 
> redact XFRM SA secret in the netlink response to xfrm_get_sa()
> or dumpall sa.
> Enable lockdown, confidentiality mode, at boot or at run time.
> 
> e.g. when enabled:
> cat /sys/kernel/security/lockdown
> none integrity [confidentiality]
> 
> [...]

Here is the summary with links:
  - xfrm: redact SA secret with lockdown confidentiality
    https://git.kernel.org/netdev/net-next/c/c7a5899eb26e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


