Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67FDBD9C1
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 10:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442725AbfIYIYp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Sep 2019 04:24:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:32480 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405820AbfIYIYp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 04:24:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 01:24:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="364256679"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga005.jf.intel.com with ESMTP; 25 Sep 2019 01:24:42 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 01:24:42 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 25 Sep 2019 01:24:41 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 25 Sep 2019 01:24:41 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.32]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.92]) with mapi id 14.03.0439.000;
 Wed, 25 Sep 2019 16:24:38 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "sebott@linux.ibm.com" <sebott@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "idos@mellanox.com" <idos@mellanox.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "christophe.de.dinechin@gmail.com" <christophe.de.dinechin@gmail.com>
Subject: RE: [PATCH V2 0/8] mdev based hardware virtio offloading support
Thread-Topic: [PATCH V2 0/8] mdev based hardware virtio offloading support
Thread-Index: AQHVct+eQdtHh3CM1kSintZ5w217Z6c8D0tg
Date:   Wed, 25 Sep 2019 08:24:38 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F68D@SHSMSX104.ccr.corp.intel.com>
References: <20190924135332.14160-1-jasowang@redhat.com>
In-Reply-To: <20190924135332.14160-1-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzNlNTRhOTItZmM2My00ZDE0LWI1MjgtY2VmOWFlNDZkMWJhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaERhd1cxSkkrS1Y5NEZRdThqNm9jSFJJNHZmRU1SUStsRnp4WnpwMkYzVU5RNGducjNJTThkRHhlUkpXMng4bCJ9
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Tuesday, September 24, 2019 9:53 PM
> 
> Hi all:
> 
> There are hardware that can do virtio datapath offloading while having
> its own control path. This path tries to implement a mdev based
> unified API to support using kernel virtio driver to drive those
> devices. This is done by introducing a new mdev transport for virtio
> (virtio_mdev) and register itself as a new kind of mdev driver. Then
> it provides a unified way for kernel virtio driver to talk with mdev
> device implementation.
> 
> Though the series only contains kernel driver support, the goal is to
> make the transport generic enough to support userspace drivers. This
> means vhost-mdev[1] could be built on top as well by resuing the
> transport.
> 
> A sample driver is also implemented which simulate a virito-net
> loopback ethernet device on top of vringh + workqueue. This could be
> used as a reference implementation for real hardware driver.
> 
> Consider mdev framework only support VFIO device and driver right now,
> this series also extend it to support other types. This is done
> through introducing class id to the device and pairing it with
> id_talbe claimed by the driver. On top, this seris also decouple

id_table claimed ... this series ...

> device specific parents ops out of the common ones.
> 
> Pktgen test was done with virito-net + mvnet loop back device.
> 
> Please review.
> 
> [1] https://lkml.org/lkml/2019/9/16/869
> 
> Changes from V1:
> 
> - move virtio_mdev.c to drivers/virtio
> - store class_id in mdev_device instead of mdev_parent
> - store device_ops in mdev_device instead of mdev_parent
> - reorder the patch, vringh fix comes first
> - really silent compiling warnings
> - really switch to use u16 for class_id
> - uevent and modpost support for mdev class_id
> - vraious tweaks per comments from Parav
> 
> Changes from RFC-V2:
> 
> - silent compile warnings on some specific configuration
> - use u16 instead u8 for class id
> - reseve MDEV_ID_VHOST for future vhost-mdev work
> - introduce "virtio" type for mvnet and make "vhost" type for future
>   work
> - add entries in MAINTAINER
> - tweak and typos fixes in commit log
> 
> Changes from RFC-V1:
> 
> - rename device id to class id
> - add docs for class id and device specific ops (device_ops)
> - split device_ops into seperate headers
> - drop the mdev_set_dma_ops()
> - use device_ops to implement the transport API, then it's not a part
>   of UAPI any more
> - use GFP_ATOMIC in mvnet sample device and other tweaks
> - set_vring_base/get_vring_base support for mvnet device
> 
> Jason Wang (8):
>   vringh: fix copy direction of vringh_iov_push_kern()
>   mdev: class id support
>   mdev: bus uevent support
>   modpost: add support for mdev class id
>   mdev: introduce device specific ops
>   mdev: introduce virtio device and its device ops
>   virtio: introduce a mdev based transport
>   docs: sample driver to demonstrate how to implement virtio-mdev
>     framework
> 
>  .../driver-api/vfio-mediated-device.rst       |   7 +-
>  MAINTAINERS                                   |   2 +
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  18 +-
>  drivers/s390/cio/vfio_ccw_ops.c               |  18 +-
>  drivers/s390/crypto/vfio_ap_ops.c             |  14 +-
>  drivers/vfio/mdev/mdev_core.c                 |  19 +
>  drivers/vfio/mdev/mdev_driver.c               |  22 +
>  drivers/vfio/mdev/mdev_private.h              |   2 +
>  drivers/vfio/mdev/vfio_mdev.c                 |  45 +-
>  drivers/vhost/vringh.c                        |   8 +-
>  drivers/virtio/Kconfig                        |   7 +
>  drivers/virtio/Makefile                       |   1 +
>  drivers/virtio/virtio_mdev.c                  | 417 +++++++++++
>  include/linux/mdev.h                          |  52 +-
>  include/linux/mod_devicetable.h               |   8 +
>  include/linux/vfio_mdev.h                     |  52 ++
>  include/linux/virtio_mdev.h                   | 145 ++++
>  samples/Kconfig                               |   7 +
>  samples/vfio-mdev/Makefile                    |   1 +
>  samples/vfio-mdev/mbochs.c                    |  20 +-
>  samples/vfio-mdev/mdpy.c                      |  20 +-
>  samples/vfio-mdev/mtty.c                      |  18 +-
>  samples/vfio-mdev/mvnet.c                     | 692 ++++++++++++++++++
>  scripts/mod/devicetable-offsets.c             |   3 +
>  scripts/mod/file2alias.c                      |  10 +
>  25 files changed, 1524 insertions(+), 84 deletions(-)
>  create mode 100644 drivers/virtio/virtio_mdev.c
>  create mode 100644 include/linux/vfio_mdev.h
>  create mode 100644 include/linux/virtio_mdev.h
>  create mode 100644 samples/vfio-mdev/mvnet.c
> 
> --
> 2.19.1

