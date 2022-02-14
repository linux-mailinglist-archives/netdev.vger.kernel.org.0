Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E28C4B52CF
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354942AbiBNOKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:10:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354904AbiBNOKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6DD25F4
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 06:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8831960FC3
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 14:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEED4C340F5;
        Mon, 14 Feb 2022 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644847811;
        bh=Y4/XDgc+544Dgh9xNve5sRdD88/V2UCbZa/mjVTRaFM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sRCujBVgv1DPZFsh833dCAsx13BTJnCT4XlstqaIcf1shtsb7gkqRxEjNQtF3JqNL
         vVCCh7g80YR4VGpnwtfHmEVan7cosE3/9+QHr0KRVfJwP+6JZqmNBpMWIy6fJRx77a
         p6f4W9DA6vJlNk0GcvctIUQracHkY0VMFSROa7B62lc5eAvhSa21OQmeP61u7Zu45K
         0jcIgu/aTqeuJzMPkFyU5eEIlveA2Igbus69AA9TtHXuDCk7Wtf08LdSr7BL/Apmgv
         Edt7GQNhKWJD+EdeXpsKziPj7ddYo1A/UpV71XfPefTKcOxOn3aWGVugeFIhBV0hV1
         hK+2dp05YBYaw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DCB89E6D453;
        Mon, 14 Feb 2022 14:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/2] net: dsa: realtek: realtek-mdio: reset before
 setup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484781089.8191.12338422990431960463.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 14:10:10 +0000
References: <20220214022012.14787-1-luizluca@gmail.com>
In-Reply-To: <20220214022012.14787-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 13 Feb 2022 23:20:10 -0300 you wrote:
> This patch series cleans the realtek-smi reset code and copy that to the
> realtek-mdio.
> 
> v1-v2)
> - do not run reset code block if GPIO is missing. It was printing "RESET
>   deasserted" even when there is no GPIO configured.
> - reset switch after dsa_unregister_switch()
> - demote reset messages to debug
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] net: dsa: realtek: realtek-smi: clean-up reset
    https://git.kernel.org/netdev/net-next/c/9a236b543f6b
  - [net-next,v3,2/2] net: dsa: realtek: realtek-mdio: reset before setup
    https://git.kernel.org/netdev/net-next/c/05f7b042c5a6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


