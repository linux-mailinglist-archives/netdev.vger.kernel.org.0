Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A91D1023
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 15:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731563AbfJIN3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 09:29:23 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40806 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731181AbfJIN3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 09:29:23 -0400
Received: by mail-wm1-f65.google.com with SMTP id b24so2611017wmj.5;
        Wed, 09 Oct 2019 06:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GDuh8wOWud4/h7FBqgUO27K9UbX8e3rhEg2xYH7BQNg=;
        b=f+nXm2f/x4SFc3z61bN/4O+TQEsVxwJLm1a8Ysx2R0Jwt5UoKtc7Rb9yu4+9HgkILs
         2wvIwU68sXGIVb1+YrM4MaTImBjZfYmarAqMC2Y7wZCPqcBvarWKAZ06VBSN8aGr/yhu
         CFfyXyi9K+DxQ8OHAp3bJFHDFyGpXl+PfCZPVC9Rmphk88/T5Y2xYIxo91ECmlJC8BZk
         9H6aB0DiFx3hQa1Z9M2a4UJbePb/vpazuPthF2V4dtM+Qx0r8gHkCyjKoAqa0IzscDd2
         GeUfBWin4JZN/V8wtLAGvLX3g816AfgCZG/57Xt3zlpLYNh+I6iatUhB3mS76zoyZ0ss
         ZNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GDuh8wOWud4/h7FBqgUO27K9UbX8e3rhEg2xYH7BQNg=;
        b=khLE/CPVTXAleTvOTe0cyHUiwO1HmVxuhOASHbTlpjB7IXmI9plWaY0IHpU5Y/Wr0N
         sBYry0IFyXPiioFvGoQDG3ob/Huq+MIXhum3q4RfM569wzrP3qW7f5C6uYH7ai6ajt7n
         yLR0Yic2fQbnbhIulAXVnjjrbFnxqJHMyhzNYAgZG3E/9ytoT+nALmNuDf+ol/QhyeXu
         P2M84RgaZ1LEZLb+R4OeugZGG4ovkXzgRYXzb74Zk+UJ2+gGjtr0lWi38D6nvzODE8qN
         TJFcKHm6V2GXzueLkuqmxI3VamMdJ+D8gYCLo1jQ6laT7qIDQf8Sbv4Uax0kJ6xUpXo7
         ipVA==
X-Gm-Message-State: APjAAAVXlMnhzZQ7noAJjylVgOpoYN8Vyq7LCdRQq10OLu2tAg9z3bG/
        vqxvUfNl7RS20Ttg9x/Xbas=
X-Google-Smtp-Source: APXvYqw1aUJubsYg5UUcikhG5dviUNyvuNRUtpwlBrEioF409+G2sxwGyLDf1q0QhLloVC316zvwsQ==
X-Received: by 2002:a1c:f210:: with SMTP id s16mr2434290wmc.24.1570627761339;
        Wed, 09 Oct 2019 06:29:21 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id t83sm3862315wmt.18.2019.10.09.06.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 06:29:20 -0700 (PDT)
Date:   Wed, 9 Oct 2019 14:29:19 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 13/13] vsock: fix bind() behaviour taking care of CID
Message-ID: <20191009132919.GN5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-14-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cs5saTBZh7UZl2eX"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-14-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cs5saTBZh7UZl2eX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2019 at 01:27:03PM +0200, Stefano Garzarella wrote:
> When we are looking for a socket bound to a specific address,
> we also have to take into account the CID.
>=20
> This patch is useful with multi-transports support because it
> allows the binding of the same port with different CID, and
> it prevents a connection to a wrong socket bound to the same
> port, but with different CID.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/af_vsock.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--cs5saTBZh7UZl2eX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2d4K8ACgkQnKSrs4Gr
c8jIHQgArLXLyHXwZu55EHHu9yiNNFHasNE5dRT3AdGHmJvK/neRvEFmuyQ2w9Xr
Ap1yzIgihhRbUNxJaiyxXeuB1KwSQmWUSs15m027eetOieQFnnPZodUYF1PVRloj
+2ol43xqmHW4vOlqdXbTrl6Ggr97gSNylVBDC5naNbR/r7/md1MYEmkpRTGHlUFe
IPQ5Ip2z8hWKLnK70fs1yYKmj8Tbb+pZBDN68i3iC5+98SzrvY9Tix1SfeQwVSn+
HKXhugUiYvtl2VwaqSEud28/3Hqcxe3wnfZcYXFJkPhj5p0/gprCBUeLUfP4jwlz
b42+Ttg66N+HW7vXgrTesK83l3PpJA==
=f3oL
-----END PGP SIGNATURE-----

--cs5saTBZh7UZl2eX--
