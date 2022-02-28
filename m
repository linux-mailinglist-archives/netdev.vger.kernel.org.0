Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9624C6B70
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 13:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbiB1MAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 07:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiB1MAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 07:00:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA6E6661E;
        Mon, 28 Feb 2022 04:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D2606111E;
        Mon, 28 Feb 2022 12:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0402FC340F2;
        Mon, 28 Feb 2022 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646049611;
        bh=+D6abYhH3MGWU4QGuKUoM0z8ucy3/j4YOANt0sFJeLc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YTVqcP6nqTnwgBeOD3seles4QOlwSv9CiS6oYdv3rPHlcw3jK52Ozpd2r2EWPAeBO
         qRF2eCRCDxNDFubgqi8ix4XgTSxsR495gwhdBrtdHcr5IBEL4BFYCQ/w/TshVZcaTY
         UE9PSqpvSoDWKs+xcEdHVzrujlpRSoOfeXcvySZ+M6PlMW9scIJm0gEAfvwv2zbVVI
         IERL5AZQx5U5eMbKZhhE4//ftCPTl0bpHt32VCdT5w69yoRDP3w+KDMSs6eoe7Z0ER
         oHMnXvostsaOYPOgwClN6NHuMWoo9leqG5OEZIZPDt5/YG4IEkz2IHmgYLQEB9atOG
         RHnVJUheWsUvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DD672F0383A;
        Mon, 28 Feb 2022 12:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net-next 1/1] net: dsa: felix: remove prevalidate_phy_mode
 interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164604961090.22318.7948733852407257272.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 12:00:10 +0000
References: <20220226223650.4129751-1-colin.foster@in-advantage.com>
In-Reply-To: <20220226223650.4129751-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 26 Feb 2022 14:36:50 -0800 you wrote:
> All users of the felix driver were creating their own prevalidate_phy_mode
> function. The same logic can be performed in a more general way by using a
> simple array of bit fields.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [v1,net-next,1/1] net: dsa: felix: remove prevalidate_phy_mode interface
    https://git.kernel.org/netdev/net-next/c/acf242fc739e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


