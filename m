Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9B75A3326
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 02:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbiH0AaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 20:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241599AbiH0AaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 20:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE49DABAC;
        Fri, 26 Aug 2022 17:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 441ED61C60;
        Sat, 27 Aug 2022 00:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FFACC433D6;
        Sat, 27 Aug 2022 00:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661560215;
        bh=zji55SH6cKjlLLE4iBryhPDn+LMywJAjWMxf273QwiY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B/c/PELhqO4XcNVCJcGm9SgUk6NmBI+bESJu5bfm7d66Xxo/1s666iyeHkALSJx9r
         1l01nqIv43anKyqUfkMI93PB0pQi1cLVa0G3D1c6EPrSGyVPBYusnIJlOnvy66n7iZ
         0XqJ52Vq25cmU0emGJmBWGOy6nwQccogDZKP6bA/EuFr37+oCwp8QriIDpOAxys/87
         UNrlaV05v0hdGfvOTTrnH4VWwyI/UcepUUrUpTvxQWZjuggGDRePXx/WFB6BzRJF8C
         5jQFEaMLgU0F++mkSeNq7/PWCyTdoOWXGIBxgpS7UXPzKtxhnCG+PqjpJ5EivgpY0z
         HFMqT1Zragn3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6BE9DE2A03C;
        Sat, 27 Aug 2022 00:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2022-08-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156021543.1708.11392622472922506498.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 00:30:15 +0000
References: <20220825234559.1837409-1-luiz.dentz@gmail.com>
In-Reply-To: <20220825234559.1837409-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Aug 2022 16:45:59 -0700 you wrote:
> The following changes since commit 4c612826bec1441214816827979b62f84a097e91:
> 
>   Merge tag 'net-6.0-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-08-25 14:03:58 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-08-25
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2022-08-25
    https://git.kernel.org/netdev/net/c/037c97b2886e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


