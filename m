Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93143BBD16
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 14:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhGEMwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 08:52:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231243AbhGEMwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 08:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625489410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W8G/JsyH47bF0khJGv25MPY6jNei9NxXk5kKt2MzRCU=;
        b=WG/IDJw9zwQK88YZqshvNZRs+Ku1Vb1nWMw7ut/7X2nnkHhYXeJR0PAZJrCNqehz5okyd7
        N0M3Mffc0o+nojO72ybSCg0rLJArvlPEE2jiiL7fM1ZYz3f9yHgksPj3RftXXrbOkupGZk
        C6F21M9FQ5gnqbR6hc6L/bGK8rmhVJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-ugf42SHOMTOwWKHm8Kh2QQ-1; Mon, 05 Jul 2021 08:50:09 -0400
X-MC-Unique: ugf42SHOMTOwWKHm8Kh2QQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA3EB1023F40;
        Mon,  5 Jul 2021 12:50:05 +0000 (UTC)
Received: from localhost (ovpn-114-164.ams2.redhat.com [10.36.114.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5985260C0F;
        Mon,  5 Jul 2021 12:49:59 +0000 (UTC)
Date:   Mon, 5 Jul 2021 13:49:58 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Yongji Xie <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 10/10] Documentation: Add documentation for VDUSE
Message-ID: <YOL/9mxkJaokKDHc@stefanha-x1.localdomain>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210615141331.407-11-xieyongji@bytedance.com>
 <YNSCH6l31zwPxBjL@stefanha-x1.localdomain>
 <CACycT3uxnQmXWsgmNVxQtiRhz1UXXTAJFY3OiAJqokbJH6ifMA@mail.gmail.com>
 <YNxCDpM3bO5cPjqi@stefanha-x1.localdomain>
 <CACycT3taKhf1cWp3Jd0aSVekAZvpbR-_fkyPLQ=B+jZBB5H=8Q@mail.gmail.com>
 <YN3ABqCMLQf7ejOm@stefanha-x1.localdomain>
 <CACycT3vo-diHgTSLw_FS2E+5ia5VjihE3qw7JmZR7JT55P-wQA@mail.gmail.com>
 <8320d26d-6637-85c6-8773-49553dfa502d@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nJZEr38ROGX7NVP+"
Content-Disposition: inline
In-Reply-To: <8320d26d-6637-85c6-8773-49553dfa502d@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nJZEr38ROGX7NVP+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 05, 2021 at 11:36:15AM +0800, Jason Wang wrote:
>=20
> =E5=9C=A8 2021/7/4 =E4=B8=8B=E5=8D=885:49, Yongji Xie =E5=86=99=E9=81=93:
> > > > OK, I get you now. Since the VIRTIO specification says "Device
> > > > configuration space is generally used for rarely-changing or
> > > > initialization-time parameters". I assume the VDUSE_DEV_SET_CONFIG
> > > > ioctl should not be called frequently.
> > > The spec uses MUST and other terms to define the precise requirements.
> > > Here the language (especially the word "generally") is weaker and mea=
ns
> > > there may be exceptions.
> > >=20
> > > Another type of access that doesn't work with the VDUSE_DEV_SET_CONFIG
> > > approach is reads that have side-effects. For example, imagine a field
> > > containing an error code if the device encounters a problem unrelated=
 to
> > > a specific virtqueue request. Reading from this field resets the error
> > > code to 0, saving the driver an extra configuration space write access
> > > and possibly race conditions. It isn't possible to implement those
> > > semantics suing VDUSE_DEV_SET_CONFIG. It's another corner case, but it
> > > makes me think that the interface does not allow full VIRTIO semantic=
s.
>=20
>=20
> Note that though you're correct, my understanding is that config space is
> not suitable for this kind of error propagating. And it would be very hard
> to implement such kind of semantic in some transports.=C2=A0 Virtqueue sh=
ould be
> much better. As Yong Ji quoted, the config space is used for
> "rarely-changing or intialization-time parameters".
>=20
>=20
> > Agreed. I will use VDUSE_DEV_GET_CONFIG in the next version. And to
> > handle the message failure, I'm going to add a return value to
> > virtio_config_ops.get() and virtio_cread_* API so that the error can
> > be propagated to the virtio device driver. Then the virtio-blk device
> > driver can be modified to handle that.
> >=20
> > Jason and Stefan, what do you think of this way?

Why does VDUSE_DEV_GET_CONFIG need to support an error return value?

The VIRTIO spec provides no way for the device to report errors from
config space accesses.

The QEMU virtio-pci implementation returns -1 from invalid
virtio_config_read*() and silently discards virtio_config_write*()
accesses.

VDUSE can take the same approach with
VDUSE_DEV_GET_CONFIG/VDUSE_DEV_SET_CONFIG.

> I'd like to stick to the current assumption thich get_config won't fail.
> That is to say,
>=20
> 1) maintain a config in the kernel, make sure the config space read can
> always succeed
> 2) introduce an ioctl for the vduse usersapce to update the config space.
> 3) we can synchronize with the vduse userspace during set_config
>=20
> Does this work?

