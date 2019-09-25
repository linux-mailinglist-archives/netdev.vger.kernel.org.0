Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD93BBDDED
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 14:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405515AbfIYMOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 08:14:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405211AbfIYMOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 08:14:06 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 552FF796EB;
        Wed, 25 Sep 2019 12:14:05 +0000 (UTC)
Received: from [10.72.12.148] (ovpn-12-148.pek2.redhat.com [10.72.12.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AADA91001938;
        Wed, 25 Sep 2019 12:13:35 +0000 (UTC)
Subject: Re: [PATCH V2 0/8] mdev based hardware virtio offloading support
To:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Cc:     "virtualization@lists.linux-foundation.org" 
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
References: <20190924135332.14160-1-jasowang@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F68D@SHSMSX104.ccr.corp.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a0466f84-0b45-a3d3-dc1d-83c9d07d6d9a@redhat.com>
Date:   Wed, 25 Sep 2019 20:13:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F68D@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 25 Sep 2019 12:14:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/25 下午4:24, Tian, Kevin wrote:
>> From: Jason Wang [mailto:jasowang@redhat.com]
>> Sent: Tuesday, September 24, 2019 9:53 PM
>>
>> Hi all:
>>
>> There are hardware that can do virtio datapath offloading while having
>> its own control path. This path tries to implement a mdev based
>> unified API to support using kernel virtio driver to drive those
>> devices. This is done by introducing a new mdev transport for virtio
>> (virtio_mdev) and register itself as a new kind of mdev driver. Then
>> it provides a unified way for kernel virtio driver to talk with mdev
>> device implementation.
>>
>> Though the series only contains kernel driver support, the goal is to
>> make the transport generic enough to support userspace drivers. This
>> means vhost-mdev[1] could be built on top as well by resuing the
>> transport.
>>
>> A sample driver is also implemented which simulate a virito-net
>> loopback ethernet device on top of vringh + workqueue. This could be
>> used as a reference implementation for real hardware driver.
>>
>> Consider mdev framework only support VFIO device and driver right now,
>> this series also extend it to support other types. This is done
>> through introducing class id to the device and pairing it with
>> id_talbe claimed by the driver. On top, this seris also decouple
> id_table claimed ... this series ...


Let me fix in V3.

Thanks


>
>> device specific parents ops out of the common ones.
>>
>> Pktgen test was done with virito-net + mvnet loop back device.
>>
>> Please review.
>>
>> [1] https://lkml.org/lkml/2019/9/16/869
>>
>> Changes from V1:
>>
>> - move virtio_mdev.c to drivers/virtio
>> - store class_id in mdev_device instead of mdev_parent
>> - store device_ops in mdev_device instead of mdev_parent
>> - reorder the patch, vringh fix comes first
>> - really silent compiling warnings
>> - really switch to use u16 for class_id
>> - uevent and modpost support for mdev class_id
>> - vraious tweaks per comments from Parav
>>
>> Changes from RFC-V2:
>>
>> - silent compile warnings on some specific configuration
>> - use u16 instead u8 for class id
>> - reseve MDEV_ID_VHOST for future vhost-mdev work
>> - introduce "virtio" type for mvnet and make "vhost" type for future
>>   work
>> - add entries in MAINTAINER
>> - tweak and typos fixes in commit log
>>
>> Changes from RFC-V1:
>>
>> - rename device id to class id
>> - add docs for class id and device specific ops (device_ops)
>> - split device_ops into seperate headers
>> - drop the mdev_set_dma_ops()
>> - use device_ops to implement the transport API, then it's not a part
>>   of UAPI any more
>> - use GFP_ATOMIC in mvnet sample device and other tweaks
>> - set_vring_base/get_vring_base support for mvnet device
>>
>> Jason Wang (8):
>>   vringh: fix copy direction of vringh_iov_push_kern()
>>   mdev: class id support
>>   mdev: bus uevent support
>>   modpost: add support for mdev class id
>>   mdev: introduce device specific ops
>>   mdev: introduce virtio device and its device ops
>>   virtio: introduce a mdev based transport
>>   docs: sample driver to demonstrate how to implement virtio-mdev
>>     framework
>>
>>  .../driver-api/vfio-mediated-device.rst       |   7 +-
>>  MAINTAINERS                                   |   2 +
>>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  18 +-
>>  drivers/s390/cio/vfio_ccw_ops.c               |  18 +-
>>  drivers/s390/crypto/vfio_ap_ops.c             |  14 +-
>>  drivers/vfio/mdev/mdev_core.c                 |  19 +
>>  drivers/vfio/mdev/mdev_driver.c               |  22 +
>>  drivers/vfio/mdev/mdev_private.h              |   2 +
>>  drivers/vfio/mdev/vfio_mdev.c                 |  45 +-
>>  drivers/vhost/vringh.c                        |   8 +-
>>  drivers/virtio/Kconfig                        |   7 +
>>  drivers/virtio/Makefile                       |   1 +
>>  drivers/virtio/virtio_mdev.c                  | 417 +++++++++++
>>  include/linux/mdev.h                          |  52 +-
>>  include/linux/mod_devicetable.h               |   8 +
>>  include/linux/vfio_mdev.h                     |  52 ++
>>  include/linux/virtio_mdev.h                   | 145 ++++
>>  samples/Kconfig                               |   7 +
>>  samples/vfio-mdev/Makefile                    |   1 +
>>  samples/vfio-mdev/mbochs.c                    |  20 +-
>>  samples/vfio-mdev/mdpy.c                      |  20 +-
>>  samples/vfio-mdev/mtty.c                      |  18 +-
>>  samples/vfio-mdev/mvnet.c                     | 692 ++++++++++++++++++
>>  scripts/mod/devicetable-offsets.c             |   3 +
>>  scripts/mod/file2alias.c                      |  10 +
>>  25 files changed, 1524 insertions(+), 84 deletions(-)
>>  create mode 100644 drivers/virtio/virtio_mdev.c
>>  create mode 100644 include/linux/vfio_mdev.h
>>  create mode 100644 include/linux/virtio_mdev.h
>>  create mode 100644 samples/vfio-mdev/mvnet.c
>>
>> --
>> 2.19.1
