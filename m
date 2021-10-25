Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1E3439A9F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 17:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhJYPmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 11:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231686AbhJYPma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 11:42:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DA9B860F02;
        Mon, 25 Oct 2021 15:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635176407;
        bh=hKVVw4yw1imWqG8Vq/yJOZAzUmP0gUXp/yz/oTMPibc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qr4WOR1BQ5AG12YZZ6Evj9r0UyimWgcsxB2FLX+FfwyrQ0udNL9wquwcTmQcQWYuG
         Vm1JHfbSbChC+ZRUmLp4VcGrpgfcQAHUC8xR2ftmUG5KXIjxsHEo9w4NzdNhiOM9k6
         wIQd3rskOjgXsMEuaGLJsP51CnLcoqVM7Gtl+osQEo3pIOiRPonc/g4I5VdFUaO8bL
         liJ2Q5Kb+rmz17XI0Zzs41BWpgO/gr0SpcR9OUC+vkldnQ7vCitMkWwgB3+Uxm46Tt
         sc7LdcNLYigyilcKVKbmD47nbYfDZy48h0GhwiScL+GIhApg7LbLRn4aiaS2t6yLhB
         gnmMxJnNduc1Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CCC8C60A90;
        Mon, 25 Oct 2021 15:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/tls: getsockopt supports complete algorithm list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163517640783.4268.1674653318729555434.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 15:40:07 +0000
References: <20211025130500.93077-1-tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20211025130500.93077-1-tianjia.zhang@linux.alibaba.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 21:05:00 +0800 you wrote:
> AES_CCM_128 and CHACHA20_POLY1305 are already supported by tls,
> similar to setsockopt, getsockopt also needs to support these
> two algorithms.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  net/tls/tls_main.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)

Here is the summary with links:
  - net/tls: getsockopt supports complete algorithm list
    https://git.kernel.org/netdev/net-next/c/3fb59a5de5cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


