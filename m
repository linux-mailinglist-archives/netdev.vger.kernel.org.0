Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864CA35C934
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242550AbhDLOvk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Apr 2021 10:51:40 -0400
Received: from mga03.intel.com ([134.134.136.65]:13079 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242544AbhDLOvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:51:39 -0400
IronPort-SDR: Hx/P2ugnxe+u00oo+coGDEaaqpruLn5IwbC9IIXhL2ZRnUm+HX8Jv9yZhbun4icyPSuIHuRWZL
 Kxrv/eIyjuiA==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="194237754"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="194237754"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 07:51:21 -0700
IronPort-SDR: aLOnJAL5S4Oq9ldJCskKLYsILXHx1/iKdhJ4v5KHBgfWUpdmY4dQfoq9N1lCTdsEqjDdfrv6rp
 NgXCaraQRgUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="417422733"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 12 Apr 2021 07:51:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 07:51:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 07:51:19 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Mon, 12 Apr 2021 07:51:19 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH v4 resend 01/23] iidc: Introduce iidc.h
Thread-Topic: [PATCH v4 resend 01/23] iidc: Introduce iidc.h
Thread-Index: AQHXK0MoREaUeG1gK0SxdZvV8XgX6Kqp0AGAgAK0eZA=
Date:   Mon, 12 Apr 2021 14:51:18 +0000
Message-ID: <2ee289f620154810921df2bc2c903192@intel.com>
References: <20210407001502.1890-1-shiraz.saleem@intel.com>
 <20210407001502.1890-2-shiraz.saleem@intel.com>
 <20210407180529.GA547588@nvidia.com>
In-Reply-To: <20210407180529.GA547588@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v4 resend 01/23] iidc: Introduce iidc.h
> 
> On Tue, Apr 06, 2021 at 07:14:40PM -0500, Shiraz Saleem wrote:
> > +/* Structure representing auxiliary driver tailored information about
> > +the core
> > + * PCI dev, each auxiliary driver using the IIDC interface will have
> > +an
> > + * instance of this struct dedicated to it.
> > + */
> > +struct iidc_core_dev_info {
> > +	struct pci_dev *pdev; /* PCI device of corresponding to main function */
> > +	struct auxiliary_device *adev;
> > +	/* KVA / Linear address corresponding to BAR0 of underlying
> > +	 * pci_device.
> > +	 */
> > +	u8 __iomem *hw_addr;
> > +	int cdev_info_id;
> > +
> > +	u8 ftype;	/* PF(false) or VF (true) */
> 
> Where is ftype initialized?

Today it is just pf. But the upcoming Intel ethernet VF driver will set it to true.

> 
> > +	u16 vport_id;
> > +	enum iidc_rdma_protocol rdma_protocol;
> 
> This duplicates the aux device name, not really sure why it is needed. One user just
> uses it to make the string, the rest is entangled with the devlink and doesn't need
> to be stored here.

It is used to pass the type of protocol at drv.probe() in aux RDMA driver.

> 
> > +	struct iidc_qos_params qos_info;
> > +	struct net_device *netdev;
> > +
> > +	struct msix_entry *msix_entries;
> > +	u16 msix_count; /* How many vectors are reserved for this device */
> > +
> > +	/* Following struct contains function pointers to be initialized
> > +	 * by core PCI driver and called by auxiliary driver
> > +	 */
> > +	const struct iidc_core_ops *ops;
> > +};
> 
> I spent a while trying to understand this struct and why it exists and..
> 
> > +
> > +struct iidc_auxiliary_dev {
> > +	struct auxiliary_device adev;
> > +	struct iidc_core_dev_info *cdev_info;
> 
> This cdev_info should just be a 'struct ice_pf *' and the "struct iidc_core_dev_info"
> should be deleted entirely. You'll notice this ends up looking nearly exactly like
> mlx5 does after this.

It was intentionally designed to be core device object carving out only pieces of the PF
information required by the rdma driver. The next near-term PCI driver using IIDC can also
this. Why expose the whole PF? This is a design choice no? Why do we need to follow mlx5?

> 
> You can see it clearly based on how this gets initialized:
> 
> 		cdev_info->pdev = pf->pdev;
> 		cdev_info->hw_addr = (u8 __iomem *)pf->hw.hw_addr;
> 
>                 struct ice_vsi *vsi = ice_get_main_vsi(pf);
> 		cdev_info->vport_id = vsi->vsi_num;
> 		cdev_info->netdev = vsi->netdev;
> 		cdev_info->msix_count = pf->num_rdma_msix;
> 		cdev_info->msix_entries = &pf->msix_entries[pf-
> >rdma_base_vector];
> 
> 		ice_setup_dcb_qos_info(pf, cdev_info->qos_info);
> 
> Since the main place this cdev_info appears is in the ops API between the two
> modules, it looks to me like this is being designed in this obfuscated way to try
> and create a stable ABI between two modules.
> 
> Remove all the stable module ABI hackery before you resend it.
> 

I don't follow what the hackery is. Just because we use cdev_info in the .ops callbacks as opposed to ice_pf?

This is a private interface for Intel RDMA/PCI drivers and yes it is designed to be forward
looking especially since when we have near-term plans to use it.

Can you explain what you mean by stable module ABI hackery?

Shiraz
