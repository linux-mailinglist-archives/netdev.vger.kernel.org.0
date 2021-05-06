Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8B93755F4
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhEFOwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:52:43 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:56627 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbhEFOwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 10:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1620312703; x=1651848703;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7xfUVt67baauwCjjZDw8mvwRHXCq289bgSvRukAo4yQ=;
  b=2tgP5BbFbJh1d31GlrSbtUqEVZDlN9nmB1DzuXCC50wMh1D6u3pEvf0N
   +BLnTbGNcX+WWFCpxJF/Z0ROvy+hTYLu7/OidvIhQJEfv0lNkq45Zin3H
   BqpgNvE20jHeIZV+gAkR0OF1ndImgAnfmO0DysBlhjyLUcv+QedVzYsW6
   4aY83kUm72cBWsIRhbRSwGCw5sCk3dX6IXcDj3+zjk1h2giQdZ/lQ1jzX
   HRiKAFZQC9jH5cMJuHEN/DtconyD17cQNdGlQWyN872Tn6WWKEuOS1H6m
   XWTDvk7LvQw7P6yeGYVPi4s6aRmWd6O7W4GN5Ry8a5HqS0/R6KPZOkdyt
   w==;
IronPort-SDR: Ub1fvDXej12gwIhShN4HUC/i9DjD/k+wpdd5YFLcF0RkwYsZnVhDSWlRLnoYJhPV+4d2lwkgcA
 Q8sxFviFL4UG6SO3co2/NwJpNYHuI7iAH+HsCzWIOH9ZzdzsPLtEhlNUlcNEac3WwcOcHXTSmU
 4It1Ag3+uavymTF61iep0+xen4wIq7+84NEueqnhmVPeM9Kp+qfrDxf/1KcoO6L1ojOm2Nf0vr
 spBj5CaWObkwCyVFPNqmL+Lw9ZL1jb8v++ZwSaSLeq6glUFN/QwZ7RCanNGO5WxqbgfSNQkILy
 E+E=
X-IronPort-AV: E=Sophos;i="5.82,277,1613458800"; 
   d="scan'208";a="119193429"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 May 2021 07:51:42 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 6 May 2021 07:51:41 -0700
Received: from W1064L-TARAKESH.mchp-main.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 6 May 2021 07:51:37 -0700
Message-ID: <ab9da4b759dec9ab69bac791300a6a8977ee7cc2.camel@microchip.com>
Subject: Re: [PATCH v2 net-next 9/9] net: dsa: microchip: add support for
 vlan operations
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Thu, 6 May 2021 20:21:35 +0530
In-Reply-To: <20210422190351.qdv2xlnxghmfpjqj@skbuf>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
         <20210422094257.1641396-10-prasanna.vengateshan@microchip.com>
         <20210422190351.qdv2xlnxghmfpjqj@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thu, 2021-04-22 at 22:03 +0300, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Thu, Apr 22, 2021 at 03:12:57PM +0530, Prasanna Vengateshan wrote:
> > Support for VLAN add, del, prepare and filtering operations.
> > 
> > It aligns with latest update of removing switchdev
> > transactional logic from VLAN objects
> 
> Maybe more in the commit message about what the patch does, as opposed
> to mentioning that you had to rebase it, would be helpful.
Sure.

> 
> > 
> > Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> > ---
> >  drivers/net/dsa/microchip/lan937x_main.c | 214 +++++++++++++++++++++++
> >  1 file changed, 214 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/microchip/lan937x_main.c
> > b/drivers/net/dsa/microchip/lan937x_main.c
> > index 7f6183dc0e31..35f3456c3506 100644
> 
> > +
> > +             rc = lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE,
> > true);
> 
> How about this bit?

> 
> I see one bit is per port and the other is global.
> Just FYI, you can have this configuration:
> 
> ip link add br0 type bridge vlan_filtering 0
> ip link add br1 type bridge vlan_filtering 1
> ip link set swp0 master br0
> ip link set swp1 master br0
> ip link set swp2 master br1
> ip link set swp3 master br1
> 
> Do the swp0 and swp1 ports remain VLAN-unaware after you touch this
> REG_SW_LUE_CTRL_0 bit?
vlan aware is global, so ds->vlan_filtering_is_global needs to be true if VLAN
aware is global, will fix this in the next version

