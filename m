Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC27D0EF3
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbfJIMf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:35:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33152 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730662AbfJIMf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 08:35:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id r17so4676578wme.0;
        Wed, 09 Oct 2019 05:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zrukuNIIpELS1SFhnaqgjV+S03DcpwgywhfpTJYGiQY=;
        b=YXWWoxP687A4XDYTVavYfNNciK2iQ3bmHf87UHCsApkdu79BpNx2//OcEqWcVxnCyi
         xLJgx28lRn8/3stvBve9smtm0pdcFk5rF6GR32ipf7KGFWBiSDNJ/G313z/GJbOLOyf1
         0GgmM4KMdLcmEr2tkc2lUPvzB9oV1LKtFNj5r1N1ztWPV3Ihq78w4at+y9KLqPFjD2dr
         wCUpV6hILJU9EpH4psIpdxWw/p5i64tRaF8FSoAJB6NFaftHNxo7ruiynw+UvZgN0PXt
         vjlD/f63gHYQPqtUD/uzBOMUaPgw9i4Bx9EbeTD923ox9nnMe3Eo1FhGzxATp5KDB48A
         5spw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zrukuNIIpELS1SFhnaqgjV+S03DcpwgywhfpTJYGiQY=;
        b=qW9QJ+LgomqnTpkiGoXM/ymUIu9J6xR5z//GCto1U9Goo4nQzxGMU47OIfAEynakS9
         W8UPBBDpL6ZBYMZEoV074umoyPp2MN88a8LGLQXHwkxZGynLa7KHYRSWvztc3QM6cLeD
         OjZ0+0bs7xw14ZJpPMBtPwzOC6XXNL4P7Sb75qZkSuUpOsHHNoc5qmWwHbZdRBoQ3S+t
         bvu89vEuJ97BoRl/KMvKrtRhf74WIv8qP1Ff1A6FycaSHIMtZQ2Hssf5+aP5Wm3N4T/a
         YfKXg8cf2heiOEPMJg61/+kjSdOmRYguh+4NerAud4TI7SeQFQUO7nh9gQhumaSVx5WR
         JjJg==
X-Gm-Message-State: APjAAAVUdb+kcX7SCxf/p7vL4vBihj9ED5FLWJ+14PaqwkI1bYM75o6n
        KJMTQCQ7Mr4e8LBxE+2CuhI=
X-Google-Smtp-Source: APXvYqyIM0rgTcW2Gxf93OV7hWpxtlNpWqt+guqqmn2grspSyMcKu7E2vZauZhYTsT6VIMg9UDo/NQ==
X-Received: by 2002:a1c:a8c7:: with SMTP id r190mr2445724wme.162.1570624526496;
        Wed, 09 Oct 2019 05:35:26 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id d15sm2260310wru.50.2019.10.09.05.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 05:35:25 -0700 (PDT)
Date:   Wed, 9 Oct 2019 13:35:24 +0100
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
Subject: Re: [RFC PATCH 09/13] hv_sock: set VMADDR_CID_HOST in the
 hvs_remote_addr_init()
Message-ID: <20191009123524.GJ5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-10-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5me2qT3T17SWzdxI"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-10-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5me2qT3T17SWzdxI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2019 at 01:26:59PM +0200, Stefano Garzarella wrote:
> Remote peer is always the host, so we set VMADDR_CID_HOST as
> remote CID instead of VMADDR_CID_ANY.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/hyperv_transport.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--5me2qT3T17SWzdxI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2d1AwACgkQnKSrs4Gr
c8jb5wf/RiXbiexvEEg0hOVPHCNYSDBNEehuU8/ZUOo11ueiWzI9+b5rFidWUcc9
4VZ3SCtzOW/3meXooyF42QP97QPJ0sQO3jpPZjCECe9McxAbm0zum+N3Cb/0AbjT
xrpQ1FHtTgGBHydsxFcsyIcZMvp91o4Q7qNtExg/CB7vbOEJXFkSmh5968GD3o1f
uK0Rqjqgx1Fm30mT41uRe41JvrE7QtJr8yc/uFB2h2JL7RgxRa+G+mIV1+66P2t+
xIwq8Nj/JyQBfvD82Bvezuvf6ITNloJ7/97xTnHgg2U0YcslB/cU8gArZJlWHAKv
O9b3imMu/xyzY1oO4yJ+mmOM3cEtFQ==
=ktlx
-----END PGP SIGNATURE-----

--5me2qT3T17SWzdxI--
