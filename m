Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C9B360327
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhDOHTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:19:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231215AbhDOHTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:19:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618471165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tjSbWtMUHOjatpUQwwbliYhoZNKm3fTz4tmeEVLucoA=;
        b=d13gihYRq2G3FSa9moB48oLhJhxJtU0R8SR7lvlC3K9o9HOV5BFTxaxr5BoPpqrCGfo71G
        dCebvLUzl61YiVgk/QZUPdqf3Km1Z1c8CUcED0pZJckHunLNaAuzvrfCUPndDDjY/KeKnZ
        mKFKz3eF+q5z6YsgrfsNuZX9OUoc3f0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-FVziLpT9PViQY8C3dTqHgg-1; Thu, 15 Apr 2021 03:19:21 -0400
X-MC-Unique: FVziLpT9PViQY8C3dTqHgg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D28DB10054F6;
        Thu, 15 Apr 2021 07:19:19 +0000 (UTC)
Received: from localhost (ovpn-114-209.ams2.redhat.com [10.36.114.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A60F56E50A;
        Thu, 15 Apr 2021 07:19:15 +0000 (UTC)
Date:   Thu, 15 Apr 2021 08:19:14 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Yongji Xie <xieyongji@bytedance.com>
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
        Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
Message-ID: <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain>
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain>
 <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="82FzIIg1Jb5ofXMG"
Content-Disposition: inline
In-Reply-To: <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--82FzIIg1Jb5ofXMG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 15, 2021 at 01:38:37PM +0800, Yongji Xie wrote:
> On Wed, Apr 14, 2021 at 10:15 PM Stefan Hajnoczi <stefanha@redhat.com> wr=
ote:
> >
> > On Wed, Mar 31, 2021 at 04:05:19PM +0800, Xie Yongji wrote:
> > > VDUSE (vDPA Device in Userspace) is a framework to support
> > > implementing software-emulated vDPA devices in userspace. This
> > > document is intended to clarify the VDUSE design and usage.
> > >
> > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > ---
> > >  Documentation/userspace-api/index.rst |   1 +
> > >  Documentation/userspace-api/vduse.rst | 212 ++++++++++++++++++++++++=
++++++++++
> > >  2 files changed, 213 insertions(+)
> > >  create mode 100644 Documentation/userspace-api/vduse.rst
> >
> > Just looking over the documentation briefly (I haven't studied the code
> > yet)...
> >
>=20
> Thank you!
>=20
> > > +How VDUSE works
> > > +------------
> > > +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioctl =
on
> > > +the character device (/dev/vduse/control). Then a device file with t=
he
> > > +specified name (/dev/vduse/$NAME) will appear, which can be used to
> > > +implement the userspace vDPA device's control path and data path.
> >
> > These steps are taken after sending the VDPA_CMD_DEV_NEW netlink
> > message? (Please consider reordering the documentation to make it clear
> > what the sequence of steps are.)
> >
>=20
> No, VDUSE devices should be created before sending the
> VDPA_CMD_DEV_NEW netlink messages which might produce I/Os to VDUSE.

I see. Please include an overview of the steps before going into detail.
Something like:

  VDUSE devices are started as follows:

  1. Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
     /dev/vduse/control.

  2. Begin processing VDUSE messages from /dev/vduse/$NAME. The first
     messages will arrive while attaching the VDUSE instance to vDPA.

  3. Send the VDPA_CMD_DEV_NEW netlink message to attach the VDUSE
     instance to vDPA.

  VDUSE devices are stopped as follows:

  ...

> > > +     static int netlink_add_vduse(const char *name, int device_id)
> > > +     {
> > > +             struct nl_sock *nlsock;
> > > +             struct nl_msg *msg;
> > > +             int famid;
> > > +
> > > +             nlsock =3D nl_socket_alloc();
> > > +             if (!nlsock)
> > > +                     return -ENOMEM;
> > > +
> > > +             if (genl_connect(nlsock))
> > > +                     goto free_sock;
> > > +
> > > +             famid =3D genl_ctrl_resolve(nlsock, VDPA_GENL_NAME);
> > > +             if (famid < 0)
> > > +                     goto close_sock;
> > > +
> > > +             msg =3D nlmsg_alloc();
> > > +             if (!msg)
> > > +                     goto close_sock;
> > > +
> > > +             if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, famid,=
 0, 0,
> > > +                 VDPA_CMD_DEV_NEW, 0))
> > > +                     goto nla_put_failure;
> > > +
> > > +             NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
> > > +             NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "vduse"=
);
> > > +             NLA_PUT_U32(msg, VDPA_ATTR_DEV_ID, device_id);
> >
> > What are the permission/capability requirements for VDUSE?
> >
>=20
> Now I think we need privileged permission (root user). Because
> userspace daemon is able to access avail vring, used vring, descriptor
> table in kernel driver directly.

Please state this explicitly at the start of the document. Existing
interfaces like FUSE are designed to avoid trusting userspace. Therefore
people might think the same is the case here. It's critical that people
are aware of this before deploying VDUSE with virtio-vdpa.

