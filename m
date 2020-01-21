Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952A21439AA
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgAUJjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:39:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49825 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728689AbgAUJjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 04:39:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579599579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgGWPH2qJri2TmOIIhSVNudNErzIIx6+vIt4WpsZSc0=;
        b=ED4FbTQWIZubDh/R7oZQk/dP5a1CLmdltW5vznES9p4rDlIbC8cMPiUcj8t3+cWXTEETTD
        maFivL+L+yUa86QWBkeL8mAwHO/6aH8WqR3cYiGak+MhX2cy1yXoos2+RuLCvDS9vWHFTG
        GuxL2mG1kHQYCcQeuhJ0lOI/qdUqb4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-vlmfGg1DMDiWOGcO6XPaqw-1; Tue, 21 Jan 2020 04:39:37 -0500
X-MC-Unique: vlmfGg1DMDiWOGcO6XPaqw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0E7C8010DC;
        Tue, 21 Jan 2020 09:39:33 +0000 (UTC)
Received: from [10.72.12.103] (ovpn-12-103.pek2.redhat.com [10.72.12.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CE6419C6A;
        Tue, 21 Jan 2020 09:39:17 +0000 (UTC)
Subject: Re: [PATCH 0/5] vDPA support
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "Bie, Tiwei" <tiwei.bie@intel.com>,
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
References: <20200116124231.20253-1-jasowang@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D73EC6B@SHSMSX104.ccr.corp.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0185b91a-f984-681e-b7c0-af8eca81d053@redhat.com>
Date:   Tue, 21 Jan 2020 17:39:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D73EC6B@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/21 =E4=B8=8B=E5=8D=884:44, Tian, Kevin wrote:
>> From: Jason Wang
>> Sent: Thursday, January 16, 2020 8:42 PM
>>
>> Hi all:
>>
>> Based on the comments and discussion for mdev based hardware virtio
>> offloading support[1]. A different approach to support vDPA device is
>> proposed in this series.
> Can you point to the actual link which triggered the direction change?
> A quick glimpse in that thread doesn't reveal such information...


Right, please see this link, the actual discussion happens on the thread=20
of virtual-bus for some reasons...

https://patchwork.ozlabs.org/patch/1195895/

Thanks


>
>> Instead of leveraging VFIO/mdev which may not work for some
>> vendors. This series tries to introduce a dedicated vDPA bus and
>> leverage vhost for userspace drivers. This help for the devices that
>> are not fit for VFIO and may reduce the conflict when try to propose a
>> bus template for virtual devices in [1].
>>
>> The vDPA support is split into following parts:
>>
>> 1) vDPA core (bus, device and driver abstraction)
>> 2) virtio vDPA transport for kernel virtio driver to control vDPA
>>     device
>> 3) vhost vDPA bus driver for userspace vhost driver to control vDPA
>>     device
>> 4) vendor vDPA drivers
>> 5) management API
>>
>> Both 1) and 2) are included in this series. Tiwei will work on part
>> 3). For 4), Ling Shan will work and post IFCVF driver. For 5) we leave
>> it to vendor to implement, but it's better to come into an agreement
>> for management to create/configure/destroy vDPA device.
>>
>> The sample driver is kept but renamed to vdap_sim. An on-chip IOMMU
>> implementation is added to sample device to make it work for both
>> kernel virtio driver and userspace vhost driver. It implements a sysfs
>> based management API, but it can switch to any other (e.g devlink) if
>> necessary.
>>
>> Please refer each patch for more information.
>>
>> Comments are welcomed.
>>
>> [1] https://lkml.org/lkml/2019/11/18/261
>>
>> Jason Wang (5):
>>    vhost: factor out IOTLB
>>    vringh: IOTLB support
>>    vDPA: introduce vDPA bus
>>    virtio: introduce a vDPA based transport
>>    vdpasim: vDPA device simulator
>>
>>   MAINTAINERS                    |   2 +
>>   drivers/vhost/Kconfig          |   7 +
>>   drivers/vhost/Kconfig.vringh   |   1 +
>>   drivers/vhost/Makefile         |   2 +
>>   drivers/vhost/net.c            |   2 +-
>>   drivers/vhost/vhost.c          | 221 +++------
>>   drivers/vhost/vhost.h          |  36 +-
>>   drivers/vhost/vhost_iotlb.c    | 171 +++++++
>>   drivers/vhost/vringh.c         | 434 +++++++++++++++++-
>>   drivers/virtio/Kconfig         |  15 +
>>   drivers/virtio/Makefile        |   2 +
>>   drivers/virtio/vdpa/Kconfig    |  26 ++
>>   drivers/virtio/vdpa/Makefile   |   3 +
>>   drivers/virtio/vdpa/vdpa.c     | 141 ++++++
>>   drivers/virtio/vdpa/vdpa_sim.c | 796
>> +++++++++++++++++++++++++++++++++
>>   drivers/virtio/virtio_vdpa.c   | 400 +++++++++++++++++
>>   include/linux/vdpa.h           | 191 ++++++++
>>   include/linux/vhost_iotlb.h    |  45 ++
>>   include/linux/vringh.h         |  36 ++
>>   19 files changed, 2327 insertions(+), 204 deletions(-)
>>   create mode 100644 drivers/vhost/vhost_iotlb.c
>>   create mode 100644 drivers/virtio/vdpa/Kconfig
>>   create mode 100644 drivers/virtio/vdpa/Makefile
>>   create mode 100644 drivers/virtio/vdpa/vdpa.c
>>   create mode 100644 drivers/virtio/vdpa/vdpa_sim.c
>>   create mode 100644 drivers/virtio/virtio_vdpa.c
>>   create mode 100644 include/linux/vdpa.h
>>   create mode 100644 include/linux/vhost_iotlb.h
>>
>> --
>> 2.19.1

