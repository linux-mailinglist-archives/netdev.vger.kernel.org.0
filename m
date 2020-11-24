Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1011E2C33C4
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388577AbgKXWTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:19:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbgKXWTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:19:00 -0500
Received: from localhost (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16A902076E;
        Tue, 24 Nov 2020 22:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606256339;
        bh=TsXDheiMj7kwobCn8Xx564+kd3avPPj+P4Om6o2ViLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e36+61hsn8M5QcLAp0HLg0e0bpUt9kBp7C+J1Rf64Rdd0aJNGieZmpj6Eaufc8H8q
         b0NDrpusNRNfbhHtd/4VYK2Hu6AlNJVpm+X/1bZO6kE29YWfQtMXf8rzCq7Xbd5b5x
         Raem4bYNuKD1U/K+xTCctTC+2rQGtTgu1tDBDzeI=
Date:   Tue, 24 Nov 2020 23:18:54 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, brouer@redhat.com, echaudro@redhat.com,
        john.fastabend@gmail.com, borkmann@iogearbox.net,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net-next 0/3] mvneta: access skb_shared_info only on last
 frag
Message-ID: <20201124221854.GA64351@lore-desk>
References: <cover.1605889258.git.lorenzo@kernel.org>
 <20201124122639.6fa91460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <20201124122639.6fa91460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 20 Nov 2020 18:05:41 +0100 Lorenzo Bianconi wrote:
> > Build skb_shared_info on mvneta_rx_swbm stack and sync it to xdp_buff
> > skb_shared_info area only on the last fragment.
> > Avoid avoid unnecessary xdp_buff initialization in mvneta_rx_swbm routi=
ne.
> > This a preliminary series to complete xdp multi-buff in mvneta driver.
>=20
> Looks fine, but since you need this for XDP multi-buff it should
> probably go via bpf-next, right?
>=20
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Hi Jakub,

thx for the review. Since the series changes networking-only bits I sent it=
 for
net-next, but I agree bpf-next is better.

@Alexei, Daniel: is it fine to merge the series in bpf-next?

Regards,
Lorenzo

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX72GywAKCRA6cBh0uS2t
rKm2AQDVGnyVQR5SsCr7MhymzZgm75hQW6kBszfznzp7f/x/TwEArAocv+7/uRO4
lO0GwvrAJOdpBcv7BSfbZmWJEENUPgw=
=8Enb
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
