Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85C63FE399
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 22:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhIAUT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 16:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhIAUTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 16:19:54 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334F2C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 13:18:57 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id y3so555078ilm.6
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 13:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AZ1XjMAUDdhdaOjhllHS/s/34iqg8yDzy0nBBqfYsfQ=;
        b=A6XpsURIzpKrsJP6WiPru6rT+p4/MZswjBc6dccTQ5mwXJElgRdNXYVmlxh6A0xL2/
         PuUI6E4e8Kyg8Sos0IzlyED2b7ZNR7M0HvjnWNCqZUrW5nui2BODRpDycXZxM/EmVD/U
         dZWBDvHBeVpxcsROM/3KBJX2+b9vFseGD3PUwWo6mqBA+1lUdcKShxA99Nx750Nh3+Da
         g28WlSdj0u4csvRlkRadotzJ8HTuW6mYD7sSLUo690dAd0j84SwZdY95LsVqfZ4ONkiT
         dSrsxSy5/LxFv6PBB0FWxjNOXBwBifvaatAutBl9ZEQZOKk0vFZjSqpKOqKoGyDedU3D
         /+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AZ1XjMAUDdhdaOjhllHS/s/34iqg8yDzy0nBBqfYsfQ=;
        b=L7e4GtNIAHNuXa1Uvkq2JMN8sX93PN5Meu5RG2F69GAg9Dpy75LgSkatOEgHj9Va74
         /pksJnkc6ET8V+p20g9StQvP39QOOT9pFVasn5o0+UdfK9Pq8qY1dfTqccIlyImtgupV
         yoDId/4LHgJ/+fi06LRD4u/qEkCfnzSwbGDHt4dKesi8U6lTQogbvYTvj/Tab1gmR0j/
         2/G+Rx77B0Nn64FgxLYXBhTGsueD7WRobiV1At7wawiiruCpDOAbmF8kD+FuiATfNVDd
         Ld4cxqZ8y/io4PPf6n3lChDIZKCwFaCOUIq/o3275vhBlKRb6qqy/Ibn86RFlm9LreVe
         7WDw==
X-Gm-Message-State: AOAM531cDkLAp4EDYWmnVhphkui7ylcdQBpifJtMfUaTGvwMJKYkFOk/
        rk0VXOrphMgY7up7Z1VMUDxtc0yuuDqSpyxhReTS7Q==
X-Google-Smtp-Source: ABdhPJxB1sTucsUXjS40V/3aBfU70CKJLgJEhcDEE6Aac4WSLc+jQvIQbA5RCWYtUqimds0/H7l8RcXvoTY4vbr3X9I=
X-Received: by 2002:a92:d0cc:: with SMTP id y12mr889489ila.38.1630527536614;
 Wed, 01 Sep 2021 13:18:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210831193425.26193-1-gerhard@engleder-embedded.com>
 <20210831193425.26193-4-gerhard@engleder-embedded.com> <YS6lQejOJJCATMCp@lunn.ch>
