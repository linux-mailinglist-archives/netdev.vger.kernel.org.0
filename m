Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7EE421A70
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 01:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbhJDXHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 19:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbhJDXHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 19:07:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37BBC061745;
        Mon,  4 Oct 2021 16:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CTVR6zb+wLVKwJhFIZ2WYhfbhiG8NwIlHNd4OoFO9Ys=; b=MbvcTBwvveu+ArZPVLW5a6Yxft
        9rPFGDlOGZ98uSa3Sj2Y4fiSMm4JDGF2yx0fR7l4T/ZCAStbSrTKo5C6suyM45+sn29fsi9CwlhyY
        Xx4GkS5tq7DwDwHLYEs8t9qIxsliK/btuwxIV4mmXMMfgVvJ98knEzyNPKxND2TjHT3Hl4penbS9Q
        i+tj741eTDVund1UfVOybIigSsvxGjKldtkeKOZ47hAwhvQmjWW8ouTV5O9QjJUIgC/MMGy8CMFhy
        go7tga8k4miFyjkfaFv2qsiEyd+knnyLooVi4LGtjwFwDmYEltbt77nLObgyPeJIsMWUsoa2salwU
        c7rM3M1w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54936)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXX1Y-00086n-Ri; Tue, 05 Oct 2021 00:05:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXX1Y-0007tp-6s; Tue, 05 Oct 2021 00:05:32 +0100
Date:   Tue, 5 Oct 2021 00:05:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [RFC net-next PATCH 09/16] net: macb: Move most of mac_prepare
 to mac_config
Message-ID: <YVuIvHZ6+AHvGPoe@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-10-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004191527.1610759-10-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:15:20PM -0400, Sean Anderson wrote:
> mac_prepare is called every time the interface is changed, so we can do
> all of our configuration there, instead of in mac_config. This will be
> useful for the next patch where we will set the PCS bit based on whether
> we are using our internal PCS. No functional change intended.

The subject line appears to be the reverse of what you're actually
doing.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
