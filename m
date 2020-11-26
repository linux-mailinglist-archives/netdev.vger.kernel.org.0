Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856322C5B36
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 18:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404591AbgKZR4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 12:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404587AbgKZR4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 12:56:11 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC6BC0613D4;
        Thu, 26 Nov 2020 09:56:11 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id bo9so4003016ejb.13;
        Thu, 26 Nov 2020 09:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y/tTKeapP/tQXscvC3Ws7ZoWlVzFotErpTHPzgP+uAM=;
        b=eq000mUkt0p1prg5Abv/12/c4mm9NxBvn25Rxisb4+DhGHcVNBjrLsbHcxlpVwTY6K
         VeOHGKNvFUj9rTlKdWTjQziJtukM8qWd4P3twc4ZmwX9rsC2xkHEcnwlDuT5NnMr/wlr
         rLvGpqc0kb0o2IuZXo1BKv9xv7k7cBOWlSxfgIrsX6wvaTkS8qpDdxJ7mn2SU0b0mW/l
         s3vWux9oTstL4dXyM6qg1i+dc1bGEMpju+78iMfcXXneAlW7cCDfg665VG9Ro/RBZdf9
         FJepCQi2k+GUwGeb8P4JNFzfahv9LWKQCGVlOzM5WgHfCwfwhoF8EhWqBjN8oK//wdzA
         i4cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y/tTKeapP/tQXscvC3Ws7ZoWlVzFotErpTHPzgP+uAM=;
        b=pKQf8HDWp0tKQjJ3n77qwqd3C5aNpOOuCfHtBtOXpJU4Ej7vJllHusuiImtAQXQj2t
         oHQxfRsTu7r86GBGf7Ouz+gvIcgaZ74pBUrIU/Cq5Crn+i7AQA3m1NmvMqVp4ReTVK+O
         yEHloYPo/kvIm5xSIZRfPaQBjyp8oZ8oiv1/Zb+7nPvfXqTNyNX3ODuSblCTovTKYwJ7
         Oj4gD8wSkfLFr/xzfCHBWoGbE8H9NpjtbBBtuxFYOJGYjEKElqjYezKqjUlmRb4tXGgX
         dwsJVNbMCbWYmUFSOqJomp9hm680am2dEmKwdqgFrSLl1/hFtqWmoyUKW+rnkChOqzNU
         Ba8w==
X-Gm-Message-State: AOAM533rX4iEMvsWQ3i+4lfUnmrau7mWj3o6W/HKAPM3WpMCulJZID8P
        NrfDdKIVCF6xwdAhtDltxsE=
X-Google-Smtp-Source: ABdhPJyw7eCxLN+WWX2pK89DXRLfyX7XMkk9kFCDXZn16IYZUiJ53/dcCp6gCtiCqEKyEVPlaRLkZQ==
X-Received: by 2002:a17:906:c821:: with SMTP id dd1mr3817384ejb.216.1606413370229;
        Thu, 26 Nov 2020 09:56:10 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id u23sm3523239ejc.46.2020.11.26.09.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 09:56:09 -0800 (PST)
Date:   Thu, 26 Nov 2020 19:56:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201126175607.bqmpwbdqbsahtjn2@skbuf>
References: <20201125193740.36825-1-george.mccollister@gmail.com>
 <20201125193740.36825-3-george.mccollister@gmail.com>
 <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
 <20201126132418.zigx6c2iuc4kmlvy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126132418.zigx6c2iuc4kmlvy@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 03:24:18PM +0200, Vladimir Oltean wrote:
