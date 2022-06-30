Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABB8560FBE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 05:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbiF3DkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 23:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiF3DkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 23:40:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886BB1E3D0;
        Wed, 29 Jun 2022 20:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E0485CE1290;
        Thu, 30 Jun 2022 03:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51991C341CA;
        Thu, 30 Jun 2022 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656560414;
        bh=GRbxPmIzfYUd0olcDNpMbJNFXHPvb4nZdiy0NGphrGM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bhA+3/gNul4m4v+BbNir3u6UqcgU80tomzUMKByDoBDcY3OUJi8LalB3W/h9LIQRl
         A6ThfNeqqYmz+eLEoctgnsLxBFYkt1YnirArlKxKzviYEqRfLDRXFU1WeLOSPt6nJF
         unsGZvyEAchoILtCEmUuYyfMudSXJDihYAyoDRlNhZ1zESRWPN7pR/TTd5dFDpo4i7
         JeCyYkclxKBKER8Pi81i7MY1bzMU9h3NiV40xXufZ/Ra6FVwSkK5tPfeqFLioYmgeK
         r/JxNvUAFUGfaJTvujhQDlMbNErV3K5TUd+WhQ024ascFDKu2C8tREgWWCsyLRREif
         8w15H8okvwZCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D31EE49BBA;
        Thu, 30 Jun 2022 03:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] net: dsa: add pause stats support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165656041424.25608.15286972215720415620.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 03:40:14 +0000
References: <20220628085155.2591201-1-o.rempel@pengutronix.de>
In-Reply-To: <20220628085155.2591201-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        lukas@wunner.de, UNGLinuxDriver@microchip.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Jun 2022 10:51:51 +0200 you wrote:
> changes v2:
> - add Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> - remove packet calculation fix from ar9331 patch. It needs more fixes.
> - add packet calculation fix for microchip
> 
> Oleksij Rempel (4):
>   net: dsa: add get_pause_stats support
>   net: dsa: ar9331: add support for pause stats
>   net: dsa: microchip: add pause stats support
>   net: dsa: microchip: count pause packets together will all other
>     packets
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net: dsa: add get_pause_stats support
    https://git.kernel.org/netdev/net-next/c/3d410403a572
  - [net-next,v2,2/4] net: dsa: ar9331: add support for pause stats
    https://git.kernel.org/netdev/net-next/c/ea294f39b438
  - [net-next,v2,3/4] net: dsa: microchip: add pause stats support
    https://git.kernel.org/netdev/net-next/c/c4748ff6566b
  - [net-next,v2,4/4] net: dsa: microchip: count pause packets together will all other packets
    https://git.kernel.org/netdev/net-next/c/961d6c70d886

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


