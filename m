Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508E951D6A9
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 13:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391348AbiEFLeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 07:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391358AbiEFLd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 07:33:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77C013F7F
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 04:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C98061EC5
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 11:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7EC8C385AA;
        Fri,  6 May 2022 11:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651836613;
        bh=Keq1zuOuWB7H3UbHeXdjUaRHaXUh/qwUJtCQ4Y0cZd8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EuYCEKwcmPbdScerESADs/GvCDwU6VKfBLk4UoujBjnrAn5PXB/ebkt1eVIcUDs0s
         YFqaDR2RYjfAeYj9wcb6VWgdGqz2cTijBvZvXnw8d/D58IUTwv6uy6xroWiOD40Puq
         kly6J8W5OKlFk+1lP0aRE2AlijDiAy1EliylRi2titWj1F2oALj1HC7cHtzj8aQDeM
         dTKbLXj1UHX2Gxq3RtDeYBz4pomf72L9+mCoOLK1Kw7X2YYPZ/eKCmA47EwKLjU1fx
         NfYl05l4ak1KlcUOhi/lp6VBV+Y2y7bLsoZBtCCFLyWphWxMgWaxnDdmwiQVuPaojA
         ahGWrqeHC2tDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB019F03870;
        Fri,  6 May 2022 11:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: disambiguate the TSO and GSO limits
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165183661369.26942.12493737757589783291.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 11:30:13 +0000
References: <20220506025134.794537-1-kuba@kernel.org>
In-Reply-To: <20220506025134.794537-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, alexander.duyck@gmail.com,
        stephen@networkplumber.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  5 May 2022 19:51:30 -0700 you wrote:
> This series separates the device-reported TSO limitations
> from the user space-controlled GSO limits. It used to be that
> we only had the former (HW limits) but they were named GSO.
> This probably lead to confusion and letting user override them.
> 
> The problem came up in the BIG TCP discussion between Eric and
> Alex, and seems like something we should address.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: add netif_inherit_tso_max()
    https://git.kernel.org/netdev/net-next/c/6df6398f7c8b
  - [net-next,2/4] net: don't allow user space to lift the device limits
    https://git.kernel.org/netdev/net-next/c/14d7b8122fd5
  - [net-next,3/4] net: make drivers set the TSO limit not the GSO limit
    https://git.kernel.org/netdev/net-next/c/ee8b7a1156f3
  - [net-next,4/4] net: move netif_set_gso_max helpers
    https://git.kernel.org/netdev/net-next/c/744d49daf8bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


