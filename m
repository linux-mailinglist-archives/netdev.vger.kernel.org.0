Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE76E6BDDA3
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCQAa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjCQAaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:30:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4F11BAE4;
        Thu, 16 Mar 2023 17:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFD8FB82396;
        Fri, 17 Mar 2023 00:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DEAAC433A8;
        Fri, 17 Mar 2023 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679013020;
        bh=KhpEYfBg/Ny2yT11VUI8QjCKTFwhFo+BIr9t653yUt4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m4zkkcuMofm3Z5SqSI67ztC6V6AkXqnEJEQHMgOut6yZqLyG32zMCSAGCkN67XM02
         x7FYDGC7CN9RkCwShlQ5OTJ11eSZfGS+AnwOqFaroNTxp7dE+njxAb98/uiwdIFNke
         JGoyQmkW/8tXY/O92p1AU3xxENuSbXkQbozmpUs6JjckTcf1pzD3CHoioA3ZL3hS5e
         cuJeHoHXqWHRZR0RkgfWGPP6w5sxPth/yVgBUJnfbpwm+LFLbRr7buMqaH3aZpn76Y
         CzJxrHY1UWNptSnUXyTg7PUs0FBl1UPyBC+NFeJm9r9gGEAAhGiyG8dxvQuI3J6LY5
         Wdbgrh6WtNjxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A581E501EA;
        Fri, 17 Mar 2023 00:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: smsc75xx: Move packet length check to prevent
 kernel panic in skb_pull
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167901302030.26766.10050313158281660408.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 00:30:20 +0000
References: <20230316110540.77531-1-szymon.heidrich@gmail.com>
In-Reply-To: <20230316110540.77531-1-szymon.heidrich@gmail.com>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     kuba@kernel.org, steve.glendinning@shawell.net,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Mar 2023 12:05:40 +0100 you wrote:
> Packet length check needs to be located after size and align_count
> calculation to prevent kernel panic in skb_pull() in case
> rx_cmd_a & RX_CMD_A_RED evaluates to true.
> 
> Fixes: d8b228318935 ("net: usb: smsc75xx: Limit packet length to skb->len")
> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: usb: smsc75xx: Move packet length check to prevent kernel panic in skb_pull
    https://git.kernel.org/netdev/net/c/43ffe6caccc7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


