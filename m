Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52CB58D27E
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 05:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbiHIDuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 23:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbiHIDuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 23:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF968F
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 20:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE6F761171
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 03:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32FF9C433D7;
        Tue,  9 Aug 2022 03:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660017015;
        bh=DICVjPEZRc16/vuEUr/mHA5365ECYka5vsaiJahp5M0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tTjCwU2gs3uXFPMkgvZEbUIVUK8zNX8GYP8Y/kLwUUXnCMLSXbbdR1J4qZr5tEWKL
         mETK1smrV+vrZeJjVfKrotn5ueurjwKM9uFxEvXnb4Y8Ht37+30LAH/2AMUn8hUfZt
         PUaB6ZYBTco12F7w4ePXLlJaGpoxo4CWg8Z2osfi5WwUx5c00gWMhRYPU8svjvbuvM
         5u8R1Sy8bRgtnbQFIQLvTCwcOtLQJZtIS3VU6wHPPNHwEj3WR8CO5zE5IYpx+PX/P0
         AElTjyjCvXH7UJ/89G/K8ZbAV1rlpNbCnNNvPZsLb8r94UjJr56HVCX/8BfcQugecb
         U1y/H5bdVF+Yw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12ED3C43143;
        Tue,  9 Aug 2022 03:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] tsnep: Two fixes for the driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166001701507.1661.17205268696320167619.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Aug 2022 03:50:15 +0000
References: <20220804183935.73763-1-gerhard@engleder-embedded.com>
In-Reply-To: <20220804183935.73763-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  4 Aug 2022 20:39:33 +0200 you wrote:
> Two simple bugfixes for tsnep driver.
> 
> Gerhard Engleder (2):
>   tsnep: Fix unused warning for 'tsnep_of_match'
>   tsnep: Fix tsnep_tx_unmap() error path usage
> 
>  drivers/net/ethernet/engleder/tsnep_main.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next,1/2] tsnep: Fix unused warning for 'tsnep_of_match'
    https://git.kernel.org/netdev/net/c/73afd7816c55
  - [net-next,2/2] tsnep: Fix tsnep_tx_unmap() error path usage
    https://git.kernel.org/netdev/net/c/b3bb8628bf64

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


