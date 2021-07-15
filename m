Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12583C999F
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 09:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240351AbhGOHat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 03:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhGOHas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 03:30:48 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9264CC061760
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 00:27:55 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t2so6349492edd.13
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 00:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=L+GvG4BW3JzxGRDoqnLBh8mB24jj3SCUoThAPlf4t6A=;
        b=G1d2azmPj/vOtCOIxVaYYEao+BiumoYpk13OAtMYOUXvXExUUHLznnBxdUujwi9iZQ
         U5lsmFHD3ZHMwbR2MDyID4zUx/wafUxUOaWt030D94wdCGwWyxhjJWyCG8PFkbCTYBFa
         A2juM3nvHvqNynbTSCY8kB9PF+oP45pqpqYX582jsXbihTkor7haiKEBPJA2Ru4v6ouT
         ZNXbfsX1VINCU5Ac/HAmcm0nFjDqkva8403+wwrOtKyvOV9dLa0DIKdbMTwy+j9SZ+nJ
         dWP8b70ElChgV7WWdoXyGyM85hqUBKvUnXQESzC9HF7XWv4dmUApCEEzN19X1dGTq5Es
         iL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L+GvG4BW3JzxGRDoqnLBh8mB24jj3SCUoThAPlf4t6A=;
        b=d2/4tXhuvBnecT91goiZOn//7EsYB6WhiHAkvAmVJapvLhYvw7o5JmxmMZ1b6jkyfZ
         3jTv7ugTabwvB5jeQsaupFNzrYB7M0ML9nbefevYgozAqErrS7HyJZH+j1A2poyP4j5m
         kOsqEkMuwnjZxQT93AhbtyUbluxZSRaN0/kt+RnmLGqihQBww4kDU3EXktWgr8whtcCG
         V8xgM+OZ8s0+Z9BKgkfA9/GS2X09Wm9bivAJWdsvnRj9S4CMw5Qej8WhIVAJ8BXZSlBI
         8LQmm+jodXSMBjDoWb90w1UDLSow6EClpN/xfJNxIIp5RdPm85pfpz6H35j1YEkk/KFO
         XYdg==
X-Gm-Message-State: AOAM532u1ywK13qHH7ctbGEKowrfcgWYTrjt1q6xwzj7iJMHukV51oIA
        MDeF8YVyyfcmKUVPpZ/Jn5fNfFqcf1gSzGNSEbyD9dHPTw==
X-Google-Smtp-Source: ABdhPJyu8g0gIBvYN01eKpBo5CvHczS6LvlCxtkDDJ6sv9MF0OKGgLbNXSHluXIma5XTC0NxlS3FXXbxlaiA9X925B4=
X-Received: by 2002:a50:ef09:: with SMTP id m9mr4805420eds.118.1626334074003;
 Thu, 15 Jul 2021 00:27:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210713084656.232-1-xieyongji@bytedance.com> <20210713084656.232-18-xieyongji@bytedance.com>
 <e8f25a35-9d45-69f9-795d-bdbbb90337a3@redhat.com>
In-Reply-To: <e8f25a35-9d45-69f9-795d-bdbbb90337a3@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 15 Jul 2021 15:27:43 +0800
Message-ID: <CACycT3u0WbUjPsYXzqQs=bR7pBtdOk7NzDM88fHkqEzVs1tsPQ@mail.gmail.com>
Subject: Re: [PATCH v9 17/17] Documentation: Add documentation for VDUSE
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
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
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 1:18 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/7/13 =E4=B8=8B=E5=8D=884:46, Xie Yongji =E5=86=99=E9=81=93=
:
> > VDUSE (vDPA Device in Userspace) is a framework to support
> > implementing software-emulated vDPA devices in userspace. This
> > document is intended to clarify the VDUSE design and usage.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   Documentation/userspace-api/index.rst |   1 +
> >   Documentation/userspace-api/vduse.rst | 248 +++++++++++++++++++++++++=
+++++++++
> >   2 files changed, 249 insertions(+)
> >   create mode 100644 Documentation/userspace-api/vduse.rst
> >
> > diff --git a/Documentation/userspace-api/index.rst b/Documentation/user=
space-api/index.rst
> > index 0b5eefed027e..c432be070f67 100644
> > --- a/Documentation/userspace-api/index.rst
> > +++ b/Documentation/userspace-api/index.rst
> > @@ -27,6 +27,7 @@ place where this information is gathered.
> >      iommu
> >      media/index
> >      sysfs-platform_profile
> > +   vduse
> >
> >   .. only::  subproject and html
> >
> > diff --git a/Documentation/userspace-api/vduse.rst b/Documentation/user=
space-api/vduse.rst
> > new file mode 100644
> > index 000000000000..2c0d56d4b2da
> > --- /dev/null
> > +++ b/Documentation/userspace-api/vduse.rst
> > @@ -0,0 +1,248 @@
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
> > +possible to implement software-emulated vDPA devices in userspace. And
> > +to make the device emulation more secure, the emulated vDPA device's
> > +control path is handled in the kernel and only the data path is
> > +implemented in the userspace.
> > +
> > +Note that only virtio block device is supported by VDUSE framework now=
,
> > +which can reduce security risks when the userspace process that implem=
ents
> > +the data path is run by an unprivileged user. The support for other de=
vice
> > +types can be added after the security issue of corresponding device dr=
iver
> > +is clarified or fixed in the future.
> > +
> > +Start/Stop VDUSE devices
> > +------------------------
> > +
> > +VDUSE devices are started as follows:
>
>
> Not native speaker but "created" is probably better.
>

