Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE711360C03
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 16:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhDOOjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 10:39:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233431AbhDOOjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 10:39:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618497521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Iq3JoHwhWsKCh1E31pkpNnsDt0ef/F0+nV9nC0WOD80=;
        b=aIvaEXOd3zqixRkaD3sKHnFza38OiJC0g1CYJs4kzwD4FH1w4kmqrA/qvrwIIta2gY8eqT
        Ya35hGTbDXusGkeIBHzRNnK0JIEGKO4uMDPxdW9IVtQ++nua6jII9F3828vXUkttbUu7Po
        z7o2jSw1QddQq/fuJobY4OGI/KujqfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-3vJzTnREPUWq1InIkPtiTQ-1; Thu, 15 Apr 2021 10:38:37 -0400
X-MC-Unique: 3vJzTnREPUWq1InIkPtiTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 898FF81433D;
        Thu, 15 Apr 2021 14:38:34 +0000 (UTC)
Received: from localhost (ovpn-114-209.ams2.redhat.com [10.36.114.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A35B610A8;
        Thu, 15 Apr 2021 14:38:27 +0000 (UTC)
Date:   Thu, 15 Apr 2021 15:38:26 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Yongji Xie <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
Subject: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
Message-ID: <YHhP4i+yXgA2KkVJ@stefanha-x1.localdomain>
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain>
 <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
 <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain>
 <80b31814-9e41-3153-7efb-c0c2fab44feb@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sF9KvzennHcEMnX5"
Content-Disposition: inline
In-Reply-To: <80b31814-9e41-3153-7efb-c0c2fab44feb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sF9KvzennHcEMnX5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 15, 2021 at 04:36:35PM +0800, Jason Wang wrote:
>=20
> =E5=9C=A8 2021/4/15 =E4=B8=8B=E5=8D=883:19, Stefan Hajnoczi =E5=86=99=E9=
=81=93:
> > On Thu, Apr 15, 2021 at 01:38:37PM +0800, Yongji Xie wrote:
> > > On Wed, Apr 14, 2021 at 10:15 PM Stefan Hajnoczi <stefanha@redhat.com=
> wrote:
> > > > On Wed, Mar 31, 2021 at 04:05:19PM +0800, Xie Yongji wrote:
> > > > > VDUSE (vDPA Device in Userspace) is a framework to support
> > > > > implementing software-emulated vDPA devices in userspace. This
> > > > > document is intended to clarify the VDUSE design and usage.
> > > > >=20
> > > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > > ---
> > > > >   Documentation/userspace-api/index.rst |   1 +
> > > > >   Documentation/userspace-api/vduse.rst | 212 +++++++++++++++++++=
+++++++++++++++
> > > > >   2 files changed, 213 insertions(+)
> > > > >   create mode 100644 Documentation/userspace-api/vduse.rst
> > > > Just looking over the documentation briefly (I haven't studied the =
code
> > > > yet)...
> > > >=20
> > > Thank you!
> > >=20
> > > > > +How VDUSE works
> > > > > +------------
> > > > > +Each userspace vDPA device is created by the VDUSE_CREATE_DEV io=
ctl on
> > > > > +the character device (/dev/vduse/control). Then a device file wi=
th the
> > > > > +specified name (/dev/vduse/$NAME) will appear, which can be used=
 to
> > > > > +implement the userspace vDPA device's control path and data path.
> > > > These steps are taken after sending the VDPA_CMD_DEV_NEW netlink
> > > > message? (Please consider reordering the documentation to make it c=
lear
> > > > what the sequence of steps are.)
> > > >=20
> > > No, VDUSE devices should be created before sending the
> > > VDPA_CMD_DEV_NEW netlink messages which might produce I/Os to VDUSE.
> > I see. Please include an overview of the steps before going into detail.
> > Something like:
> >=20
> >    VDUSE devices are started as follows:
> >=20
> >    1. Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
> >       /dev/vduse/control.
> >=20
> >    2. Begin processing VDUSE messages from /dev/vduse/$NAME. The first
> >       messages will arrive while attaching the VDUSE instance to vDPA.
> >=20
> >    3. Send the VDPA_CMD_DEV_NEW netlink message to attach the VDUSE
> >       instance to vDPA.
> >=20
> >    VDUSE devices are stopped as follows:
> >=20
> >    ...
> >=20
> > > > > +     static int netlink_add_vduse(const char *name, int device_i=
d)
> > > > > +     {
> > > > > +             struct nl_sock *nlsock;
> > > > > +             struct nl_msg *msg;
> > > > > +             int famid;
> > > > > +
> > > > > +             nlsock =3D nl_socket_alloc();
> > > > > +             if (!nlsock)
> > > > > +                     return -ENOMEM;
> > > > > +
> > > > > +             if (genl_connect(nlsock))
> > > > > +                     goto free_sock;
> > > > > +
> > > > > +             famid =3D genl_ctrl_resolve(nlsock, VDPA_GENL_NAME);
> > > > > +             if (famid < 0)
> > > > > +                     goto close_sock;
> > > > > +
> > > > > +             msg =3D nlmsg_alloc();
> > > > > +             if (!msg)
> > > > > +                     goto close_sock;
> > > > > +
> > > > > +             if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, fa=
mid, 0, 0,
> > > > > +                 VDPA_CMD_DEV_NEW, 0))
> > > > > +                     goto nla_put_failure;
> > > > > +
> > > > > +             NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
> > > > > +             NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "vd=
use");
> > > > > +             NLA_PUT_U32(msg, VDPA_ATTR_DEV_ID, device_id);
> > > > What are the permission/capability requirements for VDUSE?
> > > >=20
> > > Now I think we need privileged permission (root user). Because
> > > userspace daemon is able to access avail vring, used vring, descriptor
> > > table in kernel driver directly.
> > Please state this explicitly at the start of the document. Existing
> > interfaces like FUSE are designed to avoid trusting userspace.
>=20
>=20
> There're some subtle difference here. VDUSE present a device to kernel wh=
ich
> means IOMMU is probably the only thing to prevent a malicous device.
>=20
>=20
> > Therefore
> > people might think the same is the case here. It's critical that people
> > are aware of this before deploying VDUSE with virtio-vdpa.
> >=20
> > We should probably pause here and think about whether it's possible to
> > avoid trusting userspace. Even if it takes some effort and costs some
> > performance it would probably be worthwhile.
>=20
>=20
> Since the bounce buffer is used the only attack surface is the coherent
> area, if we want to enforce stronger isolation we need to use shadow
> virtqueue (which is proposed in earlier version by me) in this case. But =
I'm
> not sure it's worth to do that.

The security situation needs to be clear before merging this feature.

I think the IOMMU and vring can be made secure. What is more concerning
is the kernel code that runs on top: VIRTIO device drivers, network
stack, file systems, etc. They trust devices to an extent.

Since virtio-vdpa is a big reason for doing VDUSE in the first place I
don't think it makes sense to disable virtio-vdpa with VDUSE. A solution
is needed.

I'm going to be offline for a week and don't want to be a bottleneck.
I'll catch up when I'm back.

Stefan

--sF9KvzennHcEMnX5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmB4T+IACgkQnKSrs4Gr
c8huLQgArYjOVf1kgSpHtrRwoGGkfNh+oGYmr1H/QHh2dJyrb4q9Jla0GPB7VVeX
TuVffZkX1DaZm7+4JzclAyT56Lil89lNx8NsJxgPJsmmGOAy480+RvfeSvQ8qX0G
EIjnGpIUL15mH62qLC3hpBmNYoug9AuPW61zyg94ItVc4HOzzkIr1ajdPWqi5Nfy
gGK+9TzXbLeiwPfhseq4ZAR63qWDsVPRoD9SGt+GWaVUmPTvYQYSuEIOBQMG8cS8
xNJLkG8OFI1/oMncdHu1HvVAlBrKK/2eR/FFGYccpawxm7JXnt5RiuUZ6TvSQYcs
dFRncZiZcthIqakU4RHHDVY2Gh1KbA==
=w3Wk
-----END PGP SIGNATURE-----

--sF9KvzennHcEMnX5--

