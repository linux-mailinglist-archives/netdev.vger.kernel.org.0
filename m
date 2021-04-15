Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424F6360452
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 10:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhDOIeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 04:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhDOIeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 04:34:03 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5DDC06175F
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 01:33:39 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g17so26286195edm.6
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 01:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lrVKKGmxPY9gv1SmceRB5rOaCQhiNZ+70V5kR49fpLg=;
        b=o6JpXyCtx0e4kOLl1cemu4UqTSCon8S7VAKJwurY9225wWW2DnrRDeCNNf6yhWBjAf
         HQOyC6V5qBIC57TY1M++1bKDKymHhRVNuGX+omGKoFIa+PJxBxgtdf2FDdAEqLDl6Zht
         NzosNfAfYu/2vkjy6Z2zdVyqetQ5eSn8EPKzK6HRTIwATqX+AUq/ZCPMPvurXFV6dBJb
         8KQMDu/FPZamSyotpU1BsywGsLqybcm/afQ+B7lXXBn8pgOB/SfUJ4gnobzuo3UFFB52
         p0H0MchsCfpWHLpl6d2nvO4PpcAkqal2SCILKQZHWol5pT3C8b5wK7OadbAUfUF9fKPX
         Dmpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lrVKKGmxPY9gv1SmceRB5rOaCQhiNZ+70V5kR49fpLg=;
        b=KRl4NCCJkAPZ4n3Ig9Y1fI0sHP1eq2E/wFDNosers2uspYOgWgUpJUnojBpXtx84gU
         7Rdh4XsauhA6RRTZCZtfVpCQl+ItVjuKgFX8/t7J54mD9rgq8lVC8qjgsJ1Mk0aaSFa5
         Qbdg0GnMAs4C9NrAizLlDIsVdPpizyG7EUvD5rpkF4nnjIDvrNDDz7ZiVv4K7NLMvJ9S
         1gjel9SPv0fcB34viFHOLQUpJd2bFWUzLT+jATixsiXVT+evC8Ktnck42bmmwrnsho6o
         TWHH0EbDNYiUAp17fsSwWqeGPMWHRM67x5+rKNkYV/tsoDlSyjvHs78EGMmwCNTsy/LV
         MFqw==
X-Gm-Message-State: AOAM530tqPiMWXk+o2aCwlvvwwftu2CWgOM7QfasXea0HC9ZKTqSENK1
        yUi61vV+sxGhebwpoib9wmwl1pTCXN2ff+m/dBox
X-Google-Smtp-Source: ABdhPJxBbO6PW7e7UeMpcpilJ9A8wbOSFH8raoyKzISO/y/WaCsMMyiTPwfhedz60Hal1Yu9EvrAFHqTr/yfRHfew98=
X-Received: by 2002:a05:6402:278c:: with SMTP id b12mr2757237ede.145.1618475618367;
 Thu, 15 Apr 2021 01:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain> <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
 <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain>
In-Reply-To: <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 15 Apr 2021 16:33:27 +0800
Message-ID: <CACycT3tRN1n_PJm1mu3=s1dK941Pac15cpaysqZZKLR6xKaXSg@mail.gmail.com>
Subject: Re: Re: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
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

