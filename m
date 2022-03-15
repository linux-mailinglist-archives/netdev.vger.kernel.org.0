Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830024D9141
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343617AbiCOA0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237769AbiCOA0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:26:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81D53CA5F;
        Mon, 14 Mar 2022 17:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9uqjMKmxNEYWAOXFz7YPFjVrpxsSXw9BrTgO0TbpRWE=; b=eG0FI0jzcwgGEGdBZ5TNQmMGQ2
        gkC0V6P+nakw6J2KnqSUEr0+WWzSB94CTq5WabqKOvzQ/NWTDIA8Q1W01TqUWb1uzXwk6yw4sp/4c
        X79w2i7bfQNYskVrzxjsTNoyB2iMMxRdAAerfx61XNK+iUf4bK/7wxI8RMeWQWv1mtkA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nTuzR-00Aq7D-JI; Tue, 15 Mar 2022 01:24:41 +0100
Date:   Tue, 15 Mar 2022 01:24:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     huziji@marvell.com, ulf.hansson@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        catalin.marinas@arm.com, will@kernel.org,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        adrian.hunter@intel.com, thomas.petazzoni@bootlin.com,
        kostap@marvell.com, robert.marko@sartura.hr,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 7/8] arm64: dts: marvell: Add Armada 98DX2530 SoC and
 RD-AC5X board
Message-ID: <Yi/cyUJ6oIs96UW2@lunn.ch>
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
 <20220314213143.2404162-8-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314213143.2404162-8-chris.packham@alliedtelesis.co.nz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/arch/arm64/boot/dts/marvell/armada-98dx2530.dtsi b/arch/arm64/boot/dts/marvell/armada-98dx2530.dtsi
> new file mode 100644
> index 000000000000..ebe464b9ebd2
> --- /dev/null
> +++ b/arch/arm64/boot/dts/marvell/armada-98dx2530.dtsi
> @@ -0,0 +1,343 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
> +/*
> + * Device Tree For AC5.
> + *
> + * Copyright (C) 2021 Marvell
> + *
> + */
> +
> +/dts-v1/;

> +	memory@0 {
> +		device_type = "memory";
> +		reg = <0x2 0x00000000 0x0 0x40000000>;
> +		// linux,usable-memory = <0x2 0x00000000 0x0 0x80000000>;
> +	};

Is the memory part of the SoC, or is it on the board? Normally it is
on the board, so should be in the .dts file. But Apple M1 etc...

> +&mdio {
> +	phy0: ethernet-phy@0 {
> +		reg = <0 0>;

phy reg values are a single number, the address on the bus, in the
range 0 to 31.

      Andrew