We should probably pause here and think about whether it's possible to
avoid trusting userspace. Even if it takes some effort and costs some
performance it would probably be worthwhile.

Is the security situation different with vhost-vdpa? In that case it
seems more likely that the host kernel doesn't need to trust the
userspace VDUSE device.

Regarding privileges in general: userspace VDUSE processes shouldn't
need to run as root. The VDUSE device lifecycle will require privileges
to attach vhost-vdpa and virtio-vdpa devices, but the actual userspace
process that emulates the device should be able to run unprivileged.
Emulated devices are an attack surface and even if you are comfortable
with running them as root in your specific use case, it will be an issue
as soon as other people want to use VDUSE and could give VDUSE a
reputation for poor security.

> > How does VDUSE interact with namespaces?
> >
>=20
> Not sure I get your point here. Do you mean how the emulated vDPA
> device interact with namespaces? This should work like hardware vDPA
> devices do. VDUSE daemon can reside outside the namespace of a
> container which uses the vDPA device.

Can VDUSE devices run inside containers? Are /dev/vduse/$NAME and vDPA
device names global?

> > What is the meaning of VDPA_ATTR_DEV_ID? I don't see it in Linux
> > v5.12-rc6 drivers/vdpa/vdpa.c:vdpa_nl_cmd_dev_add_set_doit().
> >
>=20
> It means the device id (e.g. VIRTIO_ID_BLOCK) of the vDPA device and
> can be found in include/uapi/linux/vdpa.h.

VDPA_ATTR_DEV_ID is only used by VDPA_CMD_DEV_GET in Linux v5.12-rc6,
not by VDPA_CMD_DEV_NEW.

The example in this document uses VDPA_ATTR_DEV_ID with
VDPA_CMD_DEV_NEW. Is the example outdated?

>=20
> > > +MMU-based IOMMU Driver
> > > +----------------------
> > > +VDUSE framework implements an MMU-based on-chip IOMMU driver to supp=
ort
> > > +mapping the kernel DMA buffer into the userspace iova region dynamic=
ally.
> > > +This is mainly designed for virtio-vdpa case (kernel virtio drivers).
> > > +
> > > +The basic idea behind this driver is treating MMU (VA->PA) as IOMMU =
(IOVA->PA).
> > > +The driver will set up MMU mapping instead of IOMMU mapping for the =
DMA transfer
> > > +so that the userspace process is able to use its virtual address to =
access
> > > +the DMA buffer in kernel.
> > > +
> > > +And to avoid security issue, a bounce-buffering mechanism is introdu=
ced to
> > > +prevent userspace accessing the original buffer directly which may c=
ontain other
> > > +kernel data. During the mapping, unmapping, the driver will copy the=
 data from
> > > +the original buffer to the bounce buffer and back, depending on the =
direction of
> > > +the transfer. And the bounce-buffer addresses will be mapped into th=
e user address
> > > +space instead of the original one.
> >
> > Is mmap(2) the right interface if memory is not actually shared, why not
> > just use pread(2)/pwrite(2) to make the copy explicit? That way the copy
> > semantics are clear. For example, don't expect to be able to busy wait
> > on the memory because changes will not be visible to the other side.
> >
> > (I guess I'm missing something here and that mmap(2) is the right
> > approach, but maybe this documentation section can be clarified.)
>=20
> It's for performance considerations on the one hand. We might need to
> call pread(2)/pwrite(2) multiple times for each request.

Userspace can keep page-sized pread() buffers around to avoid additional
syscalls during a request.

mmap() access does reduce the number of syscalls, but it also introduces
page faults (effectively doing the page-sized pread() I mentioned
above).

It's not obvious to me that there is a fundamental difference between
the two approaches in terms of performance.

> On the other
> hand, we can handle the virtqueue in a unified way for both vhost-vdpa
> case and virtio-vdpa case. Otherwise, userspace daemon needs to know
> which iova ranges need to be accessed with pread(2)/pwrite(2). And in
> the future, we might be able to avoid bouncing in some cases.

Ah, I see. So bounce buffers are not used for vhost-vdpa?

Stefan

--82FzIIg1Jb5ofXMG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmB36PIACgkQnKSrs4Gr
c8jkQAf+KcYFh/gqlyxAo6TVpRadXWszhkqQFKsiSMi0sOEUhpG/XGg2mTz7obUZ
Z8BqHZxx6numt71fr/uq33E2zNU3sYvQGFwBiC9F02FpXcHcF5TChEber0x0bsCr
RMvsmDK0FZyPGiFpoxkfiJMAtzQrTgwo1tGfV5AxR7tMeP8b5u6kf6Q3sZCO5/v1
yaTujoi0t1hdmIluCm4cNAaJL/sL5QYe1snJvh2Dajktko7Rs6d9xZ0hOQWbFJH3
z54f67yXGRYWozMwa5TTEgWNswAC2F3f1WInrcolgZoTu7XlfOlLZ6ZdVoxso/ti
4tAZ1a3Ma7anA3jhAbyQZhPvoljh+A==
=DcLW
-----END PGP SIGNATURE-----

--82FzIIg1Jb5ofXMG--

