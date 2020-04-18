Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B899A1AF19E
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 17:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgDRP3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 11:29:10 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:10231 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgDRP3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 11:29:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587223750; x=1618759750;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6TbKFtDMJl3rttAHpd29hde3tTCeTElBmhYZKfSkNuc=;
  b=c/yienQce+YqSIOtNLWSEU4zXVgxXq9cvpkdWhVtvyVAvSrxJbWt2kPd
   1QwApfT16DBTtoyS0TvP3gm9K0FOWqyRdnSBhKur9Hug+Y4Xz3eTNZEWm
   NNFXL/rZqDmbAE3fu7Im4IcgTIu82JF7pZSlI+BWPVfjdR6uXyylx7p0l
   6PnpNbvDcv7D3ghONJ/D54RAkZ3NhGIVrSXNuTnOJR7FBTUD54CYvq9Cz
   x7i3fM36gy43TDA4mscjJpcmzKbhxRFeAMFdUahkX45UmRKQU3mxTxzYt
   DqWUDy3S3qtfW5mEj9NFe6u1AcVZRC65AuiCR8UpemBm80acKjQYLiRyz
   Q==;
IronPort-SDR: B9lp62wR2RTd0Bt4sIkoPdQI56fqjp29Mcrpk0ZuqKuZyCvK59gkkLN74BKBLtEh41w3xRmopd
 4vW2ymh284qVIiNteuxPyqeZkQTYaWRfbpeoCNXyOxnVSQ1j6kRY2SiVrZH/9GptLprD7B9Jex
 fnQVh0S3DWLGImYx6aZIrjpAAyTtiSUWtSY3uISjS3btWXWdNR5KV7BEFIoJ+CDT1FKCoRQXMQ
 2y00nDTtryrvt5QCzdAZmo8/nsjW1xVG9f8qbEN6gQlXu+jfWFnMmEvtx7DNk0+prz1c5+0U5c
 r5I=
X-IronPort-AV: E=Sophos;i="5.72,399,1580799600"; 
   d="scan'208";a="72974964"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Apr 2020 08:29:10 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 18 Apr 2020 08:28:46 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sat, 18 Apr 2020 08:29:14 -0700
Date:   Sat, 18 Apr 2020 17:29:08 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <davem@davemloft.net>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <olteanv@gmail.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v5 3/9] bridge: mrp: Expose function
 br_mrp_port_open
Message-ID: <20200418152908.ifaszlvmp5htr3x7@soft-dev3.microsemi.net>
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
 <20200414112618.3644-4-horatiu.vultur@microchip.com>
 <2b387697-0e4c-7d8a-ae52-d1e8ce1f6bf4@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <2b387697-0e4c-7d8a-ae52-d1e8ce1f6bf4@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/18/2020 11:11, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 14/04/2020 14:26, Horatiu Vultur wrote:
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
> >  include/linux/mrp_bridge.h | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >  create mode 100644 include/linux/mrp_bridge.h
> >
> > diff --git a/include/linux/mrp_bridge.h b/include/linux/mrp_bridge.h
> > new file mode 100644
> > index 000000000000..23d46b356263
> > --- /dev/null
> > +++ b/include/linux/mrp_bridge.h
> > @@ -0,0 +1,24 @@
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
> > + *
> > + * This eventually notify the userspace which is required to react on these
> > + * changes.
> > + */
> > +
> > +#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> > +int br_mrp_port_open(struct net_device *dev, u8 loc);
> > +#else
> > +inline int br_mrp_port_open(struct net_device *dev, u8 loc)  {}
> 
> static and put {} on their own, check how such functions are defined in other places (e.g. br_private.h)
> but in general I think you can drop this function favor of br_ifinfo_notify(). More about that in my review
> of next patches.

I have seen the other reviews but I am not sure I can completly drop
this function. I can have this function as a small wrapper over
br_ifinfo_notify.  The reason is that I want that also the drivers to be
able to notify when a port get lost of continuity.

> 
> > +#endif
> > +
> > +#endif
> >
> 

-- 
/Horatiu
