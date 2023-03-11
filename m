Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4E46B58A1
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjCKFaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjCKFaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:30:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A11EFBC
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 21:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEF8360BB8
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 05:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 547D0C433A1;
        Sat, 11 Mar 2023 05:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678512619;
        bh=qcGEP3bbrROA3GnUExXc+3TH91ypxTpQacwuJT8VTnw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j6b8wVeJE6d3xB1RtyrVtw8sL8ETFDD5j5x9CmzTkhYrDBqP7xrSxZxGiRWaGBT0v
         j3fnbYQNU2ShQ4PwOsp4OH+DoSGxVO8+Bc6fRw6/RWKVjxEn4SB468dJzHMrTfT8c2
         Xiikgh7PAuWdTSlBIoy9XoLimI1vhIp4cOjIOuRqV29wUsii7KVb+WSDG2qxM0xtRy
         wT1byn6rVkKXTpI2dQLVRQwO8oHLxc13vVs+dQNdomdSESE4nvRkA1iLlXpGkx1jgq
         4EjUBSXAetmnqqWfk8H17qXP0jIuDa6cKLJ4U+IsQjycyOwliS1t1OjanXQa//CPTz
         7aXYQRMQ1N/2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F6BDE61B75;
        Sat, 11 Mar 2023 05:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next] ptp_ocp: add force_irq to xilinx_spi
 configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167851261925.13546.13440681300627781537.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 05:30:19 +0000
References: <20230309105421.2953451-1-vadfed@meta.com>
In-Reply-To: <20230309105421.2953451-1-vadfed@meta.com>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     kuba@kernel.org, jonathan.lemon@gmail.com,
        richardcochran@gmail.com, vadim.fedorenko@linux.dev,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 9 Mar 2023 02:54:21 -0800 you wrote:
> Flashing firmware via devlink flash was failing on PTP OCP devices
> because it is using Quad SPI mode, but the driver was not properly
> behaving. With force_irq flag landed it now can be fixed.
> 
> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> ---
>  drivers/ptp/ptp_ocp.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [RESEND,net-next] ptp_ocp: add force_irq to xilinx_spi configuration
    https://git.kernel.org/netdev/net-next/c/939a3f2a76e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


