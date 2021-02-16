Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D66B31D266
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBPWBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhBPWA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 17:00:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E93F164E6B;
        Tue, 16 Feb 2021 22:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613512818;
        bh=CjW6MABjaJQv3GLkNG9GvfSSqP69fFHx5bfYMu/6408=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EgvkldXKb8kRqgo53uAyUvOFe1auQacsNPtFjgHx//LPNrSBTnWf8VeIdQnPjdxp+
         t43Lhoww1tAQw1frWFwpsHwYketBxjbJBdiPw6d/r7mb+Ey57FkWOURFp9PHxNXaHT
         En2i59X76tDh/UfgQ1iMydB8mY9An5gcWAyjaxs6KuxVOVfS5WgxnOBDPslPXYE6WB
         60OzunyFCHq/XiL+P4e1tEMOW2lKntbnQwmZefvJRdNMdtbcpT+NtdlLEpgxKMSkKr
         IWWC4IKIV7IOu4plVn2vAzea6DxZgn7WB1DN3qABzFQS/PNe/nBo5IcAXEQhEIxLDt
         FYtluUQfRp0iw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D7272609F8;
        Tue, 16 Feb 2021 22:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ionic: Remove unused function pointer typedef ionic_reset_cb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351281787.10594.1623378932363702595.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 22:00:17 +0000
References: <1613448330-4783-1-git-send-email-chen45464546@163.com>
In-Reply-To: <1613448330-4783-1-git-send-email-chen45464546@163.com>
To:     Chen Lin <chen45464546@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, drivers@pensando.io,
        snelson@pensando.io, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chen.lin5@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 12:05:30 +0800 you wrote:
> From: Chen Lin <chen.lin5@zte.com.cn>
> 
> Remove the 'ionic_reset_cb' typedef as it is not used.
> 
> Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_lif.h |    2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - ionic: Remove unused function pointer typedef ionic_reset_cb
    https://git.kernel.org/netdev/net-next/c/6825a456c9a3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


