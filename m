Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3428C68FFF0
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBIFkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBIFkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD00A31E37;
        Wed,  8 Feb 2023 21:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59F6DB81F18;
        Thu,  9 Feb 2023 05:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D31A5C4339B;
        Thu,  9 Feb 2023 05:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675921217;
        bh=ihvBewTDozaPAQhET3XvFMZKSFNYr1JvVXOTKYzHfvI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ATW4a76QC2WTbuKjt3BipBWIZdC3ZwlZ07MNlVzwPPVQJBAXBnhCd2DE9ghvXBaQD
         1r1/iivL7qVA7sWVwl8SlL4UfqiBRBVd3PEHaiMWH2lilnN4g1sSLnbWzfAuO741LA
         qwhdDwDGUQrmgBk6z1RDajrJ7r6QICdwlnurhSUCAJNWlyPRFA8WwBkcj8mLMNXYSt
         uk1ExBpG3Q8ON1m/RnPkIasSYUr87Qg3cxKrVos0WklvWmZemK0DHR78S417fsORQg
         ckpa7C0rWPbwhX12Tuvi8qbeI+WoZCU7zS3rQ8cTkzIc12cnzKEmhVGZO2RaOKGhjH
         K6iwDtFFZ4wjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9334E49FB0;
        Thu,  9 Feb 2023 05:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] can: raw: use temp variable instead of rolling
 back config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167592121775.16112.9794869651961034488.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Feb 2023 05:40:17 +0000
References: <20230208210014.3169347-2-mkl@pengutronix.de>
In-Reply-To: <20230208210014.3169347-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed,  8 Feb 2023 22:00:13 +0100 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> Introduce a temporary variable to check for an invalid configuration
> attempt from user space. Before this patch the value was copied to
> the real config variable and rolled back in the case of an error.
> 
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Link: https://lore.kernel.org/all/20230203090807.97100-1-socketcan@hartkopp.net
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] can: raw: use temp variable instead of rolling back config
    https://git.kernel.org/netdev/net-next/c/f2f527d59596
  - [net-next,2/2] can: bittiming: can_calc_bittiming(): add missing parameter to no-op function
    https://git.kernel.org/netdev/net-next/c/65db3d8b5231

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


