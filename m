Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDCA215427
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 10:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgGFIpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 04:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgGFIpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 04:45:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F89C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 01:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BBhBPzQPp6PT0ZoffMOEIjv28BXzKO47ESpQb74DF8s=; b=Lx8ebxY7q8fjJRP2o2GE4yB63
        ++TJQ2yvrkQr9UXTjo+1Oodcqvj+c4+8d0CkdsNhD+g0P4hSLlWjNEP9rHola0IxhazfVmQ0Fzhyn
        Zm4LlC75Nhie1I6BaDxA5tYWo4f2iAOX07ZSHv06Kln6MMge8RXOWplw5F5D+FzKzrZaR4WnuQqbR
        wI/hvafZIPZDKwW5xlCvKhL2g8d2d3mu0f9sN/ZyWgOLoxokY/t0WIAY1Kp9BU+i7phP/FCnAtw3R
        39s7I3fp4WTxexzmeurYraKCBjc0m3ztZGGkcxNRFDbmqPsUrMKx8+Tbpuk96A9kFtrPIerrRnpzs
        4doaac9RA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35964)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jsMkO-0005kQ-3L; Mon, 06 Jul 2020 09:45:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jsMkK-0005l3-2G; Mon, 06 Jul 2020 09:45:04 +0100
Date:   Mon, 6 Jul 2020 09:45:04 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     olteanv@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH v2 net-next 0/6] PHYLINK integration improvements for
 Felix DSA driver
Message-ID: <20200706084503.GU1551@shell.armlinux.org.uk>
References: <20200704124507.3336497-1-olteanv@gmail.com>
 <20200705.152620.1918268774429284685.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705.152620.1918268774429284685.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 05, 2020 at 03:26:20PM -0700, David Miller wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Sat,  4 Jul 2020 15:45:01 +0300
> 
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > This is an overhaul of the Felix switch driver's PHYLINK operations.
> > 
> > Patches 1, 3, 4 and 5 are cleanup, patch 2 is adding a new feature and
> > and patch 6 is adaptation to the new format of an existing phylink API
> > (mac_link_up).
> > 
> > Changes since v1:
> > - Now using phy_clear_bits and phy_set_bits instead of plain writes to
> >   MII_BMCR. This combines former patches 1/7 and 6/7 into a single new
> >   patch 1/6.
> > - Updated commit message of patch 5/6.
> 
> Series applied, thanks.

v3 was posted yesterday...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
