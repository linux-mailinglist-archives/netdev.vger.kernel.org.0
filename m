Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303EB1B15E7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgDTT04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:26:56 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:65343 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgDTT04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:26:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587410815; x=1618946815;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2Z2X+Oe46FhVfUNdHU2pO9fm49ctsQbX913UhF7CSVU=;
  b=rZQftbqlAzCtG+D1KFX+CGLbJLh8ZarU+6XrlJQhiyjs0At3AzHIIS3m
   EGcNJhBZj1y6hGplTTQLHvjf7t006WgO/5ZVo5rEuGD3bDZjCVd4Ors3G
   3tdoobQbGquE0sC1JUbzPIl44O1PT6hOawrZDF0x6qjqe7Six+6r24Bws
   n8mRsgNkNA37Y+/1OJCjSznMwr70/Y/cBbZ8MNINm+8+V/isi54A/eWtB
   1cmXf6MV1+kt2s2r6BdMEVC/QwtB4WeF0RDJyeRVoDeqPo8f8PeSBVy+J
   MWJ9i3zYY4oMD2PnOOP5y2+4THqeMBr0xZtZgGH/UcuEnaDYo/LzT4je/
   Q==;
IronPort-SDR: uXwx1ZizNlrmPOILo6sDsgXyGOs2wcCQQFEdYCGUS5MiyBO7HJKROvOXhkWMXlqnqerD/ZTUDC
 Ocyiup15TJ0jP3EA9jevE/nqth0rC74riWZOeC6GvOZgzTv1E3+64uwuKASNFsPF+PQRq+FNQz
 tI8Q3K5gJuYeosXaL8JhRCwgJc/facu6n7Dh7UF4jnKw7ZtRAbdKVMgB66DqL1AZLUcF/X1Q6/
 iRCQfBOa3jCYEFQpN/akJ+0mq9vxlYjFHhBa+2lMsJ4ySIwMEDZAA8AQAPwJcn2x38Fa49ehnk
 Qbo=
X-IronPort-AV: E=Sophos;i="5.72,407,1580799600"; 
   d="scan'208";a="72781184"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2020 12:26:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Apr 2020 12:27:02 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 20 Apr 2020 12:26:54 -0700
Date:   Mon, 20 Apr 2020 21:26:54 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <davem@davemloft.net>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 04/13] bridge: mrp: Expose function
 br_mrp_port_open
Message-ID: <20200420192654.ivar7apyv5xnzwg3@soft-dev3.microsemi.net>
References: <20200420150947.30974-1-horatiu.vultur@microchip.com>
 <20200420150947.30974-5-horatiu.vultur@microchip.com>
 <cc388b70-701c-4600-791b-8170683a7666@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <cc388b70-701c-4600-791b-8170683a7666@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/20/2020 20:30, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 20/04/2020 18:09, Horatiu Vultur wrote:
> > In case the HW is capable to detect when the MRP ring is open or closed. It is
> > expected that the network driver will notify the SW that the ring is open or
> > closed.
> >
> > The function br_mrp_port_open is used to notify the kernel that one of the ports
> > stopped receiving MRP_Test frames. The argument 'loc' has a value of '1' when
> > the port stopped receiving MRP_Test and '0' when it started to receive MRP_Test.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  include/linux/mrp_bridge.h | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> >  create mode 100644 include/linux/mrp_bridge.h
> >
> > diff --git a/include/linux/mrp_bridge.h b/include/linux/mrp_bridge.h
> > new file mode 100644
> > index 000000000000..61c1f0d395c7
> > --- /dev/null
> > +++ b/include/linux/mrp_bridge.h
> > @@ -0,0 +1,27 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +
> > +#ifndef _LINUX_MRP_BRIDGE_H
> > +#define _LINUX_MRO_BRIDGE_H
> > +
> > +#include <linux/netdevice.h>
> > +
> > +/* The drivers are responsible to call this function when it detects that the
> > + * MRP port stopped receiving MRP_Test frames or it started to receive MRP_Test.
> > + * The argument dev represents the port and loc(Lost of Continuity) has a value
> > + * of 1 when it stopped receiving MRP_Test frames and a value of 0 when it
> > + * started to receive frames.
> > + * Needs to be called with rcu_read_lock().
> > + *
> > + * This eventually notify the userspace which is required to react on these
> > + * changes.
> > + */
> > +
> > +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> > +int br_mrp_port_open(struct net_device *dev, u8 loc);
> > +#else
> > +static inline int br_mrp_port_open(struct net_device *dev, u8 loc)
> > +{
> > +}
> > +#endif
> > +
> > +#endif
> >

Hi Nik,
> 
> I see that in order to pass this "loc" to br_ifinfo_notify() you add a new port variable,
> but it's a boolean, so you can just use the port flags for it which will simplify things a lot
> and remove some ifdefs along the way. And please rename it to something longer (so it's easier
> to get what it does).

I will update to use the port flags.

> 
> One question - now that it's always sent to user-space as IFLA_BRPORT_MRP_RING_OPEN attribute
> wouldn't it be a problem, or is it read as a current state?
> I mean you'll receive that attribute about a port even if you get a completely unrelated to MRP
> notification (e.g. about a vlan change).

It should not be a problem. The default value is 0, which means that the
port has not lost the continuity.
So let's say that a port lost the continuity then the userspace will
receive a call where attribute IFLA_BRPORT_MRP_RING_OPEN will have the
value 1. This is as expected.
Then as you suggested, there is a vlan change, the userspace will
receive a notification but again the attribute IFLA_BRPORT_MRP_RING_OPEN
is 1, because the actual value is stored in the port variable, or port
flags in the new patch). But the userspace can detect this case and just
ignores it.
The same will apply also if the userspace will receive multiple
notification if the port didn't lose the continuity.

> 
> Thanks,
>  Nik

-- 
/Horatiu
