Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272B331C449
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 00:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBOXU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 18:20:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhBOXUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 18:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9DF2064DEB;
        Mon, 15 Feb 2021 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613431207;
        bh=/Xv67XX2gdGhrpr7PSrO8Wty/7eK4H3agZMQTKzmgTc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H2fL6jum2C1T+FBInUL502FnAMPvBMoe7lJlSdWbzvySZWgzv9n19Lj5dTccSYyQ/
         q+4GdAHzN+wQ2Aj5e6qdKWKHETy3QA3ICSA1b7Ljz7MTdLpUNi1+2P3v6Se0/DpLk/
         yA5onchGVrK3fMUP2amLL0WR7ZNkZYTIr8vaCc2VFsc3quHH0FXeB4/Xh6cHPuP79z
         Ia2V4jy52y3dBZYDDqRNwoH3qnw8Ez9DHLQ6ndZNrq1qY97/FMqYlKbo1zYqVWKlBm
         XTh03Q0SZhkmIY87on6AwtVjvG/D/EikbtcXUIJr/eehb68nY3+2R1RSxRTJGvlTIK
         xng0IH9pvC6XA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8CF22609EA;
        Mon, 15 Feb 2021 23:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ibmvnic: skip send_request_unmap for timeout reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161343120757.10830.4774374492956932570.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 23:20:07 +0000
References: <20210213024900.56081-1-ljp@linux.ibm.com>
In-Reply-To: <20210213024900.56081-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 12 Feb 2021 20:49:00 -0600 you wrote:
> Timeout reset will trigger the VIOS to unmap it automatically,
> similarly as FAILVOER and MOBILITY events. If we unmap it
> in the linux side, we will see errors like
> "30000003: Error 4 in REQUEST_UNMAP_RSP".
> So, don't call send_request_unmap for timeout reset.
> 
> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net] ibmvnic: skip send_request_unmap for timeout reset
    https://git.kernel.org/netdev/net/c/7d3a7b9ea59d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


