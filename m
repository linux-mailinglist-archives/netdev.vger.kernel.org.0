Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE3E579178
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiGSDuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbiGSDuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05C8BE39;
        Mon, 18 Jul 2022 20:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 431CC614E2;
        Tue, 19 Jul 2022 03:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 603FBC341CE;
        Tue, 19 Jul 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658202614;
        bh=ndJ1MGbwd7RXOXl29DvUBOR7/Zys1iUW9zi6N9WHXaU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZBiy/2WtcyUdFXNF+wxKh9wAyjgtjqT3oME3fBn4gaqKMZbgoXPUSek3TwcxZw0SK
         g1cPNPwnkJxSeRBxdZQHcuWo5V4tNsu+mnLVKif3aqjowvLUzz309sP4z3nWguElZH
         sD8FdJJuJsAV5FxQIjtUGFVsjswIIeQjKa6eauFiv6EWoMRzfVQITwOQGb7v9JX6Zc
         ttzdSWz5slklalf4eaEBNxh/Mt10p8vA7P8ZaitLgzoS4OWong+5g8UnZpT79eg3PD
         H0aXxS/5c1p2S+GLW2Eh+mpxMseeNcoexc3aa+R8tbPi1ztNXo9BwS9NaTv0CCISW4
         jemYAx9xSp9GA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47901E451B0;
        Tue, 19 Jul 2022 03:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: macb: fixup sparse warnings on __be16 ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165820261429.2183.6473988649266875182.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 03:50:14 +0000
References: <20220715173009.526126-1-ben.dooks@sifive.com>
In-Reply-To: <20220715173009.526126-1-ben.dooks@sifive.com>
To:     Ben Dooks <ben.dooks@sifive.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nicolas.ferre@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 15 Jul 2022 18:30:09 +0100 you wrote:
> The port fields in the ethool flow structures are defined
> to be __be16 types, so sparse is showing issues where these
> are being passed to htons(). Fix these warnings by passing
> them to be16_to_cpu() instead.
> 
> These are being used in netdev_dbg() so should only effect
> anyone doing debug.
> 
> [...]

Here is the summary with links:
  - [v2] net: macb: fixup sparse warnings on __be16 ports
    https://git.kernel.org/netdev/net-next/c/6ee49d629dd6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


