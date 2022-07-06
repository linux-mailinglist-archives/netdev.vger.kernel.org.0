Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B504D567FB1
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiGFHUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiGFHUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A2A222BD
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 00:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C10BB81B86
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 07:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FA46C341C0;
        Wed,  6 Jul 2022 07:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657092016;
        bh=bxKHZe24gAEC3hWjj2xr7YI4TwxV9kMT3R5XBuqtLwU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PdoLhpLCtH9KxlONSuPy1hpmG2Qo+imbrUpYu5AuCAhQk9++tJaOd9qE6yNlnQMwX
         iJsfY680qt/i8bRYUkofvYtKP0GPofonIWk40m5vhqniKEhfsGAehA6M5foK80A5I8
         jdXiMkfsJ1VVf8pBoUz1QzwVMgXNb1LPXOX9AR4Uov/219zFnSxrd982v+CWcibS2L
         hJ/aZNDlxnGZ8LAmDWSEkBDBMYCK9T4j7mw7WeqtbHLFegB4lY75MQQxDrNySslakf
         tViIo6V3Ds5OS3lrNOTWOQRaF/SPZjzHvEdhItXP/aGCWkUEY1cdCYb2X8qYLH4qQr
         4LlXQt6cK0xeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01E5AE45BD9;
        Wed,  6 Jul 2022 07:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] nfp: enable TSO by default
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165709201600.20840.632393708090448874.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jul 2022 07:20:16 +0000
References: <20220705073604.697491-1-simon.horman@corigine.com>
In-Reply-To: <20220705073604.697491-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  5 Jul 2022 08:36:02 +0100 you wrote:
> Hi,
> 
> this short series enables TSO by default on all NICs supported by the NFP
> driver.
> 
> Simon Horman (1):
>   nfp: enable TSO by default for nfp netdev
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] nfp: allow TSO packets with metadata prepended in NFDK path
    https://git.kernel.org/netdev/net-next/c/ccccb4932977
  - [net-next,2/2] nfp: enable TSO by default for nfp netdev
    https://git.kernel.org/netdev/net-next/c/7de8b691615f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


