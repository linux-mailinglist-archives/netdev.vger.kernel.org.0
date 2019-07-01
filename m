Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D97EF5BF17
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbfGAPJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:09:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43603 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbfGAPJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:09:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so14243836wru.10;
        Mon, 01 Jul 2019 08:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4C4Lsu6+V7qtjWkraF0dM4sZxy290UNJTs54g0izEto=;
        b=jjR9NZKB2J5/AEFttizEwb76mDO1keVW74L2qvV94wb2MYoEgGQ2FmJJO6m2v2i1uI
         VTr/XTqh3KP1/Pjupv/aIg8YHlosim/e+iutOtUlbzUoW+n3TxBV2VH8nkaYfTsuW5UJ
         iSSYHGJa0TF0ekiYvyw+pdGjm00UC3LwcuyYYaxUlR3TbTguwCTshvLIFIJ8xrIxNveL
         oV1EsrJjIU4Kw/t8NEThDleWzCxn7r/jJL+qDXXc4VHK4bSJO49XDhPAF3/nx2042pgK
         7S4mAqFogQNpr1pxh7NQMmm+xoxOL7yoVpssGiFHd7XVOKsFn/EyirIjqS9IuiPd5Vw+
         rStQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4C4Lsu6+V7qtjWkraF0dM4sZxy290UNJTs54g0izEto=;
        b=Qee8+LyKl8t5yTEUHhStu+MBYIxJXwxm6CdJxzHmEZ3hsj8VzUIlFvCd4nJ9K9lP6b
         6yb6xMTz/zPxhmpR3FKc5tAyc2BXwXMvVFxgHgQIYS71We4yle8UPh9kevwUotwx89yQ
         cir+5vLnNK/DZki6OEj5rfgYrsGA9mfWnAeWXPER7MeM6QZoMxafq1HmrgIF+Dy6/52w
         kYGSzPqRLw6AO/AWhjH8xRvqIDi2UxIEbOTgbTBZLB5hCZdYrzJHMwCzIUfKdFVmnoHC
         VPbIcHD+9jegIaSqrFINbnZ3hW9+zQRya1Gk0R6qZh0fjW6vqU1BhcMPWPTcZDgenYl1
         AowA==
X-Gm-Message-State: APjAAAWxHF/UjY5MoxQQ4jNaln6I070oiH+hQeNqx4rcQPWwxfJTuqpJ
        5wF4KRUyotpHpzOICfQkYfs=
X-Google-Smtp-Source: APXvYqyEm9Wo0QZCeQ35gfCp9yrIfyCDfY+4RnpuaSdyIFpwVtBTECH0YXWHs+2sB5JZoKOcoo1TdQ==
X-Received: by 2002:adf:f589:: with SMTP id f9mr19949550wro.90.1561993772081;
        Mon, 01 Jul 2019 08:09:32 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id z17sm10088062wru.21.2019.07.01.08.09.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 08:09:31 -0700 (PDT)
Date:   Mon, 1 Jul 2019 16:09:30 +0100
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
Message-ID: <20190701150930.GC11900@stefanha-x1.localdomain>
References: <20190628123659.139576-1-sgarzare@redhat.com>
 <20190628123659.139576-4-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
Content-Disposition: inline
In-Reply-To: <20190628123659.139576-4-sgarzare@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--s9fJI615cBHmzTOP
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
>=20
> Before the vdev->config->del_vqs(vdev), workers can be scheduled
> by VQ callbacks, so we must flush them after del_vqs(), to avoid
> use-after-free of 'vsock' object.

Nevermind, I looked back at Patch 2 and saw the send_pkt and loopback
work functions were also updated.  Thanks!

Stefan

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0aIioACgkQnKSrs4Gr
c8gVvwgAlt7pHdcde/naMvD5PfdMiGprB/OgOkcK9tf8VKz5xBE7qoJwvBTlAhve
22I66Q75nW7fhsMkGMn6g1wkNQDxc0aG/jPhVy1JHx/Y3NDmXvqHF0joilOYNSsm
ryxStJrhsY+0+Jpff3uPnmNKgbBJzWdzGnmn3fXIl+E3PrkvLy672DebqpaoXOr0
ISdOZG+VUuVtoVkUl90lc2uzXMY6j4s986/zPdAwnGZsI4N+GGx6Sbnb03C8h6xP
3ovvhQMqwltt+5w6qDXKpowK7L62a7EkaSPrF4Zt+y9sJudpQ6ZXMQ+J1EsbdMx/
rzsxB4KWcyBsQm2kzgSa2FmwBOPiow==
=w4hz
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--
