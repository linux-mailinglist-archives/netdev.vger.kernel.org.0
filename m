Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD371524AC
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 03:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgBECGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 21:06:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:32641 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbgBECGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 21:06:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 18:06:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,404,1574150400"; 
   d="scan'208";a="249555008"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by orsmga002.jf.intel.com with ESMTP; 04 Feb 2020 18:06:03 -0800
Date:   Wed, 5 Feb 2020 10:05:55 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        shahafs@mellanox.com, jgg@mellanox.com, rob.miller@broadcom.com,
        haotian.wang@sifive.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, rdunlap@infradead.org, hch@infradead.org,
        jiri@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200205020555.GA369236@___>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200204005306-mutt-send-email-mst@kernel.org>
 <cf485e7f-46e3-20d3-8452-e3058b885d0a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf485e7f-46e3-20d3-8452-e3058b885d0a@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 04, 2020 at 02:46:16PM +0800, Jason Wang wrote:
> On 2020/2/4 下午2:01, Michael S. Tsirkin wrote:
> > On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
> > > 5) generate diffs of memory table and using IOMMU API to setup the dma
> > > mapping in this method
> > Frankly I think that's a bunch of work. Why not a MAP/UNMAP interface?
> > 
> 
> Sure, so that basically VHOST_IOTLB_UPDATE/INVALIDATE I think?

Do you mean we let userspace to only use VHOST_IOTLB_UPDATE/INVALIDATE
to do the DMA mapping in vhost-vdpa case? When vIOMMU isn't available,
userspace will set msg->iova to GPA, otherwise userspace will set
msg->iova to GIOVA, and vhost-vdpa module will get HPA from msg->uaddr?

Thanks,
Tiwei

> 
> Thanks
> 
> 
