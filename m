Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC4F33495D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbhCJVAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:00:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:32806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231987AbhCJVAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:00:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3132565002;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615410013;
        bh=ViaoQIY5T8VXp7vUXcB8rIU/8NhhrBtIEGyU0olodRg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tTDzBJ7s38iNCaRokptBORgnAhAaX3qlMH5CQHjL/ac/sDe4uFvDbgxZ53PSpalN4
         CcMzu4TlO+Nasut+IMAbBHhp3Sssa99ZewJkvNln7Rkaiz8yh+/wegdpjcOSqax/aF
         ArFSrVyBA66wPyeFdkuCKgmwld42Vf0VesOPImBjgk0sqmI0Nnc4Bg/Dv8TaL2qMJb
         qz/svZ5bvi+P5fVHSDhLQIzE/2MQRmVXiVU1jPrsgdLzOj9rjd8NKDdH3o4aglwRaf
         Jo7aGENoy8TenUYTGBAxqpilgRwyM4ubBfWR5yxYCxxIcFNwCELxjOaNFrb2hkg4oZ
         GebJ51sqKihKQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 21F1C609D5;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/rds: Drop duplicate sin and sin6 assignments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541001313.4631.10673690545708320345.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 21:00:13 +0000
References: <20210310032343.101732-1-yejune.deng@gmail.com>
In-Reply-To: <20210310032343.101732-1-yejune.deng@gmail.com>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 11:23:43 +0800 you wrote:
> There is no need to assign the msg->msg_name to sin or sin6,
> because there is DECLARE_SOCKADDR statement.
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  net/rds/recv.c | 4 ----
>  1 file changed, 4 deletions(-)

Here is the summary with links:
  - net/rds: Drop duplicate sin and sin6 assignments
    https://git.kernel.org/netdev/net-next/c/3e6f20e09a45

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


