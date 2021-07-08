Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C763BF73A
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 11:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhGHJJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 05:09:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32533 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231156AbhGHJJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 05:09:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625735179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RjITGxVwK9Nw9PLIT74jcnOPpIL3QozfCYhTJGzFak8=;
        b=JuvQPqzmzDdV95OEMa5OL1r2vRC35x5dzzfAjC4JvE33N5ofyaMdUBoj0eY0Cn6+pGBBdu
        SdDo9bvYuZj1mFvqZPtlTgi0kHlIXAPoVWW0yC9rIrbT/FHPvB5Iw+ximuCRlD8HEuZnNQ
        m+2imcxYqt8sfiuZiw7ZHMtEYfW4pNM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-ifHEj91pP9aMZ3VZ-IdEnQ-1; Thu, 08 Jul 2021 05:06:18 -0400
X-MC-Unique: ifHEj91pP9aMZ3VZ-IdEnQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0550B19200C0;
        Thu,  8 Jul 2021 09:06:16 +0000 (UTC)
Received: from localhost (ovpn-114-141.ams2.redhat.com [10.36.114.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 967D05D9D3;
        Thu,  8 Jul 2021 09:06:11 +0000 (UTC)
Date:   Thu, 8 Jul 2021 10:06:10 +0100
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
Message-ID: <YObAAkabn+nr3taJ@stefanha-x1.localdomain>
References: <YOL/9mxkJaokKDHc@stefanha-x1.localdomain>
 <5b5107fa-3b32-8a3b-720d-eee6b2a84ace@redhat.com>
 <YOQtG3gDOhHDO5CQ@stefanha-x1.localdomain>
 <CACGkMEs2HHbUfarum8uQ6wuXoDwLQUSXTsa-huJFiqr__4cwRg@mail.gmail.com>
 <YOSOsrQWySr0andk@stefanha-x1.localdomain>
 <100e6788-7fdf-1505-d69c-bc28a8bc7a78@redhat.com>
 <YOVr801d01YOPzLL@stefanha-x1.localdomain>
 <a03c8627-7dac-2255-a2d9-603fc623b618@redhat.com>
 <YOXOMiPl7mKd7FoM@stefanha-x1.localdomain>
 <d5aef112-0828-6b79-4bce-753d3cd496c1@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DSsECoBNx8q7LFgy"
Content-Disposition: inline
In-Reply-To: <d5aef112-0828-6b79-4bce-753d3cd496c1@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DSsECoBNx8q7LFgy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 08, 2021 at 12:17:56PM +0800, Jason Wang wrote:
>=20
> =E5=9C=A8 2021/7/7 =E4=B8=8B=E5=8D=8811:54, Stefan Hajnoczi =E5=86=99=E9=
=81=93:
> > On Wed, Jul 07, 2021 at 05:24:08PM +0800, Jason Wang wrote:
> > > =E5=9C=A8 2021/7/7 =E4=B8=8B=E5=8D=884:55, Stefan Hajnoczi =E5=86=99=
=E9=81=93:
> > > > On Wed, Jul 07, 2021 at 11:43:28AM +0800, Jason Wang wrote:
> > > > > =E5=9C=A8 2021/7/7 =E4=B8=8A=E5=8D=881:11, Stefan Hajnoczi =E5=86=
=99=E9=81=93:
> > > > > > On Tue, Jul 06, 2021 at 09:08:26PM +0800, Jason Wang wrote:
> > > > > > > On Tue, Jul 6, 2021 at 6:15 PM Stefan Hajnoczi <stefanha@redh=
at.com> wrote:
> > > > > > > > On Tue, Jul 06, 2021 at 10:34:33AM +0800, Jason Wang wrote:
> > > > > > > > > =E5=9C=A8 2021/7/5 =E4=B8=8B=E5=8D=888:49, Stefan Hajnocz=
i =E5=86=99=E9=81=93:
> > > > > > > > > > On Mon, Jul 05, 2021 at 11:36:15AM +0800, Jason Wang wr=
ote:
> > > > > > > > > > > =E5=9C=A8 2021/7/4 =E4=B8=8B=E5=8D=885:49, Yongji Xie=
 =E5=86=99=E9=81=93:
> > > > > > > > > > > > > > OK, I get you now. Since the VIRTIO specificati=
on says "Device
> > > > > > > > > > > > > > configuration space is generally used for rarel=
y-changing or
> > > > > > > > > > > > > > initialization-time parameters". I assume the V=
DUSE_DEV_SET_CONFIG
> > > > > > > > > > > > > > ioctl should not be called frequently.
> > > > > > > > > > > > > The spec uses MUST and other terms to define the =
precise requirements.
> > > > > > > > > > > > > Here the language (especially the word "generally=
") is weaker and means
> > > > > > > > > > > > > there may be exceptions.
> > > > > > > > > > > > >=20
> > > > > > > > > > > > > Another type of access that doesn't work with the=
 VDUSE_DEV_SET_CONFIG
> > > > > > > > > > > > > approach is reads that have side-effects. For exa=
mple, imagine a field
> > > > > > > > > > > > > containing an error code if the device encounters=
 a problem unrelated to
> > > > > > > > > > > > > a specific virtqueue request. Reading from this f=
ield resets the error
> > > > > > > > > > > > > code to 0, saving the driver an extra configurati=
on space write access
> > > > > > > > > > > > > and possibly race conditions. It isn't possible t=
o implement those
> > > > > > > > > > > > > semantics suing VDUSE_DEV_SET_CONFIG. It's anothe=
r corner case, but it
> > > > > > > > > > > > > makes me think that the interface does not allow =
full VIRTIO semantics.
> > > > > > > > > > > Note that though you're correct, my understanding is =
that config space is
> > > > > > > > > > > not suitable for this kind of error propagating. And =
it would be very hard
> > > > > > > > > > > to implement such kind of semantic in some transports=
=2E  Virtqueue should be
> > > > > > > > > > > much better. As Yong Ji quoted, the config space is u=
sed for
> > > > > > > > > > > "rarely-changing or intialization-time parameters".
> > > > > > > > > > >=20
> > > > > > > > > > >=20
> > > > > > > > > > > > Agreed. I will use VDUSE_DEV_GET_CONFIG in the next=
 version. And to
> > > > > > > > > > > > handle the message failure, I'm going to add a retu=
rn value to
> > > > > > > > > > > > virtio_config_ops.get() and virtio_cread_* API so t=
hat the error can
> > > > > > > > > > > > be propagated to the virtio device driver. Then the=
 virtio-blk device
> > > > > > > > > > > > driver can be modified to handle that.
> > > > > > > > > > > >=20
> > > > > > > > > > > > Jason and Stefan, what do you think of this way?
> > > > > > > > > > Why does VDUSE_DEV_GET_CONFIG need to support an error =
return value?
> > > > > > > > > >=20
> > > > > > > > > > The VIRTIO spec provides no way for the device to repor=
t errors from
> > > > > > > > > > config space accesses.
> > > > > > > > > >=20
> > > > > > > > > > The QEMU virtio-pci implementation returns -1 from inva=
lid
> > > > > > > > > > virtio_config_read*() and silently discards virtio_conf=
ig_write*()
> > > > > > > > > > accesses.
> > > > > > > > > >=20
> > > > > > > > > > VDUSE can take the same approach with
> > > > > > > > > > VDUSE_DEV_GET_CONFIG/VDUSE_DEV_SET_CONFIG.
> > > > > > > > > >=20
> > > > > > > > > > > I'd like to stick to the current assumption thich get=
_config won't fail.
> > > > > > > > > > > That is to say,
> > > > > > > > > > >=20
> > > > > > > > > > > 1) maintain a config in the kernel, make sure the con=
fig space read can
> > > > > > > > > > > always succeed
> > > > > > > > > > > 2) introduce an ioctl for the vduse usersapce to upda=
te the config space.
> > > > > > > > > > > 3) we can synchronize with the vduse userspace during=
 set_config
