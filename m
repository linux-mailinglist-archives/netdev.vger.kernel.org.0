Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE0D3A5087
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 22:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhFLUWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 16:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhFLUWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 16:22:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9068D611CD;
        Sat, 12 Jun 2021 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623529204;
        bh=nV7PrcXRrlp3357UIkNwd0U7NC+AZ1qN8ItNzBTC78k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EX/cJDo9YQS05GROmYI361kM3HvC7RZX2CruUiy39ejJv3NCxOc+1eIGSNyLbSiHh
         wuxzZYv43CkQsD9vsFT1dsU4IrjVdkxA0ImkhmN1ZQ6kBIseurB/rFoy2BPKwLFpWk
         svO9+s9CbnidJMLhbzgLbYzzsxA9FYtNHGsJJlHXVqZVoWbL0FWNnUYwq7VyzynAK5
         YA/O1h7j734IdTGGGRL8556ojqhmfqrXwFJAM198ZeC9zb19aj1J1e452JUUKRvQFO
         8MqC62H6xqPlQEqQNG+EJX7WCULwTSXxAQgBgSJ3AzWbHb1JUXEk4q9jeDOVU5yxbV
         TCbxO71BWWIQg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8796260A49;
        Sat, 12 Jun 2021 20:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ibmvnic: fix kernel build warnings in
 build_hdr_descs_arr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162352920455.6609.339341081027975755.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Jun 2021 20:20:04 +0000
References: <20210611154339.85017-1-lijunp213@gmail.com>
In-Reply-To: <20210611154339.85017-1-lijunp213@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 10:43:39 -0500 you wrote:
> Fix the following kernel build warnings:
> drivers/net/ethernet/ibm/ibmvnic.c:1516: warning: Function parameter or member 'skb' not described in 'build_hdr_descs_arr'
> drivers/net/ethernet/ibm/ibmvnic.c:1516: warning: Function parameter or member 'indir_arr' not described in 'build_hdr_descs_arr'
> drivers/net/ethernet/ibm/ibmvnic.c:1516: warning: Excess function parameter 'txbuff' description in 'build_hdr_descs_arr'
> 
> Signed-off-by: Lijun Pan <lijunp213@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ibmvnic: fix kernel build warnings in build_hdr_descs_arr
    https://git.kernel.org/netdev/net-next/c/73214a690c50

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


