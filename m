Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3566387D6
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiKYKu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiKYKuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:50:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6434841B;
        Fri, 25 Nov 2022 02:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04561B82A70;
        Fri, 25 Nov 2022 10:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0F1BC43147;
        Fri, 25 Nov 2022 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669373419;
        bh=6nrP72uQJaiuLIPyaJGJ+KMCTmwd2rza4F3Lcknui2w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q+5UPbClwGcWAyq3DpLXtlx7fSI3IiH36/uPHnN2gyMf4osM0FFfEHeuSo/aQBka5
         fWumxDtGCCwPtkEuL7SghYqiq1br1H42SUrXJUKFk84F2Fy6B1PlI90PiUi1gZe5FU
         sGqtmlcsATfx9efDmxMrdaRHR996WNtKrpxjjhlPOY0QfFdFi7WnYQvFXzLmV9rfjy
         JmLlXyov79eIgpSn+/GtRv8FK/jMDdrKnTyDkNNOGNOFHPX57tuix0qFECfrMw7m6O
         dVo0QdAWENoFu4S66v21+/oonP104b6OPWFK4dNtIBNDm7vfCJR7LaOU8yE35Ddu/t
         +p22N5JSK3Xow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60B15E4D012;
        Fri, 25 Nov 2022 10:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] ptp: idt82p33: Add PTP_CLK_REQ_EXTTS support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166937341938.11224.8741791396889501029.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 10:50:19 +0000
References: <20221123195207.10260-1-min.li.xe@renesas.com>
In-Reply-To: <20221123195207.10260-1-min.li.xe@renesas.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 23 Nov 2022 14:52:06 -0500 you wrote:
> 82P33 family of chips can trigger TOD read/write by external
> signal from one of the IN12/13/14 pins, which are set user
> space programs by calling PTP_PIN_SETFUNC through ptp_ioctl
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  drivers/ptp/ptp_idt82p33.c | 683 +++++++++++++++++++++++++++++++++----
>  drivers/ptp/ptp_idt82p33.h |  20 +-
>  2 files changed, 640 insertions(+), 63 deletions(-)

Here is the summary with links:
  - [net,1/2] ptp: idt82p33: Add PTP_CLK_REQ_EXTTS support
    https://git.kernel.org/netdev/net-next/c/ad3cc7760dc4
  - [net,2/2] ptp: idt82p33: remove PEROUT_ENABLE_OUTPUT_MASK
    https://git.kernel.org/netdev/net-next/c/46da4aa2560f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


