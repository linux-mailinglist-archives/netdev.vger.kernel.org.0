Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEFE4CFD95
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiCGMBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbiCGMBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:01:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FB278912;
        Mon,  7 Mar 2022 04:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA70160ED9;
        Mon,  7 Mar 2022 12:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41496C340F8;
        Mon,  7 Mar 2022 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646654413;
        bh=uoA/yLVU/b+oLbGKfCPcOcNL/NpocL53c2UhSxUM5X0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n7lbew84IjCUDVuL0t2kMi5mLKdOSr79LSw2Ss5xBTXI24X0W5PZovs4iVr67fqKe
         ENER3ae6dBsUhCt7gr3Fgm3Sj2/h08Y0B0qCjREhpVjNkqrI0M3YnQ6DZqhZKM5EMM
         5klvwvQs/fZhtCAiQk07dTA5HlyC8yOMBLjkCK8uswJ8KnItHOTK9AcUfuGfb4Rn4B
         QhKGYDHHpkBPec7j92J9gB3YLzrFTfZkwCuIANFdcqZbMNKhJ+6ZfIQsaBUpIkUSgo
         8QAVqy+QVrmIr7FIHZq+qIZlZ4He+HnxW4UmMdNVhY9QQpSlBa9WyWM6KkWLjC8pkH
         5Yok8HKf71u1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1993BEAC081;
        Mon,  7 Mar 2022 12:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] net: Convert user to netif_rx(), part 3.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164665441309.23552.3596500663864763691.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Mar 2022 12:00:13 +0000
References: <20220306215753.3156276-1-bigeasy@linutronix.de>
In-Reply-To: <20220306215753.3156276-1-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tglx@linutronix.de, agordeev@linux.ibm.com, wintera@linux.ibm.com,
        andrew@lunn.ch, a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        borntraeger@linux.ibm.com, Divya.Koppera@microchip.com,
        gregkh@linuxfoundation.org, hca@linux.ibm.com,
        hkallweit1@gmail.com, johan.hedberg@gmail.com, jmaloy@redhat.com,
        linux-bluetooth@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-staging@lists.linux.dev, luiz.dentz@gmail.com,
        marcel@holtmann.org, mareklindner@neomailbox.ch,
        courmisch@gmail.com, linux@armlinux.org.uk, sw@simonwunderlich.de,
        sven@narfation.org, svens@linux.ibm.com,
        tipc-discussion@lists.sourceforge.net, gor@linux.ibm.com,
        wenjia@linux.ibm.com, ying.xue@windriver.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun,  6 Mar 2022 22:57:43 +0100 you wrote:
> This is the third and last batch of converting netif_rx_ni() caller to
> netif_rx(). The change making this possible is net-next and
> netif_rx_ni() is a wrapper around netif_rx(). This is a clean up in
> order to remove netif_rx_ni().
> 
> The micrel phy driver is patched twice within this series: the first is
> is to replace netif_rx_ni() and second to move netif_rx() outside of the
> IRQ-off section. It is probably simpler to keep it within this series.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] s390: net: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/a70d20704ad5
  - [net-next,02/10] staging: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/4bcc4249b4cf
  - [net-next,03/10] tun: vxlan: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/3d391f6518fd
  - [net-next,04/10] tipc: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/a0f0db8292e6
  - [net-next,05/10] batman-adv: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/94da81e2fc42
  - [net-next,06/10] bluetooth: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/d33d0dc9275d
  - [net-next,07/10] phonet: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/63d57cd67454
  - [net-next,08/10] net: phy: micrel: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/e1f9e434617f
  - [net-next,09/10] net: Remove netif_rx_any_context() and netif_rx_ni().
    https://git.kernel.org/netdev/net-next/c/2655926aea9b
  - [net-next,10/10] net: phy: micrel: Move netif_rx() outside of IRQ-off section.
    https://git.kernel.org/netdev/net-next/c/67dbd6c0a2c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


