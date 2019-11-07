Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 013FCF271A
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfKGFZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:25:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:30271 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfKGFZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 00:25:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 21:25:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,276,1569308400"; 
   d="scan'208";a="233139016"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by fmsmga002.fm.intel.com with ESMTP; 06 Nov 2019 21:25:08 -0800
Date:   Thu, 7 Nov 2019 13:25:54 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH v5] vhost: introduce mdev based hardware backend
Message-ID: <20191107052554.GA27721@___>
References: <20191105115332.11026-1-tiwei.bie@intel.com>
 <20191106075733-mutt-send-email-mst@kernel.org>
 <20191106143907.GA10776@___>
 <def13888-c99f-5f59-647b-05a4bb2f8657@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <def13888-c99f-5f59-647b-05a4bb2f8657@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 12:16:01PM +0800, Jason Wang wrote:
> On 2019/11/6 下午10:39, Tiwei Bie wrote:
> > On Wed, Nov 06, 2019 at 07:59:02AM -0500, Michael S. Tsirkin wrote:
> > > On Tue, Nov 05, 2019 at 07:53:32PM +0800, Tiwei Bie wrote:
> > > > This patch introduces a mdev based hardware vhost backend.
> > > > This backend is built on top of the same abstraction used
> > > > in virtio-mdev and provides a generic vhost interface for
> > > > userspace to accelerate the virtio devices in guest.
> > > > 
> > > > This backend is implemented as a mdev device driver on top
> > > > of the same mdev device ops used in virtio-mdev but using
> > > > a different mdev class id, and it will register the device
> > > > as a VFIO device for userspace to use. Userspace can setup
> > > > the IOMMU with the existing VFIO container/group APIs and
> > > > then get the device fd with the device name. After getting
> > > > the device fd, userspace can use vhost ioctls on top of it
> > > > to setup the backend.
> > > > 
> > > > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> > > So at this point, looks like the only thing missing is IFC, and then all
> > > these patches can go in.
> > > But as IFC is still being worked on anyway, it makes sense to
> > > address the minor comments manwhile so we don't need
> > > patches on top.
> > > Right?
> > Yeah, of course.
> > 
> > Thanks,
> > Tiwei
> 
> 
> Please send V6 and I will ack there.

Got it, I will send it soon.

Thanks!
Tiwei
