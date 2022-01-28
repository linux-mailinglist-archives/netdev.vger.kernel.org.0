Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB7049FBE2
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245244AbiA1OkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:40:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52468 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349352AbiA1OkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCEACB825ED
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BA14C340E7;
        Fri, 28 Jan 2022 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643380809;
        bh=rUX1JwQT+tn2Sh+RM3+EEVkFblkn0uh7bnzRBQEaxFY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h/pLo1HW9Amko3Qq/YWjlvV4tQkySp+kHiFMF85rtyJ+o19D9xmYi6nYy/Bxpmmvb
         0WUAkABILVKmlT0RjLlCBeazPwt76yHB4dWf6ngVcGjXK195siKURW7ynTlCC6YX82
         RL0FcXouBNwa/P9Y1VLIXQzr19aRy7j57ywslN9mLi3Jj99YV94ZFr66UENRBs3L4T
         3iD4MgDm+79CVnw7Y+lawONXsjT3rRWitsTU4H6EcJ+XrcnLzahS4/jDVzMW1nyKzB
         c//WOdJoPE0azR/0fVZSYl6plw+HL54diBo0B3WB9yCfs0BYnbBvO7unbo8jRr46IP
         rMKJQmwhrcxAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73F3BF6079F;
        Fri, 28 Jan 2022 14:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mvneta: remove unnecessary if condition in
 mvneta_xdp_submit_frame
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338080947.20347.12794752870636413631.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 14:40:09 +0000
References: <d7b846d1caf1f59612eead3d8760e7a6913695ba.1643294657.git.lorenzo@kernel.org>
In-Reply-To: <d7b846d1caf1f59612eead3d8760e7a6913695ba.1643294657.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Jan 2022 15:47:49 +0100 you wrote:
> Get rid of unnecessary if check on tx_desc pointer in
> mvneta_xdp_submit_frame routine since num_frames is always greater than
> 0 and tx_desc pointer is always initialized.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mvneta: remove unnecessary if condition in mvneta_xdp_submit_frame
    https://git.kernel.org/netdev/net-next/c/c52db2461917

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


