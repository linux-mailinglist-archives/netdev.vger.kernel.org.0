Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDDA334958
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCJVA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:32824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232000AbhCJVAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:00:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 54EF165015;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615410013;
        bh=q2xrPMBHgH74pAfIiot6Jwwe60GTAPk0QGmEpvVHYmU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PzjgzZkAajtBWO/pO0jiCRevPYyWwSoGRGYcmUJhyN+C91kcf9Kmw2eN9/I4OJ2Mf
         putwLblU2lv9bE+Cn9bTDcispOspCuHwBHQXQ0dta6aS1xRhGxUAVgq7hBiSjcZMzI
         W08Vi14E5yfAZVeq8EZKFbWUBkU0Xb+7hwwGq7Qf7X87bqaWCQAyWJdHj27+Hp6hVq
         U30rcKCZMGK6HPzynONHeo5vAj+exzdeyQI/EHO9GHLM7CYUcqB8WNcVVNhV8HJii0
         oN2nexA60zMOESLeZ+0B08S3A9yc3pg7cfWSaYlQZKY2kvqiktNYliCwJpNrOJihu/
         oE5jeK/BN0Abg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43783609BB;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: isdn: mISDN: fix spelling typo of 'wheter'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541001327.4631.4619454405550574531.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 21:00:13 +0000
References: <1615345563-1293-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1615345563-1293-1-git-send-email-wangqing@vivo.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 11:06:03 +0800 you wrote:
> wheter -> whether
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  drivers/isdn/mISDN/l1oip_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - drivers: isdn: mISDN: fix spelling typo of 'wheter'
    https://git.kernel.org/netdev/net-next/c/67a580aad179

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


