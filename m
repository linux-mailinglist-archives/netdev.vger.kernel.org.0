Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0949145A1E2
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhKWLxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:53:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236526AbhKWLxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 06:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B05261055;
        Tue, 23 Nov 2021 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637668209;
        bh=bqbpTCjbIX4Z2tnM0b5x2jEWV2GELpO5KylDWv+vv/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QjyKmIhrky4QAcdlQbNaY3QUriNnS9KuVwjrKYJm2QfSxP9ABUSXHRcrQu4W3Wpkl
         ObYnmkaxmwJPb6Ebz2vwPSfhXSQzwBoUQAlGXn/RW0SP1vggQo+YxIj+X+D0F1mzO9
         cNhgvBWpWjeDUHxYH4kz+LsSWSiEIe1PeSbVpyTeURncJ29prs6LFVY3C6l0dDAT0j
         Vkr7vDliFPCT3iJgi0y/i9uiZjrXI412PttvGGR2kiQQAzW7Uu0xFw+DBwv325X09x
         W0EWDrHaRfqczjdW3RbV6YwJRNPVw46kwOhGw/Bx7dD7XJr1KFX9i7I0p13hyt2km8
         nUCSJWL81WJVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8BEBB60A50;
        Tue, 23 Nov 2021 11:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] hamradio: fix macro redefine warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163766820956.27860.5025106023306313439.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 11:50:09 +0000
References: <20211123110749.15310-1-huangpei@loongson.cn>
In-Reply-To: <20211123110749.15310-1-huangpei@loongson.cn>
To:     Huang Pei <huangpei@loongson.cn>
Cc:     netdev@vger.kernel.org, ambrosehua@gmail.com,
        linux-arch@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 Nov 2021 19:07:48 +0800 you wrote:
> MIPS/IA64 define END as assembly function ending, which conflict
> with END definition in mkiss.c, just undef it at first
> 
> Reported-by: lkp@intel.com
> Signed-off-by: Huang Pei <huangpei@loongson.cn>
> ---
>  drivers/net/hamradio/mkiss.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [1/2] hamradio: fix macro redefine warning
    https://git.kernel.org/netdev/net/c/16517829f2e0
  - [2/2] slip: fix macro redefine warning
    https://git.kernel.org/netdev/net/c/e5b40668e930

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


