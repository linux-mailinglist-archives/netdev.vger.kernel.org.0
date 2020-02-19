Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9A4163A9C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgBSDAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:00:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:6619 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728196AbgBSDAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:00:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 19:00:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="348830245"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by fmsmga001.fm.intel.com with ESMTP; 18 Feb 2020 18:59:58 -0800
Date:   Wed, 19 Feb 2020 10:59:48 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
Message-ID: <20200219025948.GA972742@___>
References: <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <8b3e6a9c-8bfd-fb3c-12a8-2d6a3879f1ae@redhat.com>
 <20200214135232.GB4271@mellanox.com>
 <01c86ebb-cf4b-691f-e682-2d6f93ddbcf7@redhat.com>
 <20200218135608.GS4271@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200218135608.GS4271@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 01:56:12PM +0000, Jason Gunthorpe wrote:
> On Mon, Feb 17, 2020 at 02:08:03PM +0800, Jason Wang wrote:
> 
> > I thought you were copied in the patch [1], maybe we can move vhost related
> > discussion there to avoid confusion.
> >
> > [1] https://lwn.net/Articles/811210/
> 
> Wow, that is .. confusing.
> 
> So this is supposed to duplicate the uAPI of vhost-user? But it is
> open coded and duplicated because .. vdpa?

Do you mean the vhost-user in DPDK? There is no vhost-user
in Linux kernel.

Thanks,
Tiwei

> 
> > So it's cheaper and simpler to introduce a new bus instead of refactoring a
> > well known bus and API where brunches of drivers and devices had been
> > implemented for years.
> 
> If you reason for this approach is to ease the implementation then you
> should talk about it in the cover letters/etc
> 
> Maybe it is reasonable to do this because the rework is too great, I
> don't know, but to me this whole thing looks rather messy. 
> 
> Remember this stuff is all uAPI as it shows up in sysfs, so you can
> easilly get stuck with it forever.
> 
> Jason
