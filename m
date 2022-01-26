Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A81E49CBAA
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241759AbiAZN4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbiAZN4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 08:56:45 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED1EC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 05:56:45 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id a28so33053642lfl.7
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 05:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8DHydPX6tqH2+76U4AqeDQd5GtbPwximNIghIHVzbzQ=;
        b=NFmsuuhh/XjUQnfVxdtY+sicu+mepqAKNjDmmFCjjFfcHFy7Q6jCHPMp//QgC2nO9o
         Md6l9VSh4eIQMBvceetl5XiBXjnHHZ9zwxBRVUPfEHSdf0/QrEFvONVwZT/7wCu/BKIU
         wgZIddnpxPkTIUNqUT4ExgEkQwG4SxiqSl0KDv7iCYgZtv7X76zE++B19eD0ra9QVJQt
         ljZ/8Manx5EiPic1xcDmeEqH4HbvtpvZnCRZxPsXfnBzvxryIpdQ9Q5f2GPU1lMFqGFD
         nHPb5ZXI6/4yFuoP/Q0xhJlWKen0fUbkGEePZSSwRXcfsBY9kfrEWA4b9GR8FKWvtz8n
         Xf0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8DHydPX6tqH2+76U4AqeDQd5GtbPwximNIghIHVzbzQ=;
        b=paCxCXxbOHX1d9jasUZbdR2MSb1StcymBC+p6NzvPDb+uhhhTY049/Tsg+Q6IadodB
         y/1ZwybHouWn5Rs9OD+uybtToqIknVC/HIV0GFuJkTQr1N6Vks/4tE2a6+03n2oIgzMA
         EnHl436aBgjupHAhJ9CTT3aaMVX08DI3/gIPFppFUgZnurPUV+izXYho5NIQkIgBUxmw
         9cE1G/PKrgfpA3tPqx+3Czju9TOR9XQHOZ3wxmdrtd7uL4bkCsiXsjN5TxYfG6aFK8ci
         V5cs9okYe/Qv+alFN+tJetBrQIQsCHw3D8NivblzH6ZH3yqTJUTRaEAbMAPuY5/s/Vju
         3RJw==
X-Gm-Message-State: AOAM533dT1zFoZx+ij3xoDDpEjt/FgRIyCK9Nz/EwZnrNjE6bavl47xo
        hupmrjpI6yCDPB4j7sT6pZ4=
X-Google-Smtp-Source: ABdhPJwnHZbxHVw+9uu6gL0vBkxByCMmTpV8oR4VHVDVoQWXg2sToLqrBSXJ+Og8/L/eVg4cwKMlsg==
X-Received: by 2002:a05:6512:c11:: with SMTP id z17mr7332892lfu.514.1643205403401;
        Wed, 26 Jan 2022 05:56:43 -0800 (PST)
Received: from ppc.Dlink ([2001:470:28:152::2])
        by smtp.gmail.com with ESMTPSA id q10sm761844lfn.296.2022.01.26.05.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 05:56:42 -0800 (PST)
Date:   Wed, 26 Jan 2022 16:56:40 +0300
From:   "Andrey Jr. Melnikov" <temnota.am@gmail.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        mail@david-bauer.net
Subject: Re: [PATCH net-next v4 0/3] at803x fiber/SFP support
Message-ID: <YfFTGL1AdbOQOE8R@ppc.Dlink>
References: <20220125165410.252903-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125165410.252903-1-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 10:54:07AM -0600, Robert Hancock wrote:
> Add support for 1000Base-X fiber modes to the at803x PHY driver, as
> well as support for connecting a downstream SFP cage.
> 
> Changes since v3:
> -Renamed some constants with OHM suffix for clarity
> 
> Changes since v2:
> -fixed tabs/spaces issue in one patch
> 
> Changes since v1:
> -moved page selection to config_init so it is handled properly
> after suspend/resume
> -added explicit check for empty sfp_support bitmask
> 
> Robert Hancock (3):
>   net: phy: at803x: move page selection fix to config_init
>   net: phy: at803x: add fiber support
>   net: phy: at803x: Support downstream SFP cage
> 
Backported this series to 5.15.16 and tested on Ubiquiti EdgeRouter X SFP
hardware. Optical SFP modules working without problems, but cooper SFP with
Marvell 88E1111 not work - link is up but no packets sent/recieved via
interface.

