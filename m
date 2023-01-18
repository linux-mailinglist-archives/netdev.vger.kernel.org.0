Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95885671209
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjARDkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjARDkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E026D53558;
        Tue, 17 Jan 2023 19:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F36061625;
        Wed, 18 Jan 2023 03:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1B38C433D2;
        Wed, 18 Jan 2023 03:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674013218;
        bh=LAEh1qjeJJ3YVp+GzADUviUyXXdjaMIyAqB9kh1X3d8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cLz7/cNXQ3WV7JrQfGkdGY3wR5Gk7CowU9fGOo5Qfk1W7eve67VpHaazDA4NkYpBf
         Ep5DtxJY1f/46UyNY0DljFA91DZAHOoFA3Tk20yYudM/DIpAFqFqVMuLQ6J9nEpSFy
         vfkflOtniiVkgn3TJXTU0ZnC4Rw+vNZK6zVflaCezisCASPbsfnM9GypaheK2gsA9D
         MTxWQV8V0OvZA3TnIEiva1VSha91BCNNWXxNeEo+jLvgVTvqSTUjQWQxsEuBxo5tXw
         a0vnjNyeXHnYqFcb3Gs3/p1ZzBJwEAs7APyFilUpgW62Mi8R5yDEoezLBFnnSC5QBa
         U60lFiLKvpFwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4C45C395C3;
        Wed, 18 Jan 2023 03:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] net: mdio: Continue separating C22 and C45
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167401321873.20942.13534371074632308788.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 03:40:18 +0000
References: <20230116-net-next-c45-seperation-part-3-v1-0-0c53afa56aad@walle.cc>
In-Reply-To: <20230116-net-next-c45-seperation-part-3-v1-0-0c53afa56aad@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, dqfext@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, linux@armlinux.org.uk, bh74.an@samsung.com,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        thomas.lendacky@amd.com, Shyam-sundar.S-k@amd.com,
        s.shtylyov@omp.ru, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        linux-renesas-soc@vger.kernel.org, andrew@lunn.ch
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

On Tue, 17 Jan 2023 00:52:16 +0100 you wrote:
> I've picked this older series from Andrew up and rebased it onto
> the latest net-next.
> 
> This is the third (and hopefully last) patch set in the series which
> separates the C22 and C45 MDIO bus transactions at the API level to the
> MDIO bus drivers.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] net: dsa: mt7530: Separate C22 and C45 MDIO bus transactions
    https://git.kernel.org/netdev/net-next/c/defa2e541894
  - [net-next,02/12] net: sxgbe: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/e078c8b5eab7
  - [net-next,03/12] net: nixge: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/064a6a887f95
  - [net-next,04/12] net: macb: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/a4d65b1de2a2
  - [net-next,05/12] ixgbe: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/308c8ffd5a7d
  - [net-next,06/12] ixgbe: Use C45 mdiobus accessors
    https://git.kernel.org/netdev/net-next/c/ab2960f0fdfe
  - [net-next,07/12] net: hns: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/41799a77f4bb
  - [net-next,08/12] amd-xgbe: Separate C22 and C45 transactions
    https://git.kernel.org/netdev/net-next/c/070f6186a2f1
  - [net-next,09/12] amd-xgbe: Replace MII_ADDR_C45 with XGBE_ADDR_C45
    https://git.kernel.org/netdev/net-next/c/47e61593f367
  - [net-next,10/12] net: dsa: sja1105: C45 only transactions for PCS
    https://git.kernel.org/netdev/net-next/c/ae271547bba6
  - [net-next,11/12] net: dsa: sja1105: Separate C22 and C45 transactions for T1 MDIO bus
    https://git.kernel.org/netdev/net-next/c/c708e1350370
  - [net-next,12/12] net: ethernet: renesas: rswitch: C45 only transactions
    https://git.kernel.org/netdev/net-next/c/95331514d95f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


