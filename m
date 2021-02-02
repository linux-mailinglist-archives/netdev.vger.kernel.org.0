Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2903530B636
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 05:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhBBEKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 23:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229872AbhBBEKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 23:10:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A96E064E88;
        Tue,  2 Feb 2021 04:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612239006;
        bh=jA+B1fRAhIqXgs5fIl3glpTBv5J2E0gKuYmLcplUSdc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q7tXAOSpvFDKcaxwUcQ5UOQnF/7ApTUJ/w8JQD2GXNM0OOUX1NJFvFxD61N99g7b5
         xHmsr8WSi7cZWEGv56UrB5J9Nk6vwdg9VlUE/fh2GbO8CyGF6qk21MxK4d+Q8H/0j2
         YCAbRFhW6VQUaYZDtYJR3TDKhQc7v6g8aMlt4ZZjzE+NsupFBLPnGu9LRZ/QvQ+6HH
         Zcf9/K9idnbwf8RFd50TJBRJuVReMF3/VwPgwjmyZ1iNuBP8x3452e+522/Gyxo8wJ
         CAY9hSVmFPqvvrHahiKhv8abg5bomrIXCufOhHUQJD2PA9LvsE03kXKM3NDvlKEJke
         2CtvuWx9cFKMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8E7D260987;
        Tue,  2 Feb 2021 04:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND net v3] net: ip_tunnel: fix mtu calculation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161223900657.412.2704990087865304272.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 04:10:06 +0000
References: <1611959267-20536-1-git-send-email-vfedorenko@novek.ru>
In-Reply-To: <1611959267-20536-1-git-send-email-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     kuba@kernel.org, willemdebruijn.kernel@gmail.com, mail@slava.cc,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 30 Jan 2021 01:27:47 +0300 you wrote:
> dev->hard_header_len for tunnel interface is set only when header_ops
> are set too and already contains full overhead of any tunnel encapsulation.
> That's why there is not need to use this overhead twice in mtu calc.
> 
> Fixes: fdafed459998 ("ip_gre: set dev->hard_header_len and dev->needed_headroom properly")
> Reported-by: Slava Bacherikov <mail@slava.cc>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> 
> [...]

Here is the summary with links:
  - [RESEND,net,v3] net: ip_tunnel: fix mtu calculation
    https://git.kernel.org/netdev/net/c/28e104d00281

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


