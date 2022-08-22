Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E7E59BFFC
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 15:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbiHVNBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 09:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbiHVNAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 09:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BA0356D1
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 06:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71D7BB811D7
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 13:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37E29C433D6;
        Mon, 22 Aug 2022 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661173218;
        bh=SrOf7IWhAjYlG1CRgUT8xkfeelkLcvu5Q59L+g4tp6w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FtatxaXJQB5uTPhhHLXfv/QxByL2hfbAZSXxMgFECal98Bs63jlfYh+73ZqDPKDU3
         hIfmqy1zzx4t6TJ4N56RsQTroXRyxA/1qBdI8bBACFU7OwdF73H4ZFLwW1TDrnvczt
         1DO/5Noz5wETfYoDavef6XjXYuYsv8vopIUhRleMPDYwBZAjdNUAu53ifOOUaoBx5W
         Xo5ROk0YX5fyaGpXkN4vPDJHsIAF0n3D1xrenttB/nV8OHvhkcHdgSlDhTwzinf5Cz
         YruwsD/k5wiu0xZKTcUFWcWQ4yKnCifhIp6QD4880ejissv1r8mPpPhZ/XLwxKpNlO
         +Qx+0QZdg9Fjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F72CE2A03D;
        Mon, 22 Aug 2022 13:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] tsnep: Various minor driver improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166117321812.20649.4800818186358568237.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 13:00:18 +0000
References: <20220817193017.44063-1-gerhard@engleder-embedded.com>
In-Reply-To: <20220817193017.44063-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Aug 2022 21:30:12 +0200 you wrote:
> During XDP development some general driver improvements has been done
> which I want to keep out of future patch series.
> 
> Gerhard(5):
>   tsnep: Fix TSNEP_INFO_TX_TIME register define
>   tsnep: Add loopback support
>   tsnep: Improve TX length handling
>   tsnep: Support full DMA mask
>   tsnep: Record RX queue
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] tsnep: Fix TSNEP_INFO_TX_TIME register define
    https://git.kernel.org/netdev/net-next/c/7d8dd6b5cd1d
  - [net-next,2/5] tsnep: Add loopback support
    https://git.kernel.org/netdev/net-next/c/4b2220089db3
  - [net-next,3/5] tsnep: Improve TX length handling
    https://git.kernel.org/netdev/net-next/c/b99ac75117c2
  - [net-next,4/5] tsnep: Support full DMA mask
    https://git.kernel.org/netdev/net-next/c/17531519cab6
  - [net-next,5/5] tsnep: Record RX queue
    https://git.kernel.org/netdev/net-next/c/d113efb19fea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


