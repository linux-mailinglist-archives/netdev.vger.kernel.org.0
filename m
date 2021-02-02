Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9903830B43B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 01:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhBBAlO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Feb 2021 19:41:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:39095 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhBBAlM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 19:41:12 -0500
IronPort-SDR: dir/nj/ziTEwW3GGs0aszbdyqaSQvA7geeqYcJk7x8r+RxytLXJrX9l8EG2dsp4qeNO4kXrFmZ
 Rwtgrwch56/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="177266964"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="177266964"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 16:40:30 -0800
IronPort-SDR: 0COdYcDysD1QylPd9RlOA30cCzpcZe6xgGNTwUyHtZii8rdX0J/5JH7gHO/Aw02VdUvo3M4Zki
 CPcmbSS9PaOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="412766336"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 01 Feb 2021 16:40:30 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 1 Feb 2021 16:40:29 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.002;
 Mon, 1 Feb 2021 16:40:29 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao5N6oA//+n/DCAAMFCAIAAeSAAgAHXAYD//6CioIABFy+AgABrh4CAAjZjEIAE9xSA///EJCA=
Date:   Tue, 2 Feb 2021 00:40:28 +0000
Message-ID: <925c33a0b174464898c9fc5651b981ee@intel.com>
References: <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
 <99895f7c10a2473c84a105f46c7ef498@intel.com>
 <20210126005928.GF4147@nvidia.com>
 <031c2675aff248bd9c78fada059b5c02@intel.com>
 <20210127121847.GK1053290@unreal>
 <ea62658f01664a6ea9438631c9ddcb6e@intel.com>
 <20210127231641.GS4147@nvidia.com> <20210128054133.GA1877006@unreal>
 <d58f341898834170af1bfb6719e17956@intel.com>
 <20210201191805.GO4247@nvidia.com>
In-Reply-To: <20210201191805.GO4247@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> implement private channel OPs
> 
> On Sat, Jan 30, 2021 at 01:19:36AM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver
> > > and implement private channel OPs
> > >
> > > On Wed, Jan 27, 2021 at 07:16:41PM -0400, Jason Gunthorpe wrote:
> > > > On Wed, Jan 27, 2021 at 10:17:56PM +0000, Saleem, Shiraz wrote:
> > > >
> > > > > Even with another core PCI driver, there still needs to be
> > > > > private communication channel between the aux rdma driver and
> > > > > this PCI driver to pass things like QoS updates.
> > > >
> > > > Data pushed from the core driver to its aux drivers should either
> > > > be done through new callbacks in a struct device_driver or by
> > > > having a notifier chain scheme from the core driver.
> > >
> > > Right, and internal to driver/core device_lock will protect from
> > > parallel probe/remove and PCI flows.
> > >
> >
> > OK. We will hold the device_lock while issuing the .ops callbacks from core
> driver.
> > This should solve our synchronization issue.
> >
> > There have been a few discussions in this thread. And I would like to
> > be clear on what to do.
> >
> > So we will,
> >
> > 1. Remove .open/.close, .peer_register/.peer_unregister 2. Protect ops
> > callbacks issued from core driver to the aux driver with device_lock
> 
> A notifier chain is probably better, honestly.
> 
> Especially since you don't want to split the netdev side, a notifier chain can be
> used by both cases equally.
> 

The device_lock seems to be a simple solution to this synchronization problem.
May I ask what makes the notifier scheme better to solve this?

Also, are you suggesting we rid all the iidc_peer_op callbacks used for 'ice' to 'irdma' driver
communication and replace with events generated by ice driver which will be received
by subscriber irdma? Or just some specific events to solve this synchronization problem?
Sorry I am confused.

Shiraz