# dmesg | grep -iE '(dsa|eth|mdio|sfp)'
[    0.000000] MIPS: machine is Ubiquiti EdgeRouter X SFP
[    1.349162] gpio-7 (sfp_i2c_clk_gate): hogged as output/high
[    4.685535] libphy: Fixed MDIO Bus: probed
[    4.732207] libphy: mdio: probed
[    4.739151] mt7530 mdio-bus:00: MT7530 adapts as multi-chip module
[    4.768955] mtk_soc_eth 1e100000.ethernet dsa: mediatek frame engine at 0xbe100000, irq 20
[    4.852254] mt7530 mdio-bus:00: MT7530 adapts as multi-chip module
[    4.973393] mt7530 mdio-bus:00 eth0 (uninitialized): PHY [mt7530-0:00] driver [Generic PHY] (irq=POLL)
[    4.993676] mt7530 mdio-bus:00 eth1 (uninitialized): PHY [mt7530-0:01] driver [Generic PHY] (irq=POLL)
[    5.014054] mt7530 mdio-bus:00 eth2 (uninitialized): PHY [mt7530-0:02] driver [Generic PHY] (irq=POLL)
[    5.034405] mt7530 mdio-bus:00 eth3 (uninitialized): PHY [mt7530-0:03] driver [Generic PHY] (irq=POLL)
[    5.054704] mt7530 mdio-bus:00 eth4 (uninitialized): PHY [mt7530-0:04] driver [Generic PHY] (irq=POLL)
[    5.131850] mt7530 mdio-bus:00 eth5 (uninitialized): PHY [mdio-bus:07] driver [Qualcomm Atheros AR8031/AR8033] (irq=POLL)
[    5.155828] mt7530 mdio-bus:00: configuring for fixed/rgmii link mode
[    5.172290] DSA: tree 0 setup
[    5.179302] mt7530 mdio-bus:00: Link is Up - 1Gbps/Full - flow control off
[    9.103291] mtk_soc_eth 1e100000.ethernet dsa: configuring for fixed/rgmii link mode
[    9.119230] device dsa entered promiscuous mode
[    9.128654] mtk_soc_eth 1e100000.ethernet dsa: Link is Up - 1Gbps/Full - flow control rx/tx
[    9.131563] mt7530 mdio-bus:00 eth1: configuring for phy/gmii link mode
[    9.158926] IPv6: ADDRCONF(NETDEV_CHANGE): dsa: link becomes ready
[   13.306590] device dsa left promiscuous mode
[   14.587953] libphy: SFP I2C Bus: probed
[   14.751420] sfp sfp_eth5: Host maximum power 1.0W
[   14.821296] sfp sfp_eth5: No tx_disable pin: SFP modules will always be emitting.
[   15.691261] sfp sfp_eth5: module Gateray          GR-S1-RJ         rev A    sn X201604162293    dc 160422  
[   15.710686] Qualcomm Atheros AR8031/AR8033 mdio-bus:07: module may not function if 1000Base-X not supported
[   36.440072] mtk_soc_eth 1e100000.ethernet dsa: Link is Down
[   36.461374] mtk_soc_eth 1e100000.ethernet dsa: configuring for fixed/rgmii link mode
[   36.477856] mtk_soc_eth 1e100000.ethernet dsa: Link is Up - 1Gbps/Full - flow control rx/tx
[   36.495142] IPv6: ADDRCONF(NETDEV_CHANGE): dsa: link becomes ready
[   36.508246] device dsa entered promiscuous mode
[   36.517976] mt7530 mdio-bus:00 eth1: configuring for phy/gmii link mode
[   36.532794] br-lan: port 1(eth1) entered blocking state
[   36.543322] br-lan: port 1(eth1) entered disabled state
[   36.555768] device eth1 entered promiscuous mode
[   36.592332] mt7530 mdio-bus:00 eth2: configuring for phy/gmii link mode
[   36.607113] br-lan: port 2(eth2) entered blocking state
[   36.617651] br-lan: port 2(eth2) entered disabled state
[   36.630268] device eth2 entered promiscuous mode
[   36.655233] mt7530 mdio-bus:00 eth3: configuring for phy/gmii link mode
[   36.669957] br-lan: port 3(eth3) entered blocking state
[   36.680454] br-lan: port 3(eth3) entered disabled state
[   36.693351] device eth3 entered promiscuous mode
[   36.718596] mt7530 mdio-bus:00 eth4: configuring for phy/gmii link mode
[   36.733435] br-lan: port 4(eth4) entered blocking state
[   36.743977] br-lan: port 4(eth4) entered disabled state
[   36.756966] device eth4 entered promiscuous mode
[   36.779983] mt7530 mdio-bus:00 eth5: configuring for phy/rgmii-rxid link mode
[   36.795073] mt7530 mdio-bus:00 eth5: No phy led trigger registered for speed(-1)
[   36.810051] br-lan: port 5(eth5) entered blocking state
[   36.810277] mt7530 mdio-bus:00 eth5: Link is Up - Unknown/Unknown - flow control off

