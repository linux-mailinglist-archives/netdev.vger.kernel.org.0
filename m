Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91B23B6E02
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 07:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhF2Fpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 01:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbhF2Fpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 01:45:51 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132ADC061767
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 22:43:24 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id hz1so34169354ejc.1
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 22:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xrRIpRDMYCUuT0N0nNIsJAiVOtwEfWYTgjznAQmmJS4=;
        b=zt+lQ72MfdZKLD/3wmTWnyWnfinGHARJvCXzW/1j5X5loBw/AZilf2bArM91E1pEc6
         nu02CLwJ2Bgicv9Js08Q+qJwrx6Lnb57MVpml4D03kMn1p8Gus9nawMWipqIAWChe6Cb
         shCLxFQH6FZzK8Ue9dD3o/tqFGT0M0akJdImfYEmKefhQUwDm3gonC0mhAAhBqekvdJC
         vsi7qD3kA/DBKAPwtMSkBcr07EtFTVsNPpofmP+LoRSUL9q7kq5geQ6NC5iN+OA8QFjQ
         t6IA0nyY7nP6z8J8yEg/30Q3BGkEQ47rvi2Y61UTiDLAlxNQj+5RwsipSh2DVkHeRk2R
         h+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xrRIpRDMYCUuT0N0nNIsJAiVOtwEfWYTgjznAQmmJS4=;
        b=GHQijfZdvuIM7lsmTdye2NdaQRWAr9SKTD2gFpQJOfSdkCnPilPmBrlpgBLAz2TqzB
         bDvVEQzfR6VbrEcoYB0wZY36mK+dIEo9UOSiZj8S3QFnVj6LnuckCVFVNfm50wL/R3na
         4SER0hlcCIEre9aCxXBFkAyxCb4BSQdeWk444X7IT4mbU9pMQ7A6q0HY8ZwtDGR3CmFo
         oWZseHnIuFzDsEVfA7mmZjlh/o9NfMch3O3TIlsuic1At0dCTrwPNp1utDLYL500VXaZ
         Th1PAwXw9vjkgsRyCtKH5uNLoMoYNXKkEvnHnpemyJ6IYOpHuC4cz81O4aGcJaBpklR+
         Fp7A==
X-Gm-Message-State: AOAM531bavUNmMLg4pk15GeYDr7qxlWDbuxOqK0ans9f9W8kRG4A2Crp
        mnlFSg1gu6YZJp/Il+1eRn+eQrW2A//hOFWY7HKP
X-Google-Smtp-Source: ABdhPJznY7JybRnyMOh3MFPA6NLlIedQGO9ql6pXFq4VoDrTgHJmjFcBCVMzahKj2en5XHaS1+eg82lK0YHgoHdqdic=
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr28378543ejc.1.1624945402507;
 Mon, 28 Jun 2021 22:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-11-xieyongji@bytedance.com>
 <YNSCH6l31zwPxBjL@stefanha-x1.localdomain>
