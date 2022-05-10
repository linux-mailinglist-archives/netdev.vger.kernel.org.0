Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064595226E3
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbiEJWaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236719AbiEJWaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37682E15FA;
        Tue, 10 May 2022 15:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA74161811;
        Tue, 10 May 2022 22:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 248F8C385D3;
        Tue, 10 May 2022 22:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652221813;
        bh=tq6Lj50E3IpWlV66/XO9VHgtd+iJ7qGiygGljBpexSE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZFbI0mVlqtJAqJqDGvIkU6SmKMUeudh0g0dwm2PdiafUS77KOMwApTxbCp6E+4BJh
         Ir8rEqVxHijTtAHgUuA1paXx1qX5oXQ+zycaGrxpYzK75nveFulQ+TQZccWobOlNtW
         aaLrA4yhG0WOB3ttTg56c2wyXHnlpOkDHlEhy7RgmAnOMWuvhyytl25bmHOeAUPlzs
         9oHwpByI95zm+SPS6UB9UsTm+9/vUdWU24IF+1mMr/WhK3yPyvVRfT8UB1TctvDht4
         ZhY9TEpMk4Mrhz/N1LKPoFUdJg1NlLuihuIbxIG5kHGSa4ZPSUeCIPqNxcI9cdN4M/
         OGdVf5LToKwyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F30ABF03933;
        Tue, 10 May 2022 22:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] net: phy: micrel: Fix incorrect variable type in
 micrel
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165222181298.9200.1509164955750702026.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 22:30:12 +0000
References: <20220510015521.2542096-1-wanjiabing@vivo.com>
In-Reply-To: <20220510015521.2542096-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, horatiu.vultur@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Tue, 10 May 2022 09:55:21 +0800 you wrote:
> In lanphy_read_page_reg, calling __phy_read() might return a negative
> error code. Use 'int' to check the error code.
> 
> Fixes: 7c2dcfa295b1 ("net: phy: micrel: Add support for LAN8804 PHY")
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> 
> [...]

Here is the summary with links:
  - [v3,net] net: phy: micrel: Fix incorrect variable type in micrel
    https://git.kernel.org/netdev/net/c/12a4d677b1c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


