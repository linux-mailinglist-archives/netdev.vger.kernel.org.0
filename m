Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E27F2A1B59
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 01:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgKAAUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 20:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgKAAUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 20:20:06 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604190004;
        bh=+qTqqYxoMO5bHuBOplwHGcvg8669VTvV0GbtpdXWmzY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q1nCfxdZUcCZc5qHfVj6rYsCvxaf4wr5os+2VLNVJL3ZEWSzMuNbi4lB4pmYJmhfg
         HeoN6a+P4pvpsNrKHfC9CnkEp69Uv/7jx3tdE4t75cEY2LBr71oMGDgAdLAuUjBDNJ
         hmOKUEKhGfxpg0YdgRQU51FKpFrvK09pINrsKsn8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] cadence: force nonlinear buffers to be cloned
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160419000464.10456.15695618042854879811.git-patchwork-notify@kernel.org>
Date:   Sun, 01 Nov 2020 00:20:04 +0000
References: <20201030155814.622831-1-mdeneen@saucontech.com>
In-Reply-To: <20201030155814.622831-1-mdeneen@saucontech.com>
To:     Mark Deneen <mdeneen@saucontech.com>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, krnl@doth.eu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 30 Oct 2020 15:58:14 +0000 you wrote:
> In my test setup, I had a SAMA5D27 device configured with ip forwarding, and
> second device with usb ethernet (r8152) sending ICMP packets.  If the packet
> was larger than about 220 bytes, the SAMA5 device would "oops" with the
> following trace:
> 
> kernel BUG at net/core/skbuff.c:1863!
> Internal error: Oops - BUG: 0 [#1] ARM
> Modules linked in: xt_MASQUERADE ppp_async ppp_generic slhc iptable_nat xt_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 can_raw can bridge stp llc ipt_REJECT nf_reject_ipv4 sd_mod cdc_ether usbnet usb_storage r8152 scsi_mod mii o
> ption usb_wwan usbserial micrel macb at91_sama5d2_adc phylink gpio_sama5d2_piobu m_can_platform m_can industrialio_triggered_buffer kfifo_buf of_mdio can_dev fixed_phy sdhci_of_at91 sdhci_pltfm libphy sdhci mmc_core ohci_at91 ehci_atmel o
> hci_hcd iio_rescale industrialio sch_fq_codel spidev prox2_hal(O)
> CPU: 0 PID: 0 Comm: swapper Tainted: G           O      5.9.1-prox2+ #1
> Hardware name: Atmel SAMA5
> PC is at skb_put+0x3c/0x50
> LR is at macb_start_xmit+0x134/0xad0 [macb]
> pc : [<c05258cc>]    lr : [<bf0ea5b8>]    psr: 20070113
> sp : c0d01a60  ip : c07232c0  fp : c4250000
> r10: c0d03cc8  r9 : 00000000  r8 : c0d038c0
> r7 : 00000000  r6 : 00000008  r5 : c59b66c0  r4 : 0000002a
> r3 : 8f659eff  r2 : c59e9eea  r1 : 00000001  r0 : c59b66c0
> Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> Control: 10c53c7d  Table: 2640c059  DAC: 00000051
> Process swapper (pid: 0, stack limit = 0x75002d81)
> 
> [...]

Here is the summary with links:
  - [net,v3] cadence: force nonlinear buffers to be cloned
    https://git.kernel.org/netdev/net/c/403dc16796f5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


