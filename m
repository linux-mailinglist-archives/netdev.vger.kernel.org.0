Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976FB297A3D
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 03:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759141AbgJXBuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 21:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758753AbgJXBuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 21:50:05 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603504204;
        bh=Z2CtstpKmYgZ/QxhBJNPp5PiNyLqcBPcfr/cSdjC9OI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uPeO/EIx+G7tGMVFT+JViPuQB+flWNNWpoVRPUZ7yTTgGPQFMkpy/fQwLFaBkmA11
         XWVuEEeeZkXO+4Ug1oCG8O+hGOwiYWm+YHzDyVzYtQq2XYA1/Io4nw17pRVw0WLbeg
         uBKSCa3opIDzG9OgzTAsbtdlGqUyi61brBbz1G3c=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] ionic: memory usage fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160350420483.19271.2457370651181183623.git-patchwork-notify@kernel.org>
Date:   Sat, 24 Oct 2020 01:50:04 +0000
References: <20201022235531.65956-1-snelson@pensando.io>
In-Reply-To: <20201022235531.65956-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Oct 2020 16:55:28 -0700 you wrote:
> This patchset addresses some memory leaks and incorrect
> io reads.
> 
> Shannon Nelson (3):
>   ionic: clean up sparse complaints
>   ionic: no rx flush in deinit
>   ionic: fix mem leak in rx_empty
> 
> [...]

Here is the summary with links:
  - [net,1/3] ionic: clean up sparse complaints
    https://git.kernel.org/netdev/net/c/d701ec326a31
  - [net,2/3] ionic: no rx flush in deinit
    https://git.kernel.org/netdev/net/c/43ecf7b46f26
  - [net,3/3] ionic: fix mem leak in rx_empty
    https://git.kernel.org/netdev/net/c/0c32a28e247f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


