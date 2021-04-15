Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D70C360BAA
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 16:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhDOOSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 10:18:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230056AbhDOOSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 10:18:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618496276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IOewNMfPKKreZaktQJpTbBLLtYdk3yANsE5YR8AZsrE=;
        b=A31V1EnGAaoX0LjsR7HfCDpymk+xFiONcgA+OkdIn8f3WbluhPbodDXFAepBEg7ISqnWub
        1a8hIciemyNDvjdWZHsp/yliGXu6w6OWaGwApd5kozg4kEQkLm6mZfATkHfNa+AIycAoBi
        gkMXdPYBEBo1VfjfJdmZSM26yxlI4QI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-zPBktbWMNaCxZdXJ3ywBsA-1; Thu, 15 Apr 2021 10:17:55 -0400
X-MC-Unique: zPBktbWMNaCxZdXJ3ywBsA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5981D801814;
        Thu, 15 Apr 2021 14:17:52 +0000 (UTC)
Received: from localhost (ovpn-114-209.ams2.redhat.com [10.36.114.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D7495D723;
        Thu, 15 Apr 2021 14:17:47 +0000 (UTC)
Date:   Thu, 15 Apr 2021 15:17:47 +0100
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
Subject: Re: Re: Re: [PATCH v6 10/10] Documentation: Add documentation for
 VDUSE
Message-ID: <YHhLCyF/2VYzrL3g@stefanha-x1.localdomain>
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain>
 <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
 <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain>
 <CACycT3tRN1n_PJm1mu3=s1dK941Pac15cpaysqZZKLR6xKaXSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MPbHG8vrrTTLxD+q"
Content-Disposition: inline
In-Reply-To: <CACycT3tRN1n_PJm1mu3=s1dK941Pac15cpaysqZZKLR6xKaXSg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--MPbHG8vrrTTLxD+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 15, 2021 at 04:33:27PM +0800, Yongji Xie wrote:
> On Thu, Apr 15, 2021 at 3:19 PM Stefan Hajnoczi <stefanha@redhat.com> wro=
te:
> > On Thu, Apr 15, 2021 at 01:38:37PM +0800, Yongji Xie wrote:
> > > On Wed, Apr 14, 2021 at 10:15 PM Stefan Hajnoczi <stefanha@redhat.com=
> wrote:
> > > > On Wed, Mar 31, 2021 at 04:05:19PM +0800, Xie Yongji wrote:
> > It's not obvious to me that there is a fundamental difference between
> > the two approaches in terms of performance.
> >
> > > On the other
> > > hand, we can handle the virtqueue in a unified way for both vhost-vdpa
> > > case and virtio-vdpa case. Otherwise, userspace daemon needs to know
> > > which iova ranges need to be accessed with pread(2)/pwrite(2). And in
> > > the future, we might be able to avoid bouncing in some cases.
> >
> > Ah, I see. So bounce buffers are not used for vhost-vdpa?
> >
>=20
> Yes.

Okay, in that case I understand why mmap is used and it's nice to keep
virtio-vpda and vhost-vdpa unified. Thanks!

Stefan

--MPbHG8vrrTTLxD+q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmB4SwsACgkQnKSrs4Gr
c8iNcgf/SlAcQNeAhYZD3E8EAxA7kj75HWb2bs314xQK1UuM8yPecd9e468z8oN6
e0lS0+RDTiPjrV+Nlpgs6+xVqLAjatBXGWiauZeed+q6kMlAlt9OiZApRG3/AACc
spwkoFaL9mPKBS5lAaGAEiJqd3ZjA1EpKbXq8klSFDVYLXkfD8qyxxsAUlREsH6t
s0yoJqiZlLqcDPcfPw4aCEOZteP3MNSinotRCHDDQ6X0cDpcqCyInpClclxd507Z
fxz/hu7w1vEbPIGcp6O5VsaUolPr74X0HS4lkDRN32vh8OkDnGsoDiNQg0sduQ5u
FV/ND4nsUIUTsXxlBnLOcX2Cj1V4/w==
=wUKZ
-----END PGP SIGNATURE-----

--MPbHG8vrrTTLxD+q--

