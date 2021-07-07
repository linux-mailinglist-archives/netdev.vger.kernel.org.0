Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95B23BEBA6
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhGGP5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:57:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231533AbhGGP5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625673274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O2h2vlsz6ndHlg3PC9CQFPkT0i83PUyxE9o1dbsrNbo=;
        b=b9hKSOW+xl0jKnl2cuDFRAfAtamYPQcS2D/WbZH0V2pyLB6fnkmxOKNiz++IjZm2gIMchE
        o9IzTOAzOhG/u8HVzI+h6ODw40vrPqueUF2xl9lepgn0VZP3eyBJcRrHY5kj/JX5nvSzy7
        R0A8ew7JkqaJvkxgqQkZ+/iz/9N3v0g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-P6DiuWC8NqOTzqoXQu7clQ-1; Wed, 07 Jul 2021 11:54:33 -0400
X-MC-Unique: P6DiuWC8NqOTzqoXQu7clQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F896800050;
        Wed,  7 Jul 2021 15:54:30 +0000 (UTC)
Received: from localhost (ovpn-114-152.ams2.redhat.com [10.36.114.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E19E19C45;
        Wed,  7 Jul 2021 15:54:26 +0000 (UTC)
Date:   Wed, 7 Jul 2021 16:54:26 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        gregkh@linuxfoundation.org,
        "songmuchun@bytedance.com" <songmuchun@bytedance.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 10/10] Documentation: Add documentation for VDUSE
Message-ID: <YOXOMiPl7mKd7FoM@stefanha-x1.localdomain>
References: <CACycT3vo-diHgTSLw_FS2E+5ia5VjihE3qw7JmZR7JT55P-wQA@mail.gmail.com>
 <8320d26d-6637-85c6-8773-49553dfa502d@redhat.com>
 <YOL/9mxkJaokKDHc@stefanha-x1.localdomain>
 <5b5107fa-3b32-8a3b-720d-eee6b2a84ace@redhat.com>
 <YOQtG3gDOhHDO5CQ@stefanha-x1.localdomain>
 <CACGkMEs2HHbUfarum8uQ6wuXoDwLQUSXTsa-huJFiqr__4cwRg@mail.gmail.com>
 <YOSOsrQWySr0andk@stefanha-x1.localdomain>
 <100e6788-7fdf-1505-d69c-bc28a8bc7a78@redhat.com>
 <YOVr801d01YOPzLL@stefanha-x1.localdomain>
 <a03c8627-7dac-2255-a2d9-603fc623b618@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GfNuKxfgxb2Fixhx"
Content-Disposition: inline
In-Reply-To: <a03c8627-7dac-2255-a2d9-603fc623b618@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GfNuKxfgxb2Fixhx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 07, 2021 at 05:24:08PM +0800, Jason Wang wrote:
>=20
> =E5=9C=A8 2021/7/7 =E4=B8=8B=E5=8D=884:55, Stefan Hajnoczi =E5=86=99=E9=
=81=93:
> > On Wed, Jul 07, 2021 at 11:43:28AM +0800, Jason Wang wrote:
> > > =E5=9C=A8 2021/7/7 =E4=B8=8A=E5=8D=881:11, Stefan Hajnoczi =E5=86=99=
=E9=81=93:
> > > > On Tue, Jul 06, 2021 at 09:08:26PM +0800, Jason Wang wrote:
> > > > > On Tue, Jul 6, 2021 at 6:15 PM Stefan Hajnoczi <stefanha@redhat.c=
om> wrote:
> > > > > > On Tue, Jul 06, 2021 at 10:34:33AM +0800, Jason Wang wrote:
> > > > > > > =E5=9C=A8 2021/7/5 =E4=B8=8B=E5=8D=888:49, Stefan Hajnoczi =
=E5=86=99=E9=81=93:
> > > > > > > > On Mon, Jul 05, 2021 at 11:36:15AM +0800, Jason Wang wrote:
> > > > > > > > > =E5=9C=A8 2021/7/4 =E4=B8=8B=E5=8D=885:49, Yongji Xie =E5=
=86=99=E9=81=93:
> > > > > > > > > > > > OK, I get you now. Since the VIRTIO specification s=
ays "Device
> > > > > > > > > > > > configuration space is generally used for rarely-ch=
anging or
> > > > > > > > > > > > initialization-time parameters". I assume the VDUSE=
_DEV_SET_CONFIG
> > > > > > > > > > > > ioctl should not be called frequently.
> > > > > > > > > > > The spec uses MUST and other terms to define the prec=
ise requirements.
> > > > > > > > > > > Here the language (especially the word "generally") i=
s weaker and means
> > > > > > > > > > > there may be exceptions.
> > > > > > > > > > >=20
> > > > > > > > > > > Another type of access that doesn't work with the VDU=
SE_DEV_SET_CONFIG
> > > > > > > > > > > approach is reads that have side-effects. For example=
, imagine a field
> > > > > > > > > > > containing an error code if the device encounters a p=
roblem unrelated to
> > > > > > > > > > > a specific virtqueue request. Reading from this field=
 resets the error
> > > > > > > > > > > code to 0, saving the driver an extra configuration s=
pace write access
> > > > > > > > > > > and possibly race conditions. It isn't possible to im=
plement those
> > > > > > > > > > > semantics suing VDUSE_DEV_SET_CONFIG. It's another co=
rner case, but it
> > > > > > > > > > > makes me think that the interface does not allow full=
 VIRTIO semantics.
> > > > > > > > > Note that though you're correct, my understanding is that=
 config space is
> > > > > > > > > not suitable for this kind of error propagating. And it w=
ould be very hard
> > > > > > > > > to implement such kind of semantic in some transports.  V=
irtqueue should be
> > > > > > > > > much better. As Yong Ji quoted, the config space is used =
for
> > > > > > > > > "rarely-changing or intialization-time parameters".
> > > > > > > > >=20
> > > > > > > > >=20
> > > > > > > > > > Agreed. I will use VDUSE_DEV_GET_CONFIG in the next ver=
sion. And to
> > > > > > > > > > handle the message failure, I'm going to add a return v=
alue to
> > > > > > > > > > virtio_config_ops.get() and virtio_cread_* API so that =
the error can
> > > > > > > > > > be propagated to the virtio device driver. Then the vir=
tio-blk device
> > > > > > > > > > driver can be modified to handle that.
> > > > > > > > > >=20
> > > > > > > > > > Jason and Stefan, what do you think of this way?
> > > > > > > > Why does VDUSE_DEV_GET_CONFIG need to support an error retu=
rn value?
> > > > > > > >=20
> > > > > > > > The VIRTIO spec provides no way for the device to report er=
rors from
> > > > > > > > config space accesses.
> > > > > > > >=20
> > > > > > > > The QEMU virtio-pci implementation returns -1 from invalid
> > > > > > > > virtio_config_read*() and silently discards virtio_config_w=
rite*()
> > > > > > > > accesses.
> > > > > > > >=20
> > > > > > > > VDUSE can take the same approach with
> > > > > > > > VDUSE_DEV_GET_CONFIG/VDUSE_DEV_SET_CONFIG.
> > > > > > > >=20
> > > > > > > > > I'd like to stick to the current assumption thich get_con=
fig won't fail.
> > > > > > > > > That is to say,
> > > > > > > > >=20
> > > > > > > > > 1) maintain a config in the kernel, make sure the config =
space read can
> > > > > > > > > always succeed
> > > > > > > > > 2) introduce an ioctl for the vduse usersapce to update t=
he config space.
> > > > > > > > > 3) we can synchronize with the vduse userspace during set=
_config
> > > > > > > > >=20
> > > > > > > > > Does this work?
> > > > > > > > I noticed that caching is also allowed by the vhost-user pr=
otocol
> > > > > > > > messages (QEMU's docs/interop/vhost-user.rst), but the devi=
ce doesn't
> > > > > > > > know whether or not caching is in effect. The interface you=
 outlined
> > > > > > > > above requires caching.
> > > > > > > >=20
> > > > > > > > Is there a reason why the host kernel vDPA code needs to ca=
che the
> > > > > > > > configuration space?
> > > > > > > Because:
> > > > > > >=20
> > > > > > > 1) Kernel can not wait forever in get_config(), this is the m=
ajor difference
> > > > > > > with vhost-user.
> > > > > > virtio_cread() can sleep:
> > > > > >=20
> > > > > >     #define virtio_cread(vdev, structname, member, ptr)        =
             \