Link is up - but what mode is selected ?? No packets received from
interface, remote side report 1000/Full speed negotiated, TX counters
increased.

[   36.820606] br-lan: port 5(eth5) entered disabled state
[   36.849515] device eth5 entered promiscuous mode
[   36.862142] br-lan: port 5(eth5) entered blocking state
[   36.872673] br-lan: port 5(eth5) entered forwarding state
[   37.260595] mt7530 mdio-bus:00 eth0: configuring for phy/gmii link mode
[   40.362029] mt7530 mdio-bus:00 eth0: Link is Up - 1Gbps/Full - flow control off
[   40.376656] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  670.201487] mt7530 mdio-bus:00 eth5: Link is Down
[  670.211423] br-lan: port 5(eth5) entered disabled state
[  671.241339] mt7530 mdio-bus:00 eth5: No phy led trigger registered for speed(-1)
[  671.256789] mt7530 mdio-bus:00 eth5: Link is Up - Unknown/Unknown - flow control off
[  671.272343] br-lan: port 5(eth5) entered blocking state
[  671.282821] br-lan: port 5(eth5) entered forwarding state
[  671.471210] sfp sfp_eth5: module removed

Now, I'm removed copper SFP, and install optilcal SFP:

[  672.281451] mt7530 mdio-bus:00 eth5: Link is Down
[  672.290943] br-lan: port 5(eth5) entered disabled state
[  688.921868] mt7530 mdio-bus:00 eth5: Link is Up - 1Gbps/Full - flow control off
[  688.936512] br-lan: port 5(eth5) entered blocking state
[  688.946944] br-lan: port 5(eth5) entered forwarding state
[  689.591192] sfp sfp_eth5: module Gateray          GR-S1-X3120L-D   rev A    sn X201602220961    dc 160229  

Link is up, 1000/Full, packets traverse in both directions. Now, insert back
copper SFP:

[  731.561446] mt7530 mdio-bus:00 eth5: Link is Down
[  731.570947] br-lan: port 5(eth5) entered disabled state
[  733.841609] sfp sfp_eth5: module removed
[  751.321576] mt7530 mdio-bus:00 eth5: Link is Up - 1Gbps/Unknown - flow control off

Whoa, link up with 1Gbps speed.

[  751.336733] br-lan: port 5(eth5) entered blocking state
[  751.347167] br-lan: port 5(eth5) entered forwarding state
[  751.961193] sfp sfp_eth5: module Gateray          GR-S1-RJ         rev A    sn X201604162293    dc 160422  
[  751.980667] Qualcomm Atheros AR8031/AR8033 mdio-bus:07: module may not function if 1000Base-X not supported
[  753.401483] mt7530 mdio-bus:00 eth5: Link is Down
[  753.410984] br-lan: port 5(eth5) entered disabled state
[  754.441627] mt7530 mdio-bus:00 eth5: Link is Up - 1Gbps/Unknown - flow control off
[  754.457144] br-lan: port 5(eth5) entered blocking state
[  754.467619] br-lan: port 5(eth5) entered forwarding state

Now packets traverse in both directions for copper module too.

Can someone explain - why copper module not work from boot? And how controll 88E1111
inside SFP ?