> > > > > > > > > > >=20
> > > > > > > > > > > Does this work?
> > > > > > > > > > I noticed that caching is also allowed by the vhost-use=
r protocol
> > > > > > > > > > messages (QEMU's docs/interop/vhost-user.rst), but the =
device doesn't
> > > > > > > > > > know whether or not caching is in effect. The interface=
 you outlined
> > > > > > > > > > above requires caching.
> > > > > > > > > >=20
> > > > > > > > > > Is there a reason why the host kernel vDPA code needs t=
o cache the
> > > > > > > > > > configuration space?
> > > > > > > > > Because:
> > > > > > > > >=20
> > > > > > > > > 1) Kernel can not wait forever in get_config(), this is t=
he major difference
> > > > > > > > > with vhost-user.
> > > > > > > > virtio_cread() can sleep:
> > > > > > > >=20
> > > > > > > >      #define virtio_cread(vdev, structname, member, ptr)   =
                  \
> > > > > > > >              do {                                          =
                  \
> > > > > > > >                      typeof(((structname*)0)->member) virti=
o_cread_v;        \
> > > > > > > >                                                            =
                  \
> > > > > > > >                      might_sleep();                        =
                  \
> > > > > > > >                      ^^^^^^^^^^^^^^
> > > > > > > >=20
> > > > > > > > Which code path cannot sleep?
> > > > > > > Well, it can sleep but it can't sleep forever. For VDUSE, a
> > > > > > > buggy/malicious userspace may refuse to respond to the get_co=
nfig.
> > > > > > >=20
> > > > > > > It looks to me the ideal case, with the current virtio spec, =
for VDUSE is to
> > > > > > >=20
> > > > > > > 1) maintain the device and its state in the kernel, userspace=
 may sync
