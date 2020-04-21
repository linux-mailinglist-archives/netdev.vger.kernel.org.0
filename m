Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B4D1B21CC
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgDUIiD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 04:38:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:43448 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgDUIiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 04:38:01 -0400
IronPort-SDR: qRlxKjQD0Tng2ISZ2tPRHeQIIiBXUE59yjeG9jRl45QmnlnbHFDVyNX7lwRl8lVHGd9U3ksYEE
 z0N6IqMJ0/Fw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 01:38:01 -0700
IronPort-SDR: 8IW+2PE/fR+gwgM4knYj4Zc1jYAtrinha2oujA0dDKHRB3T1dtUQudt4Z8EfJZkr219po/MAzt
 +aIqesChNmOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,409,1580803200"; 
   d="scan'208";a="456024496"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga005.fm.intel.com with ESMTP; 21 Apr 2020 01:38:00 -0700
Received: from orsmsx155.amr.corp.intel.com (10.22.240.21) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 01:38:00 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.248]) by
 ORSMSX155.amr.corp.intel.com ([169.254.7.34]) with mapi id 14.03.0439.000;
 Tue, 21 Apr 2020 01:37:59 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>
Subject: RE: [net-next v2 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-04-20
Thread-Topic: [net-next v2 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-04-20
Thread-Index: AQHWF7M+ytg6HKzOoEituinftxWI0KiDOHUAgAB7mQD//4wT0A==
Date:   Tue, 21 Apr 2020 08:37:59 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D940449866D8D2@ORSMSX112.amr.corp.intel.com>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
 <61CC2BC414934749BD9F5BF3D5D940449866D71D@ORSMSX112.amr.corp.intel.com>
 <20200421083004.GB716720@kroah.com>
In-Reply-To: <20200421083004.GB716720@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Tuesday, April 21, 2020 01:30
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> jgg@ziepe.ca; parav@mellanox.com; galpress@amazon.com;
> selvin.xavier@broadcom.com; sriharsha.basavapatna@broadcom.com;
> benve@cisco.com; bharat@chelsio.com; xavier.huwei@huawei.com;
> yishaih@mellanox.com; leonro@mellanox.com; mkalderon@marvell.com;
> aditr@vmware.com; ranjani.sridharan@linux.intel.com; pierre-
> louis.bossart@linux.intel.com
> Subject: Re: [net-next v2 0/9][pull request] 100GbE Intel Wired LAN Driver
> Updates 2020-04-20
> 
> On Tue, Apr 21, 2020 at 08:15:59AM +0000, Kirsher, Jeffrey T wrote:
> > > -----Original Message-----
> > > From: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> > > Sent: Tuesday, April 21, 2020 01:02
> > > To: davem@davemloft.net; gregkh@linuxfoundation.org
> > > Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>;
> > > netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> > > nhorman@redhat.com; sassmann@redhat.com; jgg@ziepe.ca;
> > > parav@mellanox.com; galpress@amazon.com;
> selvin.xavier@broadcom.com;
> > > sriharsha.basavapatna@broadcom.com;
> > > benve@cisco.com; bharat@chelsio.com; xavier.huwei@huawei.com;
> > > yishaih@mellanox.com; leonro@mellanox.com; mkalderon@marvell.com;
> > > aditr@vmware.com; ranjani.sridharan@linux.intel.com; pierre-
> > > louis.bossart@linux.intel.com
> > > Subject: [net-next v2 0/9][pull request] 100GbE Intel Wired LAN
> > > Driver Updates
> > > 2020-04-20
> > >
> > > This series contains the initial implementation of the Virtual Bus,
> > > virtbus_device, virtbus_driver, updates to 'ice' and 'i40e' to use the new
> Virtual Bus.
> > >
> > > The primary purpose of the Virtual bus is to put devices on it and
> > > hook the devices up to drivers.  This will allow drivers, like the
> > > RDMA drivers, to hook up to devices via this Virtual bus.
> > >
> > > This series currently builds against net-next tree.
> > >
> > > Revision history:
> > > v2: Made changes based on community feedback, like Pierre-Louis's and
> > >     Jason's comments to update virtual bus interface.
> > [Kirsher, Jeffrey T]
> >
> > David Miller, I know we have heard from Greg KH and Jason Gunthorpe on
> > the patch series and have responded accordingly, I would like your
> > personal opinion on the patch series.  I respect your opinion and
> > would like to make sure we appease all the maintainers and users involved to
> get this accepted into the 5.8 kernel.
> 
> Wait, you haven't gotten my ack on that code, why are you asking for it to be
> merged already???
> 
[Kirsher, Jeffrey T] 

I was just asking for Dave's review, I was not asking that get merged without your or anyone's ACK.

> {sigh}
> 
> greg k-h
