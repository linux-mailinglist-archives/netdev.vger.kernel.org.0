Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DCF63F844
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 20:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiLATbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 14:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiLATai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 14:30:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0B1CA15F;
        Thu,  1 Dec 2022 11:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA27BB82008;
        Thu,  1 Dec 2022 19:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97982C433C1;
        Thu,  1 Dec 2022 19:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669923021;
        bh=0RxRzmDFLKwQUSgOIo6SuPkpbO4W72b1VHA4ZTgHkqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ky2zh/RynzTEWtmlLZ/FHid1Dc0FH/RMY9FbFYHg35MAt2n3x+hASDaKqs0Mdqca2
         6Jq6vyKb0SSIk0XYUf0YBuFb4SsFS+geQCDU29CkHxtL+Zh1Ht7ueAYPB0jbpnuVwU
         9m8bpO/+SQL/qJ5hoAlSHPHaRgf0UgiUbf2Q8ewt2tRKhk/2NR3I+pbgeUjg5efupC
         7or94wbkXOf/FQ+utb7pR2kUSY5V6Qn5Al9EttMPjKkhs2Q1O3DOAEug0zrKH5sjAN
         5nmr13FJTgwJXsiwqTL8xcH7bu3pv39GJo+iw+/xvM3fIg0YlcQXYzGe4KwEByGcoD
         KBg0Ab6Upl0+A==
Date:   Thu, 1 Dec 2022 19:30:16 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Subject: Re: [PATCH v1 7/7] riscv: dts: starfive: visionfive-v2: Add phy
 delay_chain configuration
Message-ID: <Y4kAyAhBseNmmDo8@spud>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-8-yanhong.wang@starfivetech.com>
 <Y4jpDvXo/uj9ygLR@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4jpDvXo/uj9ygLR@spud>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 05:49:08PM +0000, Conor Dooley wrote:
> On Thu, Dec 01, 2022 at 05:02:42PM +0800, Yanhong Wang wrote:
> > riscv: dts: starfive: visionfive-v2: Add phy delay_chain configuration
> > 
> > Add phy delay_chain configuration to support motorcomm phy driver for
> > StarFive VisionFive 2 board.

nit: please re-word this commit next time around to actually say what
you're doing here. I didn't notice it initially, but this patch is doing
a lot more than adding `delay_chain` configuration. To my dwmac unaware
brain, there's nothing hits for that term outside of the changelog :(

Thanks,
Conor.

> > 
> > Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> > ---
> >  .../jh7110-starfive-visionfive-v2.dts         | 46 +++++++++++++++++++
> >  1 file changed, 46 insertions(+)
> > 
> > diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
> > index c8946cf3a268..2868ef4c74ef 100644
> > --- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
> > +++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
> > @@ -15,6 +15,8 @@
> >  
> >  	aliases {
> >  		serial0 = &uart0;
> > +		ethernet0=&gmac0;
> > +		ethernet1=&gmac1;
> 
> Please match the whitespace usage of the existing entry.
> 
> >  	};
> >  
> >  	chosen {
> > @@ -114,3 +116,47 @@
> >  	pinctrl-0 = <&uart0_pins>;
> >  	status = "okay";
> >  };
> > +
> > +&gmac0 {
> > +	status = "okay";
> > +	#address-cells = <1>;
> > +	#size-cells = <0>;
> > +	phy-handle = <&phy0>;
> > +	status = "okay";
> > +	mdio0 {
> 
> A line of whitespace before the child nodes too please :)
> 
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +		compatible = "snps,dwmac-mdio";
> > +		phy0: ethernet-phy@0 {
> > +			reg = <0>;
> > +			rxc_dly_en = <1>;
> > +			tx_delay_sel_fe = <5>;
> > +			tx_delay_sel = <0xa>;
> > +			tx_inverted_10 = <0x1>;
> > +			tx_inverted_100 = <0x1>;
> > +			tx_inverted_1000 = <0x1>;
> > +		};
> > +	};
> > +};
> > +
> > +&gmac1 {
> > +	status = "okay";
> > +	#address-cells = <1>;
> > +	#size-cells = <0>;
> > +	phy-handle = <&phy1>;
> > +	status = "okay";
> > +	mdio1 {
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +		compatible = "snps,dwmac-mdio";
> > +		phy1: ethernet-phy@1 {
> > +			reg = <1>;
> > +			tx_delay_sel_fe = <5>;
> > +			tx_delay_sel = <0>;
> > +			rxc_dly_en = <0>;
> > +			tx_inverted_10 = <0x1>;
> > +			tx_inverted_100 = <0x1>;
> > +			tx_inverted_1000 = <0x0>;
> > +		};
> > +	};
> > +};
> > -- 
> > 2.17.1
> > 