> > > > > > > with the kernel device via ioctls
> > > > > > > 2) offload the datapath (virtqueue) to the userspace
> > > > > > >=20
> > > > > > > This seems more robust and safe than simply relaying everythi=
ng to
> > > > > > > userspace and waiting for its response.
> > > > > > >=20
> > > > > > > And we know for sure this model can work, an example is TUN/T=
AP:
> > > > > > > netdevice is abstracted in the kernel and datapath is done via
> > > > > > > sendmsg()/recvmsg().
> > > > > > >=20
> > > > > > > Maintaining the config in the kernel follows this model and i=
t can
> > > > > > > simplify the device generation implementation.
> > > > > > >=20
> > > > > > > For config space write, it requires more thought but fortunat=
ely it's
> > > > > > > not commonly used. So VDUSE can choose to filter out the
> > > > > > > device/features that depends on the config write.
> > > > > > This is the problem. There are other messages like SET_FEATURES=
 where I
> > > > > > guess we'll face the same challenge.
> > > > > Probably not, userspace device can tell the kernel about the devi=
ce_features
> > > > > and mandated_features during creation, and the feature negotiatio=
n could be
> > > > > done purely in the kernel without bothering the userspace.
> > >=20
> > > (For some reason I drop the list accidentally, adding them back, sorr=
y)
> > >=20
> > >=20
> > > > Sorry, I confused the messages. I meant SET_STATUS. It's a synchron=
ous
> > > > interface where the driver waits for the device.
> > >=20
> > > It depends on how we define "synchronous" here. If I understand corre=
ctly,
> > > the spec doesn't expect there will be any kind of failure for the ope=
ration
> > > of set_status itself.
> > >=20
> > > Instead, anytime it want any synchronization, it should be done via
> > > get_status():
> > >=20
> > > 1) re-read device status to make sure FEATURES_OK is set during featu=
re
> > > negotiation
> > > 2) re-read device status to be 0 to make sure the device has finish t=
he
> > > reset
> > >=20
> > >=20
> > > > VDUSE currently doesn't wait for the device emulation process to ha=
ndle
> > > > this message (no reply is needed) but I think this is a mistake bec=
ause
> > > > VDUSE is not following the VIRTIO device model.
> > >=20
> > > With the trick that is done for FEATURES_OK above, I think we don't n=
eed to
> > > wait for the reply.
> > >=20
> > > If userspace takes too long to respond, it can be detected since
> > > get_status() doesn't return the expected value for long time.
> > >=20
> > > And for the case that needs a timeout, we probably can use NEEDS_RESE=
T.
> > I think you're right. get_status is the synchronization point, not
> > set_status.
> >=20
> > Currently there is no VDUSE GET_STATUS message. The
> > VDUSE_START/STOP_DATAPLANE messages could be changed to SET_STATUS so
> > that the device emulation program can participate in emulating the
> > Device Status field.
>=20
>=20
> I'm not sure I get this, but it is what has been done?
>=20
> +static void vduse_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
> +{
> +=C2=A0=C2=A0=C2=A0 struct vduse_dev *dev =3D vdpa_to_vduse(vdpa);
> +=C2=A0=C2=A0=C2=A0 bool started =3D !!(status & VIRTIO_CONFIG_S_DRIVER_O=
K);
> +
> +=C2=A0=C2=A0=C2=A0 dev->status =3D status;
> +
> +=C2=A0=C2=A0=C2=A0 if (dev->started =3D=3D started)
> +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return;
> +
> +=C2=A0=C2=A0=C2=A0 dev->started =3D started;
> +=C2=A0=C2=A0=C2=A0 if (dev->started) {
> +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 vduse_dev_start_dataplane(dev);
> +=C2=A0=C2=A0=C2=A0 } else {
> +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 vduse_dev_reset(dev);
> +=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 vduse_dev_stop_dataplane(dev);
> +=C2=A0=C2=A0=C2=A0 }
> +}
>=20
>=20
> But the looks not correct:
>=20
> 1) !DRIVER_OK doesn't means a reset?
> 2) Need to deal with FEATURES_OK

I'm not sure if this reply was to me or to Yongji Xie?

Currently vduse_vdpa_set_status() does not allow the device emulation
program to participate fully in Device Status field changes. It hides
the status bits and only sends VDUSE_START/STOP_DATAPLANE.

I suggest having GET_STATUS/SET_STATUS messages instead, allowing the
device emulation program to handle these parts of the VIRTIO device
model (e.g. rejecting combinations of features that are mutually
exclusive).

Stefan

--DSsECoBNx8q7LFgy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDmwAIACgkQnKSrs4Gr
c8h6Kwf/RKFVuTsq6Q9B3X1Ds+JMJMykFGJzGIfgM9OQSBGqlXKqsqlRx4QvMyAy
IWdQd/AeUo9jSanHFiG2eNkIg59+frfMsJX8RXZ94fORW5fEQElUQQTwXiUeH0fQ
D9hVd4L5WVyJKXE+VWQ1n0rMUdOCrONpEAaFWY+AXHxZVW/q628XMOfsD5RR0oSj
QVEUsOWMIZxy+dEB0rXcIkzsv2L1//gZSdA1wo0s9k2/C3HPzpBbK/Hb2dMCtmBG
FxiWjlytiTLAD084e8CDj/AlRkMWp6iKzmoG6mBJ5k2gd/EBa4vCEd4HsSeCSQBn
HnNNKdxgODM7wncWvgKF52nAsTJpDA==
=j96S
-----END PGP SIGNATURE-----

--DSsECoBNx8q7LFgy--

