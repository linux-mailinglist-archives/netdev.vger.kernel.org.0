Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B1D68D946
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjBGN17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjBGN16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:27:58 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6D82196E;
        Tue,  7 Feb 2023 05:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mV2mknCgsicDbLzmCz6JUukMmKjwt1/IhhLm0HCHG6U=; b=lRywbhZpxU3Rb8x/0CZi0h3id9
        38amvF5EHgns2FlcWQJKeAp7XLC2NZ71TfmLsCPu8TsxG2Viy90cIhDDloBbP74hUWeIvFAWEPWob
        9ROL7FXfIhVzTbTU3ceBUTlN6aIRxMPx52i89+UhZN7VVVXwh6TpGu9YJ54Q1/X4GdQo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pPO0m-004IxU-23; Tue, 07 Feb 2023 14:27:52 +0100
Date:   Tue, 7 Feb 2023 14:27:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, michael@walle.cc
Subject: Re: [PATCH net-next v4 1/2] net: micrel: Add support for lan8841 PHY
Message-ID: <Y+JR2GAMxFT5k7Hk@lunn.ch>
References: <20230207105212.1275396-1-horatiu.vultur@microchip.com>
 <20230207105212.1275396-2-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207105212.1275396-2-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 11:52:11AM +0100, Horatiu Vultur wrote:
> The LAN8841 is completely integrated triple-speed (10BASE-T/ 100BASE-TX/
> 1000BASE-T) Ethernet physical layer transceivers for transmission and
> reception of data on standard CAT-5, as well as CAT-5e and CAT-6,
> unshielded twisted pair (UTP) cables.
> The LAN8841 offers the industry-standard GMII/MII as well as the RGMII.
> Some of the features of the PHY are:
> - Wake on LAN
> - Auto-MDIX
> - IEEE 1588-2008 (V2)
> - LinkMD Capable diagnosis
> 
> Currently the patch offers support only for link configuration.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
