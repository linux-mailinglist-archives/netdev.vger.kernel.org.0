Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CF63B3722
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhFXTmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232797AbhFXTmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 15:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C4F606120D;
        Thu, 24 Jun 2021 19:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624563603;
        bh=cbdtrZVfiwSx1BaoUyVwN2/LjCkbvHY/EXZd1PeuDQM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p8VG0q2m3C329EQtJSoh4JXwgs5uRsuMF1s4Tb0Im8wt1eirT8MfaxxwzG4AmTkIJ
         k02k2cevcrUmROnT+tsxqCUpE4QVqy7VKkcazZeGFLth/KPXH9GShpYiPNvisDLnzA
         xOIA/soYxPwvUyVeRRiWeuHRd/15TKs+14XE5sqzWHRkJTOry8wDXiJDD4cVmiVcJ9
         4rhbKscFeMo/aZPJXoI9QuWbLAlLjeQUH+HHM12XKzPnMkXT8r0Fxf+8nUJ3DyRvBc
         E25e0EpSEStADQeWg/QsQVCmhrwbJGEYcn7PvWis6WdE+abO0D+ckFPupaiTRA/dXa
         80U2xeHvUpQZw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B972360A4D;
        Thu, 24 Jun 2021 19:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] usbnet: add usbnet_event_names[] for kevent
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162456360375.4921.13140580289490455852.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 19:40:03 +0000
References: <20210624073508.10094-1-yajun.deng@linux.dev>
In-Reply-To: <20210624073508.10094-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     oneukum@suse.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 24 Jun 2021 15:35:08 +0800 you wrote:
> Modify the netdev_dbg content from int to char * in usbnet_defer_kevent(),
> this looks more readable.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  drivers/net/usb/usbnet.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)

Here is the summary with links:
  - usbnet: add usbnet_event_names[] for kevent
    https://git.kernel.org/netdev/net-next/c/478890682ff7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


