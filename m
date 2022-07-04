Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA7A564F96
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 10:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiGDIN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 04:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiGDINf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 04:13:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F49ABE3F;
        Mon,  4 Jul 2022 01:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Xh0s1LpzcO7nydfkpZGpNseYKTnrZ+2Np/ZcfDCXpDc=; b=GRRRgUttFjPFbbfTAINrHCG6OO
        G3Ucab5+mdT7nPB0AuW6e16lKwr8uqFfCLD1pBhBi2XnR5OJs9KjIC0QdsEFFfzuXCBfQq2ia9qcc
        zfUxLnlTxNNrSOYXchj1Y416h76UnLVXcdFm2EZfEflJ8dDq0Fb6iWj2x6PLVujKUEPU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o8HCK-009GCW-Ug; Mon, 04 Jul 2022 10:12:48 +0200
Date:   Mon, 4 Jul 2022 10:12:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Wei Fang <wei.fang@nxp.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, aisheng.dong@nxp.com,
        devicetree@vger.kernel.org, peng.fan@nxp.com, ping.bai@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, kernel@pengutronix.de, sudeep.holla@arm.com,
        festevam@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] arm64: dts: imx8ulp: Add the fec support
Message-ID: <YsKhAFkd0HCZVVvH@lunn.ch>
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-3-wei.fang@nxp.com>
 <751e1ec6-2d34-44f6-a6c3-775df8a3cea2@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <751e1ec6-2d34-44f6-a6c3-775df8a3cea2@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +				clocks = <&cgc1 IMX8ULP_CLK_XBAR_DIVBUS>,
> > +					 <&pcc4 IMX8ULP_CLK_ENET>,
> > +					 <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>,
> > +					 <&clock_ext_rmii>;
> > +				clock-names = "ipg", "ahb", "ptp", "enet_clk_ref";
> 
> I think the default should be the other way round, assume MAC to provide reference
> clock and allow override on board-level if PHY does it instead.

I would make it the same as all the other instances of FEC in the
IMX7, IMX6, IMX5, IMX4, Vybrid etc

      Andrew
