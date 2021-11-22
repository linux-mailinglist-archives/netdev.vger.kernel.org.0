Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4081A45905F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbhKVOnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:43:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239769AbhKVOnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 09:43:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 28CFE60E78;
        Mon, 22 Nov 2021 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637592009;
        bh=EB0EgnL1LmOnfcTSS87OT1BJlmhpKmqE3T/MtNoAAd4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s+lKInhPQzjyMdFExwPGW62F2ED9t47iu4IjZ+BYmfzv5BF4oU3vKhPN11/HFna+w
         90suBASBEgRysrW9QnSnzmWTU1Nu/PwuIJHE974UCY9Yd/RAMkLNB8PzpktDwlCWmd
         0ltAzf6d1TfMGE8uNPAujqbef87erRPlFDELhiVb6/VAA3snQqLsTq4oH/ip1pnvj+
         Vi4gsqgMZlipcT/fel3WBHd1br/3Mxw9VOUNSOI4fy9OLu49JAom4YGmgurPQmA6qD
         p2avQ+vhPAtC30QLfzHw+9lqaBd7t2pnJ9PM9I84x1QYJq+Ksdd9d/owB5hGpx/vDs
         vmEinAff9mLEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1C67360A94;
        Mon, 22 Nov 2021 14:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: ax88796c: do not receive data in pointer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759200911.2046.9687497998289586030.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 14:40:09 +0000
References: <20211121200642.2083316-1-nicolas.iooss_linux@m4x.org>
In-Reply-To: <20211121200642.2083316-1-nicolas.iooss_linux@m4x.org>
To:     Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc:     l.stelmach@samsung.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 21 Nov 2021 21:06:42 +0100 you wrote:
> Function axspi_read_status calls:
> 
>     ret = spi_write_then_read(ax_spi->spi, ax_spi->cmd_buf, 1,
>                               (u8 *)&status, 3);
> 
> status is a pointer to a struct spi_status, which is 3-byte wide:
> 
> [...]

Here is the summary with links:
  - [1/1] net: ax88796c: do not receive data in pointer
    https://git.kernel.org/netdev/net/c/f93fd0ca5e7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


