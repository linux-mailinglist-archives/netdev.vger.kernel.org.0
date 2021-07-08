Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1171D3BF740
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 11:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhGHJKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 05:10:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231190AbhGHJKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 05:10:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625735243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yKsQQhdebDXEx1+61ELONXUK6wL4wa5lTwMISxD88g0=;
        b=KFcOCA8RlhjrxyHy9L/WQ8f3CmLI4df3SgFlkgU4ks12Pa3YDFYSBnmCyBrfrFnoAR7LYp
        YMx54NDRpa/N6mRUOeHUNR7st2D0zZUo/PNurqLYTudRgla6Y43KgIILCzFixp3bX+R052
        UOZgri5W4kuGwdeZ/zRtp1VP8MsKDV0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-11uk5Y45N-SljR8RLm1AGw-1; Thu, 08 Jul 2021 05:07:21 -0400
X-MC-Unique: 11uk5Y45N-SljR8RLm1AGw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7189719200C0;
        Thu,  8 Jul 2021 09:07:19 +0000 (UTC)
Received: from localhost (ovpn-114-141.ams2.redhat.com [10.36.114.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2ED2D10372C0;
        Thu,  8 Jul 2021 09:07:15 +0000 (UTC)
Date:   Thu, 8 Jul 2021 10:07:14 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Jason Wang <jasowang@redhat.com>,
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
Message-ID: <YObAQsmJjKWxuO/C@stefanha-x1.localdomain>
References: <CACycT3uxnQmXWsgmNVxQtiRhz1UXXTAJFY3OiAJqokbJH6ifMA@mail.gmail.com>
 <YNxCDpM3bO5cPjqi@stefanha-x1.localdomain>
 <CACycT3taKhf1cWp3Jd0aSVekAZvpbR-_fkyPLQ=B+jZBB5H=8Q@mail.gmail.com>
 <YN3ABqCMLQf7ejOm@stefanha-x1.localdomain>
 <CACycT3vo-diHgTSLw_FS2E+5ia5VjihE3qw7JmZR7JT55P-wQA@mail.gmail.com>
 <8320d26d-6637-85c6-8773-49553dfa502d@redhat.com>
 <YOL/9mxkJaokKDHc@stefanha-x1.localdomain>
 <CACycT3t-BTMrpNTwBUfbvaxTh6tLthxbo3OJwMk_iuiSpMuZPg@mail.gmail.com>
 <YOQu8dB6tlb9juNz@stefanha-x1.localdomain>
 <CACycT3t=V-VV7LYDda8mt=QxN_Ay-N+3dgWp382TObkeei9MOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JRfIoP81GtaBg/o+"
Content-Disposition: inline
In-Reply-To: <CACycT3t=V-VV7LYDda8mt=QxN_Ay-N+3dgWp382TObkeei9MOg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--JRfIoP81GtaBg/o+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 07, 2021 at 05:09:13PM +0800, Yongji Xie wrote:
> On Tue, Jul 6, 2021 at 6:22 PM Stefan Hajnoczi <stefanha@redhat.com> wrot=
e:
> >
> > On Tue, Jul 06, 2021 at 11:04:18AM +0800, Yongji Xie wrote:
> > > On Mon, Jul 5, 2021 at 8:50 PM Stefan Hajnoczi <stefanha@redhat.com> =
wrote:
> > > >
> > > > On Mon, Jul 05, 2021 at 11:36:15AM +0800, Jason Wang wrote:
> > > > >
> > > > > =E5=9C=A8 2021/7/4 =E4=B8=8B=E5=8D=885:49, Yongji Xie =E5=86=99=
=E9=81=93:
> > > > > > > > OK, I get you now. Since the VIRTIO specification says "Dev=
ice
> > > > > > > > configuration space is generally used for rarely-changing or
> > > > > > > > initialization-time parameters". I assume the VDUSE_DEV_SET=
_CONFIG
> > > > > > > > ioctl should not be called frequently.
> > > > > > > The spec uses MUST and other terms to define the precise requ=
irements.
> > > > > > > Here the language (especially the word "generally") is weaker=
 and means
> > > > > > > there may be exceptions.
> > > > > > >
> > > > > > > Another type of access that doesn't work with the VDUSE_DEV_S=
ET_CONFIG
> > > > > > > approach is reads that have side-effects. For example, imagin=
e a field
> > > > > > > containing an error code if the device encounters a problem u=
nrelated to
> > > > > > > a specific virtqueue request. Reading from this field resets =
the error
> > > > > > > code to 0, saving the driver an extra configuration space wri=
te access
> > > > > > > and possibly race conditions. It isn't possible to implement =
those
> > > > > > > semantics suing VDUSE_DEV_SET_CONFIG. It's another corner cas=
e, but it
> > > > > > > makes me think that the interface does not allow full VIRTIO =
semantics.
> > > > >
> > > > >
> > > > > Note that though you're correct, my understanding is that config =
space is
> > > > > not suitable for this kind of error propagating. And it would be =
very hard
> > > > > to implement such kind of semantic in some transports.  Virtqueue=
 should be
> > > > > much better. As Yong Ji quoted, the config space is used for
> > > > > "rarely-changing or intialization-time parameters".
> > > > >
> > > > >
> > > > > > Agreed. I will use VDUSE_DEV_GET_CONFIG in the next version. An=
d to
> > > > > > handle the message failure, I'm going to add a return value to
> > > > > > virtio_config_ops.get() and virtio_cread_* API so that the erro=
r can
> > > > > > be propagated to the virtio device driver. Then the virtio-blk =
device
> > > > > > driver can be modified to handle that.
> > > > > >
> > > > > > Jason and Stefan, what do you think of this way?
> > > >
> > > > Why does VDUSE_DEV_GET_CONFIG need to support an error return value?
> > > >
> > >
> > > We add a timeout and return error in case userspace never replies to
> > > the message.
> > >
> > > > The VIRTIO spec provides no way for the device to report errors from
> > > > config space accesses.
> > > >
> > > > The QEMU virtio-pci implementation returns -1 from invalid
> > > > virtio_config_read*() and silently discards virtio_config_write*()
> > > > accesses.
> > > >
> > > > VDUSE can take the same approach with
> > > > VDUSE_DEV_GET_CONFIG/VDUSE_DEV_SET_CONFIG.
> > > >
> > >
> > > I noticed that virtio_config_read*() only returns -1 when we access a
> > > invalid field. But in the VDUSE case, VDUSE_DEV_GET_CONFIG might fail
> > > when we access a valid field. Not sure if it's ok to silently ignore
> > > this kind of error.
> >
> > That's a good point but it's a general VIRTIO issue. Any device
> > implementation (QEMU userspace, hardware vDPA, etc) can fail, so the
> > VIRTIO specification needs to provide a way for the driver to detect
> > this.
> >
> > If userspace violates the contract then VDUSE needs to mark the device
> > broken. QEMU's device emulation does something similar with the
> > vdev->broken flag.
> >
> > The VIRTIO Device Status field DEVICE_NEEDS_RESET bit can be set by
> > vDPA/VDUSE to indicate that the device is not operational and must be
> > reset.
> >
>=20
> It might be a solution. But DEVICE_NEEDS_RESET  is not implemented
> currently. So I'm thinking whether it's ok to add a check of
> DEVICE_NEEDS_RESET status bit in probe function of virtio device
> driver (e.g. virtio-blk driver). Then VDUSE can make use of it to fail
> device initailization when configuration space access failed.

Okay.

Stefan

--JRfIoP81GtaBg/o+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDmwEIACgkQnKSrs4Gr
c8h1Uwf/V57anfkJGNBdE/1nvE9TLQ0SZ4PD1vU4fyfrXmi1FuC/T0RDPx2KpjhM
pTZtL/+8qsT68q4dLuI3vRpys19JEXe5G6qtKeJp6Hj2gWhq5fcIQE40rwjI2Q0M
r7hKT/3JCtuQMcv8XDUOU7QRg32V/uP7DABqOqHvhEU0D3nK07bLS2J5g035Tn6X
munQgDzLg0BPKTntfz1CUooXjcF6l9HOuBnRBPIldlavndT3KKMnWW9atAf9Tofl
2N1is88HX38huzt8UCnp57cdjFNtA59nfH3Au3mZ4s1NDKmwtAwGLRc0yJch4+cG
M+8mdGvmL3lc/0owKY8YpOtgyL4xIg==
=kNcQ
-----END PGP SIGNATURE-----

--JRfIoP81GtaBg/o+--

