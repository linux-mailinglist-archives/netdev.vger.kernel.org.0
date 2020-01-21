Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DB114389B
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgAUIpY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Jan 2020 03:45:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:56631 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgAUIpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 03:45:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 00:44:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,345,1574150400"; 
   d="scan'208";a="425414145"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga005.fm.intel.com with ESMTP; 21 Jan 2020 00:44:41 -0800
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Jan 2020 00:44:41 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.210]) with mapi id 14.03.0439.000;
 Tue, 21 Jan 2020 16:44:39 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Bie, Tiwei" <tiwei.bie@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: RE: [PATCH 0/5] vDPA support
Thread-Topic: [PATCH 0/5] vDPA support
Thread-Index: AQHVzGp/SBLGDhHHOEaUVdPH9dzUvaf01Ivg
Date:   Tue, 21 Jan 2020 08:44:39 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D73EC6B@SHSMSX104.ccr.corp.intel.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
In-Reply-To: <20200116124231.20253-1-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjlmMDRhMzQtNDBlNy00YzU3LWI5NGYtNGU3M2IwM2FjYjMyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidnNEbEpQRG92ODhoYlZNbFRzOVpCd3BUbVlCQ2hhem92R1RZOXJ4cEo0NDQ1dzluRUNwWlRXOGdjdjc1SkhjTCJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Wang
> Sent: Thursday, January 16, 2020 8:42 PM
> 
> Hi all:
> 
> Based on the comments and discussion for mdev based hardware virtio
> offloading support[1]. A different approach to support vDPA device is
> proposed in this series.

Can you point to the actual link which triggered the direction change?
A quick glimpse in that thread doesn't reveal such information...

> 
> Instead of leveraging VFIO/mdev which may not work for some
> vendors. This series tries to introduce a dedicated vDPA bus and
> leverage vhost for userspace drivers. This help for the devices that
> are not fit for VFIO and may reduce the conflict when try to propose a
> bus template for virtual devices in [1].
> 
> The vDPA support is split into following parts:
> 
> 1) vDPA core (bus, device and driver abstraction)
> 2) virtio vDPA transport for kernel virtio driver to control vDPA
>    device
> 3) vhost vDPA bus driver for userspace vhost driver to control vDPA
>    device
> 4) vendor vDPA drivers
> 5) management API
> 
> Both 1) and 2) are included in this series. Tiwei will work on part
> 3). For 4), Ling Shan will work and post IFCVF driver. For 5) we leave
> it to vendor to implement, but it's better to come into an agreement
> for management to create/configure/destroy vDPA device.
> 
> The sample driver is kept but renamed to vdap_sim. An on-chip IOMMU
> implementation is added to sample device to make it work for both
> kernel virtio driver and userspace vhost driver. It implements a sysfs
> based management API, but it can switch to any other (e.g devlink) if
> necessary.
> 
> Please refer each patch for more information.
> 
> Comments are welcomed.
> 
> [1] https://lkml.org/lkml/2019/11/18/261
> 
> Jason Wang (5):
>   vhost: factor out IOTLB
>   vringh: IOTLB support
>   vDPA: introduce vDPA bus
>   virtio: introduce a vDPA based transport
>   vdpasim: vDPA device simulator
> 
>  MAINTAINERS                    |   2 +
>  drivers/vhost/Kconfig          |   7 +
>  drivers/vhost/Kconfig.vringh   |   1 +
>  drivers/vhost/Makefile         |   2 +
>  drivers/vhost/net.c            |   2 +-
>  drivers/vhost/vhost.c          | 221 +++------
>  drivers/vhost/vhost.h          |  36 +-
>  drivers/vhost/vhost_iotlb.c    | 171 +++++++
>  drivers/vhost/vringh.c         | 434 +++++++++++++++++-
>  drivers/virtio/Kconfig         |  15 +
>  drivers/virtio/Makefile        |   2 +
>  drivers/virtio/vdpa/Kconfig    |  26 ++
>  drivers/virtio/vdpa/Makefile   |   3 +
>  drivers/virtio/vdpa/vdpa.c     | 141 ++++++
>  drivers/virtio/vdpa/vdpa_sim.c | 796
> +++++++++++++++++++++++++++++++++
>  drivers/virtio/virtio_vdpa.c   | 400 +++++++++++++++++
>  include/linux/vdpa.h           | 191 ++++++++
>  include/linux/vhost_iotlb.h    |  45 ++
>  include/linux/vringh.h         |  36 ++
>  19 files changed, 2327 insertions(+), 204 deletions(-)
>  create mode 100644 drivers/vhost/vhost_iotlb.c
>  create mode 100644 drivers/virtio/vdpa/Kconfig
>  create mode 100644 drivers/virtio/vdpa/Makefile
>  create mode 100644 drivers/virtio/vdpa/vdpa.c
>  create mode 100644 drivers/virtio/vdpa/vdpa_sim.c
>  create mode 100644 drivers/virtio/virtio_vdpa.c
>  create mode 100644 include/linux/vdpa.h
>  create mode 100644 include/linux/vhost_iotlb.h
> 
> --
> 2.19.1

