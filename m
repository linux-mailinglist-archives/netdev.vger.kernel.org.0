Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B50352360
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbhDAXUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235905AbhDAXUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B76676113A;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617319209;
        bh=uN/XGL/KMDWWq3ubQrnN90OXwhTS2XI6AErpNQr3DTw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pnhGa1sskb6kr8eEDUlJk3Ql1p0/fJnX1qc8zrbPBAOUGdZI6ML1y0bJFHNKYum+o
         aly3pRQBN56ucS2qKqUG5knAvNZKz3S7wxy06/m/dMMS8zVX25XAcWcggZlIDiITUy
         YgL+4VTs//IbBhqroZtlvOSXO1gmG6z++3i28oZxlGFNKq9WX+Mo3Vety2mymdyRW2
         d3GAxG/Pid8bEi1EbuS3Z+sa1LRpA5Mf6ovZbaadP7otwQ6ssVPbjuJszJkGIsV2t1
         gew7xtLJelh0SN0L9qpTGe/7rbOymQ03E/THAY2UIrhgiM+TPPikdzEHAzZYSXNJEh
         3M9QGpUTMZCeg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF6CA609CF;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] lan743x: remove redundant semi-colon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731920971.16404.4934646610179660014.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:20:09 +0000
References: <20210401142015.1685712-1-yangyingliang@huawei.com>
In-Reply-To: <20210401142015.1685712-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 1 Apr 2021 22:20:15 +0800 you wrote:
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] lan743x: remove redundant semi-colon
    https://git.kernel.org/netdev/net-next/c/e228c0de904c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


