Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7BB578D4D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 00:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbiGRWEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 18:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiGRWEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 18:04:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE132ED53;
        Mon, 18 Jul 2022 15:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YHtUgjLDGyvf6StIZujoFoAHItQuRdwSruaYB0xdJvg=; b=lp57F7OQwkZwJhMpsPETuujDIU
        bpiFc7ifej4BOi2PcRnet8exrtgveihvTYViy7eFzKigEjm4tZacKCpQitsdDtYuCytLOJU2pp5Er
        /U7B6H0zYSNGuskfSxk+IF/YmxQwz+QPdeNbEOPiXEUYTgtFMLKNset3dr3nlKYH9NDI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oDYqg-00AlNM-Bn; Tue, 19 Jul 2022 00:04:18 +0200
Date:   Tue, 19 Jul 2022 00:04:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     wei.fang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, aisheng.dong@nxp.com,
        devicetree@vger.kernel.org, peng.fan@nxp.com, ping.bai@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, kernel@pengutronix.de, sudeep.holla@arm.com,
        festevam@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 3/3] arm64: dts: imx8ulp-evk: Add the fec support
Message-ID: <YtXY4naUhc2F7k2+@lunn.ch>
References: <20220718142257.556248-1-wei.fang@nxp.com>
 <20220718142257.556248-4-wei.fang@nxp.com>
 <b5f5f87e-c690-2525-4b5f-4d178157a4d3@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5f5f87e-c690-2525-4b5f-4d178157a4d3@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +	mdio {
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +
> > +		ethphy: ethernet-phy {
> 
> @1

The DT tools should of warned about this as well. So maybe the build
testing needs extending to run all the DT tools?

	Andrew