In-Reply-To: <YS6lQejOJJCATMCp@lunn.ch>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Wed, 1 Sep 2021 22:18:45 +0200
Message-ID: <CANr-f5zXWrqPxWV81CT6=4O6PoPRB0Qs0T=egJ3q8FMG16f6xw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] tsnep: Add TSN endpoint Ethernet MAC driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int tsnep_ethtool_set_priv_flags(struct net_device *netdev,
> > +                                     u32 priv_flags)
> > +{
> > +     struct tsnep_adapter *adapter = netdev_priv(netdev);
> > +     int retval;
> > +
> > +     if (priv_flags & ~TSNEP_PRIV_FLAGS)
> > +             return -EINVAL;
> > +
> > +     if ((priv_flags & TSNEP_PRIV_FLAGS_LOOPBACK_100) &&
> > +         (priv_flags & TSNEP_PRIV_FLAGS_LOOPBACK_1000))
> > +             return -EINVAL;
> > +
> > +     if ((priv_flags & TSNEP_PRIV_FLAGS_LOOPBACK_100) &&
> > +         adapter->loopback != SPEED_100) {
> > +             if (adapter->loopback != SPEED_UNKNOWN)
> > +                     retval = phy_loopback(adapter->phydev, false);
> > +             else
> > +                     retval = 0;
> > +
> > +             if (!retval) {
> > +                     adapter->phydev->speed = SPEED_100;
> > +                     adapter->phydev->duplex = DUPLEX_FULL;
> > +                     retval = phy_loopback(adapter->phydev, true);
>
> This is a pretty unusual use of private flags, changing loopback at
> runtime. ethtool --test generally does that.
>
> What is your use case which requires loopback in normal operation, not
> during testing?

Yes it is unusual. I was searching for some user space interface for loopback
and found drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c which uses
private flags.

Use case is still testing and not normal operation. Testing is done mostly with
a user space application, because I don't want to overload the driver with test
code and test frameworks can be used in user space. With loopback it is
possible to execute a lot of tests like stressing the MAC with various frame
lengths and checking TX/RX time stamps. These tests are useful for every
integration of this IP core into an FPGA and not only for IP core development.

> > +static irqreturn_t tsnep_irq(int irq, void *arg)
> > +{
> > +     struct tsnep_adapter *adapter = arg;
> > +     u32 active = ioread32(adapter->addr + ECM_INT_ACTIVE);
> > +
> > +     /* acknowledge interrupt */
> > +     if (active != 0)
> > +             iowrite32(active, adapter->addr + ECM_INT_ACKNOWLEDGE);
> > +
> > +     /* handle management data interrupt */
> > +     if ((active & ECM_INT_MD) != 0) {
> > +             adapter->md_active = false;
> > +             wake_up_interruptible(&adapter->md_wait);
> > +     }
> > +
> > +     /* handle link interrupt */
> > +     if ((active & ECM_INT_LINK) != 0) {
> > +             if (adapter->netdev->phydev) {
> > +                     struct phy_device *phydev = adapter->netdev->phydev;
> > +                     u32 status = ioread32(adapter->addr + ECM_STATUS);
> > +                     int link = (status & ECM_NO_LINK) ? 0 : 1;
> > +                     u32 speed = status & ECM_SPEED_MASK;
>
> How does PHY link and speed get into this MAC register? Is the MAC
> polling the PHY over the MDIO bus? Is the PHY internal to the MAC and
> it has backdoor access to the PHY status?

PHY is external. The MAC expects additional signals for link status. These
signals can be derived from RGMII in band signaling of the link status or by
using PHY link and speed LED outputs. The MAC is using the link status for
a quick no link reaction to minimize the impact to real time applications.
EtherCAT for example also uses the link LED output for a no link reaction
within a few microseconds.

> > +static int tsnep_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
> > +{
> > +     struct tsnep_adapter *adapter = bus->priv;
> > +     u32 md;
> > +     int retval;
> > +
> > +     if (regnum & MII_ADDR_C45)
> > +             return -EOPNOTSUPP;
> > +
> > +     /* management data frame without preamble */
> > +     md = ECM_MD_READ;
>
> I know some PHYs are happy to work without a preamble. But as far as i
> know, 802.3 c22 does not say it is optional. So this needs to be an
> opt-in feature, for when you know all the devices on the bus support
> it. We have a standard DT property for this. See mdio.yaml,
> suppress-preamble. Please look for this in the DT blob, and only
> suppress the pre-amble if it is present.

You are right, I will improve that.

> > +     md |= (regnum << ECM_MD_ADDR_SHIFT) & ECM_MD_ADDR_MASK;
> > +     md |= ECM_MD_PHY_ADDR_FLAG;
> > +     md |= (addr << ECM_MD_PHY_ADDR_SHIFT) & ECM_MD_PHY_ADDR_MASK;
> > +     adapter->md_active = true;
> > +     iowrite32(md, adapter->addr + ECM_MD_CONTROL);
> > +     retval = wait_event_interruptible(adapter->md_wait,
> > +                                       !adapter->md_active);
>
> It is pretty normal to have some sort of timeout here. So maybe use
> wait_event_interruptible_timeout()?

So far I could trust my hardware to generate the interrupt. But it makes
sense to not trust the hardware absolutely. I will add a timeout.

> > +static void tsnep_phy_link_status_change(struct net_device *netdev)
> > +{
> > +     phy_print_status(netdev->phydev);
> > +}
>
> There is normally something here, like telling the MAC what speed it
> should run at.

As explained above, the MAC knows the link speed due to additional signals
from the PHY. So there is no need to tell the MAC the link speed.

> > +     adapter->phydev->irq = PHY_MAC_INTERRUPT;
> > +     phy_start(adapter->phydev);
> > +     phy_start_aneg(adapter->phydev);
>
> No need to call phy_start_aneg().

Copied blindly from some other driver. I will fix that.
(drivers/net/ethernet/microchip/lan743x_main.c)

> > +static int tsnep_phy_init(struct tsnep_adapter *adapter)
> > +{
> > +     struct device_node *dn;
> > +     int retval;
> > +
> > +     retval = of_get_phy_mode(adapter->pdev->dev.of_node,
> > +                              &adapter->phy_mode);
> > +     if (retval)
> > +             adapter->phy_mode = PHY_INTERFACE_MODE_GMII;
> > +
> > +     dn = of_parse_phandle(adapter->pdev->dev.of_node, "phy-handle", 0);
> > +     adapter->phydev = of_phy_find_device(dn);
> > +     of_node_put(dn);
> > +     if (!adapter->phydev && adapter->mdiobus)
> > +             adapter->phydev = phy_find_first(adapter->mdiobus);
>
> Do you actually need phy_find_first()? It is better to have it in DT.

I thought it is a reasonable fallback, because then PHY can be ommited in
DT (lazy developer, unknown PHY address during development, ...). Driver
and IP core will be used also on x86 over PCIe without DT. In this case this
fallback also makes sense. But I must confess, the driver is not ready for
x86 use case yet.

> > +     return 0;
> > +
> > +     unregister_netdev(adapter->netdev);
>
> How do you get here? Is gcc is warning about unreachable code?

Left over for easy addition of goto labels. I will remove that.

Gerhard
