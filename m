Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7D29102AF2
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfKSRqw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Nov 2019 12:46:52 -0500
Received: from mga14.intel.com ([192.55.52.115]:17295 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfKSRqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 12:46:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 09:46:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,218,1571727600"; 
   d="scan'208";a="357176507"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga004.jf.intel.com with ESMTP; 19 Nov 2019 09:46:50 -0800
Received: from orsmsx101.amr.corp.intel.com ([169.254.8.229]) by
 ORSMSX103.amr.corp.intel.com ([169.254.5.179]) with mapi id 14.03.0439.000;
 Tue, 19 Nov 2019 09:46:50 -0800
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Parav Pandit <parav@mellanox.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATHptCZx1o750+cmj+dZwSi7aeNZheAgAPN0JCAAT64AIAAAj2AgABVRRA=
Date:   Tue, 19 Nov 2019 17:46:50 +0000
Message-ID: <2B0E3F215D1AB84DA946C8BEE234CCC97B30165F@ORSMSX101.amr.corp.intel.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B301493@ORSMSX101.amr.corp.intel.com>
 <AM0PR05MB4866169E38D7F157F0B4DC49D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <AM0PR05MB486682813F89233048FCB3D1D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
In-Reply-To: <AM0PR05MB486682813F89233048FCB3D1D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
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
> From: Parav Pandit <parav@mellanox.com>
> Sent: Monday, November 18, 2019 8:40 PM
> To: Parav Pandit <parav@mellanox.com>; Ertman, David M
> <david.m.ertman@intel.com>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> gregkh@linuxfoundation.org
> Cc: netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; jgg@ziepe.ca; Patil, Kiran
> <kiran.patil@intel.com>
> Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
> 
> Hi David,
> 
> > Sent: Monday, November 18, 2019 10:32 PM
> > To: Ertman, David M <david.m.ertman@intel.com>; Kirsher, Jeffrey T
> > <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> > gregkh@linuxfoundation.org
> > Cc: netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> > nhorman@redhat.com; sassmann@redhat.com; jgg@ziepe.ca; Patil, Kiran
> > <kiran.patil@intel.com>
> > Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual
> > Bus
> >
> > Hi David,
> >
> > > From: Ertman, David M <david.m.ertman@intel.com>
> > > Sent: Monday, November 18, 2019 9:59 PM
> > > Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of
> > > Virtual Bus
> > >
> > > > -----Original Message-----
> > > > From: Parav Pandit <parav@mellanox.com>
> > > > Sent: Friday, November 15, 2019 3:26 PM
> > > > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>;
> > > > davem@davemloft.net; gregkh@linuxfoundation.org
> > > > Cc: Ertman, David M <david.m.ertman@intel.com>;
> > > > netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> > > > nhorman@redhat.com; sassmann@redhat.com; jgg@ziepe.ca; Patil,
> > > > Kiran <kiran.patil@intel.com>
> > > > Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of
> > > > Virtual Bus
> > > >
> > > > Hi Jeff,
> > > >
> > > > > From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > > > > Sent: Friday, November 15, 2019 4:34 PM
> > > > >
> > > > > From: Dave Ertman <david.m.ertman@intel.com>
> > > > >
> > > > > This is the initial implementation of the Virtual Bus,
> > > > > virtbus_device and virtbus_driver.  The virtual bus is a
> > > > > software based bus intended to support lightweight devices and
> > > > > drivers and provide matching between them and probing of the
> registered drivers.
> > > > >
> > > > > The primary purpose of the virual bus is to provide matching
> > > > > services and to pass the data pointer contained in the
> > > > > virtbus_device to the virtbus_driver during its probe call.
> > > > > This will allow two separate kernel objects to match up and
> > > > > start
> > > communication.
> > > > >
> > > > It is fundamental to know that rdma device created by
> > > > virtbus_driver will be anchored to which bus for an non abusive use.
> > > > virtbus or parent pci bus?
> > > > I asked this question in v1 version of this patch.
> > >
> > > The model we will be using is a PCI LAN driver that will allocate
> > > and register a virtbus_device.  The virtbus_device will be anchored
> > > to the virtual bus, not the PCI bus.
> > o.k.
> >
> > >
> > > The virtbus does not have a requirement that elements registering
> > > with it have any association with another outside bus or device.
> > >
> > This is what I want to capture in cover letter and documentation.
> >
> > > RDMA is not attached to any bus when it's init is called.  The
> > > virtbus_driver that it will create will be attached to the virtual bus.
> > >
> > > The RDMA driver will register a virtbus_driver object.  Its probe
> > > will accept the data pointer from the virtbus_device that the PCI
> > > LAN driver
> > created.
> > >
> > What I am saying that RDMA device created by the irdma driver or
> > mlx5_ib driver should be anchored to the PCI device and not the virtbus
> device.
> >
> > struct ib_device.dev.parent = &pci_dev->dev;
> >
> > if this is not done, and if it is,
> >
> > struct ib_device.dev.parent = &virtbus_dev->dev;
> >
> > Than we are inviting huge burden as below.
> > (a) user compatibility with several tools, orchestration etc is
> > broken, because rdma cannot be reached back to its PCI device as before.
> > This is some internal kernel change for 'better code handling', which
> > is surfacing to rdma device name changing - systemd/udev broken, until
> > all distros upgrade and implement this virtbus naming scheme.
> > Even with that orchestration tools shipped outside of distro are broken.
> >
> > (b) virtbus must extend iommu support in intel, arm, amd, ppc systems
> > otherwise straight away rdma is broken in those environments with this
> > 'internal code restructure'.
> > These iommu doesn't support non PCI buses.
> >
> > (c) anchoring on virtbus brings challenge to get unique id for
> > persistent naming when irdma/mlx5_ib device is not created by 'user'.
> >
> > This improvement by bus matching service != 'ethX to ens2f0
> > improvement of netdevs happened few years back'.
> > Hence, my input is,
> >
> > irdma_virtubus_probe() {
> > 	struct ib_device.dev.parent = &pci_dev->dev;
> > 	ib_register_driver();
> > }
> >
> With this, I forgot to mention that, virtbus doesn't need PM callbacks,
> because PM core layer works on suspend/resume devices in reverse order
> of their creation.
> Given that protocol devices (like rdma and netdev) devices shouldn't be
> anchored on virtbus, it doesn't need PM callbacks.
> Please remove them.
> 
> suspend() will be called first on rdma device (because it was created last).

This is only true in the rdma/PLCI LAN situation.  virtbus can be used on two
kernel objects that have no connection to another bus or device, but only use
the virtbus for connecting up.  In that case, those entities will need the PM
callbacks.

-Dave E
