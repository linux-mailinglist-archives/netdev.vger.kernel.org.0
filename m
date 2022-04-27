Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A03510D7D
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 02:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356510AbiD0Axg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 20:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356495AbiD0Ax1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 20:53:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E5912089;
        Tue, 26 Apr 2022 17:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E53DB8244F;
        Wed, 27 Apr 2022 00:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FC73C385AD;
        Wed, 27 Apr 2022 00:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020612;
        bh=5ugFcVFrOmmS9Q8uSz+4TjYa6aVuDjAntW4uD8UynZY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pAPNnXXEyE4nya2VSXNhs71bxP9T1wlsCGw2bB0EXVMLkKAC5Nqlks3ZaXRf0f8/m
         S94m0uJHdR9Mx2KuO36FJ8iGA4x7kTrA3+OSrll1ogDiEh802lN/UY2BgR3ZRcpJJm
         XmyTJyO/PWbP2M8Lw2TECVCLljVKaSkuiEvfwm8XW96VDmcAuGtjOcWrqDDIdXu6mu
         ROTZRernPK8Y94H0cFIsqjH/gIdEgpqRjtEErV0m4WHkoO//n9QeeA4FxWmSV/XLg5
         DO191wF4qG5MKs1Z/cUIAOYUtXyTjm8RqcfF+tW9ZoeL6NE8PhcpLe5b7ufPNIwoqt
         qbz7PxPJ8XaNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EA21EF03840;
        Wed, 27 Apr 2022 00:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] net: Remove unused __SLOW_DOWN_IO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165102061195.18100.14728173281862395377.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 00:50:11 +0000
References: <20220425212644.1659070-1-helgaas@kernel.org>
In-Reply-To: <20220425212644.1659070-1-helgaas@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 25 Apr 2022 16:26:42 -0500 you wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> Remove unused mentions of __SLOW_DOWN_IO.
> 
> Bjorn Helgaas (2):
>   net: wan: atp: remove unused eeprom_delay()
>   net: remove comments that mention obsolete __SLOW_DOWN_IO
> 
> [...]

Here is the summary with links:
  - [1/2] net: wan: atp: remove unused eeprom_delay()
    https://git.kernel.org/netdev/net-next/c/dac173db114d
  - [2/2] net: remove comments that mention obsolete __SLOW_DOWN_IO
    https://git.kernel.org/netdev/net-next/c/e39f63fe0d94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


