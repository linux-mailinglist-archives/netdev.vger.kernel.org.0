Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7B3213403
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 08:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgGCGSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 02:18:20 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:53542 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCGST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 02:18:19 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0636I5RQ038190;
        Fri, 3 Jul 2020 01:18:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593757085;
        bh=s4klUDGcTWMMsrpvyz765ijFqipLqcgpGqgz49/FpbA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=DuLrf10hkGjZISECc5T7HIVgnm4U89Mj6ifWSDNkGDgipo56ypn+F/WH3UiyrR2Qq
         pcqz3q3IS45hLzWfKBMI5mQrDXs00iG7YCL8kEEx+XKnilEoKBI0vggRVw381o9FTX
         Ou5uEBciKHj1OwQP/nyIfGaDV2VlaHT+Mca+xuPk=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0636I453100383;
        Fri, 3 Jul 2020 01:18:05 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 3 Jul
 2020 01:18:04 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 3 Jul 2020 01:18:04 -0500
Received: from [10.250.233.85] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0636Hv4i079350;
        Fri, 3 Jul 2020 01:17:58 -0500
Subject: Re: [RFC PATCH 00/22] Enhance VHOST to enable SoC-to-SoC
 communication
To:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-remoteproc <linux-remoteproc@vger.kernel.org>,
        <linux-ntb@googlegroups.com>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, Alan Mikhak <alanmikhak@gmail.com>,
        <haotian.wang@duke.edu>
References: <20200702082143.25259-1-kishon@ti.com>
 <20200702055026-mutt-send-email-mst@kernel.org>
 <CANLsYky4ZrgYGZUyg4iVwbM3TQk5dvOSBwPFER8qofixjn4vyA@mail.gmail.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <9e4703f9-cf02-7aa1-1785-8cbd6ca4b26d@ti.com>
Date:   Fri, 3 Jul 2020 11:47:57 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CANLsYky4ZrgYGZUyg4iVwbM3TQk5dvOSBwPFER8qofixjn4vyA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Alan, Haotian

