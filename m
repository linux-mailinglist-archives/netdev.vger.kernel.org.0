Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C344532D0EC
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 11:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbhCDKgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 05:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238776AbhCDKfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 05:35:55 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF9EC06175F
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 02:35:15 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id d13so29075907edp.4
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 02:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=13pRJm2U7Qqc8F9qRjqfsDkKUIYvnnbBQbaolObg0q8=;
        b=AZtMAjdXY//iyWTmLxk0j7cOQAlyWKNBrh3ejJbnk9TUwqtZTe598NEFSvxvlLcJn9
         4AYPqCUGzzyA/E4xI3BlzeSYPnra4K6vxLHHs2K0cBNxurgCw2Br9lp8dR8hf79/2fxn
         dufdO9CO/Ps9ke3cfkni694EKtxvfa+Fj1eJRmaM4VLKk85tNwSzZ6R1T0a/7YLJqINt
         gnNMNnDfY3TZLOYJx9H7PD1raw4/CVQc4wRnb+qJ9ucq8u7kTwkAQVFXhPC5XvGlpElY
         x+EQdNVFlFnB33ZFc4nzUyGMWi/AMFy/5myzYMRwEk+07fysdMJZFy9Zr2tD+DkFkyBZ
         Dc0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=13pRJm2U7Qqc8F9qRjqfsDkKUIYvnnbBQbaolObg0q8=;
        b=WMYveI7bPoO7FnTy59A2i4ycFv7nzC7wG21wSQXgcFra1E0jR+bcAHGjKFsFFhH53Q
         yQ7KURtTprjmI0uX3Cu3q4bUBCmLumFl2LFefwbNUS0tdtNlMyXh38ELiVEYdMr/INRS
         T2CllmeepCRpmDgtapmXJJN+wiswzu7Y+iAi5qN8LOUOjkhoe0R0vGZRsF/X0/4k6102
         gp81Bb9tijioHtxSGd/TfCFgNbOJ3HkZf3p55qScYpWTm6yGynhQKQPA7vT613UAd27t
         vPFibUL+6mPaQWaRPNWTyLNtTWMbisWtQo/h0qvXsk8xLRhWW7HSqsjmUCOboNK6aU3f
         dvPw==
X-Gm-Message-State: AOAM5305qTQO2EuWl6tzww4Q+I0Zy+LBSDZPkpwER3FJshs8QNBLUvEJ
        1ahgbkkIfdtfRY/cH1yw7I/UC1yX305FUfMeYOCm
X-Google-Smtp-Source: ABdhPJyD011kYY+HKgFkmf0rSBAIy7U69faBXx9uGl7Gx818AoP3kpEtIvHyyz6wUVmsWr2aBzKkLIZfV+QLw4I9FS8=
X-Received: by 2002:a05:6402:4314:: with SMTP id m20mr3456223edc.5.1614854113728;
 Thu, 04 Mar 2021 02:35:13 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-10-xieyongji@bytedance.com>
 <366f2dcf-51ab-4d66-9c94-517349ef0bdd@redhat.com>
In-Reply-To: <366f2dcf-51ab-4d66-9c94-517349ef0bdd@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 4 Mar 2021 18:35:03 +0800
Message-ID: <CACycT3tvj6Hie1bjnprenhevkGC-hknPGOrsfmY6TLxFYBXNxA@mail.gmail.com>
Subject: Re: Re: [RFC v4 09/11] Documentation: Add documentation for VDUSE
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 4, 2021 at 2:40 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> > VDUSE (vDPA Device in Userspace) is a framework to support
> > implementing software-emulated vDPA devices in userspace. This
> > document is intended to clarify the VDUSE design and usage.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   Documentation/userspace-api/index.rst |   1 +
> >   Documentation/userspace-api/vduse.rst | 112 +++++++++++++++++++++++++=
+++++++++
> >   2 files changed, 113 insertions(+)
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
> > index 000000000000..2a20e686bb59
> > --- /dev/null
> > +++ b/Documentation/userspace-api/vduse.rst
> > @@ -0,0 +1,112 @@
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
>
>
> It's better to mention that in order to le thte device to be registered
> on the bus, admin need to use the management API(netlink) to create the
> vDPA device.
>
> Some codes to demnonstrate how to create the device will be better.
>

OK.

>
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
> > +             resp.request_id =3D req.unique;
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
> > +In the deta path, vDPA device's iova regions will be mapped into users=
pace
> > +with the help of VDUSE_IOTLB_GET_FD ioctl on the VDUSE device file:
> > +
> > +- VDUSE_IOTLB_GET_FD: get the file descriptor to iova region. Userspac=
e can
> > +  access this iova region by passing the fd to mmap().
>
>
> It would be better to have codes to explain how it is expected to work he=
re.
>

OK.

>
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
> > +MMU-based IOMMU Driver
> > +----------------------
> > +In virtio-vdpa case, VDUSE framework implements an MMU-based on-chip I=
OMMU
> > +driver to support mapping the kernel DMA buffer into the userspace iov=
a
> > +region dynamically.
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
> It's worth to mention this is designed for virtio-vdpa (kernel virtio
> drivers).
>

Will do it.

Thanks,
Yongji