> > > > > >             do {                                               =
             \
> > > > > >                     typeof(((structname*)0)->member) virtio_cre=
ad_v;        \
> > > > > >                                                                =
             \
> > > > > >                     might_sleep();                             =
             \
> > > > > >                     ^^^^^^^^^^^^^^
> > > > > >=20
> > > > > > Which code path cannot sleep?
> > > > > Well, it can sleep but it can't sleep forever. For VDUSE, a
> > > > > buggy/malicious userspace may refuse to respond to the get_config.
> > > > >=20
> > > > > It looks to me the ideal case, with the current virtio spec, for =
VDUSE is to
> > > > >=20
> > > > > 1) maintain the device and its state in the kernel, userspace may=
 sync
> > > > > with the kernel device via ioctls
> > > > > 2) offload the datapath (virtqueue) to the userspace
> > > > >=20
> > > > > This seems more robust and safe than simply relaying everything to
> > > > > userspace and waiting for its response.
> > > > >=20
> > > > > And we know for sure this model can work, an example is TUN/TAP:
> > > > > netdevice is abstracted in the kernel and datapath is done via
> > > > > sendmsg()/recvmsg().
> > > > >=20
> > > > > Maintaining the config in the kernel follows this model and it can
> > > > > simplify the device generation implementation.
> > > > >=20
> > > > > For config space write, it requires more thought but fortunately =
it's
> > > > > not commonly used. So VDUSE can choose to filter out the
> > > > > device/features that depends on the config write.
> > > > This is the problem. There are other messages like SET_FEATURES whe=
re I
> > > > guess we'll face the same challenge.
> > >=20
> > > Probably not, userspace device can tell the kernel about the device_f=
eatures
> > > and mandated_features during creation, and the feature negotiation co=
uld be
> > > done purely in the kernel without bothering the userspace.
>=20
>=20
> (For some reason I drop the list accidentally, adding them back, sorry)
>=20
>=20
> > Sorry, I confused the messages. I meant SET_STATUS. It's a synchronous
> > interface where the driver waits for the device.
>=20
>=20
> It depends on how we define "synchronous" here. If I understand correctly,
> the spec doesn't expect there will be any kind of failure for the operati=
on
> of set_status itself.
>=20
> Instead, anytime it want any synchronization, it should be done via
> get_status():
>=20
> 1) re-read device status to make sure FEATURES_OK is set during feature
> negotiation
> 2) re-read device status to be 0 to make sure the device has finish the
> reset
>=20
>=20
> >=20
> > VDUSE currently doesn't wait for the device emulation process to handle
> > this message (no reply is needed) but I think this is a mistake because
> > VDUSE is not following the VIRTIO device model.
>=20
>=20
> With the trick that is done for FEATURES_OK above, I think we don't need =
to
> wait for the reply.
>=20
> If userspace takes too long to respond, it can be detected since
> get_status() doesn't return the expected value for long time.
>=20
> And for the case that needs a timeout, we probably can use NEEDS_RESET.

