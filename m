Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDD03DE8EC
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 10:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbhHCIwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 04:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234487AbhHCIwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 04:52:23 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D258CC061764
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 01:52:12 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id cf5so16502190edb.2
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 01:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yNVHfomn1+7EeD9B5QlHFpydoWXL8UTDlRD2Gz6lLm4=;
        b=W0MTWrHDNl+PRjXzBtO9//AT8bfTt0UGPAHtUfBNteJlLivBgLI3a3M0Cm6JfHl6EU
         OzC+TGexcu64OQ0IP3USZrqt2WiDlFnE3x853FdQ3WR9WB4jRQw/jYSdkoofkjW2qDU3
         j58nWRiHEPc+e52N0nWvgyhMZhyAMe7deX8EcVEhLUoh4nAqTBSQO688xMWgma06sg/a
         33OeapUYYq8j1XteBpboom94lgmjToIStbqrTzJdFXzT3azY/Zuaq+3TI8dS3w7cS6uf
         7W5dKidG7EeuuBKAOhfmGL49foVg2UwnrUwNzB+zkgtIL7M7E83x3xOceSwH5iUf4oNA
         WW4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yNVHfomn1+7EeD9B5QlHFpydoWXL8UTDlRD2Gz6lLm4=;
        b=Qy/UM7ZkTF9y7r54TGExVu/sTZRzqyqFmBR0W8QgsG/sEQMk87PBuAwpoY4s/qgppD
         Q6KaLhWrl8YDdk+v6VqOq3EdBriYH7k/nHOKzTUk8J1W7MqKXw3/d1q4MxqY1Aw9TUnG
         REWeSeDzSnJMLMfuG6RU7OAJCvB650Vgq+NuMwGyTpNaC00mQutWmPQZFrFARQYdRY6p
         CDgbk1bIEvEBZnAj9JrOfBS6Jirf5r1kRZqeoRv+tdVzoqrqKfkbEEnyAHkjV0gKN8h2
         qyAX16mNYrUnCFmAZciwzpzJtYpxfsUN4NB+fSr84JmPTxug7OiMFB5k44kGyou5Y9ZS
         ln0Q==
X-Gm-Message-State: AOAM531BFXwjbcwPZ43ZzO+eknrqL8XSvMnwdcvLh7Q6dRGG4TRnyxDl
        uAK+R2PCObNWyO1VEnSmF5aNUjrKYiBFiPOIfaeq
X-Google-Smtp-Source: ABdhPJzP3mqKMcinlyFQCqeLKP6E0gKZq9ZubV8wxKczwvyn7WhW7EmyF4LbdLIGRxNOj8q+vmW+CnwGpcs0ZzKpngc=
X-Received: by 2002:a05:6402:74f:: with SMTP id p15mr23885429edy.195.1627980731381;
 Tue, 03 Aug 2021 01:52:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210729073503.187-1-xieyongji@bytedance.com> <20210729073503.187-18-xieyongji@bytedance.com>
 <05365f36-bc3a-40f4-764d-37a7249b94b1@redhat.com>
In-Reply-To: <05365f36-bc3a-40f4-764d-37a7249b94b1@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 3 Aug 2021 16:52:00 +0800
Message-ID: <CACycT3uwBy3HY4at-d8Hg2v4ciSWLkhFU5Sk4AxzjbvNEY9mCg@mail.gmail.com>
Subject: Re: [PATCH v10 17/17] Documentation: Add documentation for VDUSE
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
        Joe Perches <joe@perches.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 3:35 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/7/29 =E4=B8=8B=E5=8D=883:35, Xie Yongji =E5=86=99=E9=81=93=
:
> > VDUSE (vDPA Device in Userspace) is a framework to support
> > implementing software-emulated vDPA devices in userspace. This
> > document is intended to clarify the VDUSE design and usage.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   Documentation/userspace-api/index.rst |   1 +
> >   Documentation/userspace-api/vduse.rst | 232 +++++++++++++++++++++++++=
+++++++++
> >   2 files changed, 233 insertions(+)
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
> > index 000000000000..30c9d1482126
> > --- /dev/null
> > +++ b/Documentation/userspace-api/vduse.rst
> > @@ -0,0 +1,232 @@
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
> > +Create/Destroy VDUSE devices
> > +------------------------
> > +
> > +VDUSE devices are created as follows:
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
> > +
> > +VDUSE devices are destroyed as follows:
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
> > +configuration space, the number of virtqueues and so on for this emula=
ted device.
> > +Then a char device interface (/dev/vduse/$NAME) is exported to userspa=
ce for device
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
> > +             /* handle different types of messages */
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
> > +  get from the VDUSE_DEV_GET_FEATURES ioctl.
>
>
> I wonder if it's better to add a section about the future work?
>
> E.g the support for the userspace device to modify status (like
> NEEDS_RESET).
>

I prefer to document it after we add this new feature.

>
> > +
> > +- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping fo=
r specified
> > +  IOVA range, userspace should firstly remove the old mapping, then se=
tup the new
> > +  mapping via the VDUSE_IOTLB_GET_FD ioctl.
> > +
> > +After DRIVER_OK status bit is set via the VDUSE_SET_STATUS message, us=
erspace is
> > +able to start the dataplane processing as follows:
> > +
> > +1. Get the specified virtqueue's information with the VDUSE_VQ_GET_INF=
O ioctl,
> > +   including the size, the IOVAs of descriptor table, available ring a=
nd used ring,
> > +   the state and the ready status.
> > +
> > +2. Pass the above IOVAs to the VDUSE_IOTLB_GET_FD ioctl so that those =
IOVA regions
> > +   can be mapped into userspace. Some sample codes is shown below:
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
> > +
> > +             /*
> > +              * Find the first IOVA region that overlaps with the spec=
ified
> > +              * range [start, last] and return the corresponding file =
descriptor.
> > +              */
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
> > +3. Setup the kick eventfd for the specified virtqueues with the VDUSE_=
VQ_SETUP_KICKFD
> > +   ioctl. The kick eventfd is used by VDUSE kernel module to notify us=
erspace to
> > +   consume the available ring.
> > +
> > +4. Listen to the kick eventfd and consume the available ring. The buff=
er described
> > +   by the descriptors in the descriptor table should be also mapped in=
to userspace
> > +   via the VDUSE_IOTLB_GET_FD ioctl before accessing.
>
>
> (Or userspace may poll the indices instead, the kick eventfd is not a mus=
t).
>

OK, will add it.

Thanks,
Yongji