> 
> > +     } else {
> > +             rc = lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_VLAN_ENABLE,
> > false);
> > +             if (rc < 0)
> > +                     return rc;
> > +
> > +             rc = lan937x_port_cfg(dev, port, REG_PORT_LUE_CTRL,
> > +                                   PORT_VLAN_LOOKUP_VID_0, false);
> > +     }
> > +
> > +     return rc;
> > +}
> > +
> > +static int lan937x_port_vlan_add(struct dsa_switch *ds, int port,
> > +                              const struct switchdev_obj_port_vlan *vlan,
> > +                              struct netlink_ext_ack *extack)
> > +{
> > +     bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> > +     struct ksz_device *dev = ds->priv;
> > +     u32 vlan_table[3];
> 
> Maybe a structure would be nicer to read than an u32 array?
Okay, will make a structure.

> 
> > +     int rc;
> > +
> > +     rc = lan937x_get_vlan_table(dev, vlan->vid, vlan_table);
> > +     if (rc < 0) {
> > +             dev_err(dev->dev, "Failed to get vlan table\n");
> 
> One of the reasons for which the extack exists is so that you can report
> errors to user space and not to the console.
Sure, will add it for port_vlan_del() as well

> 
>                 NL_SET_ERR_MSG_MOD(extack, "Failed to get vlan table");
> 
> > +             return rc;
> > +     }
> > +
> > +     vlan_table[0] = VLAN_VALID | (vlan->vid & VLAN_FID_M);
> > +
> > +     /* set/clear switch port when updating vlan table registers */
> > +     if (untagged)
> > +             vlan_table[1] |= BIT(port);
> > +     else
> > +             vlan_table[1] &= ~BIT(port);
> > +     vlan_table[1] &= ~(BIT(dev->cpu_port));
> > +
> > +     vlan_table[2] |= BIT(port) | BIT(dev->cpu_port);
> 
> What's the business with the CPU port here? Does DSA not call
> .port_vlan_add for the CPU port separately?
Calls for CPU port as well. This is to be removed.

> 
> > +
> > +     rc = lan937x_set_vlan_table(dev, vlan->vid, vlan_table);
> > +     if (rc < 0) {
> > +             dev_err(dev->dev, "Failed to set vlan table\n");
> > +             return rc;
> > +     }
> > +
> > +     /* change PVID */
> > +     if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
> > +             rc = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID, vlan-
> > >vid);
> > +
> > +             if (rc < 0) {
> > +                     dev_err(dev->dev, "Failed to set pvid\n");
> > +                     return rc;
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int lan937x_port_vlan_del(struct dsa_switch *ds, int port,
> > +                              const struct switchdev_obj_port_vlan *vlan)
> > +{
> > +     bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> > +     struct ksz_device *dev = ds->priv;
> > +     u32 vlan_table[3];
> > +     u16 pvid;
> > +     int rc;
> > +
> > +     lan937x_pread16(dev, port, REG_PORT_DEFAULT_VID, &pvid);
> > +     pvid &= 0xFFF;
> > +
> > +     rc = lan937x_get_vlan_table(dev, vlan->vid, vlan_table);
> > +
> > +     if (rc < 0) {
> > +             dev_err(dev->dev, "Failed to get vlan table\n");
> > +             return rc;
> > +     }
> > +     /* clear switch port number */
> > +     vlan_table[2] &= ~BIT(port);
> > +
> > +     if (pvid == vlan->vid)
> > +             pvid = 1;
> 
> According to Documentation/networking/switchdev.rst:
> 
> When the bridge has VLAN filtering enabled and a PVID is not configured on the
> ingress port, untagged and 802.1p tagged packets must be dropped. When the
> bridge
> has VLAN filtering enabled and a PVID exists on the ingress port, untagged and
> priority-tagged packets must be accepted and forwarded according to the
> bridge's port membership of the PVID VLAN. When the bridge has VLAN filtering
> disabled, the presence/lack of a PVID should not influence the packet
> forwarding decision.
> 
> So please don't reset the pvid.
Will remove it in the next rev.

> 
> > +
> > +     if (untagged)
> > +             vlan_table[1] &= ~BIT(port);
> > +
> > +     rc = lan937x_set_vlan_table(dev, vlan->vid, vlan_table);
> > +     if (rc < 0) {
> > +             dev_err(dev->dev, "Failed to set vlan table\n");
> > +             return rc;
> > +     }
> > +
> > +     rc = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID, pvid);
> > +
> > +     if (rc < 0) {
> > +             dev_err(dev->dev, "Failed to set pvid\n");
> > +             return rc;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  static u8 lan937x_get_fid(u16 vid)
> >  {
> >       if (vid > ALU_FID_SIZE)
> > @@ -955,6 +1166,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
> >       .port_bridge_flags      = lan937x_port_bridge_flags,
> >       .port_stp_state_set     = lan937x_port_stp_state_set,
> >       .port_fast_age          = ksz_port_fast_age,
> > +     .port_vlan_filtering    = lan937x_port_vlan_filtering,
> > +     .port_vlan_add          = lan937x_port_vlan_add,
> > +     .port_vlan_del          = lan937x_port_vlan_del,
> >       .port_fdb_dump          = lan937x_port_fdb_dump,
> >       .port_fdb_add           = lan937x_port_fdb_add,
> >       .port_fdb_del           = lan937x_port_fdb_del,
> > --
> > 2.27.0
> > 


