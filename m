Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839BC31EF91
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbhBRTSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:18:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232474AbhBRTGD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 14:06:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 523DB64E79;
        Thu, 18 Feb 2021 19:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613675122;
        bh=R4gsCZgMwDgngZ9qyYmkJ+oFMXRTckcvHATUvxlt/JE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Whm2zE7EeuTvM69X4g8Gc7a/abB6P97YSfEeTZg9ybvSaTRqWfXdJbOZ6v/VY5Yk6
         4WUVOuCtYUaznHCoL/LQCUEYFwhR0hOZPwqpWha5v573IpnZzSx3CUsSRfz2+XIaMq
         BdkU3WQO/TIsAgvDRLAZaYPwUQn5Or0Ur/lR6lB8lnBS8wruUmuW08HpiYOpbtU0My
         GvyZxikx/CPFHKsyfereJrXRfNjJYZvwe5OoxNn/kSUgvTfM2U4rxQUWiBlKdeqhsJ
         AF1Ccg35n2kBgKX2wmugoQvkAMAgqjRG0nS47dggKjnUjz6dK8bDPGZ1VAOsTmGSU7
         3GGicHzc/fmVw==
Date:   Thu, 18 Feb 2021 11:05:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux.cj@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v6 02/15] net: phy: Introduce
 fwnode_mdio_find_device()
Message-ID: <20210218110520.727d24b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210218052654.28995-3-calvin.johnson@oss.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
        <20210218052654.28995-3-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Feb 2021 10:56:41 +0530 Calvin Johnson wrote:
> +/**
> + * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
> + * @np: pointer to the mdio_device's fwnode
> + *
> + * If successful, returns a pointer to the mdio_device with the embedded
> + * struct device refcount incremented by one, or NULL on failure.
> + * The caller should call put_device() on the mdio_device after its use
> + */
> +struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)

drivers/net/phy/phy_device.c:2834: warning: Function parameter or member 'fwnode' not described in 'fwnode_mdio_find_device'
drivers/net/phy/phy_device.c:2834: warning: Excess function parameter 'np' description in 'fwnode_mdio_find_device'
