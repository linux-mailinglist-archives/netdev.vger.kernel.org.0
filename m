Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC2B16ABBA
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgBXQf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:35:56 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59857 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727426AbgBXQfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 11:35:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582562154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oPEJhsKQjaftTfxeHp3y5FL2X8//l96FQ+mWxCiZnNY=;
        b=PkhIEd+DCLBnkobAERVRElX1OAv1jrfo3oiQpI8lVnw/FOzJVYlA7F9hL8ridoMPzyS8ei
        2zGulcR9rcc0dFb8GJcFS4INWNCodY31bSWEeWAplF1RW1uRTIxne5mMAY9MuTER2ehEM1
        UovdKRcENQEKLB0bkFkyRZD0y7AeC7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-Jrv0OMQ3OEWQWa77tUf6CQ-1; Mon, 24 Feb 2020 11:35:45 -0500
X-MC-Unique: Jrv0OMQ3OEWQWa77tUf6CQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51961800053;
        Mon, 24 Feb 2020 16:35:43 +0000 (UTC)
Received: from [172.31.0.54] (ovpn-112-52.rdu2.redhat.com [10.10.112.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD5F785748;
        Mon, 24 Feb 2020 16:35:40 +0000 (UTC)
From:   Doug Ledford <dledford@redhat.com>
Message-Id: <10EE986F-E1F6-44F3-A025-6F2CA820C690@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [GIT] Networking
Date:   Mon, 24 Feb 2020 11:35:38 -0500
In-Reply-To: <20200224163312.GC4526@unreal>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "Weiny, Ira" <ira.weiny@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
References: <20150624.063911.1220157256743743341.davem@davemloft.net>
 <CA+55aFybr6Fjti5WSm=FQpfwdwgH1Pcfg6L81M-Hd9MzuSHktg@mail.gmail.com>
 <CAMuHMdViacgi1W8acma7GhWaaVj92z6pg-g7ByvYOQL-DToacA@mail.gmail.com>
 <20200224124732.GA694161@kroah.com> <20200224163312.GC4526@unreal>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed;
        boundary="Apple-Mail=_FD6ECC63-F649-4CBF-8094-031AB9B42D08";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_FD6ECC63-F649-4CBF-8094-031AB9B42D08
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On Feb 24, 2020, at 11:33 AM, Leon Romanovsky <leon@kernel.org> wrote:
>=20
> On Mon, Feb 24, 2020 at 01:47:32PM +0100, Greg KH wrote:
>> On Mon, Feb 24, 2020 at 11:01:09AM +0100, Geert Uytterhoeven wrote:
>>> Hi Linus,
>>>=20
>>> On Thu, Jun 25, 2015 at 1:38 AM Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>> On Wed, Jun 24, 2015 at 6:39 AM, David Miller <davem@davemloft.net> wr=
ote:
>>>>>  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git mas=
ter
>>>>=20
>>>> On the *other* side of the same conflict, I find an even more
>>>> offensive commit, namely commit 4cd7c9479aff ("IB/mad: Add support for
>>>> additional MAD info to/from drivers") which adds a BUG_ON() for a
>>>> sanity check, rather than just returning -EINVAL or something sane
>>>> like that.
>>>>=20
>>>> I'm getting *real* tired of that BUG_ON() shit. I realize that
>>>> infiniband is a niche market, and those "commercial grade" niche
>>>> markets are more-than-used-to crap code and horrible hacks, but this
>>>> is still the kernel. We don't add random machine-killing debug checks
>>>> when it is *so* simple to just do
>>>>=20
>>>>        if (WARN_ON_ONCE(..))
>>>>                return -EINVAL;
>>>>=20
>>>> instead.
>>>=20
>>> And if we follow that advice, friendly Greg will respond with:
>>> "We really do not want WARN_ON() anywhere, as that causes systems with
>>> panic-on-warn to reboot."
>>> https://lore.kernel.org/lkml/20191121135743.GA552517@kroah.com/
>>=20
>> Yes, we should not have any WARN_ON calls for something that userspace
>> can trigger, because then syzbot will trigger it and we will get an
>> annoying report saying to fix it :)
>=20
> Impressive backlog :)
> Geert, you replied on original discussion from 2015.

Yeah, that threw me for a loop too ;-).  Took several double takes on that =
one just to make sure none of the IB comments from Linus were related to an=
ything current!

--
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD








--Apple-Mail=_FD6ECC63-F649-4CBF-8094-031AB9B42D08
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl5T+1oACgkQuCajMw5X
L93rug//f9+2IUWpedkq72QDxAiUsyYedKyHOBfUrJ79WM3RWNIVWcsxPwRoAYTB
Np1aTtiKCx/5cDQIhmtl4YtsyekT9JjDcc9y0xeTByhMJWrBT8QVH/oiKuq9n1RZ
XW7n+XS0O4h6WS0HauL/1ADXxnO+QqTD0n+SSFxZD9SR3zFsOObtLaOCTU0I/aL5
wdVX3VCdjSZoedDTtkJDf+36tvVzVyCM9mqpiCMo2A2gdZlhEysn5zswf3HL+LJz
KkEhv0uiivy7WSKZwE70zx/2rMXtZGpQIdGmKrAHwlyOHIKwW8bNCBc/oddbzEiL
VLIeDQWnFxBmwPGgywGu/vW6Q80K8UheY48y2K1y29WicWaeP1tbWxdMPzTI1Ugy
FEuCY4j/YVQqN8z6AMmX6xvjkjFMwKl/polSrFWEa9EFrfG0WVIc4r87T8RK2YAh
PxJ24l88kQxMjX0xMin9RJaz20VwqhyfdhFTWN9WauftonLIHazkc24DC4eOS+R3
UpVBY3ybch2+/tsNdgLZf10R9OsEC+DUjUrJiKyCxFl573kUwZM2ls7MctvGj8or
Q7Q9ziMJ+rz8lQhxat20dMl6uW+1RwgO29dmVChNcoDEblgSeKezTJOP8bnbGai9
zugOy3ewpgER1/aM/BehT4CbOsXt3u1BIUtm9VN7RH2VLYJPkIM=
=tadj
-----END PGP SIGNATURE-----

--Apple-Mail=_FD6ECC63-F649-4CBF-8094-031AB9B42D08--

