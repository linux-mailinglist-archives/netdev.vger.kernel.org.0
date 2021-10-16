Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F042430108
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 10:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbhJPIEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 04:04:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239875AbhJPICc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 04:02:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2DEFA61262;
        Sat, 16 Oct 2021 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634371215;
        bh=s4nLj3p5TCl8eoQynUVAfkz9NXDeqvDunm2+lTWXVbM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jOr8qXl/2tGOUOBb1LCeKhSV31vhNm5XjqR21i1jyUOpw84HnThyJw38xprigNz3U
         Soz8PyvAUI227id+7Iv///ujEAIpGZkaofUJeP9PW7ThqbiOeda4tbtvA2NxqlVr/E
         3O2D2bE+mbM2wek0d02TO0rewCkcBeaE8Oas2qm0PtBlrpo48I29bZ8VIKAKxVnJZY
         0+gZnGeuiNrEFoAKI2ca2C/nJbBsM4fDZePPM1Ta3MvG7iO3JSfx360ulNj6xsJHVz
         JuhpP6H2ZnbwKbcu76W4Nxj1GHIwDqZbD6wN8PiCvBIcGONS/L+YCWQNFnlkBSds+R
         HIkYfxWK07JaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 21A2460BBF;
        Sat, 16 Oct 2021 08:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net: macvtap: fix template string argument of
 device_create() call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163437121513.28528.3625194342664164879.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Oct 2021 08:00:15 +0000
References: <20211016054136.13286-1-sakiwit@gmail.com>
In-Reply-To: <20211016054136.13286-1-sakiwit@gmail.com>
To:     =?utf-8?q?J=CE=B5an_Sacren_=3Csakiwit=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Oct 2021 23:41:34 -0600 you wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> The last argument of device_create() call should be a template string.
> The tap_name variable should be the argument to the string, but not the
> argument of the call itself.  We should add the template string and turn
> tap_name into its argument.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: macvtap: fix template string argument of device_create() call
    https://git.kernel.org/netdev/net-next/c/1c5b5b3f0eab
  - [net-next,2/2] net: ipvtap: fix template string argument of device_create() call
    https://git.kernel.org/netdev/net-next/c/a07a296bba9d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