On 7/2/2020 11:01 PM, Mathieu Poirier wrote:
> On Thu, 2 Jul 2020 at 03:51, Michael S. Tsirkin <mst@redhat.com> wrote:
>>
>> On Thu, Jul 02, 2020 at 01:51:21PM +0530, Kishon Vijay Abraham I wrote:
>>> This series enhances Linux Vhost support to enable SoC-to-SoC
>>> communication over MMIO. This series enables rpmsg communication between
>>> two SoCs using both PCIe RC<->EP and HOST1-NTB-HOST2
>>>
>>> 1) Modify vhost to use standard Linux driver model
>>> 2) Add support in vring to access virtqueue over MMIO
>>> 3) Add vhost client driver for rpmsg
>>> 4) Add PCIe RC driver (uses virtio) and PCIe EP driver (uses vhost) for
>>>    rpmsg communication between two SoCs connected to each other
>>> 5) Add NTB Virtio driver and NTB Vhost driver for rpmsg communication
>>>    between two SoCs connected via NTB
>>> 6) Add configfs to configure the components
>>>
>>> UseCase1 :
>>>
>>>  VHOST RPMSG                     VIRTIO RPMSG
>>>       +                               +
>>>       |                               |
>>>       |                               |
>>>       |                               |
>>>       |                               |
>>> +-----v------+                 +------v-------+
>>> |   Linux    |                 |     Linux    |
>>> |  Endpoint  |                 | Root Complex |
>>> |            <----------------->              |
>>> |            |                 |              |
>>> |    SOC1    |                 |     SOC2     |
>>> +------------+                 +--------------+
>>>
>>> UseCase 2:
>>>
>>>      VHOST RPMSG                                      VIRTIO RPMSG
>>>           +                                                 +
>>>           |                                                 |
>>>           |                                                 |
>>>           |                                                 |
>>>           |                                                 |
>>>    +------v------+                                   +------v------+
>>>    |             |                                   |             |
>>>    |    HOST1    |                                   |    HOST2    |
>>>    |             |                                   |             |
>>>    +------^------+                                   +------^------+
>>>           |                                                 |
>>>           |                                                 |
>>> +---------------------------------------------------------------------+
>>> |  +------v------+                                   +------v------+  |
>>> |  |             |                                   |             |  |
>>> |  |     EP      |                                   |     EP      |  |
>>> |  | CONTROLLER1 |                                   | CONTROLLER2 |  |
>>> |  |             <----------------------------------->             |  |
>>> |  |             |                                   |             |  |
>>> |  |             |                                   |             |  |
>>> |  |             |  SoC With Multiple EP Instances   |             |  |
>>> |  |             |  (Configured using NTB Function)  |             |  |
>>> |  +-------------+                                   +-------------+  |
>>> +---------------------------------------------------------------------+
>>>
>>> Software Layering:
>>>
>>> The high-level SW layering should look something like below. This series
>>> adds support only for RPMSG VHOST, however something similar should be
>>> done for net and scsi. With that any vhost device (PCI, NTB, Platform
>>> device, user) can use any of the vhost client driver.
>>>
>>>
>>>     +----------------+  +-----------+  +------------+  +----------+
>>>     |  RPMSG VHOST   |  | NET VHOST |  | SCSI VHOST |  |    X     |
>>>     +-------^--------+  +-----^-----+  +-----^------+  +----^-----+
>>>             |                 |              |              |
>>>             |                 |              |              |
>>>             |                 |              |              |
>>> +-----------v-----------------v--------------v--------------v----------+
>>> |                            VHOST CORE                                |
>>> +--------^---------------^--------------------^------------------^-----+
>>>          |               |                    |                  |
>>>          |               |                    |                  |
>>>          |               |                    |                  |
>>> +--------v-------+  +----v------+  +----------v----------+  +----v-----+
>>> |  PCI EPF VHOST |  | NTB VHOST |  |PLATFORM DEVICE VHOST|  |    X     |
>>> +----------------+  +-----------+  +---------------------+  +----------+
>>>
>>> This was initially proposed here [1]
>>>
>>> [1] -> https://lore.kernel.org/r/2cf00ec4-1ed6-f66e-6897-006d1a5b6390@ti.com
>>
>>
>> I find this very interesting. A huge patchset so will take a bit
>> to review, but I certainly plan to do that. Thanks!
> 
> Same here - it will take time.  This patchset is sizable and sits
> behind a few others that are equally big.
> 
>>
>>>
>>> Kishon Vijay Abraham I (22):
>>>   vhost: Make _feature_ bits a property of vhost device
>>>   vhost: Introduce standard Linux driver model in VHOST
>>>   vhost: Add ops for the VHOST driver to configure VHOST device
>>>   vringh: Add helpers to access vring in MMIO
>>>   vhost: Add MMIO helpers for operations on vhost virtqueue
>>>   vhost: Introduce configfs entry for configuring VHOST
>>>   virtio_pci: Use request_threaded_irq() instead of request_irq()
>>>   rpmsg: virtio_rpmsg_bus: Disable receive virtqueue callback when
>>>     reading messages
>>>   rpmsg: Introduce configfs entry for configuring rpmsg
>>>   rpmsg: virtio_rpmsg_bus: Add Address Service Notification support
>>>   rpmsg: virtio_rpmsg_bus: Move generic rpmsg structure to
>>>     rpmsg_internal.h
>>>   virtio: Add ops to allocate and free buffer
>>>   rpmsg: virtio_rpmsg_bus: Use virtio_alloc_buffer() and
>>>     virtio_free_buffer()
>>>   rpmsg: Add VHOST based remote processor messaging bus
>>>   samples/rpmsg: Setup delayed work to send message
>>>   samples/rpmsg: Wait for address to be bound to rpdev for sending
>>>     message
>>>   rpmsg.txt: Add Documentation to configure rpmsg using configfs
>>>   virtio_pci: Add VIRTIO driver for VHOST on Configurable PCIe Endpoint
>>>     device
>>>   PCI: endpoint: Add EP function driver to provide VHOST interface
>>>   NTB: Add a new NTB client driver to implement VIRTIO functionality
>>>   NTB: Add a new NTB client driver to implement VHOST functionality
>>>   NTB: Describe the ntb_virtio and ntb_vhost client in the documentation
>>>
>>>  Documentation/driver-api/ntb.rst              |   11 +
>>>  Documentation/rpmsg.txt                       |   56 +
>>>  drivers/ntb/Kconfig                           |   18 +
>>>  drivers/ntb/Makefile                          |    2 +
>>>  drivers/ntb/ntb_vhost.c                       |  776 +++++++++++
>>>  drivers/ntb/ntb_virtio.c                      |  853 ++++++++++++
>>>  drivers/ntb/ntb_virtio.h                      |   56 +
>>>  drivers/pci/endpoint/functions/Kconfig        |   11 +
>>>  drivers/pci/endpoint/functions/Makefile       |    1 +
>>>  .../pci/endpoint/functions/pci-epf-vhost.c    | 1144 ++++++++++++++++
>>>  drivers/rpmsg/Kconfig                         |   10 +
>>>  drivers/rpmsg/Makefile                        |    3 +-
>>>  drivers/rpmsg/rpmsg_cfs.c                     |  394 ++++++
>>>  drivers/rpmsg/rpmsg_core.c                    |    7 +
>>>  drivers/rpmsg/rpmsg_internal.h                |  136 ++
>>>  drivers/rpmsg/vhost_rpmsg_bus.c               | 1151 +++++++++++++++++
>>>  drivers/rpmsg/virtio_rpmsg_bus.c              |  184 ++-
>>>  drivers/vhost/Kconfig                         |    1 +
>>>  drivers/vhost/Makefile                        |    2 +-
>>>  drivers/vhost/net.c                           |   10 +-
>>>  drivers/vhost/scsi.c                          |   24 +-
>>>  drivers/vhost/test.c                          |   17 +-
>>>  drivers/vhost/vdpa.c                          |    2 +-
>>>  drivers/vhost/vhost.c                         |  730 ++++++++++-
>>>  drivers/vhost/vhost_cfs.c                     |  341 +++++
>>>  drivers/vhost/vringh.c                        |  332 +++++
>>>  drivers/vhost/vsock.c                         |   20 +-
>>>  drivers/virtio/Kconfig                        |    9 +
>>>  drivers/virtio/Makefile                       |    1 +
>>>  drivers/virtio/virtio_pci_common.c            |   25 +-
>>>  drivers/virtio/virtio_pci_epf.c               |  670 ++++++++++
>>>  include/linux/mod_devicetable.h               |    6 +
>>>  include/linux/rpmsg.h                         |    6 +
>>>  {drivers/vhost => include/linux}/vhost.h      |  132 +-
>>>  include/linux/virtio.h                        |    3 +
>>>  include/linux/virtio_config.h                 |   42 +
>>>  include/linux/vringh.h                        |   46 +
>>>  samples/rpmsg/rpmsg_client_sample.c           |   32 +-
>>>  tools/virtio/virtio_test.c                    |    2 +-
>>>  39 files changed, 7083 insertions(+), 183 deletions(-)
>>>  create mode 100644 drivers/ntb/ntb_vhost.c
>>>  create mode 100644 drivers/ntb/ntb_virtio.c
>>>  create mode 100644 drivers/ntb/ntb_virtio.h
>>>  create mode 100644 drivers/pci/endpoint/functions/pci-epf-vhost.c
>>>  create mode 100644 drivers/rpmsg/rpmsg_cfs.c
>>>  create mode 100644 drivers/rpmsg/vhost_rpmsg_bus.c
>>>  create mode 100644 drivers/vhost/vhost_cfs.c
>>>  create mode 100644 drivers/virtio/virtio_pci_epf.c
>>>  rename {drivers/vhost => include/linux}/vhost.h (66%)
>>>
>>> --
>>> 2.17.1
>>>
>>
