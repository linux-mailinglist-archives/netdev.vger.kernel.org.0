Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA417163343
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgBRUm7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Feb 2020 15:42:59 -0500
Received: from mga14.intel.com ([192.55.52.115]:47887 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgBRUm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 15:42:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 12:42:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; 
   d="scan'208";a="382577403"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga004.jf.intel.com with ESMTP; 18 Feb 2020 12:42:57 -0800
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 18 Feb 2020 12:42:54 -0800
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.69]) by
 FMSMSX102.amr.corp.intel.com ([169.254.10.49]) with mapi id 14.03.0439.000;
 Tue, 18 Feb 2020 12:42:53 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Parav Pandit <parav@mellanox.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: RE: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework
 definitions
Thread-Topic: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework
 definitions
Thread-Index: AQHV4dioDC3nzfOBDEenlR28w/w9U6gbyl6AgAV2V/A=
Date:   Tue, 18 Feb 2020 20:42:53 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7C60C94AF@fmsmsx124.amr.corp.intel.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-11-jeffrey.t.kirsher@intel.com>
 <6f01d517-3196-1183-112e-8151b821bd72@mellanox.com>
In-Reply-To: <6f01d517-3196-1183-112e-8151b821bd72@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYTZhMGJlNTItN2U2ZC00NGFmLTlhMWYtNzg1NTc1MGEwMzAxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoic3hSREtWRlZselwvSWNyQUk0Zk1OZHVueUUxU0FEbWJ2aVwvRjdQQUlXaXRXSVBJcUN2VmpyMExqV3Z6dEMxNTNVIn0=
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework
> definitions
> 

[..]

> > +static int irdma_devlink_reload_up(struct devlink *devlink,
> > +				   struct netlink_ext_ack *extack) {
> > +	struct irdma_dl_priv *priv = devlink_priv(devlink);
> > +	union devlink_param_value saved_value;
> > +	const struct virtbus_dev_id *id = priv->vdev->matched_element;
> 
> Like irdma_probe(), struct iidc_virtbus_object *vo is accesible for the given priv.
> Please use struct iidc_virtbus_object for any sharing between two drivers.
> matched_element modification inside the virtbus match() function and accessing
> pointer to some driver data between two driver through this matched_element is
> not appropriate.

We can possibly avoid matched_element and driver data look up here.
But fundamentally, at probe time (see irdma_gen_probe) the irdma driver needs
to know which generation type of vdev we bound to. i.e. i40e or ice ? since we support both.
And based on it, extract the driver specific virtbus device object, i.e i40e_virtbus_device
vs iidc_virtbus_object and init that device.

Accessing driver_data off the vdev matched entry in irdma_virtbus_id_table is how
we know this generation info and make the decision.

This is very similar to what platform_get_device_id does for platform drivers.
https://elixir.bootlin.com/linux/v5.6-rc2/source/drivers/clk/clk-s2mps11.c

Shiraz



