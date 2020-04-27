Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084D61BA518
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgD0NmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbgD0Nl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 09:41:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6674C0610D5;
        Mon, 27 Apr 2020 06:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gzBP/5TPSgWoYnfvROGi040waenlBeLNeHeHZF/9krM=; b=uS5ZF4Y4fsPKqhBVIAb9dODmx
        drtChwbes2kdwHDoLa75LyWIXKrhHIXZjaEQMWJIGLKFoKa2ofUeQWZmLoHx1TQkk4O/dcbHnMdA+
        LYPgroUuuUOU3QT59FVZ3jBmpMp8BW1JrhUNHt9hb+3FD1wkQYMO2ra27rRJDqhs96xlFLcEgGUjE
        TJtzQASnKCxW9BwvRWMS4oqO0eTivJF3RFAQRHnV8x93MiVJi117d7PjQSeRetx05riLVwzTdipI9
        qMlbycfDIPzWea/z8VRnFf8LvRfEyDMOJuwZUbl3mGWh+kD26YT0WYL2Hhzd1PsBZ5oLsfUNg0M5a
        LjdSx93zg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:44630)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jT40w-000392-G1; Mon, 27 Apr 2020 14:41:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jT40v-0006hs-Lz; Mon, 27 Apr 2020 14:41:37 +0100
Date:   Mon, 27 Apr 2020 14:41:37 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>, linux-kernel@vger.kernel.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v2 1/3] device property: Introduce phy related
 fwnode functions
Message-ID: <20200427134137.GF25745@shell.armlinux.org.uk>
References: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
 <20200427132409.23664-2-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427132409.23664-2-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 06:54:07PM +0530, Calvin Johnson wrote:
> +/**
> + * device_phy_find_device - For the given device, get the phy_device
> + * @dev: Pointer to the given device
> + *
> + * If successful, returns a pointer to the phy_device with the embedded
> + * struct device refcount incremented by one, or NULL on failure.

It probably makes sense to refer the reader to the return conditions
for fwnode_phy_find_device() so that should fwnode_phy_find_device()
be updated, there's no need to modify multiple locations.

> + */
> +struct phy_device *device_phy_find_device(struct device *dev)
> +{
> +	return fwnode_phy_find_device(dev_fwnode(dev));
> +}
> +EXPORT_SYMBOL_GPL(device_phy_find_device);
> +
> +/**
> + * fwnode_get_phy_node - Get the phy_node using the named reference.
> + * @fwnode: Pointer to fwnode from which phy_node has to be obtained.
> + *
> + * Returns pointer to the phy fwnode, or ERR_PTR. Caller is responsible to
> + * call fwnode_handle_put() on the returned phy fwnode pointer.

This one even more so - fwnode_find_reference() is in an entirely
separate file, so the comment could well be missed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
