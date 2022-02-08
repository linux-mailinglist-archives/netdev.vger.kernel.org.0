Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F424AD8C5
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343752AbiBHNPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376443AbiBHNJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:09:29 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86045C03FECE;
        Tue,  8 Feb 2022 05:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vBzNRRge3X1+Mavkxmg8iAd7YgBffeeNExkeU6FzfYg=; b=DoNZOqTyBm6m4hoaTz5lSwxf8I
        pLSsWzf4vaa2KuXeiUj5jdq1nsWj0ZcSePDcbIPqfyew6H0+Ourt/hD7eE5mval55Zpzoaz8lQTKL
        JOUkl6p9xkbEPaILcg2oHusNrBAqUA+vrK/uaGhoyyx/Wdj8rzjyt8zFRQLw+Xuh8GRw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHQF9-004rMM-PX; Tue, 08 Feb 2022 14:09:15 +0100
Date:   Tue, 8 Feb 2022 14:09:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v8 net-next 03/10] net: phy: Add support for LAN937x T1
 phy driver
Message-ID: <YgJre2C9jpfMCXSZ@lunn.ch>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
 <20220207172204.589190-4-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207172204.589190-4-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 10:51:57PM +0530, Prasanna Vengateshan wrote:
> Added support for Microchip LAN937x T1 phy driver. The sequence of
> initialization is used commonly for both LAN87xx and LAN937x
> drivers. The new initialization sequence is an improvement to
> existing LAN87xx and it is shared with LAN937x.
> 
> Also relevant comments are added in the existing code and existing
> soft-reset customized code has been replaced with
> genphy_soft_reset().
> 
> access_ereg_clr_poll_timeout() API is introduced for polling phy
> bank write and this is linked with PHYACC_ATTR_MODE_POLL.
> 
> Finally introduced function table for LAN937X_T1_PHY_ID along with
> microchip_t1_phy_driver struct.

Hi Prasanna

That is a lot of changes in one patch.

I would suggest you make this a patch series of its own. It should be
independent of the switch changes. And then you can break this patch
up into a number of smaller patches.

Thanks
	Andrew
