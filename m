Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525DB633A88
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiKVKua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbiKVKuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2149308
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AC9061644
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8760AC433D7;
        Tue, 22 Nov 2022 10:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669114214;
        bh=lM2YEGHO0Ra6y4DrbWcB0EIe7Qa/Bsn/hT4FcekBCL0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hv9DqnQwvRiylg1jK7Oq9GhbI79u9WZzGXaSrxAHm5ItFVT9n6sfu1AmUsE/qnXKT
         2/7pfD/faahJug1ueDqx3enjQmXFuWz9PGEL28w/Dq0icdzVUiMWPj8nELJvHigeSM
         MgSLh1O3o7DZDfnDyvF/+OeEJtRKb8AxC10hD2hCCoPlQaHit6DsQtJq1hnThe0lDP
         NuX10FTjVvf3fqppIH16vO3hlwXpIAm8AVaZz6S8SUHQvE8tdUamYbhHVGvFGOMpxD
         pXmHZn4ddk9WwHIa3C3yJ0QqS8G4s2cJDVhqVoascFHK5sfHsgJzItaNKlvg9b3dyF
         ciyVgtZkpFU6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6BE4CE270E3;
        Tue, 22 Nov 2022 10:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sparx5: fix error handling in sparx5_port_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166911421443.25842.16867836484292079030.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 10:50:14 +0000
References: <20221117125918.203997-1-liujian56@huawei.com>
In-Reply-To: <20221117125918.203997-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        horatiu.vultur@microchip.com, bjarni.jonasson@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 17 Nov 2022 20:59:18 +0800 you wrote:
> If phylink_of_phy_connect() fails, the port should be disabled.
> If sparx5_serdes_set()/phy_power_on() fails, the port should be
> disabled and the phylink should be stopped and disconnected.
> 
> Fixes: 946e7fd5053a ("net: sparx5: add port module support")
> Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: sparx5: fix error handling in sparx5_port_open()
    https://git.kernel.org/netdev/net/c/4305fe232b8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


