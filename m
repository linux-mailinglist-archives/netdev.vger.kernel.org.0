Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D516AE199
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 15:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCGOFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 09:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCGOFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 09:05:21 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD9451FA0
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 06:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YVMDZytrYEm0pRK+YVIOPakgBHyzl6Ueyh42E07KaAY=; b=kgoI6cMKmQ+zdg/dopS0ok7V+S
        6EORBXJBIWER4AVvuaHbi/gUq/Q8YFq4oJ/pB9BMC/ri8l/yCLd1KTyZMD/QHNf6ro105jKSqaFAc
        VVVqdLBCaBqoOso71jjRklik6ub9CQ49KMh/dbfLhLgV1CMCy64P9jBX09KTTb2foJ52KwqeJt8MW
        IS0Pgi7vv8ofiQVNEVMhd3//caX3qAvj6KOxEu4wCt6XbUqZ9yBx9190Jtk8CU5NJwRsphHs573AM
        3knwRTIT9hEonXiy/ayN7P9CDmp3xoyP3PAlpdt/3aCyy/bCJD2Pdk+pXSq3Iycd1qsSPfDqQjUKf
        ltoby0IA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38326)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZXw8-0000PY-BV; Tue, 07 Mar 2023 14:05:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZXw3-0001Zr-SV; Tue, 07 Mar 2023 14:04:59 +0000
Date:   Tue, 7 Mar 2023 14:04:59 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 4/4] net: mtk_eth_soc: note interface modes
 not set in supported_interfaces
Message-ID: <ZAdEi2TsIw8Vjsh8@shell.armlinux.org.uk>
References: <Y/ivHGroIVTe4YP/@shell.armlinux.org.uk>
 <E1pVXJK-00CTAl-V7@rmk-PC.armlinux.org.uk>
 <ZAcnjXxLfeE9UIsO@shell.armlinux.org.uk>
 <ZAc7Q4VMzLjzQbRC@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAc7Q4VMzLjzQbRC@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 01:25:23PM +0000, Daniel Golle wrote:
> A quick grep through the device trees of the more than 650 ramips and
> mediatek boards we support in OpenWrt has revealed that *none* of them
> uses either reduced-MII or reverse-MII PHY modes. I could imaging that
> some more specialized ramips boards may use the RMII 100M PHY mode to
> connect with exotic PHYs for industrial or automotive applications
> (think: for 100BASE-T1 PHY connected via RMII). I have never seen or
> touched such boards, but there are hints that they do exist.
> 
> For reverse-MII there are cases in which the Ralink SoC (Rt305x, for
> example) is used in iNIC mode, ie. connected as a PHY to another SoC,
> and running only a minimal firmware rather than running Linux. Due to
> the lack of external DRAM for the Ralink SoC on this kind of boards,
> the Ralink SoC there will anyway never be able to boot Linux.
> I've seen this e.g. in multimedia devices like early WiFi-connected
> not-yet-so-smart TVs.
> 
> Tl;dr: I'd drop them. If anyone really needs them, it would be easy to
> add them again and then also add them to the phylink capability mask.

Thanks! That seems to be well reasoned. Would you have any objection to
using the above as part of the commit message removing these modes?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
