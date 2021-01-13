Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6AE2F4325
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbhAMEav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbhAMEau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E50132313A;
        Wed, 13 Jan 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610512209;
        bh=kIzr/I9Xt36/NurmKh6Nmc8yYsVTtaczDi1P+uFReWU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U1pxlmmnIna0Ukv9TBIiQ5eGqNkDQLanthTFCSHgAMXdK1bVK690EhtMJ4+5eKIIn
         vehsbt9cFgn6K13lYDcBPKolMNJGckB4BiwFdzOYJnyn0MSEUw99KcI0aaz9XsAPcN
         +rsojWYqcCUn6GRy53IZGWmCJ5+oD9QFuygNUh0Z3vjG6+j2WE1IaKfgW9tzGi84uZ
         +UmEgIyYZXfEFQ3ToS+a4m+BY4+FkRTr+g0e2lxTto0n99TGckzg5PX18rHNfq+WRz
         l1cnbKl2+ccmEdvnKNMegmqVbavrs0v8Kf8ZO4hoPqaIUjVcrbE1nVbOnX8JzuShvh
         m0qBbTOEkf/xQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id DBE7260593;
        Wed, 13 Jan 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hci: llc_shdlc: style: Simplify bool comparison
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161051220989.5581.1573398344013249741.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jan 2021 04:30:09 +0000
References: <1610357063-57705-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1610357063-57705-1-git-send-email-abaci-bugfix@linux.alibaba.com>
To:     YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 11 Jan 2021 17:24:23 +0800 you wrote:
> Fix the following coccicheck warning:
> ./net/nfc/hci/llc_shdlc.c:239:5-21: WARNING: Comparison to bool
> 
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci Robot<abaci@linux.alibaba.com>
> ---
>  net/nfc/hci/llc_shdlc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - hci: llc_shdlc: style: Simplify bool comparison
    https://git.kernel.org/netdev/net-next/c/f50e2f9f7916

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


