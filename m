Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F4061437D
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 04:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiKADKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 23:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiKADKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 23:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDC713F46
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 20:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B91961539
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 03:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84116C433D6;
        Tue,  1 Nov 2022 03:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667272218;
        bh=GUQ28nfD2vi8OQOBqagza9YalmUknNsiDYz2PZ9ZhEQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kfxsiq+i3Barc22fH/0PBCWQ4PjGkzvklyM5fMnSjYQIEozc/u8IbZQM4kammAl0S
         aM2YXy6wv85EsH9FXVK5KXD9121A1eqmWg8H19S9QrPK5yPm/5ReIMucuQnCeZKTkm
         rujdh0L1m6E6xfFeIA6ZCPVUNQ4iRp7YKMkL5KBKw1TbTx6LVQLxuhUGpcZ9J1DspL
         w+K2ArDzQtuiyQk7pQiFQwIbYU+m9yW6Af2inTWzwBg+X8UXpJN59nnl88bEhoXPVy
         D9k1t0BJeGIBnQHj6PNelEPZzG3htt8WI6iq/5+HIoyAZmOjayiLj1o/xaCSu38Pac
         ZnF2BJrzB2maA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6868AE524C0;
        Tue,  1 Nov 2022 03:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] net: ftmac100: prepare data path for receiving single
 segment packets > 1514
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166727221842.414.9139792048135491392.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Nov 2022 03:10:18 +0000
References: <20221028183220.155948-1-saproj@gmail.com>
In-Reply-To: <20221028183220.155948-1-saproj@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        vladimir.oltean@nxp.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 28 Oct 2022 21:32:18 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Eliminate one check in the data path and move it elsewhere, to where our
> real limitation is. We'll want to start processing "too long" frames in
> the driver (currently there is a hardware MAC setting which drops
> theses).
> 
> [...]

Here is the summary with links:
  - [1/3] net: ftmac100: prepare data path for receiving single segment packets > 1514
    https://git.kernel.org/netdev/net-next/c/55f6f3dbcf4c
  - [2/3] net: ftmac100: report the correct maximum MTU of 1500
    https://git.kernel.org/netdev/net-next/c/30f837b7b923
  - [3/3] net: ftmac100: allow increasing MTU to make most use of single-segment buffers
    https://git.kernel.org/netdev/net-next/c/37c8489012dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


