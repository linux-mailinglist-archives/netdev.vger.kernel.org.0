Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC6B51FC8B
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiEIMYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbiEIMYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:24:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A35233A67;
        Mon,  9 May 2022 05:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MVzmwksZEc5xV3HD02y8j5y1x9GRvHeT5B5x20Hc+0I=; b=hOtZV+3Jreg66zFUzHNsrUzalN
        p6D+X363nLkmBv7oaSZq1VDVIPZ/T1IDPbuqkuQc5Gv1C0L7P/alcPhlD+Y2O7jWBzYqgdyS7vTN+
        9B+My78PJSGo3Y4689YybuQK6ubPPuU+h3sHlz2bYm+DX5KPC1HIUPWIz8bhR39do6OQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1no2Mx-001wIt-3n; Mon, 09 May 2022 14:20:07 +0200
Date:   Mon, 9 May 2022 14:20:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     alexandre.torgue@foss.st.com, broonie@kernel.org,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        lgirdwood@gmail.com, linux@armlinux.org.uk, pabeni@redhat.com,
        peppe.cavallaro@st.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 0/6] arm64: add ethernet to orange pi 3
Message-ID: <YnkG9yV+Fbf7WtCh@lunn.ch>
References: <20220509074857.195302-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509074857.195302-1-clabbe@baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 07:48:51AM +0000, Corentin Labbe wrote:
> Hello
> 
> 2 sunxi board still does not have ethernet working, orangepi 1+ and
> orangepi 3.
> This is due to the fact thoses boards have a PHY which need 2 regulators.

Why PHY make/module is it which is causing problems?

    Andrew
