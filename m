Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6702AA87B
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 01:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgKHAAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 19:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKHAAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 19:00:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604793605;
        bh=9X4xbitZksyAd/N2PJKaw8ft4O0FNA2Gevrcq5xpzgg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n4N2x8v0eGtKKYmCv8OLRCe2O1OqSA+FgxYMjy4HrWEASHOkFXk4NwviWqJe9EPDH
         US8F1MP3g8StCNd3RIoPMG1+HpAO9JHMZAvb+3Q4SJaS5N54UcvcEzevQb1bpFsiue
         8+hu+YXKoY1jZDpe3rigsH+JQ/R7pohA10TyUQPA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: fix spelling typo in cdc_ncm.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160479360520.2526.17555895524859310233.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Nov 2020 00:00:05 +0000
References: <1604649025-22559-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1604649025-22559-1-git-send-email-wangqing@vivo.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     oliver@neukum.org, davem@davemloft.net, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  6 Nov 2020 15:50:25 +0800 you wrote:
> Actually, withing should be within.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  drivers/net/usb/cdc_ncm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: usb: fix spelling typo in cdc_ncm.c
    https://git.kernel.org/netdev/net-next/c/ef9ac2091180

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


