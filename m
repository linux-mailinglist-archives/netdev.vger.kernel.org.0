Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE94418819
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 12:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhIZKbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 06:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhIZKbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 06:31:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D9ADA61090;
        Sun, 26 Sep 2021 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632652206;
        bh=0rTNUgt7GN2hCScavKbFZP88FSQDQace1ISlV/QTP4k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O7NofB7sMlgL+XlAE05qqAvHJhASWSE5ZItTL6aoFiX4uMKxxl/pQqH976dokalMN
         aG6W6ZeiEBBbIDAO/QAgklPYbx9+RDTUQ/7Raa7g1VEcuBCNeClyWb4oiu8LtYDuI3
         KZpLHT0G9Di12VdSwo9va3B3YkSeC0jNUKjdX+kA2RcO+jxNFVgkpr63+2mPQcmRY2
         f8s/EXHW//6CCPZhzsuiP1Cxkm7dNCIF/U30TRr05c9zICNcbhbxXT/X+DEdg1jvQA
         xVSlQIb4K/nxvJCV3dewILixhuSkaSlpbyAMu9gQO3tsPFO+dvxeeOdCdlBqzY+yBj
         +g+0ZSmYQLRTw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C6A5C60A3E;
        Sun, 26 Sep 2021 10:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 0/2] adding KPU profile changes for GTPU and custom
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163265220680.26415.8925595801133738113.git-patchwork-notify@kernel.org>
Date:   Sun, 26 Sep 2021 10:30:06 +0000
References: <20210924061851.680922-1-kirankumark@marvell.com>
In-Reply-To: <20210924061851.680922-1-kirankumark@marvell.com>
To:     <kirankumark@marvell.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 24 Sep 2021 11:48:49 +0530 you wrote:
> From: Kiran Kumar K <kirankumark@marvell.com>
> 
> Adding changes to limit the KPU processing for GTPU headers to parse
> packet up to L4 and added changes to variable length headers to parse LA
> as part of PKIND action.
> 
> Kiran Kumar K (2):
>   octeontx2-af: Limit KPU parsing for GTPU packets
>   octeontx2-af: Optimize KPU1 processing for variable-length headers
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] octeontx2-af: Limit KPU parsing for GTPU packets
    https://git.kernel.org/netdev/net-next/c/2fae469ae238
  - [net-next,2/2] octeontx2-af: Optimize KPU1 processing for variable-length headers
    https://git.kernel.org/netdev/net-next/c/edadeb38dc2f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


