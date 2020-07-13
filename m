Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E1021CE7F
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 07:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgGMFAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 01:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728378AbgGMFAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 01:00:09 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC20C061794;
        Sun, 12 Jul 2020 22:00:09 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id s26so5490647pfm.4;
        Sun, 12 Jul 2020 22:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1lLPOLkBFlaZV5JAnqBpeyu6VZ/I+sGZba7MGHvAN6A=;
        b=N5/I3pTYAxvtTzanlIR2Cbqs1jk5fLXdC1cjlNf29HIJjtEs+2VsLlZGwBFC7hZgdn
         oOLHhPNLXAQ/HsH0EaPMrkOg8fzBfqljXBjrQxJ4CYCEmZamriPMNHBlMY/HzWfnbN9R
         0cxbiYzptjJjWceFN8rdIEuLIGbwxzwu9aXVh4a0QHB7nRar7sB/tMBIVmU0k3ygWrfO
         ag3I1mXbl0ZYj79DYW1A4SMXtomgduxpEOv82jmEleKzPvlefsGCOP8c72zWyNZE9Vwm
         Nsbe0dMjPcjEpEjsITiQuGqE8QHgSLoyY4U3XsWzQuCMnzXmzzIh8jgRhNNdw7NBB8rx
         l+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1lLPOLkBFlaZV5JAnqBpeyu6VZ/I+sGZba7MGHvAN6A=;
        b=XOqo29lgt43cwdesHLayc1asY/+l7jR1P41AnUrGvXaxA8h74fRAuJarwmqbaZ2S/x
         2u2XfxTe9gFGjMZWrp6LC3aYqhj7t7dCunxsxfp2zJdQtMuo7Q4QNpK5Jm0Z470Oppn2
         WinOLCVk3oBJVVVcMsrg4bzztYbDI9Xjh8zx/rFr9h7W5sx3Huj4kYqTZkNx09oiWiqc
         LXjB2K4kVrfNXw3CDDt994gvlOvqH6rcg75G7iZX/uaNgt4XJwFKfL6j8wnAIUeqw+Hc
         pL8UfgA5FrKq5kNG5LocgV9RXyvtg3HEvdjCPexn5Q3wLBbugCqi9dn83y9fOmAcTFhu
         EkRA==
X-Gm-Message-State: AOAM533u4E80VmUZFw/feV6Wi0e7r6p+3aQm7ZU8Tmi+E42byNFeFtyS
        5JSfkwOYhCILF3vdsAvYO/Q=
X-Google-Smtp-Source: ABdhPJwngWJbrCL+Ce1UIdpNQiTFU6Wga8WC7uWyBeSsPzEYo4Eyvgcd9b5Tq6dDyVmo9riN2aXtFA==
X-Received: by 2002:a63:720b:: with SMTP id n11mr65406194pgc.137.1594616409123;
        Sun, 12 Jul 2020 22:00:09 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id f14sm12195717pgj.62.2020.07.12.22.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 22:00:07 -0700 (PDT)
Date:   Mon, 13 Jul 2020 13:59:59 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Suraj Upadhyay <usuraj35@gmail.com>
Cc:     manishrc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Remove pci-dma-compat wrapper APIs.
Message-ID: <20200713045959.GA7563@f3>
References: <20200711124633.GA16459@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20200711124633.GA16459@blackclown>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-07-11 18:16 +0530, Suraj Upadhyay wrote:
> The legacy API wrappers in include/linux/pci-dma-compat.h
> should go away as it creates unnecessary midlayering
> for include/linux/dma-mapping.h APIs, instead use dma-mapping.h
> APIs directly.
>=20
> The patch has been generated with the coccinelle script below
> and compile-tested.
>=20
[...]
>=20
> @@ expression E1, E2, E3, E4; @@
> - pci_dma_sync_single_for_device(E1, E2, E3, E4)
> + dma_sync_single_for_device(&E1->dev, E2, E3, (enum dma_data_direction)E=
4)

The qlge driver contains more usages of the deprecated pci_dma_* api
than what this diff addresses. In particular, there are some calls to
pci_dma_sync_single_for_cpu() which were not changed despite this
expression being in the semantic patch.

Dunno what happened but it should be reviewed. After converting away
=66rom all of the old api, the TODO file should also be updated.

[...]

>=20
> diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_=
mpi.c
> index fa178fc642a6..16a9bf818346 100644
> --- a/drivers/staging/qlge/qlge_mpi.c
> +++ b/drivers/staging/qlge/qlge_mpi.c
> @@ -788,8 +788,9 @@ int ql_dump_risc_ram_area(struct ql_adapter *qdev, vo=
id *buf,
>  	char *my_buf;
>  	dma_addr_t buf_dma;
> =20
> -	my_buf =3D pci_alloc_consistent(qdev->pdev, word_count * sizeof(u32),
> -				      &buf_dma);
> +	my_buf =3D dma_alloc_coherent(&qdev->pdev->dev,
> +				    word_count * sizeof(u32), &buf_dma,
> +				    GFP_ATOMIC);
>  	if (!my_buf)
>  		return -EIO;
> =20
> @@ -797,8 +798,8 @@ int ql_dump_risc_ram_area(struct ql_adapter *qdev, vo=
id *buf,
>  	if (!status)
>  		memcpy(buf, my_buf, word_count * sizeof(u32));
> =20
> -	pci_free_consistent(qdev->pdev, word_count * sizeof(u32), my_buf,
> -			    buf_dma);
> +	dma_free_coherent(&qdev->pdev->dev, word_count * sizeof(u32), my_buf,
> +			  buf_dma);
>  	return status;
>  }
> =20
> --=20
> 2.17.1
>=20



--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEkvpDtefvZykbqQVOaJBbS33YWS0FAl8L6koACgkQaJBbS33Y
WS1JBA/+J9cy/Iz2PMdfWkQxIYA+Et7kUXCQ21Vc1Iaz+TslGD0tYqvp8jcZe8wg
gzVTHeosvCxsTn9BuTjeXnHHPEIsFl6EMRlW7xoXOkvpV0iZ/ZJ1/nK2UT/C8haf
yJo096ohW877MbE227k9wqrZZroC168padc6XGEepMoBhQ0W5Hs+soybKQj3od4J
8WnOC/oF06Feu/KdvkUeqwAHVj0w2Vwlhw+lUyNlsrxY5ZPx6BkjZLm9rNTgplu7
UuLgyhXzeq8RUtN6If06T15+tl4e0lDPFPmBQVM60J3aq+4wzGQg2lvXOzL27urL
DUWywJ79h2diXPjDEfyJow5661c6ubIBRagvvgYd5fHFLmqcevo0Dtw/k3C0cNg+
NmdyoMlU0/Db2Op3btgSjKdidlfMM0ImkuOiUYKR6FHf+rk2rxLQTt2z0/FK8QQi
LdTGR5zHSofGsuWpCvkKVgTXuLMtCCseY9kvOkaIyBl7uv2BW6RbnjGoHpO+G+PF
S20mH3WQojjD8+YwP7Dw0One+Lr+5aiM8tzqIXz7IMk4Q10XFWpKZpCYJCdPDiSg
3H3jTDcBvH4ngEDIHP/6SmNpB8WLSBRpaoC13hUQcpEJKBtzkvpPisElsWgRwkRw
J4IRtz70uN/bW/m4zRxpKDP28NDMZCfzHGbMtdJk10n4w8oFvxc=
=TkyJ
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
