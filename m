Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9454F364DAC
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhDSWau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhDSWaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 18:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 71828613AA;
        Mon, 19 Apr 2021 22:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618871416;
        bh=lLxmA2Lr1plWQnPoYcvGR6hrKItAx102K97tvUMt9oQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c6DglxVUNXBjHADFJSyFX5JZsnMLBxfyF66FfuLuVC73eKrwGlShzHgtlcjVEVvpT
         nbtAlE/GjvW5kxKfxP6h/DFYcJGBgga7xWTv85atGI7h6yFxxeQbVeztFa69bUAyxw
         5+KB9+dUxWcP9FZrhCSYTCodG4OSPVCZvEuZNG7l5PCebCXs9C13fZdS4O7usgr+xE
         tAKT7QWy/2c7aSyLbPOwZ2Cyi6dPkZ8bdLlYW5hThPT7dkWuMd1GqxtYLObshqcm1+
         DY8OBKJtXH6Trd1Chn07XIwO+emT7ZfIQChhhRgMp5ORKI6C7Ty9dnjeZoC9HUjef6
         hiCP+QdcwdZVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6156960A13;
        Mon, 19 Apr 2021 22:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mld: remove unnecessary prototypes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887141639.15331.6203636309511637253.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 22:30:16 +0000
References: <20210416174148.26589-1-ap420073@gmail.com>
In-Reply-To: <20210416174148.26589-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 17:41:48 +0000 you wrote:
> Some prototypes are unnecessary, so delete it.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  net/ipv6/mcast.c | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - [net-next] mld: remove unnecessary prototypes
    https://git.kernel.org/netdev/net-next/c/83c1ca257aca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


