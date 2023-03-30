Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4603B6CFA62
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjC3Eu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjC3EuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:50:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F1B1995;
        Wed, 29 Mar 2023 21:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B6523CE270C;
        Thu, 30 Mar 2023 04:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3135C4339E;
        Thu, 30 Mar 2023 04:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680151819;
        bh=2ja2AhCTxFypzu73emzHuHUbhhpDPKSz4opQx9IQoOc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CIJ6ylrlXYaZ5MgA3Im/Ug0lUGNYwAE0s1S2BrVp5T1xaVQYnPgpa/q0ufNBEijcx
         pvUt191e+5/IdoudAoVLaUxovUMkbeMJuzu1qkzTUovBm7IIFPycQgJlqjJrC1erd3
         k+USb1p5O+QEqvns2kEuSxEK2lJlqHEWdE+JTARcbU9NM9iRPrwvbHz/B/bi9o311g
         LvM5v5qJlxnJHHOwU7waC6phTFo0nYwZ+SsJ//SHxri4lDbCN+0X91bjJFZeECoQFQ
         qlizB9QI9gJtCx8Cm8M+HOvRdsMVwSmo4vmaVvqneo9D4pUYM3tZ4XXR8zX7eUAH7C
         XCXr3rQIUneqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB7AAE49FA7;
        Thu, 30 Mar 2023 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request v2: ieee802154 for net 2023-03-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168015181982.11752.11485460121793339363.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 04:50:19 +0000
References: <20230329064541.2147400-1-stefan@datenfreihafen.org>
In-Reply-To: <20230329064541.2147400-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        miquel.raynal@bootlin.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Mar 2023 08:45:41 +0200 you wrote:
> Hello Dave, Jakub, Paolo.
> 
> An update from ieee802154 for your *net* tree:
> 
> Two small fixes this time.
> 
> Dongliang Mu removed an unnecessary null pointer check.
> 
> [...]

Here is the summary with links:
  - pull-request v2: ieee802154 for net 2023-03-29
    https://git.kernel.org/netdev/net/c/a4d7108c2efb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


