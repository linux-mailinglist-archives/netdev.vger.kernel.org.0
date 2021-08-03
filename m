Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA573DEB77
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbhHCLAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235549AbhHCLAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D97FA6112F;
        Tue,  3 Aug 2021 11:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627988406;
        bh=wTFUtRXlHb3817XlTGJsb1KVM3G4zKnll9BSqp8LD7Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kinl6f6zpJQEvyEfdhNivk9myMmV3jLGgmGObR22QkEgHTnfmav16ZXsrJlp43675
         pL7luYga8QmrWi+ZmewdkujOdrntO8ylhRNevoJMrDNVG6/KK48T27PrrEYQ6/qDcu
         2+pRjk2mopAA84u22WWzwEu8Hy2VCcLtrxYy/RipU517akcDPR3wXHy+Jp2zDcclkb
         QtsJX3tEI3wWOV0bWZAMPvsot5Fyw8byETbiRDsFE/lL2t3G2eNBg9+TNtQZgEGbS7
         t9ltBXEm5Jh5VKu/frVIBwArMH9NKUAV7oQ//9dZyuegJf9H34Ca6A+RWlPXa88M2A
         RmJqIxkP4oZ8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D138660075;
        Tue,  3 Aug 2021 11:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: Remove duplicated include of kernel.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162798840685.8237.13025716118269286394.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 11:00:06 +0000
References: <1627870718-54491-1-git-send-email-zhouchuangao@vivo.com>
In-Reply-To: <1627870718-54491-1-git-send-email-zhouchuangao@vivo.com>
To:     zhouchuangao <zhouchuangao@vivo.com>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  1 Aug 2021 19:18:38 -0700 you wrote:
> Duplicate include header file <linux/kernel.h>
> line 4: #include <linux/kernel.h>
> line 7: #include <linux/kernel.h>
> 
> Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - qed: Remove duplicated include of kernel.h
    https://git.kernel.org/netdev/net-next/c/2414d628042b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


