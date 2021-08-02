Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09583DD44E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhHBKsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:48:54 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:55485 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbhHBKsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 06:48:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1627901324; x=1659437324;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TK416wLbqT9UDE6WEJeilEIagVGG4FyRZEIJ5bkTLTE=;
  b=CYzuZLmTOdEHM1BefFg3IYG+c5wvivF/f4TabZbtuXYR4mJhmdlKinw8
   uKmFNhWu+6x1T8txzp3ehWE4EiDypbW2D2g8jt1lWTvzwDPdeAg7rS1gv
   mchQ2TEuH2b9IdJrMAhANaaFOwS7aGKOeE/xEC4z/SIK4TJP3/Vyp8mVV
   SFpvbItP8mY1b/cqEVivCUFBz+QMNeU+O53AjWsbq2nikUNjI4uPoCALh
   yqlskk3R9EOitVX5Bo3vtwWr0G/LaKeV7d2VTnqL59WgzAv+fjFwmLw5/
   qDhoP/8tP+FKAIou4v0ekPLvLjEdLEBFLqzGphyBZKDqEyjwY2JrD9cHm
   w==;
IronPort-SDR: 2r7+p/05xC0erTJhj4ITNbSEouGfSKMFZ68M4EJ0IPYH/X3wXAPJtDjhOoBNj6kZ/fKTpJeOIe
 lb3pIYsT0P9ZqDWjNqt5bNTmJS46MiLwu4N7n0Gs5jd8zJu+UfH3Q64jZEEp9w2V1ByvZwd7/q
 /3kUSoSgUzRk2OcowlcwO0bnmZdZth3ijoMNoSvdzByJDnzd7kB4684hhyKZpVUsMaGvav1hns
 /vACv1X8s/tAyg/gNftC3DQ9gmr4UYsbdE8bh8Hql1eLJMBxUo0B/a7GtYY9LC1osHJ51PXWVT
 Vi08I2Di1DpeuJTZABgFIeQ5
X-IronPort-AV: E=Sophos;i="5.84,288,1620716400"; 
   d="scan'208";a="138413805"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Aug 2021 03:48:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 03:48:43 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Mon, 2 Aug 2021 03:48:38 -0700
Message-ID: <16d7c1fd8ecaa10ed040e04261045274231ca654.camel@microchip.com>
Subject: Re: [PATCH v3 net-next 10/10] net: dsa: microchip: add support for
 vlan operations
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Mon, 2 Aug 2021 16:18:36 +0530
In-Reply-To: <20210731150838.2pigkik3iaeguflz@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
         <20210723173108.459770-11-prasanna.vengateshan@microchip.com>
         <20210731150838.2pigkik3iaeguflz@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-07-31 at 18:08 +0300, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Fri, Jul 23, 2021 at 11:01:08PM +0530, Prasanna Vengateshan wrote:
> > +static int lan937x_port_vlan_add(struct dsa_switch *ds, int port,
> > +                              const struct switchdev_obj_port_vlan *vlan,
> > +                              struct netlink_ext_ack *extack)
> > +{
> > +     bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> > +     struct ksz_device *dev = ds->priv;
> > +     struct lan937x_vlan vlan_entry;
> > +     int ret;
> > +
> > +     ret = lan937x_get_vlan_table(dev, vlan->vid, &vlan_entry);
> > +     if (ret < 0) {
> > +             NL_SET_ERR_MSG_MOD(extack, "Failed to get vlan table\n");
> 
> The NL_SET_ERR_MSG_MOD function already adds the \n at the end.

i will remove \n from other places as well for NL_SET_ERR_MSG_MOD.

> 
> > +             return ret;
> > 
> > +
> > +     /* change PVID */
> > +     if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
> > +             ret = lan937x_pwrite16(dev, port, REG_PORT_DEFAULT_VID,
> > +                                    vlan->vid);
> > +             if (ret < 0) {
> > +                     NL_SET_ERR_MSG_MOD(extack, "Failed to set pvid\n");
> > +                     return ret;
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> 
> Side question: do you think the ds->configure_vlan_while_not_filtering = false
> from ksz9477.c and ksz8795.c serve any purpose, considering that you did
> not need this setting for lan937x? If not, could you please send a patch
> to remove that setting from those 2 other KSZ drivers? Thanks.

Sure, I will add this patch in my next submission.


