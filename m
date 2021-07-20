Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21453CFBFD
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbhGTNnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239968AbhGTNj0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:39:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E2EE61186;
        Tue, 20 Jul 2021 14:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626790804;
        bh=Hz4FNLak5VJYRl+KXz/n6BUtZZ/PWKMQPeyrBu6FRw8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t0HmVUSzdOXs2NTWhrROspItwTWWcmjsV2OTBARly3x4TEtaC6ioytqNSYJkl9hgf
         GAD+d2te4H0kkGMjIKCM0WF7pvXc5osC26Mq1Lo68usmBkCxLJ5y15VZrS++9Dpoca
         MVnQnswtFZTscYlz06j1qeosziuatv8DZM1eO4Eep5WNcDZZsoZeYZ6UDrJywktVYs
         hcS9hSXlGU5xPTi1h8MFWwGR/Dr/7fFP/IgRIjk7flpsCTMm6MB7HFVTaXqew7TNdM
         xHBPzKGihKLuyMs8SxVDZ3myAL2rERWzdlzNKxXnXDTjCFwGasEtP+Xb7+wAKCku5t
         z9Poz2Ra76tqQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 42E3360CD3;
        Tue, 20 Jul 2021 14:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] fsl/fman: Add fibre support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679080426.18101.13696128057221560266.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:20:04 +0000
References: <20210720050838.7635-1-fido_max@inbox.ru>
In-Reply-To: <20210720050838.7635-1-fido_max@inbox.ru>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, madalin.bucur@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 20 Jul 2021 08:08:38 +0300 you wrote:
> Set SUPPORTED_FIBRE to mac_dev->if_support. It allows proper usage of
> PHYs with optical/fiber support.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> ---
>  drivers/net/ethernet/freescale/fman/mac.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - fsl/fman: Add fibre support
    https://git.kernel.org/netdev/net/c/75d5641497a6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


