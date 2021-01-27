Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C621D3052F2
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbhA0GBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:01:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235914AbhA0D0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 22:26:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A325C64D87;
        Wed, 27 Jan 2021 02:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611713411;
        bh=Z6Nes6jXw39OkEoGAxpFB5QbpJAZeRxODla6luX5Hdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FoQhKKkPBxzs2jksORFnP8Sn2H5QkH0+NHt/ENvJd7pHL+tq9HK18sRXDK+ou//1M
         +yFFXLIsN+eEh303esJ/RsIhV9Y9gWP9sqisQw/aN2WmT2j5Ot9qtQrhNvhESIzJ8o
         0bxUsz0SonSbcVPT4wxX6trPmTM37uKushRJ1tkPHQ0ALycuXZKqYBzEJg4TS8U5BF
         dmSdXU5vuRBobs6uOwQgeKyNIeqOup4HOe7cZSKAKxNXdoV0XZsjVUTLizGgUeaUqf
         mm0mbbutFdAW3xaoMAHfOHAJ5aTC6YZ+HPKsyqD95y0JQ+kQbXOpruYuqfjQbQ/ncm
         yaGeDhTBek9bw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8D618652E0;
        Wed, 27 Jan 2021 02:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net: dsa: mv88e6xxx: remove some
 6250-specific methods
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161171341157.20940.9935214678600398819.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jan 2021 02:10:11 +0000
References: <20210125150449.115032-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20210125150449.115032-1-rasmus.villemoes@prevas.dk>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, olteanv@gmail.com,
        tobias@waldekranz.com, kuba@kernel.org, davem@davemloft.net,
        vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 16:04:47 +0100 you wrote:
> v2:
> 
> - resend now that the bug-fix patch (87fe04367d84, "net: dsa:
>   mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext") is in
>   net and also merged to net-next.
> 
> - include various tags in patch 1.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: dsa: mv88e6xxx: use mv88e6185_g1_vtu_getnext() for the 6250
    https://git.kernel.org/netdev/net-next/c/67c9ed1c8809
  - [net-next,v2,2/2] net: dsa: mv88e6xxx: use mv88e6185_g1_vtu_loadpurge() for the 6250
    https://git.kernel.org/netdev/net-next/c/b28f3f3c3f30

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


