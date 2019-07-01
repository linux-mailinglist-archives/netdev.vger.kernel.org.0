Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84FB5BF0F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfGAPIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:08:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43469 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727568AbfGAPIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:08:38 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so14240467wru.10;
        Mon, 01 Jul 2019 08:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LrbpjkQWerlunh+jeg3XioAotSIW/UwN3t21/vc60iI=;
        b=JXWwK7v6XEcs0OcGV8++JG1skKr/kr821hTyDG9c7CSJo5gWT5oFllmVtyWXK8FXFj
         yf3FfYlSQ51/rEml0Fzx/WmfBKNx3Ut/mbSvITyYvbM5pY6iEdE0BcBprLybJ3hA/LZg
         qiDdj3fOXQiNGT43YPcVPWeL21JoKL7VMRST43yF93hIzxie87lb5+8UwQY+jmXfU3hY
         TUJG19mgj3lF5yWOZI77MANVBqYIdwTwAgO6rE0cGt7Y6oqOsVIvH3lbvanjfv3QRBaX
         u1nhRbZusAzjFGsfNgQuqJe3bWWz+jk6sK6u5c0ZiYhy/2FdHPN0AFOL8ulY5sEBgieX
         Ae1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LrbpjkQWerlunh+jeg3XioAotSIW/UwN3t21/vc60iI=;
        b=Nvu0DLmAPCrNZwdbCYTQe7CgIB9PFLyRu4oRNAWY620rLwqbwHUbvYngtl9MsEzIwf
         02NaAfvjuv6xOBTqnYY7t9qlZcuOMaLNgPIQcvKh31LfVJLFELR3649POzmAs3DApIwM
         ok+CGx0V0wfvNy8yik1zhbYAZB04lBE4gEC3HPJbIMgFRLA+wIpiZFM3+//2bKoFs748
         vXMJeOdhZVPl7ZP10ugptsrqShMVprg5IdDVkOUMZDHxC1YAelzVKKdEaQ2wMuh7+LF9
         hYRiqHNwp7o0FiV4wRoU7Foyme2Mm6QwQvdT+r6r9u+n2/45fMo/A7WHYsdto7tFDNLE
         SQdQ==
X-Gm-Message-State: APjAAAU20wqYBFkGe2ulgBEvVbt/dkx2ZYeJKgDoM0SexgEeIuepdCPO
        WVqHfwaR77hgJ7BxTzctwPk=
X-Google-Smtp-Source: APXvYqzZdW0/Y4hmwKKDz/2X7Q0VwEU4tO5q2PLye3hB7/1KoFP9nEEiTBMs9FfvVZZ33rZ/AahFwA==
X-Received: by 2002:a5d:4992:: with SMTP id r18mr19297196wrq.107.1561993716303;
        Mon, 01 Jul 2019 08:08:36 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id n125sm15427370wmf.6.2019.07.01.08.08.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 08:08:35 -0700 (PDT)
Date:   Mon, 1 Jul 2019 16:08:34 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 3/3] vsock/virtio: fix flush of works during the
 .remove()
Message-ID: <20190701150834.GB11900@stefanha-x1.localdomain>
References: <20190628123659.139576-1-sgarzare@redhat.com>
 <20190628123659.139576-4-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
In-Reply-To: <20190628123659.139576-4-sgarzare@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2019 at 02:36:59PM +0200, Stefano Garzarella wrote:
> This patch moves the flush of works after vdev->config->del_vqs(vdev),
> because we need to be sure that no workers run before to free the
> 'vsock' object.
>=20
> Since we stopped the workers using the [tx|rx|event]_run flags,
> we are sure no one is accessing the device while we are calling
> vdev->config->reset(vdev), so we can safely move the workers' flush.

What about send_pkt and loopback work?  How were they stopped safely?

For example, if send_pkt work executes then we're in trouble since it
accesses the tx virtqueue which is deleted by ->del_vqs().

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0aIfIACgkQnKSrs4Gr
c8iHxwf/f/ztZPmFyV30cfT2/l/WmLT+ofdX6M4X2Z7eEb3qolhp0sYuGZjAXdAP
FrEZY0n5LGLBskjM4s3HThB2uyV/ByLZPDBKuA7SszFKZWGbB/VgR7Z2BzDCaaz2
7HnJPZoeE7KzeCygCEQ7dneriR+/HgqEW6VZFlaOYX31Nv4X7hUYerrqwmcP9qS+
tMXxWcsEMjZi9bQFxr+MCZqEJoK/Xct0Yt0ssNUxNz6Uv/KAG7XIaRXP/f+GjHXy
Uyw/MJKpC4T3N+YwpR9xfGWvLK7NZqvuorr4JGqB8R49AODaYBJepjdxnd6OD8bY
qmeew3QFothoW6phvjI3A4uKJVsYvw==
=KE3u
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
