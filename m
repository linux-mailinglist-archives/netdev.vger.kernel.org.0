Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E613B9032
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 12:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbhGAKDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 06:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235868AbhGAKDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 06:03:33 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86968C0617AF
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 03:01:02 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t3so7556066edc.7
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 03:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qOYZNd8tzTZWQQ3iE/sKulUoLJ+DUUAeTlRapzbCzyo=;
        b=QSYlrD/MVr22v17jK2LXYkFKyNvXa0YtIYF3RTHJJ96XgQMn9ZdBpDSuIl776nTqDj
         ZZ8IuDUT4n9Ep52Xzk0RDkyrkzxv3JwMWXoKleEDDWHooUD5W5822cyOIET5JiCXulby
         JAjhI5jYtXrjjcp7gfS8T373fXHVCkGeU9EobRUUj9OfU40q1cl2Q1oOhWyFLAgM613K
         LgaOz8L+f1U86RJx/r7kggiyvlkMSVmZFE1SGzCnUuy3ZklwPNDYuX2wEZH7rwrej/td
         gwQZCuONr9oVPSL91ymdqJ9VOd2kslHupYAZuuskcnLB8gL++4dMAPNKxhu/UG51UU5U
         4xPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qOYZNd8tzTZWQQ3iE/sKulUoLJ+DUUAeTlRapzbCzyo=;
        b=DsN8wjo5RWhRcqO1agVYs9mzBST1KJluriO9Fsjf/uApqoOjWqAC/+/JsqzP9Dt8ys
         vu8kSABuLvj/TQ9kkp/8bbF4et/73K5ILVBwSWGGyYMygia6ZfchPRdfg7gVyyUzhJ7x
         DFlHCgPj3Ru0TudsRhxNvUxKGMYdmtgySa0NDBKhpAiXVOrI3/82F6sACWZ7o8wLxm0G
         vIvkssVYEjQzG456BUi7EHbtApoTxMl52lKaFzglWOwlRmFep+C/t+B9W2br34qgKQMP
         0vicxMY+VaVVCb9byln0shvt9eKjIgoxHVPthoZtqYtkJBzqd7Y3nW7iZuioIZL9JxJA
         WWvA==
X-Gm-Message-State: AOAM533zenBoyuOz4DvMK6oqWf0ec+FM3+Snk41osoNiSOtBSUaTYq41
        PsR8epeYp4Rlg31VxoJN2zlv+T1eAJfqLy50+JG6
X-Google-Smtp-Source: ABdhPJyVuZAS/8fRhn8JfTgP4stvjkAYWDbtWQVryrBZd8Z2Eh+Eo9sdOMWCKMsJZJcpoIcUAu683H7RRLEbnF1GDBs=
X-Received: by 2002:a05:6402:4243:: with SMTP id g3mr35275741edb.118.1625133660893;
 Thu, 01 Jul 2021 03:01:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-11-xieyongji@bytedance.com>
 <YNSCH6l31zwPxBjL@stefanha-x1.localdomain> <CACycT3uxnQmXWsgmNVxQtiRhz1UXXTAJFY3OiAJqokbJH6ifMA@mail.gmail.com>
 <YNxCDpM3bO5cPjqi@stefanha-x1.localdomain>
In-Reply-To: <YNxCDpM3bO5cPjqi@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 1 Jul 2021 18:00:48 +0800
Message-ID: <CACycT3taKhf1cWp3Jd0aSVekAZvpbR-_fkyPLQ=B+jZBB5H=8Q@mail.gmail.com>
Subject: Re: Re: Re: [PATCH v8 10/10] Documentation: Add documentation for VDUSE
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

