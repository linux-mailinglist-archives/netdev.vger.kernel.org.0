Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAF450DDE1
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbiDYKdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240536AbiDYKdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:33:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E976DE81;
        Mon, 25 Apr 2022 03:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52B1160EC5;
        Mon, 25 Apr 2022 10:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3759C385B5;
        Mon, 25 Apr 2022 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650882612;
        bh=/E5XbKh/086Rn9IubPH6wu5hqvSHp6JL0A+u9pvEsfM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ov+N7ti96TYsOZPb3ohOG1bncaEO3gm1k1RPJCdvb9FqfNhjiyQCSMyV2DzWJ6DS8
         ukRK2OmxeSOajK3Gj8VrA/2QCZGSsJjcX962I5ppeXYNt+fNKKd4W8l75ZD/hviHgx
         xs2AqfuMoXVZJ5SztAkCXhn7814z2izKs+6Yo8eayA0dMftnXX7p1pghk59jx1VA90
         m/vAifkPBVKWet+I+vq5qaeuvDJTN1HdypBUYxRHL6+gMvSyl+NbMCJBpTUMyOwpEA
         D+rIKUV/Ie/RinAIgc5xs9fWsRmCeizQsGEHez/B8DW1zc8i2Fk9VZtV0YrKthKHOZ
         0buFL4Ebk/P4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86948F0383D;
        Mon, 25 Apr 2022 10:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: broadcom/sb1250-mac: remove BUG_ON in sbmac_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088261254.604.612739052279250904.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 10:30:12 +0000
References: <20220421135148.2890823-1-yangyingliang@huawei.com>
In-Reply-To: <20220421135148.2890823-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 21 Apr 2022 21:51:48 +0800 you wrote:
> Replace the BUG_ON() with returning error code to handle
> the fault more gracefully.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/broadcom/sb1250-mac.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Here is the summary with links:
  - ethernet: broadcom/sb1250-mac: remove BUG_ON in sbmac_probe()
    https://git.kernel.org/netdev/net-next/c/60d78e9fce88

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