On Thu, Apr 15, 2021 at 3:19 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Thu, Apr 15, 2021 at 01:38:37PM +0800, Yongji Xie wrote:
> > On Wed, Apr 14, 2021 at 10:15 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > >
> > > On Wed, Mar 31, 2021 at 04:05:19PM +0800, Xie Yongji wrote:
> > > > VDUSE (vDPA Device in Userspace) is a framework to support
> > > > implementing software-emulated vDPA devices in userspace. This
> > > > document is intended to clarify the VDUSE design and usage.
> > > >
> > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > ---
> > > >  Documentation/userspace-api/index.rst |   1 +
> > > >  Documentation/userspace-api/vduse.rst | 212 ++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 213 insertions(+)
> > > >  create mode 100644 Documentation/userspace-api/vduse.rst
> > >
> > > Just looking over the documentation briefly (I haven't studied the code
> > > yet)...
> > >
> >
> > Thank you!
> >
> > > > +How VDUSE works
> > > > +------------
> > > > +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl on
> > > > +the character device (/dev/vduse/control). Then a device file with the
> > > > +specified name (/dev/vduse/$NAME) will appear, which can be used to
> > > > +implement the userspace vDPA device's control path and data path.
> > >
> > > These steps are taken after sending the VDPA_CMD_DEV_NEW netlink
> > > message? (Please consider reordering the documentation to make it clear
> > > what the sequence of steps are.)
> > >
> >
> > No, VDUSE devices should be created before sending the
> > VDPA_CMD_DEV_NEW netlink messages which might produce I/Os to VDUSE.
>
> I see. Please include an overview of the steps before going into detail.
> Something like:
>
>   VDUSE devices are started as follows:
>
>   1. Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
>      /dev/vduse/control.
>
>   2. Begin processing VDUSE messages from /dev/vduse/$NAME. The first
>      messages will arrive while attaching the VDUSE instance to vDPA.
>
>   3. Send the VDPA_CMD_DEV_NEW netlink message to attach the VDUSE
>      instance to vDPA.
>
>   VDUSE devices are stopped as follows:
>
>   ...
>

Sure.

> > > > +     static int netlink_add_vduse(const char *name, int device_id)
> > > > +     {
> > > > +             struct nl_sock *nlsock;
> > > > +             struct nl_msg *msg;
> > > > +             int famid;
> > > > +
> > > > +             nlsock = nl_socket_alloc();
> > > > +             if (!nlsock)
> > > > +                     return -ENOMEM;
> > > > +
> > > > +             if (genl_connect(nlsock))
> > > > +                     goto free_sock;
> > > > +
> > > > +             famid = genl_ctrl_resolve(nlsock, VDPA_GENL_NAME);
> > > > +             if (famid < 0)
> > > > +                     goto close_sock;
> > > > +
> > > > +             msg = nlmsg_alloc();
> > > > +             if (!msg)
> > > > +                     goto close_sock;
> > > > +
> > > > +             if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, famid, 0, 0,
> > > > +                 VDPA_CMD_DEV_NEW, 0))
> > > > +                     goto nla_put_failure;
> > > > +
> > > > +             NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
> > > > +             NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "vduse");
> > > > +             NLA_PUT_U32(msg, VDPA_ATTR_DEV_ID, device_id);
> > >
> > > What are the permission/capability requirements for VDUSE?
> > >
> >
> > Now I think we need privileged permission (root user). Because
> > userspace daemon is able to access avail vring, used vring, descriptor
> > table in kernel driver directly.
>
> Please state this explicitly at the start of the document. Existing
> interfaces like FUSE are designed to avoid trusting userspace. Therefore
> people might think the same is the case here. It's critical that people
> are aware of this before deploying VDUSE with virtio-vdpa.
>
> We should probably pause here and think about whether it's possible to
> avoid trusting userspace. Even if it takes some effort and costs some
> performance it would probably be worthwhile.
>
> Is the security situation different with vhost-vdpa? In that case it
> seems more likely that the host kernel doesn't need to trust the
> userspace VDUSE device.
>

Yes.

> Regarding privileges in general: userspace VDUSE processes shouldn't
> need to run as root. The VDUSE device lifecycle will require privileges
> to attach vhost-vdpa and virtio-vdpa devices, but the actual userspace
> process that emulates the device should be able to run unprivileged.
> Emulated devices are an attack surface and even if you are comfortable
> with running them as root in your specific use case, it will be an issue
> as soon as other people want to use VDUSE and could give VDUSE a
> reputation for poor security.
>

Agreed. Rethink about the virtio-vdpa case. The security risks mainly
come from the untrusted user being able to rewrite the content of
avail vring, used vring, descriptor table. But it seems that the worst
result of doing this is getting a broken virtqueue. Not sure if it's
acceptable to kernel.

