Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D25C4CFD2F
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242047AbiCGLlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 06:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbiCGLlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:41:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8C84E39E
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 03:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FDF7B8111D
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 11:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE9CBC340F9;
        Mon,  7 Mar 2022 11:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646653211;
        bh=ku8RDwF77gQUhLUvhnUHufc0Pey/mXUMQOx/OaEfA84=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KJPkLiN3q6/t5Z/DfdMdITRZjjRZAIeejXUpCtHn1U/Wn86Nctx9e7/u9kemp4mAA
         pg4wZxEZP2W4EF2QyLB2C9iVchHPdkTTr4oHarB1Vr/Thkn4FpvfROvnmKlLM3OJzV
         NuHK4DY9JraRiBP8mFYy8n9sFZSM3HfsPE7V3atw8zfizRPFz6MKg8NGE3BIYB5snT
         4m3KFafoW6yCCYpmNlqtMZ8Rh8TVKCHfbNHLarvPzuUm5CzxuqF4biBkXY+vqKzA/2
         uu1zIBr3jt11EHyYZsm6iwvRYL1k2Ti2/89MYPPTwTyyCUtjgn+FaWv7xq9GolhZrY
         x5FljSSjwJUtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D87F1EAC081;
        Mon,  7 Mar 2022 11:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] ptp: Add generic is_sync() function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164665321088.12267.5514068782206775189.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Mar 2022 11:40:10 +0000
References: <20220305112127.68529-1-kurt@linutronix.de>
In-Reply-To: <20220305112127.68529-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        yhs@fb.com, daniel@iogearbox.net, andrii@kernel.org,
        Divya.Koppera@microchip.com, horatiu.vultur@microchip.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Mar 2022 12:21:24 +0100 you wrote:
> Hi,
> 
> as multiple PHY drivers such as micrel or TI dp83640 need to inspect whether a
> given skb represents a PTP Sync message, provide a generic function for it. This
> avoids code duplication and can be reused by future PHY IEEE 1588 implementations.
> 
> Thanks,
> Kurt
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] ptp: Add generic PTP is_sync() function
    https://git.kernel.org/netdev/net-next/c/f72de02ebece
  - [net-next,2/3] dp83640: Use generic ptp_msg_is_sync() function
    https://git.kernel.org/netdev/net-next/c/1246b229c6e8
  - [net-next,3/3] micrel: Use generic ptp_msg_is_sync() function
    https://git.kernel.org/netdev/net-next/c/3914a9c07e8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


