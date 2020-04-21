Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BE01B1AAE
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 02:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgDUA1a convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Apr 2020 20:27:30 -0400
Received: from mga04.intel.com ([192.55.52.120]:19903 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbgDUA13 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 20:27:29 -0400
IronPort-SDR: slLJu45iqLR/bZHVS/uBX89QxfOJ4ySnZwLq8L9fcmtx+vJSmNTLXlOqYv2xLK/uYbAfVEx9Yj
 44QHn75v+Jqg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 17:27:29 -0700
IronPort-SDR: RGtpzhphnE7xijZKTGYBYd26lfS40/D+1tWa1ZabP+CfxStgLnI18BBXZ0yWl9qGsnXusrQYwg
 m9yizxIzKg1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="244002024"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga007.jf.intel.com with ESMTP; 20 Apr 2020 17:27:29 -0700
Received: from fmsmsx101.amr.corp.intel.com (10.18.124.199) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 17:27:28 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 fmsmsx101.amr.corp.intel.com ([169.254.1.121]) with mapi id 14.03.0439.000;
 Mon, 20 Apr 2020 17:27:28 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [RFC PATCH v5 12/16] RDMA/irdma: Add miscellaneous utility
 definitions
Thread-Topic: [RFC PATCH v5 12/16] RDMA/irdma: Add miscellaneous utility
 definitions
Thread-Index: AQHWFNtzYxwJ525w0UOK+2ymyeL4bqh+OjIAgAQT/QA=
Date:   Tue, 21 Apr 2020 00:27:28 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD485B7@fmsmsx124.amr.corp.intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-13-jeffrey.t.kirsher@intel.com>
 <20200417203216.GH3083@unreal>
In-Reply-To: <20200417203216.GH3083@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC PATCH v5 12/16] RDMA/irdma: Add miscellaneous utility
> definitions
> 
> On Fri, Apr 17, 2020 at 10:12:47AM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Add miscellaneous utility functions and headers.
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> >  drivers/infiniband/hw/irdma/osdep.h  |  105 ++
> >  drivers/infiniband/hw/irdma/protos.h |   93 +
> >  drivers/infiniband/hw/irdma/status.h |   69 +
> >  drivers/infiniband/hw/irdma/utils.c  | 2445
> > ++++++++++++++++++++++++++
> >  4 files changed, 2712 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/irdma/osdep.h
> >  create mode 100644 drivers/infiniband/hw/irdma/protos.h
> >  create mode 100644 drivers/infiniband/hw/irdma/status.h
> >  create mode 100644 drivers/infiniband/hw/irdma/utils.c
> >
> > diff --git a/drivers/infiniband/hw/irdma/osdep.h
> > b/drivers/infiniband/hw/irdma/osdep.h
> > new file mode 100644
> > index 000000000000..23ddfb8e9568
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/irdma/osdep.h
> > @@ -0,0 +1,105 @@
> > +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> > +/* Copyright (c) 2015 - 2019 Intel Corporation */ #ifndef
> > +IRDMA_OSDEP_H #define IRDMA_OSDEP_H
> > +
> > +#include <linux/version.h>
> 
> Why is that?
Not needed. Thanks!

> 
> > +#define irdma_debug_buf(dev, prefix, desc, buf, size)	\
> > +	print_hex_dump_debug(prefix ": " desc " ",	\
> > +			     DUMP_PREFIX_OFFSET,	\
> > +			     16, 8, buf, size, false)
> > +
> 
> I think that it can be beneficial to be as ibdev_print_buf().

Macro itself looks a little weird since dev is not used and needs to be fixed.
I wonder why there isn't a struct device ver. of this print buf
to start with.

[...]

> > +	IRDMA_ERR_BAD_STAG			= -66,
> > +	IRDMA_ERR_CQ_COMPL_ERROR		= -67,
> > +	IRDMA_ERR_Q_DESTROYED			= -68,
> > +	IRDMA_ERR_INVALID_FEAT_CNT		= -69,
> > +	IRDMA_ERR_REG_CQ_FULL			= -70,
> > +	IRDMA_ERR_VF_MSG_ERROR			= -71,
> > +};
> 
> Please don't do vertical space alignment in all the places

vertically aligning groups of defines that are related or enum constants
look more readable.

+       IRDMA_ERR_BAD_STAG = -66,
+       IRDMA_ERR_CQ_COMPL_ERROR = -67,
+       IRDMA_ERR_Q_DESTROYED = -68,
+       IRDMA_ERR_INVALID_FEAT_CNT = -69,
+       IRDMA_ERR_REG_CQ_FULL = -70,
+       IRDMA_ERR_VF_MSG_ERROR = -71,

This looks less readable IMHO.

> 
> > +#endif /* IRDMA_STATUS_H */
> > diff --git a/drivers/infiniband/hw/irdma/utils.c
> > b/drivers/infiniband/hw/irdma/utils.c
> > new file mode 100644
> > index 000000000000..be46d672afc5
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/irdma/utils.c
> > @@ -0,0 +1,2445 @@
> > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > +/* Copyright (c) 2015 - 2019 Intel Corporation */ #include
> > +<linux/mii.h> #include <linux/in.h> #include <linux/init.h> #include
> > +<asm/irq.h> #include <asm/byteorder.h> #include <net/neighbour.h>
> > +#include "main.h"
> > +
> > +/**
> > + * irdma_arp_table -manage arp table
> > + * @rf: RDMA PCI function
> > + * @ip_addr: ip address for device
> > + * @ipv4: IPv4 flag
> > + * @mac_addr: mac address ptr
> > + * @action: modify, delete or add
> > + */
> > +int irdma_arp_table(struct irdma_pci_f *rf, u32 *ip_addr, bool ipv4,
> > +		    u8 *mac_addr, u32 action)
> 
> ARP table in the RDMA driver looks strange, I see that it is legacy from i40iw, but
> wonder if it is the right thing to do the same for the new driver.
> 

See response in Patch #1.
