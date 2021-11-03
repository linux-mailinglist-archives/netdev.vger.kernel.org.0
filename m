Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47212443ACF
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 02:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhKCBWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 21:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhKCBWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 21:22:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 53FDC610C8;
        Wed,  3 Nov 2021 01:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635902408;
        bh=e2oXP+9pkm8F8thNJGF759mOg8xwyBb2BE+EwmZ3CJc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lSX9SiGNf0DbkEkYEnTQuS1taCMxLaxHcOcFyCxVmkd2zLZ9xeQ0YDZIdx0IndyjW
         gApJWPbGVNThOw1rhXOQxGKlB86MZnlQPf4at6riDn17zsgMRVUWrra48SSYsvMbKF
         66/Cv9kEokWPOxLclgB8sGHuDNaR0mlkS5WqvzdJ1zvJBtTTQtxPzLtYzLoMfNrrWH
         0nqiP2PzZRcfHFOMRQsu4bbT3627ENRBIL+5ru3zf/18viwRVB/duHhfzrqhu2j+Ro
         gsZe5ghbIyzAI4pwnYNkYMy6Fe5G6eie74BDeChjZSzJkK80LIgyKtTVrUxRW+a9tZ
         djN7yDsDuQZ9Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D91860BE4;
        Wed,  3 Nov 2021 01:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnxt_en: avoid newline at end of message in
 NL_SET_ERR_MSG_MOD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163590240824.27381.3769489581985147239.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 01:20:08 +0000
References: <20211102020312.16567-1-wanjiabing@vivo.com>
In-Reply-To: <20211102020312.16567-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     michael.chan@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiabing.wan@qq.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  1 Nov 2021 22:03:12 -0400 you wrote:
> Fix following coccicheck warning:
> ./drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c:446:8-56: WARNING
> avoid newline at end of message in NL_SET_ERR_MSG_MOD.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - bnxt_en: avoid newline at end of message in NL_SET_ERR_MSG_MOD
    https://git.kernel.org/netdev/net/c/6ab9f57a6489

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


