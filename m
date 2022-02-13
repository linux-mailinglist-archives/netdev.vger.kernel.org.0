Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A7C4B3B4A
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 13:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbiBMMUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 07:20:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbiBMMUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 07:20:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6198B5D18A
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 04:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 199F0B80B08
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD3C3C340F1;
        Sun, 13 Feb 2022 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644754810;
        bh=HaeVfrg3L096rfnVOIlNIeWwAyDUi/wJSmespuzoAHY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ub5BoSLZNfaH7GInVfhFvxx+yAIbxPCCoRc43ak9ydS/iP9r8UvlhTOj62+K0NkU5
         SFaRZ4L5mKZCDxXhT098dAHItD3QHGHpGN7LuZ0PCU0bzZLVDL1RkvGtKp/Gu9WAeQ
         AdECle+wXI2AVjA/Gx/5PQ/rihvb65f5OZKvyQBZJFidieLRVzutL2HuIi5rsDV7qO
         3FuCE5HwObAVrd504sjp2AMYW94k8BZU8ovTyF/8GPPrgrEULpK0ziADfhjklyeA4j
         NkUEPFYb2uZ6oYQ0nxGV1bnn+dC8lYbWiStc0IXj7/V3u2Ng2rTToA8Tir6avvlLOv
         4O5T1h5/CblYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBFA7E6BBD2;
        Sun, 13 Feb 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V1 0/5] net: lan743x: PCI11010 / PCI11414 devices
 Enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164475481083.14254.15796641250627236354.git-patchwork-notify@kernel.org>
Date:   Sun, 13 Feb 2022 12:20:10 +0000
References: <20220212155315.340359-1-Raju.Lakkaraju@microchip.com>
In-Reply-To: <20220212155315.340359-1-Raju.Lakkaraju@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        kuba@kernel.org, UNGLinuxDriver@microchip.com
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

On Sat, 12 Feb 2022 21:23:10 +0530 you wrote:
> This patch series adds support of the Ethernet function of the PCI11010 / PCI11414 devices to the LAN743x driver.
> The PCI1xxxx family of devices consists of a PCIe switch with a variety of embedded PCI endpoints on its downstream ports.
> The PCI11010 / PCI11414 devices include an Ethernet 10/100/1000/2500 function as one of those embedded endpoints.
> 
> Raju Lakkaraju (5):
>   net: lan743x: Add PCI11010 / PCI11414 device IDs
>   net: lan743x: Add support for 4 Tx queues
>   net: lan743x: Increase MSI(x) vectors to 16 and Int de-assertion
>     timers to 10
>   net: lan743x: Add support for SGMII interface
>   net: lan743x: Add support for Clause-45 MDIO PHY management
> 
> [...]

Here is the summary with links:
  - [net-next,V1,1/5] net: lan743x: Add PCI11010 / PCI11414 device IDs
    https://git.kernel.org/netdev/net-next/c/bb4f6bffe33c
  - [net-next,V1,2/5] net: lan743x: Add support for 4 Tx queues
    https://git.kernel.org/netdev/net-next/c/cf9aaea8e55b
  - [net-next,V1,3/5] net: lan743x: Increase MSI(x) vectors to 16 and Int de-assertion timers to 10
    https://git.kernel.org/netdev/net-next/c/ac16b6eb39d6
  - [net-next,V1,4/5] net: lan743x: Add support for SGMII interface
    https://git.kernel.org/netdev/net-next/c/a46d9d37c4f4
  - [net-next,V1,5/5] net: lan743x: Add support for Clause-45 MDIO PHY management
    https://git.kernel.org/netdev/net-next/c/a2ab95a31352

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