In-Reply-To: <YNSCH6l31zwPxBjL@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 29 Jun 2021 13:43:11 +0800
Message-ID: <CACycT3uxnQmXWsgmNVxQtiRhz1UXXTAJFY3OiAJqokbJH6ifMA@mail.gmail.com>
Subject: Re: Re: [PATCH v8 10/10] Documentation: Add documentation for VDUSE
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 9:02 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Tue, Jun 15, 2021 at 10:13:31PM +0800, Xie Yongji wrote:
> > VDUSE (vDPA Device in Userspace) is a framework to support
> > implementing software-emulated vDPA devices in userspace. This
> > document is intended to clarify the VDUSE design and usage.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >  Documentation/userspace-api/index.rst |   1 +
> >  Documentation/userspace-api/vduse.rst | 222 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 223 insertions(+)
> >  create mode 100644 Documentation/userspace-api/vduse.rst
> >
> > diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
> > index 0b5eefed027e..c432be070f67 100644
> > --- a/Documentation/userspace-api/index.rst
> > +++ b/Documentation/userspace-api/index.rst
> > @@ -27,6 +27,7 @@ place where this information is gathered.
> >     iommu
> >     media/index
> >     sysfs-platform_profile
> > +   vduse
> >
> >  .. only::  subproject and html
> >
> > diff --git a/Documentation/userspace-api/vduse.rst b/Documentation/userspace-api/vduse.rst
> > new file mode 100644
> > index 000000000000..2f9cd1a4e530
> > --- /dev/null
> > +++ b/Documentation/userspace-api/vduse.rst
> > @@ -0,0 +1,222 @@
> > +==================================
> > +VDUSE - "vDPA Device in Userspace"
> > +==================================
> > +
> > +vDPA (virtio data path acceleration) device is a device that uses a
> > +datapath which complies with the virtio specifications with vendor
> > +specific control path. vDPA devices can be both physically located on
> > +the hardware or emulated by software. VDUSE is a framework that makes it
> > +possible to implement software-emulated vDPA devices in userspace. And
> > +to make it simple, the emulated vDPA device's control path is handled in
> > +the kernel and only the data path is implemented in the userspace.
> > +
> > +Note that only virtio block device is supported by VDUSE framework now,
> > +which can reduce security risks when the userspace process that implements
> > +the data path is run by an unprivileged user. The Support for other device
> > +types can be added after the security issue is clarified or fixed in the future.
> > +
> > +Start/Stop VDUSE devices
> > +------------------------
> > +
> > +VDUSE devices are started as follows:
> > +
> > +1. Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
> > +   /dev/vduse/control.
> > +
> > +2. Begin processing VDUSE messages from /dev/vduse/$NAME. The first
> > +   messages will arrive while attaching the VDUSE instance to vDPA bus.
> > +
> > +3. Send the VDPA_CMD_DEV_NEW netlink message to attach the VDUSE
> > +   instance to vDPA bus.
> > +
> > +VDUSE devices are stopped as follows:
> > +
> > +1. Send the VDPA_CMD_DEV_DEL netlink message to detach the VDUSE
> > +   instance from vDPA bus.
> > +
> > +2. Close the file descriptor referring to /dev/vduse/$NAME
> > +
> > +3. Destroy the VDUSE instance with ioctl(VDUSE_DESTROY_DEV) on
> > +   /dev/vduse/control
> > +
> > +The netlink messages metioned above can be sent via vdpa tool in iproute2
> > +or use the below sample codes:
> > +
> > +.. code-block:: c
> > +
> > +     static int netlink_add_vduse(const char *name, enum vdpa_command cmd)
> > +     {
> > +             struct nl_sock *nlsock;
> > +             struct nl_msg *msg;
> > +             int famid;
> > +
> > +             nlsock = nl_socket_alloc();
> > +             if (!nlsock)
> > +                     return -ENOMEM;
> > +
> > +             if (genl_connect(nlsock))
> > +                     goto free_sock;
> > +
> > +             famid = genl_ctrl_resolve(nlsock, VDPA_GENL_NAME);
> > +             if (famid < 0)
> > +                     goto close_sock;
> > +
> > +             msg = nlmsg_alloc();
> > +             if (!msg)
> > +                     goto close_sock;
> > +
> > +             if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, famid, 0, 0, cmd, 0))
> > +                     goto nla_put_failure;
> > +
> > +             NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
> > +             if (cmd == VDPA_CMD_DEV_NEW)
> > +                     NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "vduse");
> > +
> > +             if (nl_send_sync(nlsock, msg))
> > +                     goto close_sock;
> > +
> > +             nl_close(nlsock);
> > +             nl_socket_free(nlsock);
> > +
> > +             return 0;
> > +     nla_put_failure:
> > +             nlmsg_free(msg);
> > +     close_sock:
> > +             nl_close(nlsock);
> > +     free_sock:
> > +             nl_socket_free(nlsock);
> > +             return -1;
> > +     }
> > +
> > +How VDUSE works
> > +---------------
> > +
> > +Since the emuldated vDPA device's control path is handled in the kernel,
>
> s/emuldated/emulated/
>

Will fix it.

