Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8671CD0DDB
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 13:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbfJILm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 07:42:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52701 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfJILm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 07:42:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id r19so2180634wmh.2;
        Wed, 09 Oct 2019 04:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c5SSACmthJRQcjJkz/aOKtBtFAYEKfh5z4QTzPsgi4Y=;
        b=j5tdx8nF7X8fZu4hsRKd/9vyZSpHRVdLGFki/5+EuZUC/Vh3+55WPgCkxycSLkeQ2+
         3FLGfFGqHCnDUW6y2RCS+tYGfVY4YTGwpTRPlPzAA35xmR2qLUqwx/eJjnPeqH5Deiz9
         IOQ3jAitlMDxnITZX6li+DSdGpJhlIBS/JeDTYBX4vgyx3T5iLbw/pupJqYhUtpVTwo+
         NLI4HJWk5AsKOYLp4+8bvqqn6s5FkJaK0pnUenMqh5Uhb+vENvSrJ7mM8c6fT7cTNIC2
         I3KFL+WOQlolgxOgQ8w1dERgNuxGpgwa00v4YdnXu2I/+jK0l6aUMEpgp8WMzUAGlmdo
         saOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c5SSACmthJRQcjJkz/aOKtBtFAYEKfh5z4QTzPsgi4Y=;
        b=ttH8DbfRAxhUphfV4hakGq0JaxRFP6b3MSSg090OEvkkRFv3zhnbGMr4V5tutVBbKp
         VYiMGceGTIQEd8M9JQFkQB+Ij/49pTiKCUxH8plUSEKJZCpTZE52dXoqDtktYsE2iXzw
         fzj4SSJIVqrq0vGmiotwgzmd152/HOYrYaj8gyq+ORwb/ayY954M2xGzMaQlX162+7yu
         5wnhrUIn+SKcDrPRpYYFtP9GD7ChXV2ybZNeOvuL1DMrIooYJcUmeBxrSFq/jVrI4Bpz
         TzbDQd1n8H5UH7mx3aTXlM6c1ZWJutFK9Fc9Dk3IQbLx8eAEXbnu8zkBOzWdj6OxZmXi
         RgEQ==
X-Gm-Message-State: APjAAAWSi6QzQQRz7OXUcTqFF04kk3AokruL61S2oo8bsL91FKxEqCAv
        s8pMoxFXcUB/KlS2Yb/g0jA=
X-Google-Smtp-Source: APXvYqxDusp37rvnAAD8JV7i111vUFrUvZt0D6U0IlYV2lVUtocVAp+sY2ltqAtjrhtVSpEyY/ib6A==
X-Received: by 2002:a1c:49c2:: with SMTP id w185mr2223617wma.16.1570621346629;
        Wed, 09 Oct 2019 04:42:26 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id v20sm1848031wml.26.2019.10.09.04.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 04:42:25 -0700 (PDT)
Date:   Wed, 9 Oct 2019 12:42:24 +0100
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
Subject: Re: [RFC PATCH 02/13] vsock: remove vm_sockets_get_local_cid()
Message-ID: <20191009114224.GC5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-3-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-3-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2019 at 01:26:52PM +0200, Stefano Garzarella wrote:
> vm_sockets_get_local_cid() is only used in virtio_transport_common.c.
> We can replace it calling the virtio_transport_get_ops() and
> using the get_local_cid() callback registered by the transport.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/linux/vm_sockets.h              |  2 --
>  net/vmw_vsock/af_vsock.c                | 10 ----------
>  net/vmw_vsock/virtio_transport_common.c |  2 +-
>  3 files changed, 1 insertion(+), 13 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2dx6AACgkQnKSrs4Gr
c8hCTQf7B7NVspFDFsnm05GLUu5jhE/dRHrC3VyeqqicE3uUMPD7T+dn+SoNtnKs
OX/U72s4FYr4zeIPdjJaH4nqrMEmX8Cl6v9T20IEH58vvEnms/9iSyj0w+FdTFD7
ob0Ggxu22UzOtKpdYjzKXO2JyzxEguYGigkvWnN+WNAlLxfI4UyruK7LGhLrngDe
1TdiSHMS/b/HDZgQVbcF8wSEg9D+yg6gJsz+CiYneq3hcTR1ezWBCVLwUmkMGm9E
WOJP23V3t0m5K+Ottl8daxdvvIh58O/y9Xsrd8G4FRAjJvpSGwiai4KPnTfAhHzQ
sLP3Xt853ipwkz1KWXmS9dg8eJEyTQ==
=k7J2
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--
