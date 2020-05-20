Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F2D1DABF8
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgETHZl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 May 2020 03:25:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:58421 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETHZl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 03:25:41 -0400
IronPort-SDR: K2suYE2EmbWK+rI5oq5UvJ0Ph9ewBSt9R6dZmFeVwzTU3Z/WZ3faQa08BEQ1W4H+pBBLWkwjeC
 gDhjTIzSkT6w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 00:25:40 -0700
IronPort-SDR: T00mQAQx3SvME2QIjdd6Jg5swtumwJuKm+/d/2uDo3yO7pgVF+FdaPGNyoWh9MAKQCDtzADCNo
 bP0FSlb/0VIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,413,1583222400"; 
   d="scan'208";a="299846660"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga002.fm.intel.com with ESMTP; 20 May 2020 00:25:39 -0700
Received: from orsmsx158.amr.corp.intel.com (10.22.240.20) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 20 May 2020 00:25:39 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX158.amr.corp.intel.com ([169.254.10.218]) with mapi id 14.03.0439.000;
 Wed, 20 May 2020 00:25:39 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
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
Subject: RE: [net-next v4 00/12][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-05-19
Thread-Topic: [net-next v4 00/12][pull request] 100GbE Intel Wired LAN
 Driver Updates 2020-05-19
Thread-Index: AQHWLnSg3eQJ1oiLqUW7Z32mKfEdGaixBcaA//+LT/A=
Date:   Wed, 20 May 2020 07:25:39 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986C2E05@ORSMSX112.amr.corp.intel.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520071707.GA2365898@kroah.com>
In-Reply-To: <20200520071707.GA2365898@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, May 20, 2020 00:17
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> jgg@ziepe.ca; parav@mellanox.com; galpress@amazon.com;
> selvin.xavier@broadcom.com; sriharsha.basavapatna@broadcom.com;
> benve@cisco.com; bharat@chelsio.com; xavier.huwei@huawei.com;
> yishaih@mellanox.com; leonro@mellanox.com; mkalderon@marvell.com;
> aditr@vmware.com; ranjani.sridharan@linux.intel.com; pierre-
> louis.bossart@linux.intel.com
> Subject: Re: [net-next v4 00/12][pull request] 100GbE Intel Wired LAN Driver
> Updates 2020-05-19
> 
> On Wed, May 20, 2020 at 12:02:15AM -0700, Jeff Kirsher wrote:
> > This series contains the initial implementation of the Virtual Bus,
> > virtbus_device, virtbus_driver, updates to 'ice' and 'i40e' to use the
> > new Virtual Bus.
> >
> > The primary purpose of the Virtual bus is to put devices on it and
> > hook the devices up to drivers.  This will allow drivers, like the
> > RDMA drivers, to hook up to devices via this Virtual bus.
> >
> > The associated irdma driver designed to use this new interface, is
> > still in RFC currently and was sent in a separate series.  The latest
> > RFC series follows this series, named "Intel RDMA Driver Updates 2020-05-
> 19".
> >
> > This series currently builds against net-next tree.
> >
> > Revision history:
> > v2: Made changes based on community feedback, like Pierre-Louis's and
> >     Jason's comments to update virtual bus interface.
> > v3: Updated the virtual bus interface based on feedback from Jason and
> >     Greg KH.  Also updated the initial ice driver patch to handle the
> >     virtual bus changes and changes requested by Jason and Greg KH.
> > v4: Updated the kernel documentation based on feedback from Greg KH.
> >     Also added PM interface updates to satisfy the sound driver
> >     requirements.  Added the sound driver changes that makes use of the
> >     virtual bus.
> 
> Why didn't you change patch 2 like I asked you to?
> 
> And I still have no idea why you all are not using the virtual bus in the "ice"
> driver implementation.  Why is it even there if you don't need it?  I thought that
> was the whole reason you wrote this code, not for the sound drivers.
> 
> How can you get away with just using a virtual device but not the bus?
> What does that help out with?  What "bus" do those devices belong to?
> 
> Again, please fix up patch 2 to only add virtual device/bus support to, right now
> it is just too much of a mess with all of the other functionality you are adding in
> there to be able to determine if you are using the new api correctly.
> 
> And again, didn't I ask for this last time?
[Kirsher, Jeffrey T] 

We apologize, but last submission you only commented on the first patch and the documentation.

In v1 & v2, you and Jason made comments on the LAN driver implementation (patch 2), which we
addressed all the comments and did not hear any comments to the contrary in v3 until now.  If you
give constructive feedback, will work to fix any issues you find.
