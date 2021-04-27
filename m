Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2CD36C05C
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 09:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbhD0Hoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 03:44:37 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:17688 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbhD0Hof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 03:44:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619509433; x=1651045433;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zVu72u0iSOp34XxoKrrVVItUe9/8meo5yL6rk53zSoY=;
  b=OmpL4AoUqOkdmUE2yodwGSpr4RsE5fsl9ZF0fVuWp0YTb9fpOt6Y1pyD
   AFe7dmA9ehrny+WngqnLscWIxwdtOCM0k1hAKVOyKivHlDObQLRbRFblw
   1IcZJj3lR9A0biJue4GLwdWOyfwattG55hVL+PR7puPyma6/97fJp89CC
   bCgsHK3fssArASco8S0kC2cX51llHk0GYJIEoi8gSbuPSo2YEMrt6t225
   A+gNaYl0PDOKHNu3MNb1Np8QiOPoNAZG+jKVzY+09YdTzEvhDcjFoBho9
   I7TtjVo7pouT4ObcEqlWgKlNLDt3NA9xd+zRiP5hM+cWhNtg6L91Dfd+s
   A==;
IronPort-SDR: aPz/IgOJ/04k2Mk6NoBkSKU3aVHpCCGX4bYYXfCjegfOMWAePgj9TewIpx0vjN3nqmgLtt6w1A
 H2ZouQ+Sotu5YEJkA/vsyraPh7AMs7nWAH/X7FJOwIbMCsDNpxvsOpotZhKroBIc58DgQgBPWd
 9ZkLoMk42ud+5tClO8JVO0ebr0f4Y0jJ9xmju+W2ll9vXfV6AWXlB66XZlDSG5AbvED6gUpKDL
 t0gnnNZWgJOhEuwXyU30d7x2RUUBdoHcX5BkunTUj9jpJI7fe+z+pElbawGg+we9MYBWckuQWX
 iko=
X-IronPort-AV: E=Sophos;i="5.82,254,1613458800"; 
   d="scan'208";a="118491478"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2021 00:43:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Apr 2021 00:43:51 -0700
Received: from IDC-LT-I00072C.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 27 Apr 2021 00:43:45 -0700
Message-ID: <1db7f578599e25e2ec754a87eaea8bdc0b5b1e00.camel@microchip.com>
Subject: Re: [PATCH v2 net-next 4/9] net: dsa: microchip: add DSA support
 for microchip lan937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Tue, 27 Apr 2021 13:13:44 +0530
In-Reply-To: <20210422195921.utxdh5dn4ddltxkf@skbuf>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
         <20210422094257.1641396-5-prasanna.vengateshan@microchip.com>
         <20210422195921.utxdh5dn4ddltxkf@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-04-22 at 22:59 +0300, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Thu, Apr 22, 2021 at 03:12:52PM +0530, Prasanna Vengateshan wrote:
> > Basic DSA driver support for lan937x and the device will be
> > configured through SPI interface.
> > 
> > drivers/net/dsa/microchip/ path is already part of MAINTAINERS &
> > the new files come under this path. Hence no update needed to the
> > MAINTAINERS
> > 
> > Reused KSZ APIs for port_bridge_join() & port_bridge_leave() and
> > added support for port_stp_state_set() & port_fast_age().
> > 
> > lan937x_flush_dyn_mac_table() which gets called from
> > port_fast_age() of KSZ common layer, hence added support for it.
> > 
> > currently port_bridge_flags returns -EOPNOTSUPP, this support
> > will be added later
> > 
> > Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> > ---
> (...)
> > +int lan937x_reset_switch(struct ksz_device *dev)
> > +{
> > +     u32 data32;
> > +     u8 data8;
> > +     int rc;
> > +
> > +     /* reset switch */
> > +     rc = lan937x_cfg(dev, REG_SW_OPERATION, SW_RESET, true);
> > +     if (rc < 0)
> > +             return rc;
> > +
> > +     /* default configuration */
> > +     rc = ksz_read8(dev, REG_SW_LUE_CTRL_1, &data8);
> > +     if (rc < 0)
> > +             return rc;
> > +
> > +     data8 = SW_AGING_ENABLE | SW_LINK_AUTO_AGING |
> > +           SW_SRC_ADDR_FILTER;
> > +
> > +     rc = ksz_write8(dev, REG_SW_LUE_CTRL_1, data8);
> > +     if (rc < 0)
> > +             return rc;
> > +
> > +     /* disable interrupts */
> > +     rc = ksz_write32(dev, REG_SW_INT_MASK__4, SWITCH_INT_MASK);
> > +     if (rc < 0)
> > +             return rc;
> > +
> > +     rc = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0xFF);
> > +     if (rc < 0)
> > +             return rc;
> > +
> > +     rc = ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);
> > +     if (rc < 0)
> > +             return rc;
> > +
> > +     /* set broadcast storm protection 10% rate */
> > +     rc = regmap_update_bits(dev->regmap[1], REG_SW_MAC_CTRL_2,
> > +                             BROADCAST_STORM_RATE,
> > +                        (BROADCAST_STORM_VALUE *
> > +                        BROADCAST_STORM_PROT_RATE) / 100);
> 
> Why do you think this is a sane enough configuration to enable by
> default? We have tc-flower policers for this kind of stuff. If the
> broadcast policer is global to the switch and not per port, you can
> model it using:
> 
> tc qdisc add dev lan1 ingress_block 1 clsact
> tc qdisc add dev lan2 ingress_block 1 clsact
> tc qdisc add dev lan3 ingress_block 1 clsact
> tc filter add block 1 flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
>         action police \
>         rate 43Mbit \
>         burst 10000
Noted, What i understand is FLOW_ACTION_POLICE to be implemented later as part
of cls_flower_add(). Will remove this config in the next version.

