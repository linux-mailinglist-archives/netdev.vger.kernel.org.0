Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBE46E8700
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 02:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbjDTAvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 20:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbjDTAvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 20:51:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E9176AB
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 17:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0742664423
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 00:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6AA0AC4339B;
        Thu, 20 Apr 2023 00:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681951818;
        bh=FkPl9uCfCWlO1TwEC1RzdopNaoIOk3eU5Xve0pLRJdo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=psvqJ7b2Ab/Flpm4HZg825I3ZtlqPjUJyv1mBY23/eHOLUZ2ueCacoC5iSioCrx1z
         lsIzTZUrYE9hMoCLR58YpZ6iAH24pezpX9RmcWvtjQzHIjoee6vx6g+4IWZDSQcfsZ
         ctlET5eov1LTDFtadKcblqT4t67EQZVAoHzw3MNHk49AqK4aqDGyUeVQnkAO+5Z++9
         lvr+raiQBmVY2Bl0FFTRD5vHOkdKI2VzfRwMHyu4TtHlGbdsAAye0+Fo/xardV+Cw0
         lX5U0jh80Ot+fh0UnnLy3qQHKi+A8rydsRm+hmsZUzqekYO+9x8tEoIcgiRXJLUyt2
         CFlLoK37Ms1Gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F369C561EE;
        Thu, 20 Apr 2023 00:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt_en: fix free-runnig PHC mode 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168195181832.16132.5614757383741623494.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 00:50:18 +0000
References: <20230418202511.1544735-1-vadfed@meta.com>
In-Reply-To: <20230418202511.1544735-1-vadfed@meta.com>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     pavan.chebbi@broadcom.com, kuba@kernel.org,
        michael.chan@broadcom.com, vadim.fedorenko@linux.dev,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Apr 2023 13:25:11 -0700 you wrote:
> The patch in fixes changed the way real-time mode is chosen for PHC on
> the NIC. Apparently there is one more use case of the check outside of
> ptp part of the driver which was not converted to the new macro and is
> making a lot of noise in free-running mode.
> 
> Fixes: 131db4991622 ("bnxt_en: reset PHC frequency in free-running mode")
> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> 
> [...]

Here is the summary with links:
  - [net] bnxt_en: fix free-runnig PHC mode
    https://git.kernel.org/netdev/net/c/8c154d272c3e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


