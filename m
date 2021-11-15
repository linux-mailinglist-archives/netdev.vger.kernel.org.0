Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE5845070D
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbhKOOeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:34:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234216AbhKOOdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:33:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4D88863236;
        Mon, 15 Nov 2021 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636986610;
        bh=VOVUwRVkr/kXNIIgL/kNaKzI4cJyubwmaTEGwzE8UTI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kunUEfYI7DSEmlW+igV/f1phrlL8tp59D8xwm+y+HOnB/FCfOyZ7tgCaAcBN9nIbd
         l3oIHY56ypsoCI4LvN1odSHG3gPHXrMGYX+/sWl5VHFV0o8zInBxMRwQB4zofrQ9nX
         Trs0wpnD2mQwXKHKlcZ3Vrz3vNagDyLNSNs5/DdnMgoxAN1apXeKtg2PRp8AEjl05+
         +gMQdE/iOmjH7WMnuSfFG5jL2yhsGOXKA0adB27SvFgenRz0yQ/F9WPxT8gi8lkpn3
         C4MSbX5nCkty+9Gul0bNLn5NHalrFuK0k5uCFUNmOb+l+gLjfqUqXGmVI2RQzpB8hj
         3LZFIqaz7D5LQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43BD960A3B;
        Mon, 15 Nov 2021 14:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fddi: use swap() to make code cleaner
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698661027.25242.14178193132923865996.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:30:10 +0000
References: <20211115065826.5221-1-hanyihao@vivo.com>
In-Reply-To: <20211115065826.5221-1-hanyihao@vivo.com>
To:     Yihao Han <hanyihao@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@vivo.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 14 Nov 2021 22:58:16 -0800 you wrote:
> Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
> opencoding it.
> 
> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> ---
>  drivers/net/fddi/skfp/smt.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)

Here is the summary with links:
  - net: fddi: use swap() to make code cleaner
    https://git.kernel.org/netdev/net-next/c/311107bdecd1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


