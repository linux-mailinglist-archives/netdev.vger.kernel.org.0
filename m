Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EA1482B13
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 13:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiABMaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 07:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiABMaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 07:30:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166BEC061574
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 04:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB937B80D05
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 12:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DED2C36AF0;
        Sun,  2 Jan 2022 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641126609;
        bh=pv2EPUEN4ksUo/p5QZsEA7FemBQQ2wJLT9FEMQVUOxo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TcQNSbWRynZSDg8Wee6INEyezdGhh3SKhgkQGnobdNAYJDsTBmgOlbn/byf5hizoa
         nJau4lajtbivBHCSbvLBr9MTwo/maQtTxOx1j3yxBL/+kgj/n9DxphWzHbCnfX5Nkt
         mPKp9tWBUOEM8u6KxIOvINDv2MaB7BaAgB4VrAk6uiPZjpx6JGTCEhOsdt7jhRxso7
         vA1JorJSyDnBN02KbE/Di3HAzbL2pBuvSzonGt0Ph15vmAGLyAtNLtaSUGnXjR+omV
         gMhoZgLMw35rNim+f/x0kc/6A9oOZf2jCerkR1kcIKYbRjZKylNvmrWIGUszeJfSxE
         4exu3VTjS3mQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86813C395EA;
        Sun,  2 Jan 2022 12:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: socket.c: style fix
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164112660954.27407.6776273911142543339.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 12:30:09 +0000
References: <20220101123825.GA28230@elusivenode-Oryx-Pro>
In-Reply-To: <20220101123825.GA28230@elusivenode-Oryx-Pro>
To:     Hamish MacDonald <elusivenode@gmail.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 1 Jan 2022 22:38:25 +1000 you wrote:
> Removed spaces and added a tab that was causing an error on checkpatch
> 
> Signed-off-by: Hamish MacDonald <elusivenode@gmail.com>
> ---
>  net/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: socket.c: style fix
    https://git.kernel.org/netdev/net-next/c/e44ef1d4de57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