> On Wed, Nov 25, 2020 at 08:25:11PM -0600, George McCollister wrote:
> > > > +     {XRS_RX_UNDERSIZE_L, "rx_undersize"},
> > > > +     {XRS_RX_FRAGMENTS_L, "rx_fragments"},
> > > > +     {XRS_RX_OVERSIZE_L, "rx_oversize"},
> > > > +     {XRS_RX_JABBER_L, "rx_jabber"},
> > > > +     {XRS_RX_ERR_L, "rx_err"},
> > > > +     {XRS_RX_CRC_L, "rx_crc"},
> > >
> > > As Vladimir already mentioned to you the statistics which have
> > > corresponding entries in struct rtnl_link_stats64 should be reported
> > > the standard way. The infra for DSA may not be in place yet, so best
> > > if you just drop those for now.
> >
> > Okay, that clears it up a bit. Just drop these 6? I'll read through
> > that thread again and try to make sense of it.
>
> I feel that I should ask. Do you want me to look into exposing RMON
> interface counters through rtnetlink (I've never done anything like that
> before either, but there's a beginning for everything), or are you going
> to?

So I started to add .ndo_get_stats64 based on the hardware counters, but
I already hit the first roadblock, as described by the wise words of
Documentation/networking/statistics.rst:

| The `.ndo_get_stats64` callback can not sleep because of accesses
| via `/proc/net/dev`. If driver may sleep when retrieving the statistics
| from the device it should do so periodically asynchronously and only return
| a recent copy from `.ndo_get_stats64`. Ethtool interrupt coalescing interface
| allows setting the frequency of refreshing statistics, if needed.


Unfortunately, I feel this is almost unacceptable for a DSA driver that
more often than not needs to retrieve these counters from a slow and
bottlenecked bus (SPI, I2C, MDIO etc). Periodic readouts are not an
option, because the only periodic interval that would not put absurdly
high pressure on the limited SPI bandwidth would be a readout interval
that gives you very old counters.

What exactly is it that incurs the atomic context? I cannot seem to
figure out from this stack trace:

[  869.692526] ------------[ cut here ]------------
[  869.697174] WARNING: CPU: 0 PID: 444 at kernel/rcu/tree_plugin.h:297 rcu_note_context_switch+0x54/0x438
[  869.706598] Modules linked in:
[  869.709662] CPU: 0 PID: 444 Comm: cat Not tainted 5.10.0-rc5-next-20201126-00006-g0598c9bbacc1-dirty #1452
[  869.724764] pstate: 20000085 (nzCv daIf -PAN -UAO -TCO BTYPE=--)
[  869.730790] pc : rcu_note_context_switch+0x54/0x438
[  869.735681] lr : rcu_note_context_switch+0x44/0x438
[  869.740570] sp : ffff80001039b420
[  869.743889] x29: ffff80001039b420 x28: ffff0f7a046c8e80
[  869.749220] x27: ffffcc70e3fad000 x26: ffff80001039b9d4
[  869.754550] x25: 0000000000000000 x24: ffffcc70e27ae82c
[  869.759879] x23: ffffcc70e3f90000 x22: 0000000000000000
[  869.765208] x21: ffff0f7a02177140 x20: ffff0f7a02177140
[  869.770537] x19: ffff0f7a7b9d3bc0 x18: 00000000ffffffff
[  869.775865] x17: 0000000000000000 x16: 0000000000000000
[  869.781193] x15: 0000000000000004 x14: 0000000000000000
[  869.786523] x13: 0000000000000000 x12: 0000000000000000
[  869.791852] x11: 0000000000000000 x10: 0000000000000000
[  869.797181] x9 : ffff0f7a022d0800 x8 : 0000000000000004
[  869.802510] x7 : 0000000000000004 x6 : ffff80001039b410
[  869.807838] x5 : 0000000000000001 x4 : 0000000000000001
[  869.813168] x3 : 503c00c9a4c6a300 x2 : 0000000000000000
[  869.818496] x1 : ffffcc70e3f90b98 x0 : 0000000000000001
[  869.823826] Call trace:
[  869.826276]  rcu_note_context_switch+0x54/0x438
[  869.830819]  __schedule+0xc0/0x708
[  869.834228]  schedule+0x4c/0x108
[  869.837462]  schedule_timeout+0x1a8/0x320
[  869.841480]  wait_for_completion+0x9c/0x148
[  869.845675]  dspi_transfer_one_message+0x158/0x550
[  869.850480]  __spi_pump_messages+0x208/0x818
[  869.854760]  __spi_sync+0x2a4/0x2e0
[  869.858257]  spi_sync+0x34/0x58
[  869.861404]  spi_sync_transfer+0x94/0xb8
[  869.865337]  sja1105_xfer.isra.1+0x250/0x2e0
[  869.869618]  sja1105_xfer_buf+0x4c/0x60
[  869.873462]  sja1105_port_status_get+0x68/0x8f0
[  869.878004]  sja1105_port_get_stats64+0x58/0x100
[  869.882633]  dsa_slave_get_stats64+0x3c/0x58
[  869.886916]  dev_get_stats+0xc0/0xd8
[  869.890500]  dev_seq_printf_stats+0x44/0x118
[  869.894780]  dev_seq_show+0x30/0x60
[  869.898276]  seq_read_iter+0x330/0x450
[  869.902032]  seq_read+0xf8/0x148
[  869.905268]  proc_reg_read+0xd4/0x110
[  869.908939]  vfs_read+0xac/0x1c8
[  869.912172]  ksys_read+0x74/0xf8
[  869.915405]  __arm64_sys_read+0x24/0x30
[  869.919251]  el0_svc_common.constprop.3+0x80/0x1b0
[  869.924055]  do_el0_svc+0x34/0xa0
[  869.927378]  el0_sync_handler+0x138/0x198
[  869.931397]  el0_sync+0x140/0x180
[  869.934718] ---[ end trace fd45b387ae2c6970 ]---
