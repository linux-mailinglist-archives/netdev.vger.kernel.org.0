Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4586762EE
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 03:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjAUCLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 21:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjAUCLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 21:11:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1060073AF3;
        Fri, 20 Jan 2023 18:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4E1362169;
        Sat, 21 Jan 2023 02:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41688C433A7;
        Sat, 21 Jan 2023 02:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674267019;
        bh=GtPIB8yrRdBZzYyEE+4TRbULPhyQrDxKe1xyUkqJfr0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fRyp9mULisUnSxS+roMIKgn144Xa64pl0WlQitWYaWdOSWi63QEpvFwco/oDxclwO
         mwshC4L+MI0Md0Kj/e7wEEcw5QR/yRnNO6EN8Si1zqTaMTFNooxgv6E/GkkzvOnqgo
         8JEpNN1gqszKfKyOuKke9iFriJfxLGdtK6lTYd1hIGSEZzMHS9CTllxlT78vGEeSiM
         D+K+vX5F/gzqYt2Yk6eJbK8Lae1QzLtpZJmnHDocyihmUXlMzjb9Iart77BPd4pF0T
         O8FX7+Az+98zUXIaOiDyngUGebn3mCAn0oMAxEZPb5WLVXkn7YPKFFOZbRVywc4DiF
         Ogm15/iYetOXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2BFFEE54D2B;
        Sat, 21 Jan 2023 02:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] r8152: improve the code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167426701917.27266.1166869033080131872.git-patchwork-notify@kernel.org>
Date:   Sat, 21 Jan 2023 02:10:19 +0000
References: <20230119074043.10021-397-nic_swsd@realtek.com>
In-Reply-To: <20230119074043.10021-397-nic_swsd@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 19 Jan 2023 15:40:41 +0800 you wrote:
> These are some minor improvements depending on commit ec51fbd1b8a2 ("r8152:
> add USB device driver for config selection").
> 
> Hayes Wang (2):
>   r8152: remove rtl_vendor_mode function
>   r8152: reduce the control transfer of rtl8152_get_version()
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] r8152: remove rtl_vendor_mode function
    https://git.kernel.org/netdev/net-next/c/95a4c1d617b9
  - [net-next,2/2] r8152: reduce the control transfer of rtl8152_get_version()
    https://git.kernel.org/netdev/net-next/c/02767440e1dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


