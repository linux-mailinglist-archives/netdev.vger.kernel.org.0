Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE27357DC9
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 10:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhDHIJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 04:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhDHIJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 04:09:41 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F5BC061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 01:09:29 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w18so1350153edc.0
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 01:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j2HelfyDv0B9WCGbpY62g0IA7XA6d7qbEBxA9DU2nD0=;
        b=mqxWErVM9oTuMzJRJA5DXx9POY5vTN5mdVXTI3nqS7U6ccJKnahOIsVEkMVt51mh0v
         TptkGqoTlGZ6Tyup41NgPmy6isjsfC+vCqp8Lp95mseug2rScVkQJoZdz7lQlEJdk7/j
         y6JsUIZZ0Uw0RFJN4czpWrSK4Ot5DdCDZ0FT6GH+usrvqPPoiEHbLVhRJRAdmWpzOUvV
         npuNbLLZFvmXo1LLCJDn5qpGxbAwGRKHtzTYjZAC/dM0yM8KUv9qhfreUM3M+RRrXGD7
         kE3Uct370kO5N8p804YduIkv6KRbSfpbN2xSNAJGiPMqp3TLvcp0pM6zG1Aex7cAyOjf
         qWPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j2HelfyDv0B9WCGbpY62g0IA7XA6d7qbEBxA9DU2nD0=;
        b=msTbeSHrD+L3m2zil1i4mm1+CEPD2vimYJbcusj4c6qgKa9KhVOoSnaG7x395Rwb65
         wed6d2JPPgpLH+G0WfwOXdozRPHoH/A2z2uYTbEP1Btgxndg98orKbzq5O72EQeQSKGV
         uYEsV4ss1OCeBEUR09DxfmToyzj6IxQaHoqZTw0919F7WhsBPKoVOLEjG+zrIXLsvgR2
         6NvWuDIPLL804gc/nrVM1Kchsq99VEhO90WOYc5Yh5hG94vMOINh7rZUyd25OWQarJWV
         AQEZoVir40unmIVteBKja+MJze1J3UQj2edKAvivu6hO93wwDNWxoa3gVBacNlo5iiEq
         LA4Q==
X-Gm-Message-State: AOAM5334laZyBRu8rdFsYu5xahvmzm4zMHEFrowC3S33fNPK8AzMLrql
        8AaJLPGfMxU479p8fUZqhhOp0N6KMEQ3ftSP9kng
X-Google-Smtp-Source: ABdhPJwXiAzLfojL6u8jjCURZWBzUGV4pnwYa4X4D38+BLrV0Nz3PyKq599ThjBv8dW8JKXQIOfBLoEMu2zAYvNqGms=
X-Received: by 2002:a05:6402:278c:: with SMTP id b12mr2809345ede.145.1617869368228;
 Thu, 08 Apr 2021 01:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-11-xieyongji@bytedance.com>
 <b3d97ee2-5c8c-2568-20ab-7e9ce51c4e72@redhat.com>
In-Reply-To: <b3d97ee2-5c8c-2568-20ab-7e9ce51c4e72@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 8 Apr 2021 16:09:17 +0800
Message-ID: <CACycT3t5NSRdsMVOfeYVKN6hV5-xVAnSKOhqQRTj=oCvc1PRvA@mail.gmail.com>
Subject: Re: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 8, 2021 at 3:18 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/31 =E4=B8=8B=E5=8D=884:05, Xie Yongji =E5=86=99=E9=81=93=
:
> > VDUSE (vDPA Device in Userspace) is a framework to support
> > implementing software-emulated vDPA devices in userspace. This
> > document is intended to clarify the VDUSE design and usage.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   Documentation/userspace-api/index.rst |   1 +
> >   Documentation/userspace-api/vduse.rst | 212 +++++++++++++++++++++++++=
+++++++++
> >   2 files changed, 213 insertions(+)
> >   create mode 100644 Documentation/userspace-api/vduse.rst
> >
> > diff --git a/Documentation/userspace-api/index.rst b/Documentation/user=
space-api/index.rst
> > index acd2cc2a538d..f63119130898 100644
> > --- a/Documentation/userspace-api/index.rst
> > +++ b/Documentation/userspace-api/index.rst
> > @@ -24,6 +24,7 @@ place where this information is gathered.
> >      ioctl/index
> >      iommu
> >      media/index
> > +   vduse
> >
> >   .. only::  subproject and html
> >
> > diff --git a/Documentation/userspace-api/vduse.rst b/Documentation/user=
space-api/vduse.rst
> > new file mode 100644
> > index 000000000000..8c4e2b2df8bb
> > --- /dev/null
> > +++ b/Documentation/userspace-api/vduse.rst
> > @@ -0,0 +1,212 @@
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +VDUSE - "vDPA Device in Userspace"
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +vDPA (virtio data path acceleration) device is a device that uses a
> > +datapath which complies with the virtio specifications with vendor
> > +specific control path. vDPA devices can be both physically located on
> > +the hardware or emulated by software. VDUSE is a framework that makes =
it
> > +possible to implement software-emulated vDPA devices in userspace.
> > +
> > +How VDUSE works
> > +------------
> > +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl on
> > +the character device (/dev/vduse/control). Then a device file with the
> > +specified name (/dev/vduse/$NAME) will appear, which can be used to
> > +implement the userspace vDPA device's control path and data path.
> > +
> > +To implement control path, a message-based communication protocol and =
some
> > +types of control messages are introduced in the VDUSE framework:
> > +
> > +- VDUSE_SET_VQ_ADDR: Set the vring address of virtqueue.
> > +
> > +- VDUSE_SET_VQ_NUM: Set the size of virtqueue
> > +
> > +- VDUSE_SET_VQ_READY: Set ready status of virtqueue
> > +
> > +- VDUSE_GET_VQ_READY: Get ready status of virtqueue
> > +
> > +- VDUSE_SET_VQ_STATE: Set the state for virtqueue
> > +
> > +- VDUSE_GET_VQ_STATE: Get the state for virtqueue
> > +
> > +- VDUSE_SET_FEATURES: Set virtio features supported by the driver
> > +
> > +- VDUSE_GET_FEATURES: Get virtio features supported by the device
> > +
> > +- VDUSE_SET_STATUS: Set the device status
> > +
> > +- VDUSE_GET_STATUS: Get the device status
> > +
> > +- VDUSE_SET_CONFIG: Write to device specific configuration space
> > +
> > +- VDUSE_GET_CONFIG: Read from device specific configuration space
> > +
> > +- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping in=
 device IOTLB