How about using "added"?

>
> > +
> > +1. Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
> > +   /dev/vduse/control.
> > +
> > +2. Setup each virtqueue with ioctl(VDUSE_VQ_SETUP) on /dev/vduse/$NAME=
.
> > +
> > +3. Begin processing VDUSE messages from /dev/vduse/$NAME. The first
> > +   messages will arrive while attaching the VDUSE instance to vDPA bus=
.
> > +
> > +4. Send the VDPA_CMD_DEV_NEW netlink message to attach the VDUSE
> > +   instance to vDPA bus.
>
>
> I think 4 should be done before 3?
>

VDPA_CMD_DEV_NEW netlink message should be done after userspace
listens to /dev/vduse/$NAME. Otherwise, the messages would be hung.

>
> > +
> > +VDUSE devices are stopped as follows:
>
>
> "removed" or "destroyed" is better than "stopped" here.
>

"removed" looks better?

>
> > +
> > +1. Send the VDPA_CMD_DEV_DEL netlink message to detach the VDUSE
> > +   instance from vDPA bus.
> > +
> > +2. Close the file descriptor referring to /dev/vduse/$NAME.
> > +
> > +3. Destroy the VDUSE instance with ioctl(VDUSE_DESTROY_DEV) on
> > +   /dev/vduse/control.
> > +
> > +The netlink messages can be sent via vdpa tool in iproute2 or use the
> > +below sample codes:
> > +
> > +.. code-block:: c
> > +
> > +     static int netlink_add_vduse(const char *name, enum vdpa_command =
cmd)
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
, 0, cmd, 0))
> > +                     goto nla_put_failure;
> > +
> > +             NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
> > +             if (cmd =3D=3D VDPA_CMD_DEV_NEW)
> > +                     NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "=
vduse");
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
> > +As mentioned above, a VDUSE device is created by ioctl(VDUSE_CREATE_DE=
V) on
> > +/dev/vduse/control. With this ioctl, userspace can specify some basic =
configuration
> > +such as device name (uniquely identify a VDUSE device), virtio feature=
s, virtio
> > +configuration space, bounce buffer size
>
>
> This bounce buffer size looks questionable. We'd better not expose any
> implementation details to userspace.
>
> I think we can simply start with a module parameter for VDUSE?
>

Looks good to me.

>
> >   and so on for this emulated device. Then
> > +a char device interface (/dev/vduse/$NAME) is exported to userspace fo=
r device
> > +emulation. Userspace can use the VDUSE_VQ_SETUP ioctl on /dev/vduse/$N=
AME to
> > +add per-virtqueue configuration such as the max size of virtqueue to t=
he device.
> > +
> > +After the initialization, the VDUSE device can be attached to vDPA bus=
 via
> > +the VDPA_CMD_DEV_NEW netlink message. Userspace needs to read()/write(=
) on
> > +/dev/vduse/$NAME to receive/reply some control messages from/to VDUSE =
kernel
> > +module as follows:
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
>
>
> "messages"?
>

OK.

