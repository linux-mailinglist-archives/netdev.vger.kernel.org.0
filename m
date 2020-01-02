Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF17D12E863
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgABQBD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Jan 2020 11:01:03 -0500
Received: from mga07.intel.com ([134.134.136.100]:42502 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbgABQBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 11:01:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 08:01:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,387,1571727600"; 
   d="scan'208";a="270347078"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Jan 2020 08:01:01 -0800
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 2 Jan 2020 08:01:01 -0800
Received: from fmsmsx123.amr.corp.intel.com ([169.254.7.87]) by
 FMSMSX109.amr.corp.intel.com ([169.254.15.48]) with mapi id 14.03.0439.000;
 Thu, 2 Jan 2020 08:01:00 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     'Jason Gunthorpe' <jgg@ziepe.ca>
CC:     'Greg KH' <gregkh@linuxfoundation.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Thread-Topic: [PATCH v3 04/20] i40e: Register a virtbus device to provide
 RDMA
Thread-Index: AQHVruLyruZaK+NBaUahwsdRBRLbTKe0CH+AgAR/tTCAAVOvgIAE7IIggAIQfgD//4cxcA==
Date:   Thu, 2 Jan 2020 16:01:00 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7C1DEF295@fmsmsx123.amr.corp.intel.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
 <20191210153959.GD4053085@kroah.com>
 <9DD61F30A802C4429A01CA4200E302A7B6B9345E@fmsmsx124.amr.corp.intel.com>
 <20191214083753.GB3318534@kroah.com>
 <9DD61F30A802C4429A01CA4200E302A7B6B9AFF7@fmsmsx124.amr.corp.intel.com>
 <20191218192058.GH17227@ziepe.ca>
In-Reply-To: <20191218192058.GH17227@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTBlMzI1YjgtZWQ1OS00NmU3LWJhOTEtNjE0MmQzNjIwOGY2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWDJPOTkySU44NlBIYXd2OEFPbW4zZDRqMDJWTW9nYVdqWkc2TlVMcGw0dFE0YU5ZM3VhZTNTVmhwTzRCSTd4VSJ9
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

> Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
> 
> On Wed, Dec 18, 2019 at 06:57:10PM +0000, Saleem, Shiraz wrote:
> > diff --git a/include/linux/net/intel/i40e_client.h
> > b/include/linux/net/intel/i40e_client.h
> > index 7e147d3..5c81261 100644
> > +++ b/include/linux/net/intel/i40e_client.h
> > @@ -83,11 +83,11 @@ struct i40e_params {
> >
> >  /* Structure to hold Lan device info for a client device */  struct
> > i40e_info {
> >  	struct i40e_client_version version;
> 
> I hope this isn't the inter-module versioning stuff we already Nak'd?

This is not used in irdma for checking any versioning.

This and the version in struct i40e_client are not cleaned up because they are used
between i40e <--> i40iw. And the thought was once i40iw is removed, we can send
a follow on patch to remove this versioning + the global
exported functions i40e_register_client() and i40e_unregister_client() used by i40iw. 

For the ice driver, we have already removed all versioning.

> 
> >  	u8 lanmac[6];
> 
> Is this different from the mac reachable from the netdev?

Hmmm... I think not. This should be possible to get from netdev. We can send a cleanup follow on patch.


> > +struct i40e_virtbus_device {
> > +	struct virtbus_device vdev;
> > +	struct i40e_info *ldev;
> 
> Is the lifetime actually any better? Will ldev be freed and left danling before
> virtbus_device is released?
> 
The consumer of the ldev (i.e the rdma driver) will have a
valid ldev when drv->remove() is called as part of the virtbus
device unregister.
It is probably good to set this ldev pointer inside the i40e_virtbus_device
object to NULL in the netdev driver soon after virtbus device unregister.

