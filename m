Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FAB1B2202
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgDUIuv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 04:50:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:48035 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbgDUIuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 04:50:50 -0400
IronPort-SDR: 1IndZf5pvixI6bNzfC9sxDhE1NpRGNunLAKrRHKr2htxwy/VodzJ5/vLNb9CQTbp4abrBUnyfw
 bk+ir/YURIyg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 01:50:49 -0700
IronPort-SDR: PoyKafOxnUV8/s9/IkDdt6mA16RtaknBtRd8gg9lDGGJ6ZCtNIcbtfiKZPOGjVj9wba9lfuhiE
 agWejxvQ9IRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,409,1580803200"; 
   d="scan'208";a="365284342"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga001.fm.intel.com with ESMTP; 21 Apr 2020 01:50:49 -0700
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 01:50:49 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.248]) by
 ORSMSX157.amr.corp.intel.com ([169.254.9.116]) with mapi id 14.03.0439.000;
 Tue, 21 Apr 2020 01:50:48 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Ertman, David M" <david.m.ertman@intel.com>,
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
        <pierre-louis.bossart@linux.intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next v2 1/9] Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/9] Implementation of Virtual Bus
Thread-Index: AQHWF7M+699LxoK9Tk+TPsV+SPc7DqiDtjaA//+NveA=
Date:   Tue, 21 Apr 2020 08:50:47 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D940449866D956@ORSMSX112.amr.corp.intel.com>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
 <20200421080235.6515-2-jeffrey.t.kirsher@intel.com>
 <20200421083747.GC716720@kroah.com>
In-Reply-To: <20200421083747.GC716720@kroah.com>
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
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Tuesday, April 21, 2020 01:38
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Ertman, David M <david.m.ertman@intel.com>;
> netdev@vger.kernel.org; linux-rdma@vger.kernel.org; nhorman@redhat.com;
> sassmann@redhat.com; jgg@ziepe.ca; parav@mellanox.com;
> galpress@amazon.com; selvin.xavier@broadcom.com;
> sriharsha.basavapatna@broadcom.com; benve@cisco.com;
> bharat@chelsio.com; xavier.huwei@huawei.com; yishaih@mellanox.com;
> leonro@mellanox.com; mkalderon@marvell.com; aditr@vmware.com;
> ranjani.sridharan@linux.intel.com; pierre-louis.bossart@linux.intel.com; Patil,
> Kiran <kiran.patil@intel.com>; Bowers, AndrewX
> <andrewx.bowers@intel.com>
> Subject: Re: [net-next v2 1/9] Implementation of Virtual Bus
> 
> On Tue, Apr 21, 2020 at 01:02:27AM -0700, Jeff Kirsher wrote:
> > --- /dev/null
> > +++ b/Documentation/driver-api/virtual_bus.rst
> > @@ -0,0 +1,62 @@
> > +===============================
> > +Virtual Bus Devices and Drivers
> > +===============================
> > +
> > +See <linux/virtual_bus.h> for the models for virtbus_device and
> virtbus_driver.
> > +This bus is meant to be a lightweight software based bus to attach
> > +generic devices and drivers to so that a chunk of data can be passed
> between them.
> > +
> > +One use case example is an RDMA driver needing to connect with
> > +several different types of PCI LAN devices to be able to request
> > +resources from them (queue sets).  Each LAN driver that supports RDMA
> > +will register a virtbus_device on the virtual bus for each physical
> > +function.  The RDMA driver will register as a virtbus_driver on the
> > +virtual bus to be matched up with multiple virtbus_devices and
> > +receive a pointer to a struct containing the callbacks that the PCI
> > +LAN drivers support for registering with them.
> > +
> > +Sections in this document:
> > +        Virtbus devices
> > +        Virtbus drivers
> > +        Device Enumeration
> > +        Device naming and driver binding
> > +        Virtual Bus API entry points
> > +
> > +Virtbus devices
> > +~~~~~~~~~~~~~~~
> > +Virtbus_devices support the minimal device functionality.  Devices
> > +will accept a name, and then, when added to the virtual bus, an
> > +automatically generated index is concatenated onto it for the
> virtbus_device->name.
> > +
> > +Virtbus drivers
> > +~~~~~~~~~~~~~~~
> > +Virtbus drivers register with the virtual bus to be matched with
> > +virtbus devices.  They expect to be registered with a probe and
> > +remove callback, and also support shutdown, suspend, and resume
> > +callbacks.  They otherwise follow the standard driver behavior of
> > +having discovery and enumeration handled in the bus infrastructure.
> > +
> > +Virtbus drivers register themselves with the API entry point
> > +virtbus_register_driver and unregister with virtbus_unregister_driver.
> > +
> > +Device Enumeration
> > +~~~~~~~~~~~~~~~~~~
> > +Enumeration is handled automatically by the bus infrastructure via
> > +the ida_simple methods.
> > +
> > +Device naming and driver binding
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +The virtbus_device.dev.name is the canonical name for the device. It
> > +is built from two other parts:
> > +
> > +        - virtbus_device.name (also used for matching).
> > +        - virtbus_device.id (generated automatically from ida_simple
> > + calls)
> > +
> > +Virtbus device IDs are always in "<name>.<instance>" format.
> > +Instances are automatically selected through an ida_simple_get so are
> positive integers.
> > +Name is taken from the device name field.
> > +
> > +Driver IDs are simple <name>.
> > +
> > +Need to extract the name from the Virtual Device compare to name of
> > +the driver.
> 
> Why is this document even needed?
> 
> I understand the goal of documenting how to use this and such, but the above
> document does none of that.  The last sentance here doesn't even make sense
> to me.
> 
> How about tieing it into the kerneldoc functions that you have created in the .c
> file, to create something that actually is useful?  As it is, the above text doesn't
> describe anything to me that I could actually use, did it help someone who
> wants to use this api that you know of?
[Kirsher, Jeffrey T] 

Thank you for the feedback, I will work with David to fix the documentation so
that it is useful to you.
 
> Bad documentation is worse than no documentation for things like this...
> 
> greg k-h