>
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
> > +There are now three types of messages introduced by VDUSE framework:
> > +
> > +- VDUSE_GET_VQ_STATE: Get the state for virtqueue, userspace should re=
turn
> > +  avail index for split virtqueue or the device/driver ring wrap count=
ers and
> > +  the avail and used index for packed virtqueue.
> > +
> > +- VDUSE_SET_STATUS: Set the device status, userspace should follow
> > +  the virtio spec: https://docs.oasis-open.org/virtio/virtio/v1.1/virt=
io-v1.1.html
> > +  to process this message. For example, fail to set the FEATURES_OK de=
vice
> > +  status bit if the device can not accept the negotiated virtio featur=
es
> > +  get from the VDUSE_GET_FEATURES ioctl.
> > +
> > +- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping fo=
r specified
> > +  IOVA range, userspace should firstly remove the old mapping, then se=
tup the new
> > +  mapping via the VDUSE_IOTLB_GET_FD ioctl.
> > +
> > +After DRIVER_OK status bit is set via the VDUSE_SET_STATUS message, us=
erspace is
> > +able to start the dataplane processing with the help of below ioctls:
> > +
> > +- VDUSE_IOTLB_GET_FD: Find the first IOVA region that overlaps with th=
e specified
> > +  range [start, last] and return the corresponding file descriptor. In=
 vhost-vdpa
> > +  cases, it might be a full chunk of guest RAM. And in virtio-vdpa cas=
es, it should
> > +  be the whole bounce buffer or the memory region that stores one virt=
queue's
> > +  metadata (descriptor table, available ring and used ring).
>
>
> I think we can simply remove the driver specific sentences. And just say
> to use map the pages to the IOVA.
>

OK.

>
> > Userspace can access
> > +  this IOVA region by passing fd and corresponding size, offset, perm =
to mmap().
> > +  For example:
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
> > +             entry.last =3D iova;
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
> > +             /*
> > +              * Using some data structures such as linked list to stor=
e
> > +              * the iotlb mapping. The munmap(2) should be called for =
the
> > +              * cached mapping when the corresponding VDUSE_UPDATE_IOT=
LB
> > +              * message is received or the device is reset.
> > +              */
> > +
> > +             return addr + iova - entry.start;
> > +     }
> > +
> > +- VDUSE_VQ_GET_INFO: Get the specified virtqueue's information includi=
ng the size,
> > +  the IOVAs of descriptor table, available ring and used ring, the sta=
te
> > +  and the ready status.
>
>
> Maybe it's better just show the  vduse_vq_info here, or both. (maybe we
> can do the same for the rest of ioctls).
>

The struct vduse_vq_info and more details can be found in
include/uapi/linux/vduse.h. I just want to simply describe what the
ioctl does here.

>
> > The IOVAs should be passed to the VDUSE_IOTLB_GET_FD ioctl
> > +  so that userspace can access the descriptor table, available ring an=
d used ring.
> > +
> > +- VDUSE_VQ_SETUP_KICKFD: Setup the kick eventfd for the specified virt=
queues.
> > +  The kick eventfd is used by VDUSE kernel module to notify userspace =
to consume
> > +  the available ring.
> > +
> > +- VDUSE_INJECT_VQ_IRQ: Inject an interrupt for specific virtqueue. It'=
s used to
> > +  notify virtio driver to consume the used ring.
>
>
> The config interrupt injection is missed.
>

Since the config interrupt is not related to dataplane processing, I
didn't write it here. Do you think we need to add it? Users can refer
to include/uapi/linux/vduse.h to know that.

>
> > +
> > +More details on the uAPI can be found in include/uapi/linux/vduse.h.
> > +
> > +MMU-based IOMMU Driver
> > +----------------------
> > +
>
>
> It's kind of software IOTLB actually. Maybe we can call that "MMU-based
> software IOTLB"
>

Looks good to me.

>
> > +VDUSE framework implements an MMU-based on-chip IOMMU driver to suppor=
t
> > +mapping the kernel DMA buffer into the userspace IOVA region dynamical=
ly.
> > +This is mainly designed for virtio-vdpa case (kernel virtio drivers).
> > +
> > +The basic idea behind this driver is treating MMU (VA->PA) as IOMMU (I=
OVA->PA).
> > +The driver will set up MMU mapping instead of IOMMU mapping for the DM=
A transfer
> > +so that the userspace process is able to use its virtual address to ac=
cess
> > +the DMA buffer in kernel.
> > +
> > +And to avoid security issue, a bounce-buffering mechanism is introduce=
d to
> > +prevent userspace accessing the original buffer directly which may con=
tain other
> > +kernel data.
>
>
> I wonder if it's worth to describe the method we used for guarding
> against malicious userspace device.
>

I can add it to the commit log or the source file instead.

Thanks,
Yongji
