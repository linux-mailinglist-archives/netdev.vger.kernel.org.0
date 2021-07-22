Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6953D1E1A
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 08:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhGVFje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 01:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231213AbhGVFj3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 01:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3756D61287;
        Thu, 22 Jul 2021 06:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626934805;
        bh=1tOkVdcqWvv8NCaTJz2wGxUAHtdnRs1/WRnGdDS5XBo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TYr7NSx3WpTJ1Z4b7j5V6fBEtdtbiVHuGOYWdXNUz/FOX7/5soAzU4PYPGIyepEvL
         Y2ngMtKruElFwlsUorLmdXsaKEwCO+e+5pVDPL06k6tPHVKkLZjOyFFj6U+gt6XWO2
         ZTFDpZjvyA5RYnvSWiIppnUOafcsQpM3vc93Y9Y7ep0jKYCcrgNp5wgwfRNOroZU4w
         pf0siNrl8Wmt5ASbitN4F5Rz5EDtTL6FZlPsuavrKY/VvE1HCp6ww2r+y8A9WaPNa8
         6VnRhiQBQT9Y3q0tdwQr/DLirYoOGic7B1JMdwTz/qdnqHgyI66oG/zAvNJ2dFIExA
         i02D+wAdUqu2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 297C160C09;
        Thu, 22 Jul 2021 06:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ravb: Remove extra TAB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162693480516.4679.2580254083230388638.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 06:20:05 +0000
References: <20210721182126.18861-1-biju.das.jz@bp.renesas.com>
In-Reply-To: <20210721182126.18861-1-biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     davem@davemloft.net, kuba@kernel.org, sergei.shtylyov@gmail.com,
        geert+renesas@glider.be, f.fainelli@gmail.com,
        s.shtylyov@omprussia.ru, aford173@gmail.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris.Paterson2@renesas.com, biju.das@bp.renesas.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Jul 2021 19:21:26 +0100 you wrote:
> Align the member description comments for struct ravb_desc by
> removing the extra TAB.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - ravb: Remove extra TAB
    https://git.kernel.org/netdev/net/c/9f061b9acbb0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