I think you're right. get_status is the synchronization point, not
set_status.

Currently there is no VDUSE GET_STATUS message. The
VDUSE_START/STOP_DATAPLANE messages could be changed to SET_STATUS so
that the device emulation program can participate in emulating the
Device Status field. This change could affect VDUSE's VIRTIO feature
interface since the device emulation program can reject features by not
setting FEATURES_OK.

Stefan

--GfNuKxfgxb2Fixhx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDlzjEACgkQnKSrs4Gr
c8jk7Af8C+qpq0TGkJsNdJWxNkO0LaKJkGRafNGYDXKpL6AaW8PZeS7d0WN0s2DZ
g+1e0HO7JypMsUwqYGARUhMKM3LjbLuZeZfXbq3O/zb0BuVr12Ti93R9AlrYQSJp
81gNJSE3OkErl5K4dHAPEmYZ9y35A5GzOBP9WjEgGSDDk6zavc8cFig5t/H4Ql3E
eyPrdXFWOUVbZ6IDIDqVDzv8fYLkne6vgwZJJR/jG92OY9ofgBusngdtmwtyZWIQ
Ym1li+nNq68ibl4in6RbpTVlGEGIsL/BcFm4bGgLYBhAF1WcvDQ3koyPcT81lpCk
790iF3m01i/+PO4+b09qQN3LgCQPNw==
=i3wA
-----END PGP SIGNATURE-----

--GfNuKxfgxb2Fixhx--

