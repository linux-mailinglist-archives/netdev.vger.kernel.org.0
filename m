Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18FD2E9315
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 11:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbhADKFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 05:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbhADKFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 05:05:42 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F57C061574;
        Mon,  4 Jan 2021 02:05:01 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id a12so31528252wrv.8;
        Mon, 04 Jan 2021 02:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uFFU3VXsv3EPwLwjLxtgH+p/qlSMAwu7grwI0PaoZiQ=;
        b=QWHADie0s84qde1sI/e7JgVp7NxxE472JwIN5+FxFbv0+u60SVbKkD00Whsau0NoYi
         xHiPER08qL35eUyUT+waT/v6wk4E1Mwd1YNeoY1k4fKaI22fU/WTMA6NNFiEI8eCmBVs
         59rYSyNyisznbyyBOgt4g27fCW3SlwkGU7eF67/Q6L7XEiXaw1mhD7ztsx9zyKgD5bkC
         E1uz/HbEf8he4AJvRV3uJANyJZA+1SV7DyY4485hqC0N392FNN0Li2LQ5SEZN2VHmUpk
         L5IBSzuUI8c+g0XKddW6OFMVoWy2MDkT3OkrFF5Endgg5/j4BGIEc+o1l0E2NO8yleFf
         wheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uFFU3VXsv3EPwLwjLxtgH+p/qlSMAwu7grwI0PaoZiQ=;
        b=RxYBbc0uCjx+MLJ0KmH9M9mJa6wplAwNnsbcASjsud79YTWk+15uK/CJy2rHfD8NG0
         ZrHaGC8OaOpwWqRSnUIXO5VDOoZAnX491PSxCXbP8FSQs+8zAcHFalHCitEd2CU4TgYI
         L9ppCiaYw032NH5GhNPiQN4ds4T4G8QDucRW68o13+whmwb+pR2twFCCEoPPJv1Yx6/x
         clHt0hGjp1K5ni86Ki8wG5rNR/MBSrOemKWAVeHFgCW23ZRsLWA+rpKGZb/JUjPhSOMn
         VX2PF3SLNr1F6lzrEtCjVaXFyDPurO2dlom+0g78Kd311Kjd6GhdatNeVIlF7iO5IvBH
         dnkQ==
X-Gm-Message-State: AOAM5307v2L/1ARfTArh6RdiSZ1DrYtxly+mGa7vHiAfrJ/2u1V0MNhf
        P1Qp4sD/7pGX/KNXGfM+4aSM/PxpKFLvPw==
X-Google-Smtp-Source: ABdhPJzHUrpdcysfWmvcKOTpV/rCqvrg6zvR2no2fO3kzOoq/dycLaf10uIQjBP/NfbhUBxGo0HWIg==
X-Received: by 2002:a5d:4e92:: with SMTP id e18mr82200857wru.66.1609754700700;
        Mon, 04 Jan 2021 02:05:00 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id f14sm77042982wre.69.2021.01.04.02.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 02:04:59 -0800 (PST)
Date:   Mon, 4 Jan 2021 10:04:58 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, lulu@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, eperezma@redhat.com,
        stefanha@redhat.com, eli@mellanox.com, lingshan.zhu@intel.com,
        rob.miller@broadcom.com
Subject: Re: [PATCH 06/21] vdpa: introduce virtqueue groups
Message-ID: <20210104100458.GC342399@stefanha-x1.localdomain>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-7-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
Content-Disposition: inline
In-Reply-To: <20201216064818.48239-7-jasowang@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 16, 2020 at 02:48:03PM +0800, Jason Wang wrote:
> This patch introduces virtqueue groups to vDPA device. The virtqueue
> group is the minimal set of virtqueues that must share an address
> space. And the adddress space identifier could only be attached to
> a specific virtqueue group.
>=20
> A new mandated bus operation is introduced to get the virtqueue group
> ID for a specific virtqueue.
>=20
> All the vDPA device drivers were converted to simply support a single
> virtqueue group.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c   |  9 ++++++++-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c |  8 +++++++-
>  drivers/vdpa/vdpa.c               |  4 +++-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c  | 11 ++++++++++-
>  include/linux/vdpa.h              | 12 +++++++++---
>  5 files changed, 37 insertions(+), 7 deletions(-)

Maybe consider calling it iotlb_group or iommu_group so the purpose of
the group is clear?

--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/y6EoACgkQnKSrs4Gr
c8iKNwgAtnS7PgEL7jT2JkaKAXLejyXKO8IW8xfLeTqNpJCmwkwbyzsQjH83riBW
TFaz9i//mTuWeJjzc9ZPWSkeDGQ30KdUG+keqyrr4IBcu2g7YO58mAqf8DL/b/Vf
EkX+sXimegTguYioYzT5zbgApNPlo5RPJWS0UTInQ8n2+gzXKmBmhyI9EXchVNqz
MZDTWzKqZ6urkT5JZlOIlMa1Mw/Xr+yRQpVIBYuZe3GEdwM5gfn6ElhAyrT8qhO/
ssFCNPzcSuJl+2MhxDVM3uyaadUQhr63o4BzNSSyr2Gk4i+nepfTCe0pXukbrnGs
wWqtRMGsRbjl811BZJwNtdVCqu/lsw==
=J7Jn
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--
