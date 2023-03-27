Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DCF6CAC89
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjC0R6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjC0R6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:58:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D36EC
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2hkb1UruUHgmE16hmkgtWayDjuCRmv86R7fW7sWjOE8=; b=jbbV7gbT//1bU/tIPRciZPZuwZ
        o35py5TsnF+tvqtkNU4/iJDHRF8Y3FdetL50msgD+UnHbY6w86lckqBok7NaVyMPMUNy2g3gkBe1T
        Ff4ZiJIXsfs/dgEC5mG1loK2VyxEOwfW0zZBeu0C11C19WZNUfUzXwyAtj0RVITOlZd4dBpA5UFWj
        Rh64VWr4dTR1cJh1h76nFDu4U4OTIK8zt+6EQrZg3T0hcqA7/j1p0DtpnGdj0dqYYL24LAFnURxzx
        9czFsDtVdE1r+OX/9Gb6Dy9xixEXSUdjacizduB2W2bWw7cU0P2Pda48ctIrYbELR967V7N1wbk/V
        SmD/ZxSw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57270)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pgr7F-0004PU-O7; Mon, 27 Mar 2023 18:58:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pgr7F-0005dB-5A; Mon, 27 Mar 2023 18:58:45 +0100
Date:   Mon, 27 Mar 2023 18:58:45 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC/RFT 04/23] net: phy: Keep track of EEE tx_lpi_enabled
Message-ID: <ZCHZVUmo/o81Qrqy@shell.armlinux.org.uk>
References: <20230327170201.2036708-1-andrew@lunn.ch>
 <20230327170201.2036708-5-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327170201.2036708-5-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 07:01:42PM +0200, Andrew Lunn wrote:
> Have phylib keep track of the EEE tx_lpi_enabled configuration.  This
> simplifies the MAC drivers, in that they don't need to store it.
> 
> Future patches to phylib will also make use of this information to
> further simplify the MAC drivers.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
