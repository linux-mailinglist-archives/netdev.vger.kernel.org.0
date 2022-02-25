Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DC04C451E
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 14:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbiBYNAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 08:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbiBYNAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 08:00:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8009C1DA002
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 05:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30B42B83032
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C53F0C340F2;
        Fri, 25 Feb 2022 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645794010;
        bh=+1GTd5QtR6/HfwTXVBJE1MhXD8273OR94yeVQt3/JFA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BGQb9LyXv5vTGGOp8BV6USJGINwqqyXs6YjvvCHmemvi7jNVJrc0srAvbR1fpgT1d
         cteNRfOuxiJw1KhG8OUhiZuC36Qq9Pj6bBkIGWMANl0lQSbSI5o4elzKBZEETxiaBa
         i0ac/7OIGP47+9dpFcdo/eIDcd9jvK/4Gw8pYHzmnJ91xY+wnfT0NkYO2+7X0q51I9
         hpLdui+gquqwJMAR4Ra892v/vi55ZxK9eTGN4AxgYNYdsW7T8PPsZMhPCwhblWzUZx
         ge6AVLuz6DiKUf8RNAmu461JBZI2DZXywQcVE8XyjKPeGlZM84t9bZFKpfMg+cCrUa
         dTu7uwFMHHWlg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A88E2E6D4BB;
        Fri, 25 Feb 2022 13:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sparx5: Fix add vlan when invalid operation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164579401068.25347.2669970883815920632.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 13:00:10 +0000
References: <20220225101516.mhafzkt3mlgmdafc@wse-c0155>
In-Reply-To: <20220225101516.mhafzkt3mlgmdafc@wse-c0155>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        bjarni.jonasson@microchip.com, netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 25 Feb 2022 11:15:16 +0100 you wrote:
> Check if operation is valid before changing any
> settings in hardware. Otherwise it results in
> changes being made despite it not being a valid
> operation.
> 
> Fixes: 78eab33bb68b ("net: sparx5: add vlan support")
> 
> [...]

Here is the summary with links:
  - [net] net: sparx5: Fix add vlan when invalid operation
    https://git.kernel.org/netdev/net/c/b3a34dc362c0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


