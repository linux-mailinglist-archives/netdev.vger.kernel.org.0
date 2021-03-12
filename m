Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7453133839C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhCLCaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 21:30:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231200AbhCLCaQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 21:30:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EEB8A64F9F;
        Fri, 12 Mar 2021 02:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615516216;
        bh=rfUkCt+yYBrXnbRL9JOZl8866B521zpsBhR9OtFIwx0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VZz0SD8kEx+Qbzkacv/U1jrbgS/ynusn+SA2SJp4omFv2ArOHMw3X8+ouEhZq1hMB
         LT9f35U8bWhILTKvhC27YEKEKbJ2ilT2Kf2BFn8XgmYadzPZn+5j4CDjF6h37AM6/g
         j1XeOVkLxpHG1CL/DkTUZCvO6S2PbH5J08Rp9EDM4ZEEKVi1PghOFTWcSvNjAzVlg/
         GxkoGRKATXI2Nu1cLbvaFJ3IEuLaTOwhoZyjGcgfH6ql3qSejhVfwVJWKBe2/2X2tM
         N/VAl4C2+HZFHMk8nPYgBNsqqn1IUyxxHI1YQOVKks+3jlL99HhYagcvsOW1a001q6
         E/HNVOuJFnsHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EAB37609CD;
        Fri, 12 Mar 2021 02:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] isdn: remove extra spaces in the header file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161551621595.2118.13752673463914480240.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 02:30:15 +0000
References: <20210311042756.2062322-1-ztong0001@gmail.com>
In-Reply-To: <20210311042756.2062322-1-ztong0001@gmail.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 23:27:55 -0500 you wrote:
> fix some coding style issues in the isdn header
> 
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> ---
>  drivers/isdn/hardware/mISDN/iohelper.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Here is the summary with links:
  - isdn: remove extra spaces in the header file
    https://git.kernel.org/netdev/net-next/c/8176f8c0f095

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


