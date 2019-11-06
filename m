Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5B0F18D4
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731976AbfKFOiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:38:24 -0500
Received: from mga17.intel.com ([192.55.52.151]:50000 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731929AbfKFOiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 09:38:24 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 06:38:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="214264460"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by orsmga002.jf.intel.com with ESMTP; 06 Nov 2019 06:38:21 -0800
Date:   Wed, 6 Nov 2019 22:39:07 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH v5] vhost: introduce mdev based hardware backend
Message-ID: <20191106143907.GA10776@___>
References: <20191105115332.11026-1-tiwei.bie@intel.com>
 <20191106075733-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191106075733-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 06, 2019 at 07:59:02AM -0500, Michael S. Tsirkin wrote:
> On Tue, Nov 05, 2019 at 07:53:32PM +0800, Tiwei Bie wrote:
> > This patch introduces a mdev based hardware vhost backend.
> > This backend is built on top of the same abstraction used
> > in virtio-mdev and provides a generic vhost interface for
> > userspace to accelerate the virtio devices in guest.
> > 
> > This backend is implemented as a mdev device driver on top
> > of the same mdev device ops used in virtio-mdev but using
> > a different mdev class id, and it will register the device
> > as a VFIO device for userspace to use. Userspace can setup
> > the IOMMU with the existing VFIO container/group APIs and
> > then get the device fd with the device name. After getting
> > the device fd, userspace can use vhost ioctls on top of it
> > to setup the backend.
> > 
> > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> 
> So at this point, looks like the only thing missing is IFC, and then all
> these patches can go in.
> But as IFC is still being worked on anyway, it makes sense to
> address the minor comments manwhile so we don't need
> patches on top.
> Right?

Yeah, of course.

Thanks,
Tiwei
