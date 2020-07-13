Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B438821CFF8
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 08:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbgGMGsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 02:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgGMGsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 02:48:40 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEC3C061794;
        Sun, 12 Jul 2020 23:48:40 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k5so5081534plk.13;
        Sun, 12 Jul 2020 23:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SAPtRk62vgok+OCp4FDhzKpYNdP7Sd2Zxk67EZLZW4s=;
        b=JzKhR6162GFC5VhCrC2ZMjPibXyVrn4NpK4CoC4bL8nEOnU8GB4RLXSE9CbyR3q12d
         DLj9MXIISzjfzQ2Sz2Z1M/ZVzYDgyng/kB7yktmW3FkuA59LOaXJvFNtCbRPQGZw2X8Z
         2yRY67djD27N56uVmv5yCmUAULIJXGD4phkKg0sVLCiMtzM0QTJJzyJ/iaMrLq0NolEy
         go1Z9Tqu86OEIDULwaC2THAhlIHMLCsDge5biXgqfHZyvg3g+pRoJOX9ShKV13EooyKC
         L7n08q2Kw6lVHA26tXwOU8f5FfWFGIsAIX2pWrTAtiEwHBCW/xVmWa/Zwk1BEahMRCLT
         XIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SAPtRk62vgok+OCp4FDhzKpYNdP7Sd2Zxk67EZLZW4s=;
        b=VQslFvHpCxoX8JaOXBWH+xqXjaxuGrrdDmdGGV7+NM0zgXVZl/Lr2M41e0fY3gioJr
         djyijKC7UST40dCkf1nTHLa22zdlieK+l74R5cPPqIKJKhQqhSzvYrL1ZEI6t9/GAN5J
         1RheeLyCxScXsNMU4VgDIre/p+xc6g94TkAsTfltJS4d10VzColznw6nFH6TK549oC6y
         I1L71gDxLiRi3fq1mL+phA3ySX7BZpaYw8YcMPuYs53mWMGSUr4HNd630JwH50NB0lxm
         OReti3Y99LpqnWwsa7DO1NFfuOqCUFAI7vMHgsy0pefinhEulyHQOMS3eosEYbJzH7Fb
         U0uQ==
X-Gm-Message-State: AOAM530Kco4mJfgsLlMWWmRz4P5N4LHY40ZdXdIzHHjT7VxxMvpLrr42
        xwBMlHtNU0KsaYaXRJlJmhZ1FGpTGn4=
X-Google-Smtp-Source: ABdhPJwyBbQTl0SHlr8Oiv1p8vvgdsnUG1JFu3GYsBRjd72qXfgQNtST22obAK9eHquVC2aUN3SABg==
X-Received: by 2002:a17:90b:1386:: with SMTP id hr6mr18072499pjb.93.1594622920276;
        Sun, 12 Jul 2020 23:48:40 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id g5sm13096103pjl.31.2020.07.12.23.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 23:48:39 -0700 (PDT)
Date:   Mon, 13 Jul 2020 15:48:35 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Suraj Upadhyay <usuraj35@gmail.com>
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Remove pci-dma-compat wrapper APIs.
Message-ID: <20200713064835.GA11354@f3>
References: <20200711124633.GA16459@blackclown>
 <20200713045959.GA7563@f3>
 <20200713054424.GD12262@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20200713054424.GD12262@blackclown>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-07-13 11:14 +0530, Suraj Upadhyay wrote:
> On Mon, Jul 13, 2020 at 01:59:59PM +0900, Benjamin Poirier wrote:
> > On 2020-07-11 18:16 +0530, Suraj Upadhyay wrote:
> > > The legacy API wrappers in include/linux/pci-dma-compat.h
> > > should go away as it creates unnecessary midlayering
> > > for include/linux/dma-mapping.h APIs, instead use dma-mapping.h
> > > APIs directly.
> > >=20
> > > The patch has been generated with the coccinelle script below
> > > and compile-tested.
> > >=20
> > [...]
> > >=20
> > > @@ expression E1, E2, E3, E4; @@
> > > - pci_dma_sync_single_for_device(E1, E2, E3, E4)
> > > + dma_sync_single_for_device(&E1->dev, E2, E3, (enum dma_data_directi=
on)E4)
> >=20
> > The qlge driver contains more usages of the deprecated pci_dma_* api
> > than what this diff addresses. In particular, there are some calls to
> > pci_dma_sync_single_for_cpu() which were not changed despite this
> > expression being in the semantic patch.
>=20
> Hii Ben,
>         I couldn't find any instances of pci_dma_sync_single_for_cpu in
> the drivers/staging/qlge/ driver, I ran a simple `git grep pci_dma_sync_s=
ingle_for_cpu/device`
> and got nothing.
> If I am wrong, please send the line number of the usages.

You're right, sorry. I was missing commit e955a071b9b3 ("staging: qlge:
replace deprecated apis pci_dma_*") in my tree.

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEkvpDtefvZykbqQVOaJBbS33YWS0FAl8MA8MACgkQaJBbS33Y
WS3Viw/9F4tUPBlh3yVIBpSQ1Ax5GZhlnpGL3XUpFA7Z1aBtZIU+1W9EbDXmZNOo
KO5Nbqr0CfNDPeKJRpB2K+YVriga9F7B299BVvnqKvEvv5NcxSGfVzpEWpyJL3RL
tmjpcquRyY6huKBbYVyfa3D0iUkrURoGmPm9QbpA1JNcKGs55qIyHbwqI+3nYrZt
DZYf5VruMkqQh7gqhW9koHjUyANhWAL4qCLSoQsZAC+HNsY7UsAWLU8sPqD18UaZ
yE1tSSqOyl4R52tGVzaH5WFMbT8xYhCZ7ZXc862LjoEcPoB4jPeHDdDxxq8w2VhS
Kt2O3b5HC8VFByaA32sHVRYpG1iFtMY8MEb6VM+N6qTUmZVNkVJkNTDYpEHSfJ/U
x+j0bunXKUUdnaS14vuzgpfG/L2XAFq9wezZUWvoVg8NWTabHOyeRlNPF1aVYeGr
eJsJ2wtGPNEVPcDpZMo9nSCZeSevun1/9OyFYEkXKO/OQ1vXORY54jik2rv4pPx6
vmYS413oRgOru8drLJR5jiRoZuGjk2RsiEVwdrqkj7pdf7FJ7fr6tYbnoHeWJPz4
h6Wa2prcQ16lPhndAtne+xjc77/O8zqDUmBLShf2ca/5+QgQPuJv6+kC0S9DIK/7
DcAik0SP5lG9iiOAuRxPgQUCYu+prWCBuRcR+2ITbnDd4s2A5cY=
=YM6/
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