> > +
> > +Those control messages are mostly based on the vdpa_config_ops in
> > +include/linux/vdpa.h which defines a unified interface to control
> > +different types of vdpa device. Userspace needs to read()/write()
> > +on the VDUSE device file to receive/reply those control messages
> > +from/to VDUSE kernel module as follows:
> > +
> > +.. code-block:: c
> > +
> > +     static int vduse_message_handler(int dev_fd)
> > +     {
> > +             int len;
> > +             struct vduse_dev_request req;
> > +             struct vduse_dev_response resp;
> > +
> > +             len =3D read(dev_fd, &req, sizeof(req));
> > +             if (len !=3D sizeof(req))
> > +                     return -1;
> > +
> > +             resp.request_id =3D req.request_id;
> > +
> > +             switch (req.type) {
> > +
> > +             /* handle different types of message */
> > +
> > +             }
> > +
> > +             len =3D write(dev_fd, &resp, sizeof(resp));
> > +             if (len !=3D sizeof(resp))
> > +                     return -1;
> > +
> > +             return 0;
> > +     }
> > +
> > +In the data path, vDPA device's iova regions will be mapped into users=
pace
> > +with the help of VDUSE_IOTLB_GET_FD ioctl on the VDUSE device file:
> > +
> > +- VDUSE_IOTLB_GET_FD: get the file descriptor to the first overlapped =
iova region.
> > +  Userspace can access this iova region by passing fd and correspondin=
g size, offset,
> > +  perm to mmap(). For example:
> > +
> > +.. code-block:: c
> > +
> > +     static int perm_to_prot(uint8_t perm)
> > +     {
> > +             int prot =3D 0;
> > +
> > +             switch (perm) {
> > +             case VDUSE_ACCESS_WO:
> > +                     prot |=3D PROT_WRITE;
> > +                     break;
> > +             case VDUSE_ACCESS_RO:
> > +                     prot |=3D PROT_READ;
> > +                     break;
> > +             case VDUSE_ACCESS_RW:
> > +                     prot |=3D PROT_READ | PROT_WRITE;
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
> > +             entry.start =3D iova;
> > +             entry.last =3D iova + 1;
> > +             fd =3D ioctl(dev_fd, VDUSE_IOTLB_GET_FD, &entry);
> > +             if (fd < 0)
> > +                     return NULL;
> > +
> > +             size =3D entry.last - entry.start + 1;
> > +             *len =3D entry.last - iova + 1;
> > +             addr =3D mmap(0, size, perm_to_prot(entry.perm), MAP_SHAR=
ED,
> > +                         fd, entry.offset);
> > +             close(fd);
> > +             if (addr =3D=3D MAP_FAILED)
> > +                     return NULL;
> > +
> > +             /* do something to cache this iova region */
> > +
> > +             return addr + iova - entry.start;
> > +     }
> > +
> > +Besides, the following ioctls on the VDUSE device file are provided to=
 support
> > +interrupt injection and setting up eventfd for virtqueue kicks:
> > +
> > +- VDUSE_VQ_SETUP_KICKFD: set the kickfd for virtqueue, this eventfd is=
 used
> > +  by VDUSE kernel module to notify userspace to consume the vring.
> > +
> > +- VDUSE_INJECT_VQ_IRQ: inject an interrupt for specific virtqueue
> > +
> > +- VDUSE_INJECT_CONFIG_IRQ: inject a config interrupt
> > +
> > +Register VDUSE device on vDPA bus
> > +---------------------------------
> > +In order to make the VDUSE device work, administrator needs to use the=
 management
> > +API (netlink) to register it on vDPA bus. Some sample codes are show b=
elow:
> > +
> > +.. code-block:: c
> > +
> > +     static int netlink_add_vduse(const char *name, int device_id)
> > +     {
> > +             struct nl_sock *nlsock;
> > +             struct nl_msg *msg;
> > +             int famid;
> > +
> > +             nlsock =3D nl_socket_alloc();
> > +             if (!nlsock)
> > +                     return -ENOMEM;
> > +
> > +             if (genl_connect(nlsock))
> > +                     goto free_sock;
> > +
> > +             famid =3D genl_ctrl_resolve(nlsock, VDPA_GENL_NAME);
> > +             if (famid < 0)
> > +                     goto close_sock;
> > +
> > +             msg =3D nlmsg_alloc();
> > +             if (!msg)
> > +                     goto close_sock;
> > +
> > +             if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, famid, 0=
, 0,
> > +                 VDPA_CMD_DEV_NEW, 0))
> > +                     goto nla_put_failure;
> > +
> > +             NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
> > +             NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "vduse");
> > +             NLA_PUT_U32(msg, VDPA_ATTR_DEV_ID, device_id);
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
>
>
> Let's also explain this can be done via vdpa tool in iproute2 as well.
>

Sure.

Thanks,
Yongji
