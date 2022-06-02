Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE0153B127
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiFBAkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 20:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbiFBAkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 20:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4692F29B2C8
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 17:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1A54615A6
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 00:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5026BC34119;
        Thu,  2 Jun 2022 00:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654130412;
        bh=xOeJfKY3LDCjFEdw3KE9lk+llhEVeVit8w13SgfLvU4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sUQWK9+FTzMUXqQ1liLgrxg785spBXSn3rOzU74LvKdIUY1YSztLbl+CdOUqJrJlT
         IDnTXMTV7srNImpbLCc9HghCw4zwU1OLfpuOfYEO9cN5b2HWVUXcPNwMnOSQc9Y4uz
         3sbjAcA5/d7rKYRa5wi6O2aQX4nk1ts79rWmSpPP6RSe/ocP4u9yBrqxchJspzndVk
         Q9qdjjsfKXe6zKAse3uv4+QDRd5rNuXkByXSa50JRW766Q/mJ2D3tue0VoWZEUWH/S
         eiXCJk1TRgelipbBxDPQ8SsCIC2e+BWjy0+cRLDaHUXex3HnqjIYdK4ClCM9CqhR1x
         cArCkfFqjHgxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 304BBF0394F;
        Thu,  2 Jun 2022 00:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] socket: Don't use u8 type in uapi socket.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165413041219.18481.5655890932630615236.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 00:40:12 +0000
References: <20220531094345.13801-1-tklauser@distanz.ch>
In-Reply-To: <20220531094345.13801-1-tklauser@distanz.ch>
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        David.Laight@ACULAB.COM, hmukos@yandex-team.ru,
        netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 31 May 2022 11:43:45 +0200 you wrote:
> Use plain 255 instead, which also avoid introducing an additional header
> dependency on <linux/types.h>
> 
> Fixes: 26859240e4ee ("txhash: Add socket option to control TX hash rethink behavior")
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
> v3: changed to plain 255 as suggested by David Laight and Paolo Abeni
> 
> [...]

Here is the summary with links:
  - [v3] socket: Don't use u8 type in uapi socket.h
    https://git.kernel.org/netdev/net/c/8d3398ba2a0d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


