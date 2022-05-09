Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E834F5200F3
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238169AbiEIPXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238115AbiEIPXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:23:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6989B233A71;
        Mon,  9 May 2022 08:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=Vs4pKWIO8ghtfzDiPPWpzVvLUDOdEY+WjcGzBGinpww=; b=Zj
        38KWpyFIE1rldm9h43e0xD67487kEzzUvJu0jiAurIiK1eG/aBCAn5lYK2s3MmYe+kg8YScajaJ9d
        biCy4/Wer9aj72+q4NfUzqCR0Y2rcb5zs5RXgTSaenYKATy2gkQn1UB6VWPFo2+WBglXwXaepcfU7
        xDNBwG2sgOxEw0A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1no5AK-001xhf-8m; Mon, 09 May 2022 17:19:16 +0200
Date:   Mon, 9 May 2022 17:19:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     LABBE Corentin <clabbe@baylibre.com>
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
Message-ID: <Ynkw9EekNj5Ih5gc@lunn.ch>
References: <20220509074857.195302-1-clabbe@baylibre.com>
 <YnkG9yV+Fbf7WtCh@lunn.ch>
 <YnkWwrKk4zjPnZLg@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YnkWwrKk4zjPnZLg@Red>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 03:27:30PM +0200, LABBE Corentin wrote:
> Le Mon, May 09, 2022 at 02:20:07PM +0200, Andrew Lunn a écrit :
> > On Mon, May 09, 2022 at 07:48:51AM +0000, Corentin Labbe wrote:
> > > Hello
> > > 
> > > 2 sunxi board still does not have ethernet working, orangepi 1+ and
> > > orangepi 3.
> > > This is due to the fact thoses boards have a PHY which need 2 regulators.
> > 
> > Why PHY make/module is it which is causing problems?
> > 
> 
> The problem was stmmac support only one regulator for PHY.

I'm trying to understand the differences between the two different
regulators. If you tell me what the PHY is, i might be able to find
the data sheet, and then understand why two regulators are needed and
if one needs to be controlled by the PHY driver, not the MDIO bus
driver.

	Andrew
