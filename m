Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C1CBF8DA
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfIZSKn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Sep 2019 14:10:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:4436 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbfIZSKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 14:10:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 11:10:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="214564343"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga004.fm.intel.com with ESMTP; 26 Sep 2019 11:10:40 -0700
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Sep 2019 11:10:40 -0700
Received: from fmsmsx123.amr.corp.intel.com ([169.254.7.221]) by
 fmsmsx115.amr.corp.intel.com ([169.254.4.243]) with mapi id 14.03.0439.000;
 Thu, 26 Sep 2019 11:10:40 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Thread-Topic: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Thread-Index: AQHVdInWRrhtw3GiCUGgUX5/wYICeKc+opcAgAASvICAAACcAP//ivXw
Date:   Thu, 26 Sep 2019 18:10:40 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7AC702AF5@fmsmsx123.amr.corp.intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
 <20190926165506.GF19509@mellanox.com> <20190926180215.GA1733924@kroah.com>
 <20190926180416.GI19509@mellanox.com>
In-Reply-To: <20190926180416.GI19509@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzQ3ZmE3NGItZWFkMC00MTgwLWI0YjgtYjNlMzQzOGNhNWExIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZ1FRUzNBQ3IySzVWWDNOY2tzZTVtanozMkZhcHl2RkJyeXgrc0JOSHpHZDRUWnhcL3dCNVd0emhiUnFDYWk5UzQifQ==
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC 04/20] RDMA/irdma: Add driver framework definitions
> 
> On Thu, Sep 26, 2019 at 08:02:15PM +0200, gregkh@linuxfoundation.org wrote:
> > On Thu, Sep 26, 2019 at 04:55:12PM +0000, Jason Gunthorpe wrote:
> > > On Thu, Sep 26, 2019 at 09:45:03AM -0700, Jeff Kirsher wrote:
> > > > +int i40iw_probe(struct platform_device *pdev) {
> > > > +	struct i40e_peer_dev_platform_data *pdata =
> > > > +		dev_get_platdata(&pdev->dev);
> > > > +	struct i40e_info *ldev;
> > >
> > > I thought Greg already said not to use platform_device for this?
> >
> > Yes I did, which is what I thought this whole "use MFD" was supposed
> > to solve.  Why is a platform device still being used here?
> 
> Looks like when mfd creates the 'multi' devices it creates them as
> platform_devices
> 
> /*
>  * Given a platform device that's been created by mfd_add_devices(), fetch
>  * the mfd_cell that created it.
>  */
> static inline const struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
> 
> Jason

That's right. We used the MFD framework. mfd_add_devices() registers the child devices
as platform devs. And the function drivers probe() will get a platform dev.

Shiraz