> 
> > +
> > +     return rc;
> > +}
> > +
> (...)
> > +int lan937x_internal_phy_write(struct ksz_device *dev, int addr,
> > +                            int reg, u16 val)
> > +{
> > +     u16 temp, addr_base;
> > +     unsigned int value;
> > +     int rc;
> > +
> > +     /* Check for internal phy port */
> > +     if (!lan937x_is_internal_phy_port(dev, addr))
> > +             return -EOPNOTSUPP;
> > +
> > +     if (lan937x_is_internal_100BTX_phy_port(dev, addr))
> > +             addr_base = REG_PORT_TX_PHY_CTRL_BASE;
> > +     else
> > +             addr_base = REG_PORT_T1_PHY_CTRL_BASE;
> > +
> > +     temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
> > +
> > +     rc = ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
> > +     if (rc < 0)
> > +             return rc;
> > +
> > +     /* Write the data to be written to the VPHY reg */
> > +     rc = ksz_write16(dev, REG_VPHY_IND_DATA__2, val);
> > +     if (rc < 0)
> > +             return rc;
> > +
> > +     /* Write the Write En and Busy bit */
> > +     rc = ksz_write16(dev, REG_VPHY_IND_CTRL__2, (VPHY_IND_WRITE
> > +                             | VPHY_IND_BUSY));
> 
> This isn't quite the coding style that the kernel community is used to
> seeing. This looks more adequate:
My apologies on the incorrect indentation in some places. I will find out how
did i miss and fix from my side.

> > +
> > +     /* failed to write phy register. get out of loop */
> 
> What loop? The regmap_read_poll_timeout? If you're here you're already
> out of it, aren't you?
"get out of loop" should be removed.


> > +
> > +             
> > 
> > +static int lan937x_mdio_register(struct dsa_switch *ds)
> > +{
> > +     struct ksz_device *dev = ds->priv;
> > +     int ret;
> > +
> > +     dev->mdio_np = of_get_compatible_child(ds->dev->of_node,
> > "microchip,lan937x-mdio");
> 
> I think it is strange to have a node with a compatible string but no
> dedicated driver? I think the most popular option is to set:
> 
>         dev->mdio_np = of_get_child_by_name(node, "mdio");
> 
> and just create an "mdio" subnode with no compatible.
Sure

> 
> > +
> > +     if (!dev->mdio_np) {
> > +             dev_err(ds->dev, "no MDIO bus node\n");
> > +             return -ENODEV;
> > +     }
> > +
> > +     ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
> > +
> > +     if (!ds->slave_mii_bus)
> > +             return -ENOMEM;
> > +
> > +     ds->slave_mii_bus->priv = ds->priv;
> > +     ds->slave_mii_bus->read = lan937x_sw_mdio_read;
> > +     ds->slave_mii_bus->write = lan937x_sw_mdio_write;
> > +     ds->slave_mii_bus->name = "lan937x slave smi";
> > +     snprintf(ds->slave_mii_bus->id, MII_BUS_ID_SIZE, "SMI-%d",
> > +              ds->index);
> > +     ds->slave_mii_bus->parent = ds->dev;
> > +     ds->slave_mii_bus->phy_mask = ~ds->phys_mii_mask;
> > +
> > +     ret = of_mdiobus_register(ds->slave_mii_bus, dev->mdio_np);
> > +
> > +     if (ret) {
> > +             dev_err(ds->dev, "unable to register MDIO bus %s\n",
> > +                     ds->slave_mii_bus->id);
> > +             of_node_put(dev->mdio_np);
> > +             return ret;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > 
> > +
> > +static phy_interface_t lan937x_get_interface(struct ksz_device *dev, int
> > port)
> > +{
> > +     phy_interface_t interface;
> > +     u8 data8;
> > +     int rc;
> > +
> > +     if (lan937x_is_internal_phy_port(dev, port))
> > +             return PHY_INTERFACE_MODE_NA;
> 
> I think conventional wisdom is to use PHY_INTERFACE_MODE_INTERNAL for
> internal ports, as the name would suggest.
Sure.

> 
> > 
> > +static void lan937x_config_cpu_port(struct dsa_switch *ds)
> > +{
> > +     struct ksz_device *dev = ds->priv;
> > +     struct ksz_port *p;
> > +     int i;
> > +
> > +     ds->num_ports = dev->port_cnt;
> > +
> > +     for (i = 0; i < dev->port_cnt; i++) {
> > +             if (dsa_is_cpu_port(ds, i) && (dev->cpu_ports & (1 << i))) {
> > +                     phy_interface_t interface;
> > +                     const char *prev_msg;
> > +                     const char *prev_mode;
> > +
> > +                     dev->cpu_port = i;
> > +                     dev->host_mask = (1 << dev->cpu_port);
> > +                     dev->port_mask |= dev->host_mask;
> > +                     p = &dev->ports[i];
> > +
> > +                     /* Read from XMII register to determine host port
> > +                      * interface.  If set specifically in device tree
> > +                      * note the difference to help debugging.
> > +                      */
> > +                     interface = lan937x_get_interface(dev, i);
> > +                     if (!p->interface) {
> > +                             if (dev->compat_interface)
> > +                                     p->interface = dev->compat_interface;
> 
> Compatibility with what? This is a new driver.
Should be removed.

> 
> > +                             else
> > +                                     p->interface = interface;
> > +                     }
> > +
> > +                     if (interface && interface != p->interface) {
> > +                             prev_msg = " instead of ";
> > +                             prev_mode = phy_modes(interface);
> > +                     } else {
> > +                             prev_msg = "";
> > +                             prev_mode = "";
> > +                     }
> > +
> > +                     dev_info(dev->dev,
> > +                              "Port%d: using phy mode %s%s%s\n",
> > +                              i,
> > +                              phy_modes(p->interface),
> > +                              prev_msg,
> > +                              prev_mode);
> 
> It's unlikely that anyone is going to be able to find such a composite
> error message string using grep.
Since the compatibility is going to be removed, it is expected to configure from
DTS. I will retain the dev_info with out the string 'instead of' for just to
inform what interface is currently configured.

> 
> > +
> > +                     /* enable cpu port */
> > +                     lan937x_port_setup(dev, i, true);
> > +                     p->vid_member = dev->port_mask;
> > +             }
> > +     }
> > +
> > +     dev->member = dev->host_mask;
> > +
> > +     for (i = 0; i < dev->port_cnt; i++) {
> > +             if (i == dev->cpu_port)
> > +                     continue;
> > +             p = &dev->ports[i];
> > +
> > +             /* Initialize to non-zero so that lan937x_cfg_port_member()
> > will
> > +              * be called.
> > +              */
> > +             p->vid_member = (1 << i);
> > +             p->member = dev->port_mask;
> > +             lan937x_port_stp_state_set(ds, i, BR_STATE_DISABLED);
> > +     }
> > +}
> > +
> > +static int lan937x_setup(struct dsa_switch *ds)
> > +{
> > +     struct ksz_device *dev = ds->priv;
> > +     int rc;
> > +
> > +     dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
> > +                                    dev->num_vlans, GFP_KERNEL);
> > +     if (!dev->vlan_cache)
> > +             return -ENOMEM;
> > +
> > +     rc = lan937x_reset_switch(dev);
> > +     if (rc < 0) {
> > +             dev_err(ds->dev, "failed to reset switch\n");
> > +             return rc;
> > +     }
> > +
> > +     /* Required for port partitioning. */
> > +     lan937x_cfg32(dev, REG_SW_QM_CTRL__4, UNICAST_VLAN_BOUNDARY,
> > +                   true);
> > +
> > +     lan937x_config_cpu_port(ds);
> > +
> > +     ds->configure_vlan_while_not_filtering = true;
> 
> You can delete this line, it's implicitly true now.
Sure.

> 

> > +
> > +     lan937x_enable_spi_indirect_access(dev);
> > +
> > +     /* start switch */
> > +     lan937x_cfg(dev, REG_SW_OPERATION, SW_START, true);
> > +
> > +     ksz_init_mib_timer(dev);
> > +
> > +     return 0;
> > +}
> > +
> > +static int lan937x_change_mtu(struct dsa_switch *ds, int port, int mtu)
> > +{
> > +     struct ksz_device *dev = ds->priv;
> > +     u16 max_size;
> > +     int rc;
> > +
> > +     if (mtu >= FR_MIN_SIZE) {
> > +             rc = lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0,
> > PORT_JUMBO_EN, true);
> > +             max_size = FR_MAX_SIZE;
> > +     } else {
> > +             rc = lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0,
> > PORT_JUMBO_EN, false);
> > +             max_size = FR_MIN_SIZE;
> > +     }
> > +
> > +     if (rc < 0) {
> > +             dev_err(ds->dev, "failed to enable jumbo\n");
> > +             return rc;
> > +     }
> > +
> > +     /* Write the frame size in PORT_MAX_FR_SIZE register */
> > +     rc = lan937x_pwrite16(dev, port, PORT_MAX_FR_SIZE, max_size);
> > +
> > +     if (rc < 0) {
> > +             dev_err(ds->dev, "failed to change the mtu\n");
> > +             return rc;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int lan937x_get_max_mtu(struct dsa_switch *ds, int port)
> > +{
> > +     /* Frame size is 9000 (= 0x2328) if
> > +      * jumbo frame support is enabled, PORT_JUMBO_EN bit will be enabled
> > +      * based on mtu in lan937x_change_mtu() API
> > +      */
> > +     return FR_MAX_SIZE;
> 
> Frame size is one thing. But MTU is L2 payload, which excludes MAC DA,
> MAC SA, EtherType and VLAN ID. So does the switch really accept a packet
> with an L2 payload length of 9000 bytes and a VLAN tag?
(FR_MAX_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN) is supposed to be returned and i
will add the test case from my side. will make the changes in next rev.

> 
> > +}
> > +
> > +static int   lan937x_port_pre_bridge_flags(struct dsa_switch *ds, int port,
> > +                                           struct switchdev_brport_flags
> > flags,
> > +                                      struct netlink_ext_ack *extack)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> > +static int   lan937x_port_bridge_flags(struct dsa_switch *ds, int port,
> > +                                       struct switchdev_brport_flags flags,
> > +                                      struct netlink_ext_ack *extack)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> 
> This shouldn't have been implemented but is necessary due to a bug, see
> commit 70a7c484c7c3 ("net: dsa: fix bridge support for drivers without
> port_bridge_flags callback").
Thanks for pointing out the commit ID. I will remove it.

> 
> > +
> > +const struct dsa_switch_ops lan937x_switch_ops = {
> > +     .get_tag_protocol       = lan937x_get_tag_protocol,
> > +     .setup                  = lan937x_setup,
> > +     .phy_read               = lan937x_phy_read16,
> > +     .phy_write              = lan937x_phy_write16,
> > +     .port_enable            = ksz_enable_port,
> > +     .port_bridge_join       = ksz_port_bridge_join,
> > +     .port_bridge_leave      = ksz_port_bridge_leave,
> > +     .port_pre_bridge_flags  = lan937x_port_pre_bridge_flags,
> > +     .port_bridge_flags      = lan937x_port_bridge_flags,
> > +     .port_stp_state_set     = lan937x_port_stp_state_set,
> > +     .port_fast_age          = ksz_port_fast_age,
> > +     .port_max_mtu           = lan937x_get_max_mtu,
> > +     .port_change_mtu        = lan937x_change_mtu,
> > +};
> > +
> > +int lan937x_switch_register(struct ksz_device *dev)
> > +{
> > +     int ret;
> > +
> > +     ret = ksz_switch_register(dev, &lan937x_dev_ops);
> > +
> > +     if (ret) {
> > +             if (dev->mdio_np) {
> > +                     mdiobus_unregister(dev->ds->slave_mii_bus);
> 
> I don't see any mdiobus_unregister when the driver is removed?
Oops, i will add unregister in ".remove" as well.

> 
> > +                     of_node_put(dev->mdio_np);
> 
> Also, why keep mdio_np inside ksz_device, therefore for the entire
> lifetime of the driver? Why do you need it? 
ksz_switch_register common function is used here. Inside ksz_switch_register
function, mdio is being registered through init(). After the mdio bus
registration, there is dsa_register_switch() in ksz common layer. Hence made
that as part of ksz_device to unregister the mdio if there were any failures and
unregistered along with of_node_put. Do you think this is a bad approach?


> Not to mention you don't
> appear to be ever calling of_node_put on unbind, unless I'm missing
> something.
of_node_put is called as above. And then the same is called, if
of_mdiobus_register() is failed in lan937x_dev.c. Then the next action is to
call during driver removal. Did i miss any other place?


> 
> > +             }
> > +     }
> > +
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL(lan937x_switch_register);
> > +
> > +MODULE_AUTHOR("Prasanna Vengateshan Varadharajan < 
> > Prasanna.Vengateshan@microchip.com>");
> > +MODULE_DESCRIPTION("Microchip LAN937x Series Switch DSA Driver");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/net/dsa/microchip/lan937x_spi.c
> > b/drivers/net/dsa/microchip/lan937x_spi.c
> > new file mode 100644
> > index 000000000000..d9731d6afb96
> > --- /dev/null
> > +++ b/drivers/net/dsa/microchip/lan937x_spi.c
> > @@ -0,0 +1,226 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Microchip LAN937X switch driver register access through SPI
> > + * Copyright (C) 2019-2021 Microchip Technology Inc.
> > + */
> > +#include <asm/unaligned.h>
> 
> Why do you need this?
> 
> > +
> > +#include <linux/delay.h>
> 
> Or this?
Will remove both of them

> 
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/regmap.h>
> > +#include <linux/spi/spi.h>
> > +#include <linux/of_device.h>
> > +
> > +#include "ksz_common.h"
> > +
> > +#define SPI_ADDR_SHIFT                               24
> > +#define SPI_ADDR_ALIGN                               3
> > +#define SPI_TURNAROUND_SHIFT         5
> > +
> > +KSZ_REGMAP_TABLE(lan937x, 32, SPI_ADDR_SHIFT,
> > +              SPI_TURNAROUND_SHIFT, SPI_ADDR_ALIGN);
> > +
> > +struct lan937x_chip_data {
> > +     u32 chip_id;
> > +     const char *dev_name;
> > +     int num_vlans;
> > +     int num_alus;
> > +     int num_statics;
> > +     int cpu_ports;
> > +     int port_cnt;
> > +};
> > +
> > +static const struct of_device_id lan937x_dt_ids[];
> > +
> > +static const struct lan937x_chip_data lan937x_switch_chips[] = {
> > +     {
> > +             .chip_id = 0x00937010,
> > +             .dev_name = "LAN9370",
> > +             .num_vlans = 4096,
> > +             .num_alus = 1024,
> > +             .num_statics = 256,
> > +             /* can be configured as cpu port */
> > +             .cpu_ports = 0x10,
> > +             /* total port count */
> > +             .port_cnt = 5,
> > +     },
> > +     {
> > +             .chip_id = 0x00937110,
> > +             .dev_name = "LAN9371",
> > +             .num_vlans = 4096,
> > +             .num_alus = 1024,
> > +             .num_statics = 256,
> > +             /* can be configured as cpu port */
> > +             .cpu_ports = 0x30,
> > +             /* total port count */
> > +             .port_cnt = 6,
> > +     },
> > +     {
> > +             .chip_id = 0x00937210,
> > +             .dev_name = "LAN9372",
> > +             .num_vlans = 4096,
> > +             .num_alus = 1024,
> > +             .num_statics = 256,
> > +             /* can be configured as cpu port */
> > +             .cpu_ports = 0x30,
> > +             /* total port count */
> > +             .port_cnt = 8,
> > +     },
> > +     {
> > +             .chip_id = 0x00937310,
> > +             .dev_name = "LAN9373",
> > +             .num_vlans = 4096,
> > +             .num_alus = 1024,
> > +             .num_statics = 256,
> > +             /* can be configured as cpu port */
> > +             .cpu_ports = 0x38,
> > +             /* total port count */
> > +             .port_cnt = 5,
> > +     },
> > +     {
> > +             .chip_id = 0x00937410,
> > +             .dev_name = "LAN9374",
> > +             .num_vlans = 4096,
> > +             .num_alus = 1024,
> > +             .num_statics = 256,
> > +             /* can be configured as cpu port */
> > +             .cpu_ports = 0x30,
> > +             /* total port count */
> > +             .port_cnt = 8,
> > +     },
> > +
> 
> The new line shouldn't be here?
Noted, will remove it.

> 
> > +};
> > +


