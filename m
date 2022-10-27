Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EC760EE9A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbiJ0DbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234342AbiJ0Dan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:30:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC983303E4;
        Wed, 26 Oct 2022 20:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 533D4B824D3;
        Thu, 27 Oct 2022 03:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE495C433D7;
        Thu, 27 Oct 2022 03:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666841423;
        bh=oUZzl7FjelsAn8qr9lwGL5uT7E0gKnb0S9mmxFdVweQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EoJs5rOREc1ppID+fra4VtB9qjZdWmdurx6OuKZTKP5xADWsbxfxdBTaCRpJhK/YX
         l85hR/aNx/2pE8tB87RWju9Ih43mL+B2Es8NiBkF1hvZN4IbYztUgRP6MVOmfyGQjG
         7RpoZCsqqQpcUkeNXPm9LyNmMqGl7YVIikJ9EjopRbdV3h9tTcLtNyIbKYRpxI4hkG
         lyMFNO26v0sZr8wX1KBIKfABSj985/+GTBlNiJVxUMNCEPZaOcjZoFC5zr+U8iksgH
         jM0AoZINm9rLxoCKKSAq9Q143efLqjCQdLKvKQ8XxNb3sldytcfA/g3R9fPM5Furfi
         R2j1jOfk/0pzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B92DEE270DE;
        Thu, 27 Oct 2022 03:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/n] pull-request: can 2022-10-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166684142373.32384.12876299340184919641.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 03:30:23 +0000
References: <20221026075520.1502520-1-mkl@pengutronix.de>
In-Reply-To: <20221026075520.1502520-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed, 26 Oct 2022 09:55:18 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 2 patches for net/master.
> 
> Both patches are by Dongliang Mu.
> 
> The 1st patch adds a missing cleanup call in the error path of the
> probe function in mpc5xxx glue code for the mscan driver.
> 
> [...]

Here is the summary with links:
  - [net,0/n] pull-request: can 2022-10-25
    https://git.kernel.org/netdev/net/c/8b9d377afaed
  - [net,2/2] can: mcp251x: mcp251x_can_probe(): add missing unregister_candev() in error path
    https://git.kernel.org/netdev/net/c/b1a09b63684c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


