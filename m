Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3162B72F9
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgKRAUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:20:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgKRAUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 19:20:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605658805;
        bh=PvhMD3Ctzz8gXhX4cE22i/hG00su5wBXv4NShmZZ81c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MmBT+KkysUsULS7rQU4vShktpuhdTj9tAGjme1qq8H0BUXS1NMlm1Fet5dA0nTrSp
         QRO2FkAo560HDHtQ6GIvtaK6mK+kQRUyAJJncv7+J65AiN8E4Y/rxIv33Uf9ODJ5Mb
         g0l+Y2lU5Ej2wHIpu+TEcpib9EZYdnFKKjnE2cEM=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] inet_diag: Fix error path to cancel the meseage in
 inet_req_diag_fill()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160565880497.13043.1047131082112615893.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Nov 2020 00:20:04 +0000
References: <20201116082018.16496-1-wanghai38@huawei.com>
In-Reply-To: <20201116082018.16496-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, lorenzo@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 16 Nov 2020 16:20:18 +0800 you wrote:
> nlmsg_cancel() needs to be called in the error path of
> inet_req_diag_fill to cancel the message.
> 
> Fixes: d545caca827b ("net: inet: diag: expose the socket mark to privileged processes.")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] inet_diag: Fix error path to cancel the meseage in inet_req_diag_fill()
    https://git.kernel.org/netdev/net/c/e33de7c5317e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


