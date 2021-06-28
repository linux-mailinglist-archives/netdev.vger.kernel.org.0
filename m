Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B68E3B69D3
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237495AbhF1Unc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236739AbhF1UnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 16:43:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 69F3461CE4;
        Mon, 28 Jun 2021 20:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624912854;
        bh=CajqUMecoADBkbeoaKzPXIX7jkPoVWBcpxW+ih912Nc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R2jJhCSc4wSD4vvlubUzrOObNeknGUtx60loLfAThVfTTX1RCsgAYifz0WGQIoi9l
         PT32E0Lm3SiC3l2PGyI4Wh+V2evHdPLX9T4VCqmLle655cfgnobVMAzNuf05T7mBfZ
         Ew2JgwEVhxz7QJ8bJgv6+MwRoFUJvdjxKMUPDujzbqpJ2Okg9lUcuvHPCASk1Wjw4p
         SJ0q3hFTrUYv8Ot9ECuyiq7gGspB07ql7b8GWI0/04eRiPduKndp79j0nkcOWkP7Ed
         1lB83Yn13PqQuzIMEV0NS4CGyI317xs+DDazrnRQmlE6fZrNq4iiWvO8VzQ0AWGqWt
         uUXE6UJi4i5Kg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E75860A6C;
        Mon, 28 Jun 2021 20:40:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net-next): ipsec-next 2021-06-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491285438.18293.5911624500438120439.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 20:40:54 +0000
References: <20210628054522.1718786-1-steffen.klassert@secunet.com>
In-Reply-To: <20210628054522.1718786-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Mon, 28 Jun 2021 07:45:05 +0200 you wrote:
> 1) Remove an unneeded error assignment in esp4_gro_receive().
>    From Yang Li.
> 
> 2) Add a new byseq state hashtable to find acquire states faster.
>    From Sabrina Dubroca.
> 
> 3) Remove some unnecessary variables in pfkey_create().
>    From zuoqilin.
> 
> [...]

Here is the summary with links:
  - pull request (net-next): ipsec-next 2021-06-28
    https://git.kernel.org/netdev/net-next/c/1b077ce1c5be

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