> > +a message-based communication protocol and few types of control messages
> > +are introduced by VDUSE framework to make userspace be aware of the data
> > +path related changes:
> > +
> > +- VDUSE_GET_VQ_STATE: Get the state for virtqueue from userspace
> > +
> > +- VDUSE_START_DATAPLANE: Notify userspace to start the dataplane
> > +
> > +- VDUSE_STOP_DATAPLANE: Notify userspace to stop the dataplane
> > +
> > +- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping in device IOTLB
> > +
> > +Userspace needs to read()/write() on /dev/vduse/$NAME to receive/reply
> > +those control messages from/to VDUSE kernel module as follows:
> > +
> > +.. code-block:: c
> > +
> > +     static int vduse_message_handler(int dev_fd)
> > +     {
> > +             int len;
> > +             struct vduse_dev_request req;
> > +             struct vduse_dev_response resp;
> > +
> > +             len = read(dev_fd, &req, sizeof(req));
> > +             if (len != sizeof(req))
> > +                     return -1;
> > +
> > +             resp.request_id = req.request_id;
> > +
> > +             switch (req.type) {
> > +
> > +             /* handle different types of message */
> > +
> > +             }
> > +
> > +             if (req.flags & VDUSE_REQ_FLAGS_NO_REPLY)
> > +                     return 0;
> > +
> > +             len = write(dev_fd, &resp, sizeof(resp));
> > +             if (len != sizeof(resp))
> > +                     return -1;
> > +
> > +             return 0;
> > +     }
> > +
> > +After VDUSE_START_DATAPLANE messages is received, userspace should start the
> > +dataplane processing with the help of some ioctls on /dev/vduse/$NAME:
> > +
> > +- VDUSE_IOTLB_GET_FD: get the file descriptor to the first overlapped iova region.
> > +  Userspace can access this iova region by passing fd and corresponding size, offset,
> > +  perm to mmap(). For example:
> > +
> > +.. code-block:: c
> > +
> > +     static int perm_to_prot(uint8_t perm)
> > +     {
> > +             int prot = 0;
> > +
> > +             switch (perm) {
> > +             case VDUSE_ACCESS_WO:
> > +                     prot |= PROT_WRITE;
> > +                     break;
> > +             case VDUSE_ACCESS_RO:
> > +                     prot |= PROT_READ;
> > +                     break;
> > +             case VDUSE_ACCESS_RW:
> > +                     prot |= PROT_READ | PROT_WRITE;
> > +                     break;
> > +             }
> > +
> > +             return prot;
> > +     }
> > +
> > +     static void *iova_to_va(int dev_fd, uint64_t iova, uint64_t *len)
> > +     {
> > +             int fd;
> > +             void *addr;
> > +             size_t size;
> > +             struct vduse_iotlb_entry entry;
> > +
> > +             entry.start = iova;
> > +             entry.last = iova + 1;
>
> Why +1?
>
> I expected the request to include *len so that VDUSE can create a bounce
> buffer for the full iova range, if necessary.
>

The function is used to translate iova to va. And the *len is not
specified by the caller. Instead, it's used to tell the caller the
length of the contiguous iova region from the specified iova. And the
ioctl VDUSE_IOTLB_GET_FD will get the file descriptor to the first
overlapped iova region. So using iova + 1 should be enough here.

> > +             fd = ioctl(dev_fd, VDUSE_IOTLB_GET_FD, &entry);
> > +             if (fd < 0)
> > +                     return NULL;
> > +
> > +             size = entry.last - entry.start + 1;
> > +             *len = entry.last - iova + 1;
> > +             addr = mmap(0, size, perm_to_prot(entry.perm), MAP_SHARED,
> > +                         fd, entry.offset);
> > +             close(fd);
> > +             if (addr == MAP_FAILED)
> > +                     return NULL;
> > +
> > +             /* do something to cache this iova region */
>
> How is userspace expected to manage iotlb mmaps? When should munmap(2)
> be called?
>

The simple way is using a list to store the iotlb mappings. And we
should call the munmap(2) for the old mappings when VDUSE_UPDATE_IOTLB
or VDUSE_STOP_DATAPLANE message is received.

> Should userspace expect VDUSE_IOTLB_GET_FD to return a full chunk of
> guest RAM (e.g. multiple gigabytes) that can be cached permanently or
> will it return just enough pages to cover [start, last)?
>

It should return one iotlb mapping that covers [start, last). In
vhost-vdpa cases, it might be a full chunk of guest RAM. In
virtio-vdpa cases, it might be the whole bounce buffer or one coherent
mapping (produced by dma_alloc_coherent()).

> > +
> > +             return addr + iova - entry.start;
> > +     }
> > +
> > +- VDUSE_DEV_GET_FEATURES: Get the negotiated features
>
> Are these VIRTIO feature bits? Please explain how feature negotiation
> works. There must be a way for userspace to report the device's
> supported feature bits to the kernel.
>

Yes, these are VIRTIO feature bits. Userspace will specify the
device's supported feature bits when creating a new VDUSE device with
ioctl(VDUSE_CREATE_DEV).

> > +- VDUSE_DEV_UPDATE_CONFIG: Update the configuration space and inject a config interrupt
>
> Does this mean the contents of the configuration space are cached by
> VDUSE?

Yes, but the kernel will also store the same contents.

> The downside is that the userspace code cannot generate the
> contents on demand. Most devices doin't need to generate the contents
> on demand, so I think this is okay but I had expected a different
> interface:
>
> kernel->userspace VDUSE_DEV_GET_CONFIG
> userspace->kernel VDUSE_DEV_INJECT_CONFIG_IRQ
>

The problem is how to handle the failure of VDUSE_DEV_GET_CONFIG. We
will need lots of modification of virtio codes to support that. So to
make it simple, we choose this way:

userspace -> kernel VDUSE_DEV_SET_CONFIG
userspace -> kernel VDUSE_DEV_INJECT_CONFIG_IRQ

> I think you can leave it the way it is, but I wanted to mention this in
> case someone thinks it's important to support generating the contents of
> the configuration space on demand.
>

Sorry, I didn't get you here. Can't VDUSE_DEV_SET_CONFIG and
VDUSE_DEV_INJECT_CONFIG_IRQ achieve that?

> > +- VDUSE_VQ_GET_INFO: Get the specified virtqueue's metadata
> > +
> > +- VDUSE_VQ_SETUP_KICKFD: set the kickfd for virtqueue, this eventfd is used
> > +  by VDUSE kernel module to notify userspace to consume the vring.
> > +
> > +- VDUSE_INJECT_VQ_IRQ: inject an interrupt for specific virtqueue
>
> This information is useful but it's not enough to be able to implement a
> userspace device. Please provide more developer documentation or at
> least refer to uapi header files, published documents, etc that contain
> the details.

OK, I will try to add more details.

Thanks,
Yongji
