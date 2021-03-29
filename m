Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDA534D142
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 15:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhC2NgZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Mar 2021 09:36:25 -0400
Received: from mga05.intel.com ([192.55.52.43]:55821 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231558AbhC2NgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 09:36:18 -0400
IronPort-SDR: U7NFNTYUMJatsWSY6PJtw0PdUGuEpwAkIjkBC8pEI3cz9+AslsJ3trDOSX8vlyc3DGnYHKngsd
 sL3WdhJdhqrA==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="276713182"
X-IronPort-AV: E=Sophos;i="5.81,287,1610438400"; 
   d="scan'208";a="276713182"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 06:36:15 -0700
IronPort-SDR: rC12aNwIyfOAA4YSLEk9Ox/k991pvN5ER73tkAyGSA+8Rd6p6472JhkMA8mZkX4dNh1KYs839r
 u7LuxSEcsa8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,287,1610438400"; 
   d="scan'208";a="417672924"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 29 Mar 2021 06:36:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 29 Mar 2021 06:36:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 29 Mar 2021 06:36:08 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Mon, 29 Mar 2021 06:36:08 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>, Mark Bloch <mbloch@nvidia.com>,
        "Adit Ranadive" <aditr@vmware.com>,
        Ariel Elior <aelior@marvell.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christian Benvenuti <benve@cisco.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        "Latif, Faisal" <faisal.latif@intel.com>,
        "Gal Pressman" <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Ou <oulijun@huawei.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Mike Marciniszyn" <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Nelson Escobar <neescoba@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "VMware PV-Drivers" <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "Zhu Yanjun" <zyjzyj2000@gmail.com>
Subject: RE: [PATCH rdma-next] RDMA: Support more than 255 rdma ports
Thread-Topic: [PATCH rdma-next] RDMA: Support more than 255 rdma ports
Thread-Index: AQHXDmkmOzm7EEaf5Eai9jcp+2A9uqqW3dkAgAAsl1A=
Date:   Mon, 29 Mar 2021 13:36:08 +0000
Message-ID: <24e5759118f746c18539fc5fc0b4c706@intel.com>
References: <20210301070420.439400-1-leon@kernel.org>
 <20210326131934.GA832996@nvidia.com>
In-Reply-To: <20210326131934.GA832996@nvidia.com>
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

> Subject: Re: [PATCH rdma-next] RDMA: Support more than 255 rdma ports
> 
> On Mon, Mar 01, 2021 at 09:04:20AM +0200, Leon Romanovsky wrote:
> > From: Mark Bloch <mbloch@nvidia.com>
> >
> > Current code uses many different types when dealing with a port of a
> > RDMA device: u8, unsigned int and u32. Switch to u32 to clean up the
> > logic.
> >
> > This allows us to make (at least) the core view consistent and use the
> > same type. Unfortunately not all places can be converted. Many uverbs
> > functions expect port to be u8 so keep those places in order not to break
> UAPIs.
> > HW/Spec defined values must also not be changed.
> >
> > With the switch to u32 we now can support devices with more than 255
> > ports. U32_MAX is reserved to make control logic a bit easier to deal
> > with. As a device with U32_MAX ports probably isn't going to happen
> > any time soon this seems like a non issue.
> >
> > When a device with more than 255 ports is created uverbs will report
> > the RDMA device as having 255 ports as this is the max currently supported.
> >
> > The verbs interface is not changed yet because the IBTA spec limits
> > the port size in too many places to be u8 and all applications that
> > relies in verbs won't be able to cope with this change. At this stage,
> > we are extending the interfaces that are using vendor channel solely
> >
> > Once the limitation is lifted mlx5 in switchdev mode will be able to
> > have thousands of SFs created by the device. As the only instance of
> > an RDMA device that reports more than 255 ports will be a representor
> > device and it exposes itself as a RAW Ethernet only device
> > CM/MAD/IPoIB and other ULPs aren't effected by this change and their
> > sysfs/interfaces that are exposes to userspace can remain unchanged.
> >
> > While here cleanup some alignment issues and remove unneeded sanity
> > checks (mainly in rdmavt),
> >
> > Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> 
> Applied to for-next, I suppose this means the irdma driver needs re-spinning
> already.
> 

Sure.
