Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488363601A6
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 07:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhDOFjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 01:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhDOFjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 01:39:13 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96A7C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 22:38:49 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r12so34960589ejr.5
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 22:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0P8H6IVO0dyZeIuAW8ZR9AtUyyvmCv4TuNxDO0wEaXg=;
        b=Cozl+eOcoIHhfqPao/zDDsnj09QM5xmTkX42nlL21Z+McOiFmPuiHjPlm6bBkKvtR9
         0hN7TYZ0QHLGchGplNr3sra/IYjSSc6BZHgSfYmR1GwIsx2uMh+qP/+4pBKWqSUG+C2i
         AzPq0SAKjsVdqjZFRdfFwIUKWij1DYVanHq9vVGRjv2xO2CoCw+PUO2IpVDo5pamBShu
         ayOKSEbtJIJMJYq8XBSACfBvP7bXj4iIjT1ButgixHGzZ6kkno+vuf+1sg6O4SMajbLb
         tLUrLic0+9r6q4ulZsaWvKgK6hryzU4JeA74NVUC5lXZie2tDntLJjA7j1C19vl3aWtI
         sUsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0P8H6IVO0dyZeIuAW8ZR9AtUyyvmCv4TuNxDO0wEaXg=;
        b=G/yQH2TD2deLD5xGJDT3XL8WjqifcBj/ryhcb5oB2aPdWSTD7ZgrItjhFreCpBXRJH
         AAFfp1F85VBx4MaabCIG9ffD6ihrgVkqnoOj43HIg6adTvTSKaLvnJSxlAn1GFY3C0kP
         a4/fRYQuJDaCCcPOishFczeCLrKjbk2xeh3I++tfzxRnFF+0D73dSHyR+9aRoON1rRpA
         GR4OEjBPe1cZOznYj2YhtHS19VoY62IoLZlLhWJvC0DZUpsTNQagRLZ6vuFPxQFFzOon
         zXJf/MTcVu4z0shL2GG+NK1lCB2dLwthzpYY2Om3fJWPMmEsrmAT9LAJs0oRM1psYHfW
         lmWQ==
X-Gm-Message-State: AOAM531vTeNxlSwCejQLplv5Ka5Og+ArfyzImw2COQs7VUXpZQERAQo7
        t0kNsYoVjoJh3Pytu49pGOXS5umbJccokDeDGT2u
X-Google-Smtp-Source: ABdhPJwh+G1vInvpEkrazgi/DM/Ms/uGskhRBZcYpBmxBBAn6v6bZ3KegJbGzHR85Tgp+jQCc8tQjRRKzWOR6kzbE9k=
X-Received: by 2002:a17:906:1a0d:: with SMTP id i13mr1567075ejf.197.1618465128395;
 Wed, 14 Apr 2021 22:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain>
In-Reply-To: <YHb44R4HyLEUVSTF@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 15 Apr 2021 13:38:37 +0800
Message-ID: <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
Subject: Re: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 10:15 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Wed, Mar 31, 2021 at 04:05:19PM +0800, Xie Yongji wrote:
> > VDUSE (vDPA Device in Userspace) is a framework to support
> > implementing software-emulated vDPA devices in userspace. This
> > document is intended to clarify the VDUSE design and usage.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >  Documentation/userspace-api/index.rst |   1 +
> >  Documentation/userspace-api/vduse.rst | 212 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 213 insertions(+)
> >  create mode 100644 Documentation/userspace-api/vduse.rst
>
> Just looking over the documentation briefly (I haven't studied the code
> yet)...
>

Thank you!

> > +How VDUSE works
> > +------------
> > +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl on
> > +the character device (/dev/vduse/control). Then a device file with the
> > +specified name (/dev/vduse/$NAME) will appear, which can be used to
> > +implement the userspace vDPA device's control path and data path.
>
> These steps are taken after sending the VDPA_CMD_DEV_NEW netlink
> message? (Please consider reordering the documentation to make it clear
> what the sequence of steps are.)
>

No, VDUSE devices should be created before sending the
VDPA_CMD_DEV_NEW netlink messages which might produce I/Os to VDUSE.

> > +     static int netlink_add_vduse(const char *name, int device_id)
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
> > +             if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, famid, 0, 0,
> > +                 VDPA_CMD_DEV_NEW, 0))
> > +                     goto nla_put_failure;
> > +
> > +             NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
> > +             NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "vduse");
> > +             NLA_PUT_U32(msg, VDPA_ATTR_DEV_ID, device_id);
>
> What are the permission/capability requirements for VDUSE?
>

Now I think we need privileged permission (root user). Because
userspace daemon is able to access avail vring, used vring, descriptor
table in kernel driver directly.

> How does VDUSE interact with namespaces?
>

Not sure I get your point here. Do you mean how the emulated vDPA
device interact with namespaces? This should work like hardware vDPA
devices do. VDUSE daemon can reside outside the namespace of a
container which uses the vDPA device.

> What is the meaning of VDPA_ATTR_DEV_ID? I don't see it in Linux
> v5.12-rc6 drivers/vdpa/vdpa.c:vdpa_nl_cmd_dev_add_set_doit().
>

It means the device id (e.g. VIRTIO_ID_BLOCK) of the vDPA device and
can be found in include/uapi/linux/vdpa.h.

> > +MMU-based IOMMU Driver
> > +----------------------
> > +VDUSE framework implements an MMU-based on-chip IOMMU driver to support
> > +mapping the kernel DMA buffer into the userspace iova region dynamically.
> > +This is mainly designed for virtio-vdpa case (kernel virtio drivers).
> > +
> > +The basic idea behind this driver is treating MMU (VA->PA) as IOMMU (IOVA->PA).
> > +The driver will set up MMU mapping instead of IOMMU mapping for the DMA transfer
> > +so that the userspace process is able to use its virtual address to access
> > +the DMA buffer in kernel.
> > +
> > +And to avoid security issue, a bounce-buffering mechanism is introduced to
> > +prevent userspace accessing the original buffer directly which may contain other
> > +kernel data. During the mapping, unmapping, the driver will copy the data from
> > +the original buffer to the bounce buffer and back, depending on the direction of
> > +the transfer. And the bounce-buffer addresses will be mapped into the user address
> > +space instead of the original one.
>
> Is mmap(2) the right interface if memory is not actually shared, why not
> just use pread(2)/pwrite(2) to make the copy explicit? That way the copy
> semantics are clear. For example, don't expect to be able to busy wait
> on the memory because changes will not be visible to the other side.
>
> (I guess I'm missing something here and that mmap(2) is the right
> approach, but maybe this documentation section can be clarified.)

It's for performance considerations on the one hand. We might need to
call pread(2)/pwrite(2) multiple times for each request. On the other
hand, we can handle the virtqueue in a unified way for both vhost-vdpa
case and virtio-vdpa case. Otherwise, userspace daemon needs to know
which iova ranges need to be accessed with pread(2)/pwrite(2). And in
the future, we might be able to avoid bouncing in some cases.

Thanks,
Yongji
