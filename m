Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48703234CFD
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 23:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgGaV3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 17:29:32 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21826 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728514AbgGaV3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 17:29:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596230969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PuwZFWhwZBRSn3Bn711DLqpZCBRy+3WpCEMs6GPPNkU=;
        b=WqbPWEmzUpWxvOFe0ggW81HnQwP6ToXTWqoVJBsJn76m0Z9g790JOXddC/RKgmUKgC5Neb
        FMFB3I/Vr2Me/s7h60sYsKmnlqk+mx0dV84fBZYemGQqj29ft75Rs1Gc5OoelNeOkEtWP+
        2w1SlOIIZSoFuEGnPJxyJ8E9GULrRJ0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-EF81HtG4OMqRGBrKw3yEXA-1; Fri, 31 Jul 2020 17:29:25 -0400
X-MC-Unique: EF81HtG4OMqRGBrKw3yEXA-1
Received: by mail-ej1-f70.google.com with SMTP id t9so1475410ejx.22
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 14:29:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PuwZFWhwZBRSn3Bn711DLqpZCBRy+3WpCEMs6GPPNkU=;
        b=Uew+r+UV5zZAoGsYcZ/Pevuvi6hp/aAApbyY3pR7xrF41U4UJ7EXOXc0yPeczkL3me
         rVIr/Xe9jUVba5qGMDVdMEhf1d6431J9gemxOLsoOToQ6or2seUg8fbyk4ATqoydgpWh
         1b4QyFwvROTcWGJiYa0bMjapA/nJxNkeA2TCbpYMYu+z0gYDgazeH46DOyr4pjTp6uv6
         oITsAMEWqNOg6W/xOnOqrY+Y1Ul0w9HLmPxwRZ3JCkit2Dnp1ZVk+vQF6fNqHnv9ubAl
         wsDIZRlFshj9Wi8OcZAA2jM2yKUmKEjwca5NGPy0Btk0VN6wvtBHqCrZZy4DHGcHV1ri
         gWJw==
X-Gm-Message-State: AOAM530AFlv57V5wEhaZoo271+GMO9kEBTuzRE2ybhp+vz9OBy30upD0
        2DWWv3/qckqjcnU75v51icInU9k4Zl+JuVXC7X/zIQTW+rDmZV/cC4BGf5cY1lFNN3l8U5gAqzz
        Rp5NW2OnkHv/AS1lg
X-Received: by 2002:a17:906:f90:: with SMTP id q16mr5925830ejj.208.1596230963984;
        Fri, 31 Jul 2020 14:29:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmvJVJ+gpoxuTdiqqxgzm80YdM5O048lakhRyw5lpzuRVnBmsnmYfmprY3CVvPE1sswbiOSA==
X-Received: by 2002:a17:906:f90:: with SMTP id q16mr5925821ejj.208.1596230963789;
        Fri, 31 Jul 2020 14:29:23 -0700 (PDT)
Received: from localhost ([151.48.137.169])
        by smtp.gmail.com with ESMTPSA id m13sm1614722eds.10.2020.07.31.14.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 14:29:21 -0700 (PDT)
Date:   Fri, 31 Jul 2020 23:29:27 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com,
        marcelo.leitner@gmail.com
Subject: Re: [PATCH net] net: gre: recompute gre csum for sctp over gre
 tunnels
Message-ID: <20200731212927.GA3149@lore-laptop-rh.lan>
References: <6722d2c4fe1b9b376a277b3f35cdf3eb3345874e.1596218124.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <6722d2c4fe1b9b376a277b3f35cdf3eb3345874e.1596218124.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> The GRE tunnel can be used to transport traffic that does not rely on a
> Internet checksum (e.g. SCTP). The issue can be triggered creating a GRE
> or GRETAP tunnel and transmitting SCTP traffic ontop of it where CRC
> offload has been disabled. In order to fix the issue we need to
> recompute the GRE csum in gre_gso_segment() not relying on the inner
> checksum.
> The issue is still present when we have the CRC offload enabled.
> In this case we need to disable the CRC offload if we require GRE
> checksum since otherwise skb_checksum() will report a wrong value.
>=20
> Fixes: 4749c09c37030 ("gre: Call gso_make_checksum")

I put the wrong Fixes tag, reviewing it I guess the right one is:

Fixes: 90017accff61 ("sctp: Add GSO support")

sorry for the noise.

Regards,
Lorenzo

> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/ipv4/gre_offload.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
> index 2e6d1b7a7bc9..e0a246575887 100644
> --- a/net/ipv4/gre_offload.c
> +++ b/net/ipv4/gre_offload.c
> @@ -15,12 +15,12 @@ static struct sk_buff *gre_gso_segment(struct sk_buff=
 *skb,
>  				       netdev_features_t features)
>  {
>  	int tnl_hlen =3D skb_inner_mac_header(skb) - skb_transport_header(skb);
> +	bool need_csum, need_recompute_csum, gso_partial;
>  	struct sk_buff *segs =3D ERR_PTR(-EINVAL);
>  	u16 mac_offset =3D skb->mac_header;
>  	__be16 protocol =3D skb->protocol;
>  	u16 mac_len =3D skb->mac_len;
>  	int gre_offset, outer_hlen;
> -	bool need_csum, gso_partial;
> =20
>  	if (!skb->encapsulation)
>  		goto out;
> @@ -41,6 +41,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *=
skb,
>  	skb->protocol =3D skb->inner_protocol;
> =20
>  	need_csum =3D !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
> +	need_recompute_csum =3D skb->csum_not_inet;
>  	skb->encap_hdr_csum =3D need_csum;
> =20
>  	features &=3D skb->dev->hw_enc_features;
> @@ -98,7 +99,15 @@ static struct sk_buff *gre_gso_segment(struct sk_buff =
*skb,
>  		}
> =20
>  		*(pcsum + 1) =3D 0;
> -		*pcsum =3D gso_make_checksum(skb, 0);
> +		if (need_recompute_csum && !skb_is_gso(skb)) {
> +			__wsum csum;
> +
> +			csum =3D skb_checksum(skb, gre_offset,
> +					    skb->len - gre_offset, 0);
> +			*pcsum =3D csum_fold(csum);
> +		} else {
> +			*pcsum =3D gso_make_checksum(skb, 0);
> +		}
>  	} while ((skb =3D skb->next));
>  out:
>  	return segs;
> --=20
> 2.26.2
>=20

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXySNNAAKCRA6cBh0uS2t
rNQAAP9EqhHleBWVkEq14x30WC5yU2cyNXAcqQBaqP+7YPVj3gD8DjgTlewlOzxa
b8oSNQ4u3ZQWeY9njAOrOyONKDBfGg0=
=jPvy
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--