> > > How does VDUSE interact with namespaces?
> > >
> >
> > Not sure I get your point here. Do you mean how the emulated vDPA
> > device interact with namespaces? This should work like hardware vDPA
> > devices do. VDUSE daemon can reside outside the namespace of a
> > container which uses the vDPA device.
>
> Can VDUSE devices run inside containers? Are /dev/vduse/$NAME and vDPA
> device names global?
>

I think we can run it inside containers. But there might be some
limitations. As you mentioned, the device name is global. So we need
to make sure the VDUSE daemons in different containers don't use the
same name to create vDPA devices.

> > > What is the meaning of VDPA_ATTR_DEV_ID? I don't see it in Linux
> > > v5.12-rc6 drivers/vdpa/vdpa.c:vdpa_nl_cmd_dev_add_set_doit().
> > >
> >
> > It means the device id (e.g. VIRTIO_ID_BLOCK) of the vDPA device and
> > can be found in include/uapi/linux/vdpa.h.
>
> VDPA_ATTR_DEV_ID is only used by VDPA_CMD_DEV_GET in Linux v5.12-rc6,
> not by VDPA_CMD_DEV_NEW.
>
> The example in this document uses VDPA_ATTR_DEV_ID with
> VDPA_CMD_DEV_NEW. Is the example outdated?
>

Oh, you are right. Will update it.

> >
> > > > +MMU-based IOMMU Driver
> > > > +----------------------
> > > > +VDUSE framework implements an MMU-based on-chip IOMMU driver to support
> > > > +mapping the kernel DMA buffer into the userspace iova region dynamically.
> > > > +This is mainly designed for virtio-vdpa case (kernel virtio drivers).
> > > > +
> > > > +The basic idea behind this driver is treating MMU (VA->PA) as IOMMU (IOVA->PA).
> > > > +The driver will set up MMU mapping instead of IOMMU mapping for the DMA transfer
> > > > +so that the userspace process is able to use its virtual address to access
> > > > +the DMA buffer in kernel.
> > > > +
> > > > +And to avoid security issue, a bounce-buffering mechanism is introduced to
> > > > +prevent userspace accessing the original buffer directly which may contain other
> > > > +kernel data. During the mapping, unmapping, the driver will copy the data from
> > > > +the original buffer to the bounce buffer and back, depending on the direction of
> > > > +the transfer. And the bounce-buffer addresses will be mapped into the user address
> > > > +space instead of the original one.
> > >
> > > Is mmap(2) the right interface if memory is not actually shared, why not
> > > just use pread(2)/pwrite(2) to make the copy explicit? That way the copy
> > > semantics are clear. For example, don't expect to be able to busy wait
> > > on the memory because changes will not be visible to the other side.
> > >
> > > (I guess I'm missing something here and that mmap(2) is the right
> > > approach, but maybe this documentation section can be clarified.)
> >
> > It's for performance considerations on the one hand. We might need to
> > call pread(2)/pwrite(2) multiple times for each request.
>
> Userspace can keep page-sized pread() buffers around to avoid additional
> syscalls during a request.
>

In the indirect descriptors case , it looks like we can't use one
pread() to get all buffers?

> mmap() access does reduce the number of syscalls, but it also introduces
> page faults (effectively doing the page-sized pread() I mentioned
> above).
>

Yes, but only on the first access.

> It's not obvious to me that there is a fundamental difference between
> the two approaches in terms of performance.
>
> > On the other
> > hand, we can handle the virtqueue in a unified way for both vhost-vdpa
> > case and virtio-vdpa case. Otherwise, userspace daemon needs to know
> > which iova ranges need to be accessed with pread(2)/pwrite(2). And in
> > the future, we might be able to avoid bouncing in some cases.
>
> Ah, I see. So bounce buffers are not used for vhost-vdpa?
>

Yes.

Thanks,
Yongji
