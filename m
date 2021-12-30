Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FDD481C85
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239568AbhL3Naa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:30:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52860 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239557AbhL3NaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:30:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4845EB81C53;
        Thu, 30 Dec 2021 13:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B4C0C36AF3;
        Thu, 30 Dec 2021 13:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640871013;
        bh=17RmdGqWkioDW2fwqSLhW0QRgjoGBQPUVfZDNIsEB8E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gP4S6TF/pW8UE/+7yQVopi9iNBzeBNcZFn4etnrJA0ds3QaLCUa0AFnSTvdjvI1a3
         vOG7cr+R+xTbgdT6ZXQsjbkRb0LqqfngWMFG8a79bQhJxXmfFaw9MmILTNFINeF6VP
         qOIfBSHa0+YHnEodD163S+uebhhGyglBVBKyOFJxmRj3HVxnfCj5zfwROwNwajstby
         lVIKJYUH160XsHcdfdQYs2BiHopsvaEzmwHpBGgJS4fwKd5BzqMAYC0tkkWExJKCTd
         GKg47crzu/isHzB60SqssVKzwmaB70hPirXWd5cXqUSkqr2D5GrnGMotr47Q0D9aOh
         dWt7CA44dzWMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB888C395E4;
        Thu, 30 Dec 2021 13:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lantiq_etop: make alignment match open
 parenthesis
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164087101296.9335.13489218151106206704.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 13:30:12 +0000
References: <20211229233952.5306-1-olek2@wp.pl>
In-Reply-To: <20211229233952.5306-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     davem@davemloft.net, kuba@kernel.org, jgg@ziepe.ca,
        rdunlap@infradead.org, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Dec 2021 00:39:52 +0100 you wrote:
> checkpatch.pl complains as the following:
> 
> Alignment should match open parenthesis
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/net/ethernet/lantiq_etop.c | 34 +++++++++++++++---------------
>  1 file changed, 17 insertions(+), 17 deletions(-)

Here is the summary with links:
  - [net-next] net: lantiq_etop: make alignment match open parenthesis
    https://git.kernel.org/netdev/net-next/c/7a6653adde03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


