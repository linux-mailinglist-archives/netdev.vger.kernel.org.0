Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7277C50524B
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 14:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239325AbiDRMkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 08:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240690AbiDRMja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 08:39:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BEB12AFB;
        Mon, 18 Apr 2022 05:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5E9560F0A;
        Mon, 18 Apr 2022 12:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49668C385AE;
        Mon, 18 Apr 2022 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650285011;
        bh=JxYUHWfGukrKeEVSVM/JogyJAEmmHT9oqMMQ5s4QGN8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sF9sNCZVZuond4+u2k9kWnzvbIgrI9BI5bds67c/QBrn8WbjxwXQ3JqfDn2c9RFD5
         o6Amh6OIvHjPvUc0Bx1d/YciQ907zdPhXDrScsieya7DoVsoX6Q7b981dijNRKQEdY
         keAnos51W8qB1ZburIrtZWbfXziIBcHRLddrQ/YRv6ay/Fafn6cABKgfJ82bAKwZz9
         wK+RqA01mZTE5x0TMFoN9hWzjXhejzw9cRCJzAvT5RRCPO6s6RgTp1pU9yIiMEXf/j
         R82R3ERMlWtgRPqHuJVfYMvpY0kdmBDmx1bwtZelUJxYsZKbsT1793DOelrvI++Hfd
         HbOC32ifhYf1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24C96E8DBD4;
        Mon, 18 Apr 2022 12:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] docs: net: dsa: describe issues with checksum
 offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165028501114.22399.12104889374283323185.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Apr 2022 12:30:11 +0000
References: <20220416052737.25509-1-luizluca@gmail.com>
In-Reply-To: <20220416052737.25509-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        tobias@waldekranz.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vladimir.oltean@nxp.com, corbet@lwn.net, kuba@kernel.org,
        davem@davemloft.net
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 16 Apr 2022 02:27:37 -0300 you wrote:
> DSA tags before IP header (categories 1 and 2) or after the payload (3)
> might introduce offload checksum issues.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/networking/dsa/dsa.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Here is the summary with links:
  - [net-next,v3] docs: net: dsa: describe issues with checksum offload
    https://git.kernel.org/netdev/net-next/c/a997157e42e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


