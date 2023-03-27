Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742A36CB121
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 00:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjC0V75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 17:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC0V74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 17:59:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7484210D
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 14:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=l4SKYG1WduLN9Ot2Huibi42ieM9i05Eqp51nzA7j+bY=; b=c8lQZ3QMADo4pP+UdfVlPbmpYI
        ih19yqNhdZToGJv7uOCTji80Ybrd+rTuUlyw/IBFMxupzMpYPG16Z43E6sur0CMiVq4UISb1+U3G7
        kry1NodgzYRDSscdJNVu5/HQbjZnaij5vOt4eU5/NcTgTIwr75mnWIeeBn6OFOiAsB1WjjiyvYa2T
        n8JWHJ3RSvNMRGP4Vyn/OqepAOgc0PK/HPqSggBpyLJ8qYWeyxT1IonKnz8MhvreESUTc+Ky8SZkG
        VDM3TtkbAuswypL6csAI0M54+/4BCKlUmPuwLWZSE6Z2Ti3drrNAvKBvthgRNd4lZYHMdkHtdoAdO
        do4XslEw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55326)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pgusa-0004ms-MQ; Mon, 27 Mar 2023 22:59:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pgusZ-0005nl-M4; Mon, 27 Mar 2023 22:59:51 +0100
Date:   Mon, 27 Mar 2023 22:59:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC/RFT 20/23] net: phylink: Add MAC_EEE to mac_capabilites
Message-ID: <ZCIR1/TSonhMSGKF@shell.armlinux.org.uk>
References: <20230327170201.2036708-1-andrew@lunn.ch>
 <20230327170201.2036708-21-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327170201.2036708-21-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 07:01:58PM +0200, Andrew Lunn wrote:
> If the MAC supports Energy Efficient Ethernet, it should indicate this
> by setting the MAC_EEE bit in the config.mac_capabilities
> bitmap. phylink will then enable EEE in the PHY, if it supports it.

I know it will be a larger patch, but I would prefer to add it after
MAC_ASYM_PAUSE and shuffle the speeds up. I'm sure network speeds will
continue to increase, resulting in more bits added in the future.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
