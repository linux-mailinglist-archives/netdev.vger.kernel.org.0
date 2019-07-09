Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D451063CF9
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbfGIU4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:56:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:23270 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729852AbfGIU43 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 16:56:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 13:56:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,472,1557212400"; 
   d="scan'208";a="173673832"
Received: from horosco-mobl2.amr.corp.intel.com (HELO horosco-MOBL2) ([10.122.74.43])
  by FMSMGA003.fm.intel.com with SMTP; 09 Jul 2019 13:56:27 -0700
Received: by horosco-MOBL2 (sSMTP sendmail emulation); Tue, 09 Jul 2019 15:56:26 -0500
Date:   Tue, 9 Jul 2019 15:56:13 -0500
From:   Henry Orosco <henry.orosco@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "Ertman, David M" <david.m.ertman@intel.com>
Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
Message-ID: <20190709205613.GA7440@horosco-MOBL2.amr.corp.intel.com>
References: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
 <20190704021259.15489-16-jeffrey.t.kirsher@intel.com>
 <20190704074021.GH4727@mtr-leonro.mtl.com>
 <20190704121933.GD3401@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7A684DAAA@fmsmsx124.amr.corp.intel.com>
 <20190705171650.GI31525@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7A68512AA@fmsmsx124.amr.corp.intel.com>
 <20190708141336.GF23966@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708141336.GF23966@mellanox.com>
User-Agent: Mutt/1.7.0 (2016-08-17)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 02:13:39PM +0000, Jason Gunthorpe wrote:
> On Sat, Jul 06, 2019 at 04:15:20PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
> > > 
> > > On Fri, Jul 05, 2019 at 04:42:19PM +0000, Saleem, Shiraz wrote:
> > > > > Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
> > > > >
> > > > > On Thu, Jul 04, 2019 at 10:40:21AM +0300, Leon Romanovsky wrote:
> > > > > > On Wed, Jul 03, 2019 at 07:12:57PM -0700, Jeff Kirsher wrote:
> > > > > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > > >
> > > > > > > Add ABI definitions for irdma.
> > > > > > >
> > > > > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > > > include/uapi/rdma/irdma-abi.h | 130
> > > > > > > ++++++++++++++++++++++++++++++++++
> > > > > > >  1 file changed, 130 insertions(+)  create mode 100644
> > > > > > > include/uapi/rdma/irdma-abi.h
> > > > > > >
> > > > > > > diff --git a/include/uapi/rdma/irdma-abi.h
> > > > > > > b/include/uapi/rdma/irdma-abi.h new file mode 100644 index
> > > > > > > 000000000000..bdfbda4c829e
> > > > > > > +++ b/include/uapi/rdma/irdma-abi.h
> > > > > > > @@ -0,0 +1,130 @@
> > > > > > > +/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
> > > > > > > +/* Copyright (c) 2006 - 2019 Intel Corporation.  All rights reserved.
> > > > > > > + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> > > > > > > + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> > > > > > > + * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
> > > > > > > + */
> > > > > > > +
> > > > > > > +#ifndef IRDMA_ABI_H
> > > > > > > +#define IRDMA_ABI_H
> > > > > > > +
> > > > > > > +#include <linux/types.h>
> > > > > > > +
> > > > > > > +/* irdma must support legacy GEN_1 i40iw kernel
> > > > > > > + * and user-space whose last ABI ver is 5  */ #define
> > > > > > > +IRDMA_ABI_VER
> > > > > > > +6
> > > > > >
> > > > > > Can you please elaborate about it more?
> > > > > > There is no irdma code in RDMA yet, so it makes me wonder why new
> > > > > > define shouldn't start from 1.
> > > > >
> > > > > It is because they are ABI compatible with the current user space,
> > > > > which raises the question why we even have this confusing header file..
> > > >
> > > > It is because we need to support current providers/i40iw user-space.
> > > > Our user-space patch series will introduce a new provider (irdma)
> > > > whose ABI ver. is also 6 (capable of supporting X722 and which will
> > > > work with i40iw driver on older kernels) and removes providers/i40iw from rdma-
> > > core.
> > > 
> > > Why on earth would we do that?
> > > 
> > A unified library providers/irdma to go in hand with the driver irdma and uses the ABI header.
> > It can support the new network device e810 and existing x722 iWARP device. It obsoletes
> > providers/i40iw and extends its ABI. So why keep providers/i40iw around in rdma-core?
> 
> Why rewrite a perfectly good userspace that is compatible with the
> future and past kernels?
> 
> Is there something so wrong with the userspace provider to need this?
>

Yes, the issue is that providers/i40iw was never designed to work with a unified driver
which supports multiple hardware generations.

Henry 
