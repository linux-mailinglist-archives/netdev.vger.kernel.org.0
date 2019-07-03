Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A803D5E0B1
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 11:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbfGCJO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 05:14:58 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45099 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfGCJO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 05:14:57 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so1853014wre.12;
        Wed, 03 Jul 2019 02:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lMART3am9pWyOxnMhWlb45/gJVQGInIr11h4R6xfxH4=;
        b=f2qyXvKO8+f+AuUjin7CqwXeE0Ga3HeWuyEYBaaGc+UwaFejqxHfryHROkXHME8FVm
         6cPDGURKrLajBSDB5utM0xsCZaUabbFOrG+2XFvmbYZUHrxr3vgl1DOVYBYhg9Gp3Fke
         bDwJtfXwC47tA8rOx0XMa7+yoHyrS/9KvykBXxpgXpz3j9fFzrJUg1J4F+ipFHFCrawG
         2nJ0Cm+iBz3IRm9WIYGSwS+QYx1YPn8rZ/k8Am5vZwXO5dJVcHjg/fEcHlZ9QDVUxwQ2
         NXgh3/xHAgoeUv7K6QLjQlwN9YUIFsd5zHBiSp26KsLJaLDUOUZkGrLkO/XEtcHuMLd3
         2R4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lMART3am9pWyOxnMhWlb45/gJVQGInIr11h4R6xfxH4=;
        b=bwSmgPJKywFPEfknoTn+Rg3hi1nHLbEWPYCpCjkKBWMDXCzOCZNgtikOJf8iq/WxzY
         61Nyv2OC12SKsReSHDW4636lIJARIK2EStyT5uqNiDHHJ3WakAvJhD2svfnNznfUWCn4
         GGQ4FtKrf75gI8P6RdtqQ0a9OntT5pplFoJpjq1lyd4Vez1ysgL2Om+3wWllcwIf/iqb
         33dCA97SyA7LfX310df/Xhe2eo395EXZgv2YLODjgRCQW94e0JTmmNs4k3rWlFNCczpo
         NP5OyA5NBFV4+sZbyB6vDRiNKeuy2cdc8N5qxrusSUuJUQ1TFHrv6lOvTXWIGSIAmOMO
         R/tg==
X-Gm-Message-State: APjAAAW7FImwhwnvbmiQEjzq2CaGwx4AShtIfMu7NdiGqUVovKRqwDQ9
        r+bxDr7/J1Zfs0dA5OPgLbU=
X-Google-Smtp-Source: APXvYqzasBfYpcZTJ2DlrlFwe3DY2hUvRtKYYQff/WD1ChvV/9imQB0Ha2M7v94UGw7/KW2Dc9TQZQ==
X-Received: by 2002:adf:e803:: with SMTP id o3mr4360588wrm.69.1562145295443;
        Wed, 03 Jul 2019 02:14:55 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id b2sm1921496wrp.72.2019.07.03.02.14.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 02:14:54 -0700 (PDT)
Date:   Wed, 3 Jul 2019 10:14:53 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 0/3] vsock/virtio: several fixes in the .probe() and
 .remove()
Message-ID: <20190703091453.GA11844@stefanha-x1.localdomain>
References: <20190628123659.139576-1-sgarzare@redhat.com>
 <20190701151113.GE11900@stefanha-x1.localdomain>
 <20190701170357.jtuhy3ank7mv6izb@steredhat>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20190701170357.jtuhy3ank7mv6izb@steredhat>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 01, 2019 at 07:03:57PM +0200, Stefano Garzarella wrote:
> On Mon, Jul 01, 2019 at 04:11:13PM +0100, Stefan Hajnoczi wrote:
> > On Fri, Jun 28, 2019 at 02:36:56PM +0200, Stefano Garzarella wrote:
> > > During the review of "[PATCH] vsock/virtio: Initialize core virtio vs=
ock
> > > before registering the driver", Stefan pointed out some possible issu=
es
> > > in the .probe() and .remove() callbacks of the virtio-vsock driver.
> > >=20
> > > This series tries to solve these issues:
> > > - Patch 1 adds RCU critical sections to avoid use-after-free of
> > >   'the_virtio_vsock' pointer.
> > > - Patch 2 stops workers before to call vdev->config->reset(vdev) to
> > >   be sure that no one is accessing the device.
> > > - Patch 3 moves the works flush at the end of the .remove() to avoid
> > >   use-after-free of 'vsock' object.
> > >=20
> > > v2:
> > > - Patch 1: use RCU to protect 'the_virtio_vsock' pointer
> > > - Patch 2: no changes
> > > - Patch 3: flush works only at the end of .remove()
> > > - Removed patch 4 because virtqueue_detach_unused_buf() returns all t=
he buffers
> > >   allocated.
> > >=20
> > > v1: https://patchwork.kernel.org/cover/10964733/
> >=20
> > This looks good to me.
>=20
> Thanks for the review!
>=20
> >=20
> > Did you run any stress tests?  For example an SMP guest constantly
> > connecting and sending packets together with a script that
> > hotplug/unplugs vhost-vsock-pci from the host side.
>=20
> Yes, I started an SMP guest (-smp 4 -monitor tcp:127.0.0.1:1234,server,no=
wait)
> and I run these scripts to stress the .probe()/.remove() path:
>=20
> - guest
>   while true; do
>       cat /dev/urandom | nc-vsock -l 4321 > /dev/null &
>       cat /dev/urandom | nc-vsock -l 5321 > /dev/null &
>       cat /dev/urandom | nc-vsock -l 6321 > /dev/null &
>       cat /dev/urandom | nc-vsock -l 7321 > /dev/null &
>       wait
>   done
>=20
> - host
>   while true; do
>       cat /dev/urandom | nc-vsock 3 4321 > /dev/null &
>       cat /dev/urandom | nc-vsock 3 5321 > /dev/null &
>       cat /dev/urandom | nc-vsock 3 6321 > /dev/null &
>       cat /dev/urandom | nc-vsock 3 7321 > /dev/null &
>       sleep 2
>       echo "device_del v1" | nc 127.0.0.1 1234
>       sleep 1
>       echo "device_add vhost-vsock-pci,id=3Dv1,guest-cid=3D3" | nc 127.0.=
0.1 1234
>       sleep 1
>   done
>=20
> Do you think is enough or is better to have a test more accurate?

That's good when left running overnight so that thousands of hotplug
events are tested.

Stefan

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0ccg0ACgkQnKSrs4Gr
c8hyTQgAmrtuLTRHUWq+SnSxTw9xESj0gUVZd4sbTh6S0V4rPGdVbra3YbPfZfkH
IaakopaoNOkTWrPnhYmwgU30HpR8IAq/y7clSCsRIfPUYDSZok/iyag75Cy5oKno
lVANXMQYQ4Kgkq07R+BER41HW3MELCrSAX57rIat1F1OD3KouG6YicgmP7wetWcU
HVXVfjP7u1a2lUmuBdlcgPKX05STySKyNEQ3QdtLI6bgM6rGkx8OYn38Qe9cQuyi
zVG7+8JLFoJav87vvcIIB0IT8ifWocctQY//efyVVnrfHN6T5/35TPcM4bBW8HrK
Zs+bh7qyccexuuow4DrBHexFCIdtCw==
=jl/1
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
