Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10477227B2A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 10:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgGUIyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 04:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgGUIyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 04:54:01 -0400
Received: from localhost (unknown [151.48.143.159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1540D20717;
        Tue, 21 Jul 2020 08:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595321640;
        bh=QNgLkTCWY3EYQ3ieqDeHtG6YfjtHULYF0/ELxrPsN2E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OM1HOYQHL2BxjFDZYDMXkl7yk3Wp7Tpclxt2ZRxw/eq5vQx+DWyDCp6+uvfKScHh+
         bi7tIwDy1Ro24OOHoHwXHjVVg8z0DrKionJByYRjP/i/fgt6Qr7IW8bJ4tsl4x8EOp
         V9PV3kmhcMklyXOImOn6TABHO9dBraoT/qooPy/g=
Date:   Tue, 21 Jul 2020 10:53:55 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20200721085355.GA2315@lore-desk>
References: <20200721121630.5c06c492@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20200721121630.5c06c492@canb.auug.org.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]

> diff --cc include/net/xdp.h
> index d3005bef812f,5be0d4d65b94..000000000000
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@@ -104,15 -98,12 +104,21 @@@ struct xdp_frame=20
>   	struct net_device *dev_rx; /* used by cpumap */
>   };
>  =20
>  +static inline struct skb_shared_info *
>  +xdp_get_shared_info_from_frame(struct xdp_frame *frame)
>  +{
>  +	void *data_hard_start =3D frame->data - frame->headroom - sizeof(*fram=
e);
>  +
>  +	return (struct skb_shared_info *)(data_hard_start + frame->frame_sz -
>  +				SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
>  +}
>  +
> + struct xdp_cpumap_stats {
> + 	unsigned int redirect;
> + 	unsigned int pass;
> + 	unsigned int drop;
> + };

Hi Stephen,

the fix is correct, thanks and sorry for the noise. I will point out possib=
le
conflicts next time.

Regards,
Lorenzo

> +=20
>   /* Clear kernel pointers in xdp_frame */
>   static inline void xdp_scrub_frame(struct xdp_frame *frame)
>   {



--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXxatIAAKCRA6cBh0uS2t
rGbTAQC483shj2VUfaMePo8unA0csxUt7uxG2tovQSubdPYP7AEAmoaZA903SipY
JvkDxg2Cj8TAyNavq8nq3QFk00Kd7gI=
=RPkj
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