I noticed that caching is also allowed by the vhost-user protocol
messages (QEMU's docs/interop/vhost-user.rst), but the device doesn't
know whether or not caching is in effect. The interface you outlined
above requires caching.

Is there a reason why the host kernel vDPA code needs to cache the
configuration space?

Here are the vhost-user protocol messages:

  Virtio device config space
  ^^^^^^^^^^^^^^^^^^^^^^^^^^

  +--------+------+-------+---------+
  | offset | size | flags | payload |
  +--------+------+-------+---------+

  :offset: a 32-bit offset of virtio device's configuration space

  :size: a 32-bit configuration space access size in bytes

  :flags: a 32-bit value:
    - 0: Vhost master messages used for writeable fields
    - 1: Vhost master messages used for live migration

  :payload: Size bytes array holding the contents of the virtio
            device's configuration space

  ...

  ``VHOST_USER_GET_CONFIG``
    :id: 24
    :equivalent ioctl: N/A
    :master payload: virtio device config space
    :slave payload: virtio device config space

    When ``VHOST_USER_PROTOCOL_F_CONFIG`` is negotiated, this message is
    submitted by the vhost-user master to fetch the contents of the
    virtio device configuration space, vhost-user slave's payload size
    MUST match master's request, vhost-user slave uses zero length of
    payload to indicate an error to vhost-user master. The vhost-user
    master may cache the contents to avoid repeated
    ``VHOST_USER_GET_CONFIG`` calls.

  ``VHOST_USER_SET_CONFIG``
    :id: 25
    :equivalent ioctl: N/A
    :master payload: virtio device config space
    :slave payload: N/A

    When ``VHOST_USER_PROTOCOL_F_CONFIG`` is negotiated, this message is
    submitted by the vhost-user master when the Guest changes the virtio
    device configuration space and also can be used for live migration
    on the destination host. The vhost-user slave must check the flags
    field, and slaves MUST NOT accept SET_CONFIG for read-only
    configuration space fields unless the live migration bit is set.

Stefan

--nJZEr38ROGX7NVP+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDi//YACgkQnKSrs4Gr
c8jgKwf/S3jEpQ3OvcO2LwK0GDdjhgQBhsendLEbARZ7hCRFfpQT9NfPYYUu6ct/
WLxxofULohkENWZgImWB7p0JD3XhfXusVRbY8gy70ZjrQ9LuTglcJHd0ZBOdW9nI
ZE/AWB6ltdKTSFUmiEh+rQ2KyLB55l8VPpNhEL/KhztpGM3ZqpStVNwgpGJE4D53
7/tXKbqCMBLdVenAetRVOdbi+/DXXgCpPVutcTKEirfkJqZaum8PqPQUoT4rh1j9
vHVvnKRGLLsdLxCSa5Jw2jF9Ting+CbCV38QKdYTv8nWX7LFwIRd+xYkSkUea3i3
aRvxtciBZWCajqsu/TEsHsk1sQn4Sg==
=GVfM
-----END PGP SIGNATURE-----

--nJZEr38ROGX7NVP+--