On Wed, Jun 30, 2021 at 6:06 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Tue, Jun 29, 2021 at 01:43:11PM +0800, Yongji Xie wrote:
> > On Mon, Jun 28, 2021 at 9:02 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > > On Tue, Jun 15, 2021 at 10:13:31PM +0800, Xie Yongji wrote:
> > > > +     static void *iova_to_va(int dev_fd, uint64_t iova, uint64_t *len)
> > > > +     {
> > > > +             int fd;
> > > > +             void *addr;
> > > > +             size_t size;
> > > > +             struct vduse_iotlb_entry entry;
> > > > +
> > > > +             entry.start = iova;
> > > > +             entry.last = iova + 1;
> > >
> > > Why +1?
> > >
> > > I expected the request to include *len so that VDUSE can create a bounce
> > > buffer for the full iova range, if necessary.
> > >
> >
> > The function is used to translate iova to va. And the *len is not
> > specified by the caller. Instead, it's used to tell the caller the
> > length of the contiguous iova region from the specified iova. And the
> > ioctl VDUSE_IOTLB_GET_FD will get the file descriptor to the first
> > overlapped iova region. So using iova + 1 should be enough here.
>
> Does the entry.last field have any purpose with VDUSE_IOTLB_GET_FD? I
> wonder why userspace needs to assign a value at all if it's always +1.
>

If we need to get some iova regions in the specified range, we need
the entry.last field. For example, we can use [0, ULONG_MAX] to get
the first overlapped iova region which might be [4096, 8192]. But in
this function, we don't use VDUSE_IOTLB_GET_FD like this. We need to
get the iova region including the specified iova.

> >
> > > > +             fd = ioctl(dev_fd, VDUSE_IOTLB_GET_FD, &entry);
> > > > +             if (fd < 0)
> > > > +                     return NULL;
> > > > +
> > > > +             size = entry.last - entry.start + 1;
> > > > +             *len = entry.last - iova + 1;
> > > > +             addr = mmap(0, size, perm_to_prot(entry.perm), MAP_SHARED,
> > > > +                         fd, entry.offset);
> > > > +             close(fd);
> > > > +             if (addr == MAP_FAILED)
> > > > +                     return NULL;
> > > > +
> > > > +             /* do something to cache this iova region */
> > >
> > > How is userspace expected to manage iotlb mmaps? When should munmap(2)
> > > be called?
> > >
> >
> > The simple way is using a list to store the iotlb mappings. And we
> > should call the munmap(2) for the old mappings when VDUSE_UPDATE_IOTLB
> > or VDUSE_STOP_DATAPLANE message is received.
>
> Thanks for explaining. It would be helpful to have a description of
> IOTLB operation in this document.
>

Sure.

> > > Should userspace expect VDUSE_IOTLB_GET_FD to return a full chunk of
> > > guest RAM (e.g. multiple gigabytes) that can be cached permanently or
> > > will it return just enough pages to cover [start, last)?
> > >
> >
> > It should return one iotlb mapping that covers [start, last). In
> > vhost-vdpa cases, it might be a full chunk of guest RAM. In
> > virtio-vdpa cases, it might be the whole bounce buffer or one coherent
> > mapping (produced by dma_alloc_coherent()).
>
> Great, thanks. Adding something about this to the documentation would
> help others implementing VDUSE devices or libraries.
>

OK.

> > > > +
> > > > +             return addr + iova - entry.start;
> > > > +     }
> > > > +
> > > > +- VDUSE_DEV_GET_FEATURES: Get the negotiated features
> > >
> > > Are these VIRTIO feature bits? Please explain how feature negotiation
> > > works. There must be a way for userspace to report the device's
> > > supported feature bits to the kernel.
> > >
> >
> > Yes, these are VIRTIO feature bits. Userspace will specify the
> > device's supported feature bits when creating a new VDUSE device with
> > ioctl(VDUSE_CREATE_DEV).
>
> Can the VDUSE device influence feature bit negotiation? For example, if
> the VDUSE virtio-blk device does not implement discard/write-zeroes, how
> does QEMU or the guest find out about this?
>

There is a "features" field in struct vduse_dev_config which is used
to do feature negotiation.

> > > > +- VDUSE_DEV_UPDATE_CONFIG: Update the configuration space and inject a config interrupt
> > >
> > > Does this mean the contents of the configuration space are cached by
> > > VDUSE?
> >
> > Yes, but the kernel will also store the same contents.
> >
> > > The downside is that the userspace code cannot generate the
> > > contents on demand. Most devices doin't need to generate the contents
> > > on demand, so I think this is okay but I had expected a different
> > > interface:
> > >
> > > kernel->userspace VDUSE_DEV_GET_CONFIG
> > > userspace->kernel VDUSE_DEV_INJECT_CONFIG_IRQ
> > >
> >
> > The problem is how to handle the failure of VDUSE_DEV_GET_CONFIG. We
> > will need lots of modification of virtio codes to support that. So to
> > make it simple, we choose this way:
> >
> > userspace -> kernel VDUSE_DEV_SET_CONFIG
> > userspace -> kernel VDUSE_DEV_INJECT_CONFIG_IRQ
> >
> > > I think you can leave it the way it is, but I wanted to mention this in
> > > case someone thinks it's important to support generating the contents of
> > > the configuration space on demand.
> > >
> >
> > Sorry, I didn't get you here. Can't VDUSE_DEV_SET_CONFIG and
> > VDUSE_DEV_INJECT_CONFIG_IRQ achieve that?
>
> If the contents of the configuration space change continuously, then the
> VDUSE_DEV_SET_CONFIG approach is inefficient and might have race
> conditions. For example, imagine a device where the driver can read a
> timer from the configuration space. I think the VIRTIO device model
> allows that although I'm not aware of any devices that do something like
> it today. The problem is that VDUSE_DEV_SET_CONFIG would have to be
> called frequently to keep the timer value updated even though the guest
> driver probably isn't accessing it.
>

OK, I get you now. Since the VIRTIO specification says "Device
configuration space is generally used for rarely-changing or
initialization-time parameters". I assume the VDUSE_DEV_SET_CONFIG
ioctl should not be called frequently.

> What's worse is that there might be race conditions where other
> driver->device operations are supposed to update the configuration space
> but VDUSE_DEV_SET_CONFIG means that the VDUSE kernel code is caching an
> outdated copy.
>

I'm not sure. Should the device and driver be able to access the same
fields concurrently?

> Again, I don't think it's a problem for existing devices in the VIRTIO
> specification. But I'm not 100% sure and future devices might require
> what I've described, so the VDUSE_DEV_SET_CONFIG interface could become
> a problem.
>

If so, maybe a new interface can be added at that time. The
VDUSE_DEV_GET_CONFIG might be better, but I still did not find a good
way for failure handling.

Thanks,
Yongji
