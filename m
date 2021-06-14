Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3888E3A6FB6
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhFNUCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233356AbhFNUCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:02:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C7A3F61356;
        Mon, 14 Jun 2021 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623700805;
        bh=lwYf/GRwuSm+3oyji4AkP0R/ZlBbPRUXo6ta57Nvxuo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nW6Lz1DIVaV6ZuJYxMDiN2sbuMVM57Gbp1EVjod5HpzcwPqq33aMsBanwM5XsXnOC
         CixByGnB1b7c21wCU88vgcX3arkU3SUDF9qdMyS/T6SKp9o84JZuHIl68bl3QjP1O2
         2PtG5rgnW0+u4DytKWVq4dM///Jy9fO+8vDcuYAb0ext5mZY3n9jvdvOwNEZ9RFKMl
         bU671YzMI/gLmavJS4N6qtvJi37lYe+C2R9/m4Fr6+4C18BhQq+KpNrdx5iuUwNgRq
         aOnQcnlVRLgxYy1yJ5tODTopODPSDl8iNjlTGHOntjIstvli4bACgGMwgGrt9Jinn6
         PTqz4Id6MqgxA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B255B60BE1;
        Mon, 14 Jun 2021 20:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ibmvnic: fix send_request_map incompatible argument
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370080572.15507.155878020829363670.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 20:00:05 +0000
References: <20210614052045.28523-1-lijunp213@gmail.com>
In-Reply-To: <20210614052045.28523-1-lijunp213@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Jun 2021 00:20:45 -0500 you wrote:
> The 3rd argument is u32 by function definition while it is __be32
> by function declaration.
> 
> Signed-off-by: Lijun Pan <lijunp213@gmail.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] ibmvnic: fix send_request_map incompatible argument
    https://git.kernel.org/netdev/net-next/c/673ead2431e2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


