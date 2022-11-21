Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762856322F0
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiKUNA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiKUNAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9BB2B24B;
        Mon, 21 Nov 2022 05:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65CC2B80FB3;
        Mon, 21 Nov 2022 13:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 180ADC4314B;
        Mon, 21 Nov 2022 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669035618;
        bh=+9QlJi73hkGIPRYErDFD23s5S6qfTBH7stoae7LcFbU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ux009WYsqUMLe+yv/kcwVZLxB5Sk8G5BDcT6V2Yt2jaBKOtJjKJVAXD5bgQfsfO+B
         pLNViyQjlqS+CTxTvbnQWbpvcCwgMSM6K0CPy5W76DNaIMFz038Fv1ElRwg0e+68lp
         b0hfFNJiV7UU/Vp72xxsPTGZH+0jZMGLwWBEoYq8WY2DoDZ+J/F8HRqpROzQ0RPhNu
         orozRFUaDMkmuJhtFkN3Ol10REIpeUvpmw8VYbFzc88kQhUcbl/h4nydV1+7gFxc+L
         p7zFSDJwCpnyOQy33isTNPHELNq4g3k0mpbpcPbwMJ89O4PR90I9k2zDq3ZhX41jNg
         ECgaVN6W1PQtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E471CE270C9;
        Mon, 21 Nov 2022 13:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: renesas: Add missing slash in
 rswitch_init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166903561792.31413.10815307263712035156.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 13:00:17 +0000
References: <20221121094138.21028-1-yuehaibing@huawei.com>
In-Reply-To: <20221121094138.21028-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 21 Nov 2022 17:41:38 +0800 you wrote:
> Fix smatch warning:
> 
> drivers/net/ethernet/renesas/rswitch.c:1717
>  rswitch_init() warn: '%pM' cannot be followed by 'n'
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: renesas: Add missing slash in rswitch_init
    https://git.kernel.org/netdev/net-next/c/1cb507263290

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


