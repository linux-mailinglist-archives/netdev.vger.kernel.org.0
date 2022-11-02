Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285D86162D4
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 13:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiKBMk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 08:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiKBMkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 08:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1BA2A240
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 05:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC95661943
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 12:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F132C433B5;
        Wed,  2 Nov 2022 12:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667392817;
        bh=59q1qFphgguvEKsPTnqLVqmrFSpy+GWwzX6LQtrf3Dc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DAU5EN4MS1ymPoTaSk1EIOhaFkmZ8PgKUoH0Uw6KI2Iu14kwzxH+8bLiKiaEq6lWv
         qZJu6c9JkvHR9vz+VgHdXIpU6jXP/BQrvZPvO1+OtH+6xPk6tjG195V3LT/TaSI5X8
         AMdBhaDtj8r1cGsiHbNgvV+NB/1QJJfsZnmAi15PCOG3m/FL80rVicxJfdt8IY/+iR
         ZInkTXbv/SmAF3Os/bVuLOOaCNS0cpTbQ7bSyBP7dTLsKWQn9SsM97Ws0RPLPpTVXQ
         cRGG2Bs4u9sQuZty6upTOn44GLdebMJXp2DpcoOoIV1d2Fju6PH49eVIcIH9Mqo15+
         zIScH/ubvV4ew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0B495C41620;
        Wed,  2 Nov 2022 12:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: WangXun txgbe/ngbe ethernet driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166739281704.30188.5220664554915467813.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 12:40:17 +0000
References: <20221031070757.982-1-mengyuanlou@net-swift.com>
In-Reply-To: <20221031070757.982-1-mengyuanlou@net-swift.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 31 Oct 2022 15:07:54 +0800 you wrote:
> This patch series adds support for WangXun NICS, to initialize
> interface from software to firmware.
> 
> Jiawen Wu (2):
>   net: libwx: Implement interaction with firmware
>   net: txgbe: Add operations to interact with firmware
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: libwx: Implement interaction with firmware
    https://git.kernel.org/netdev/net-next/c/1efa9bfe58c5
  - [net-next,2/3] net: txgbe: Add operations to interact with firmware
    https://git.kernel.org/netdev/net-next/c/049fe5365324
  - [net-next,3/3] net: ngbe: Initialize sw info and register netdev
    https://git.kernel.org/netdev/net-next/c/02338c484ab6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


