Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89FF673103
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 06:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjASFMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 00:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjASFMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 00:12:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A48110A91
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 21:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34E1E61B22
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 05:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9423EC433F2;
        Thu, 19 Jan 2023 05:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674105019;
        bh=qHiRUKJlgp2mf6wHPfvx1O2W+L6sxETEI9H3+zs7wXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TjjNaRoUKWgRi0bMo2L1U3K7l9N5M/eCZJ3M674GUEzkS0/sBcLwrdV+KLvRDe1RG
         kXtqbSHJ65fvCU+XQEWlLriKzjtFvAYPPt2wgXYkSb2cTmF0jNwAqJi0mQbUYoSykn
         AJu11p73ftAbGkEcs/tdJH7xUR8nWKtZsK/v12/Z1u6AVMZNe0sK26GEgrQyWWxaso
         7GEzaNOPIc/UHSk+w1hr5ftmf4WCBoFvO768VOWx9tAWhjxLAn8xQvc1IDuRUmNWeE
         BFZuqztpX49HgJSI3lLeM9hngRekDWOxHTiQOve1+WqS+ML2dHpJ2Fn5XCF7A+9hvA
         +RKiwq98dM1Hw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 814FFC40C5E;
        Thu, 19 Jan 2023 05:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] ENETC BD ring cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167410501952.20849.3176784852303427442.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 05:10:19 +0000
References: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com
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

On Wed, 18 Jan 2023 01:02:22 +0200 you wrote:
> The highlights of this patch set are:
> 
> - Installing a BPF program and changing PTP RX timestamping settings are
>   currently implemented through a port reconfiguration procedure which
>   triggers an AN restart on the PHY, and these procedures are not
>   generally guaranteed to leave the port in a sane state. Patches 9/12
>   and 11/12 address that.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] net: enetc: set next_to_clean/next_to_use just from enetc_setup_txbdr()
    https://git.kernel.org/netdev/net-next/c/1cbf19c575dd
  - [net-next,02/12] net: enetc: set up RX ring indices from enetc_setup_rxbdr()
    https://git.kernel.org/netdev/net-next/c/fbf1cff98c95
  - [net-next,03/12] net: enetc: create enetc_dma_free_bdr()
    https://git.kernel.org/netdev/net-next/c/0d6cfd0f5e4d
  - [net-next,04/12] net: enetc: rx_swbd and tx_swbd are never NULL in enetc_free_rxtx_rings()
    https://git.kernel.org/netdev/net-next/c/2c3387109d11
  - [net-next,05/12] net: enetc: drop redundant enetc_free_tx_frame() call from enetc_free_txbdr()
    https://git.kernel.org/netdev/net-next/c/bbd6043f74e1
  - [net-next,06/12] net: enetc: bring "bool extended" to top-level in enetc_open()
    https://git.kernel.org/netdev/net-next/c/d075db51e013
  - [net-next,07/12] net: enetc: split ring resource allocation from assignment
    https://git.kernel.org/netdev/net-next/c/f3ce29e169d0
  - [net-next,08/12] net: enetc: move phylink_start/stop out of enetc_start/stop
    https://git.kernel.org/netdev/net-next/c/598ca0d09056
  - [net-next,09/12] net: enetc: implement ring reconfiguration procedure for PTP RX timestamping
    https://git.kernel.org/netdev/net-next/c/5093406c784f
  - [net-next,10/12] net: enetc: rename "xdp" and "dev" in enetc_setup_bpf()
    https://git.kernel.org/netdev/net-next/c/766338c79b10
  - [net-next,11/12] net: enetc: set up XDP program under enetc_reconfigure()
    https://git.kernel.org/netdev/net-next/c/c33bfaf91c4c
  - [net-next,12/12] net: enetc: prioritize ability to go down over packet processing
    https://git.kernel.org/netdev/net-next/c/ff58fda09096

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


