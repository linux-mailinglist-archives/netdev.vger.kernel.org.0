Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90EED0DEB
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 13:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730888AbfJILqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 07:46:46 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42523 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730398AbfJILqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 07:46:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id n14so2512278wrw.9;
        Wed, 09 Oct 2019 04:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tKPlVOyQX0Mune1fiTMXvubT6ipc/MtiuESvbbCqVwA=;
        b=tfAur79IhqF7wyao5kZUd9YgUGH1vIsmdgKNoxBs2vpbNOP8YmIxbc5xmrGLAnSgFb
         nbQSQSxChJq8lAcivLbr0JZHSnbndhraQDtZBqW4F6z7sXPVXdJR1q8hUAyf74dsiuDj
         W/ZBbrnCh7013OOsNB90IBEwi3GQ1y3MLWqAaQs8QoZhy46MUkwBBWwawYFwDTFMJ9Jp
         47BDhuQMCOZCjsv8pDWbRQz9ij9hLaBPelGzUX0OfHOaYc+lqdINR0bHzSQelS4pIvuK
         Vc6zxx6v+x46nwuG/UOXq5SAtsG+P33cxhH37KhBSGLGwQagjNaxCzIrCZ3Z4EhQ47wh
         FYLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tKPlVOyQX0Mune1fiTMXvubT6ipc/MtiuESvbbCqVwA=;
        b=rnOI4tXREvFF5N2GwdBt6Z8WE9H2swbZ5d03uEJPEb7bJID5Tes4QwaaAqCDHWUTga
         R4r5K0jLMwGOdcFXNNcus31sGPcJMnLIGtBfB/sMBiTqbhs1E3pmYxKODMYqapFMMJHb
         bUyyGDY3W/Q6+6VrNbif5OyqW7cXVEid0CIYijRqGzUQ2ng1SsI7ZpQgbP4/pDtzN/Vq
         uDKRmbVbsVAQeU9GVVwvIfe/rCNkrNhIaXhVqF0PDLekZucY8VqqHJQCYyNmV4NhMr4p
         loBOXZ3VMXaLt2XgmSavcze/7Bi4u69tzfNqKHXarrNDpTyQZpumsBtuYvLFFNj3DtzC
         /fPg==
X-Gm-Message-State: APjAAAUFF+2avopdxcvmu9Sq2O3Q5ZBsB5L4m1+BnUjCgpy2/TritfCX
        ycCy71hilNw/XENSC7rPfRc=
X-Google-Smtp-Source: APXvYqwavV9IPYcWKUfdQEMiJWJzx8yh1yPx1dxVIpmks3FRBII+mSAk/MXkMGyOZd/46y+5xHO+PQ==
X-Received: by 2002:adf:db43:: with SMTP id f3mr1458077wrj.11.1570621603697;
        Wed, 09 Oct 2019 04:46:43 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id w5sm2212043wrs.34.2019.10.09.04.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 04:46:42 -0700 (PDT)
Date:   Wed, 9 Oct 2019 12:46:41 +0100
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
Subject: Re: [RFC PATCH 04/13] vsock: add 'transport' member in the struct
 vsock_sock
Message-ID: <20191009114641.GE5747@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-5-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OZkY3AIuv2LYvjdk"
Content-Disposition: inline
In-Reply-To: <20190927112703.17745-5-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OZkY3AIuv2LYvjdk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2019 at 01:26:54PM +0200, Stefano Garzarella wrote:
> As a preparation to support multiple transports, this patch adds
> the 'transport' member at the 'struct vsock_sock'.
> This new field is initialized during the creation in the
> __vsock_create() function.
>=20
> This patch also renames the global 'transport' pointer to
> 'transport_single', since for now we're only supporting a single
> transport registered at run-time.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/net/af_vsock.h   |  1 +
>  net/vmw_vsock/af_vsock.c | 56 +++++++++++++++++++++++++++-------------
>  2 files changed, 39 insertions(+), 18 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--OZkY3AIuv2LYvjdk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2dyKEACgkQnKSrs4Gr
c8gl2wf9GDmxHYnnuV/4iY/UGudKy+Um/JJ6pvLVFrUG/VRJTTs7M23YLemIGqSr
G8h+cAEog9/59utW/OavWSSiV6dn3b84u74m7VrMCp4SYrYO8XbdUy0adjFAi6CT
+CeNnNORBhdA98Z8vMb4Z7oRjNF6i93S2Qb/ShDZX1K9zq1OhMNKstoZ+nrCbTOD
PP8heokQ0sC2Gh6+QOMFmG/yPufk9Yp3Ld1FN4jzxZuLnj7vS/qq8w6/m33qdkKs
O59qSocNgs90h6x7IP8dxTzfyjPIL76Pd8YeER0+WKvMubbc2tp1fyAZFXGHCf8p
8MPdEyjQYwluu8naEZY7Xp29OVNOnQ==
=2nON
-----END PGP SIGNATURE-----

--OZkY3AIuv2LYvjdk--
