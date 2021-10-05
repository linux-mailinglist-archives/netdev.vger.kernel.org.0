Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2D6422324
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 12:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhJEKOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 06:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhJEKON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 06:14:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD27AC061749;
        Tue,  5 Oct 2021 03:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UBZLxMuMMqAMN+6dt2Y8ZmEZCnKumRdcBRucu92Bimk=; b=o2mz3Zi5qgTlHUht0Zdq1S2Lt7
        KEccvYnfJQi/N39tPJ4Uf2lMqVb7T3xCBSjtlPFNqWArgfzDKIcAK6CqhdYd6wUxpvQe9zGSNZI+y
        W1MOJoNP6JI/tdQ2Fsqrguix0qmTIBYBCgGbq+x0unlJv9QUEaHDpY8LjwibvRmbN1s6RX7BX/Gpl
        Q+qupSa6UAktMYJeZBrHvLWHhMg2tIuCWUkIN4SxfyVSx1FABJ+NBXqmNmYyZSihsJ//ByuQi0loa
        kcJtDhk2XfZliJbIMqY4SoVeErEBp3pewKb2YfVWVmLXBX+a44VNufiQb4qGT0CSGAxVWkkGeF7h6
        aLu2OJbQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54952)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXhQp-000082-SQ; Tue, 05 Oct 2021 11:12:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXhQo-0008OH-Nz; Tue, 05 Oct 2021 11:12:18 +0100
Date:   Tue, 5 Oct 2021 11:12:18 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next PATCH 13/16] net: phy: Export get_phy_c22_id
Message-ID: <YVwlAkW9U0Pk3oKA@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-14-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004191527.1610759-14-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:15:24PM -0400, Sean Anderson wrote:
> This function is useful when probing MDIO devices which present a
> phy-like interface despite not using the Linux ethernet phy subsystem.

Maybe we should consider moving this into mdio_device.c and renaming
it if it's going to become more generic? Maybe mdio_read_c22_id()?
Andrew, Heiner, any opinions?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
