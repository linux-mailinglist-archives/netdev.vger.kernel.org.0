Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3634F906E
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiDHINS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiDHINR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:13:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC71424B2
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 01:11:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24BB26131D
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 08:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB2DC385A3;
        Fri,  8 Apr 2022 08:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649405473;
        bh=I4c7bHLh7cSruTKgBfCeR6Oc+khbQJWUVvwal7PIDWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i9IVHxEXVg2m4SzCP7mkS2k1PNsfo7/kIyRYRWaExn8vebiAdotWvPdC7vwDfRRT5
         ThJ2ozs+y2DFEo2nkPryYb+/NvrFr/suPiIY2iMEL5Zt3dBu72obj58sKmY8vHjCHZ
         ZVD3KOKKGO4ASF/HCdOBa/sgAtUd8TeCVkxUhOQ6mQ0BIGkG7Z/YosmLO3/Brqwu3e
         SX+j+3f7j9RoHgTwEQQpH+jZs3tfX4CyZp909SBfQKPGA1zY62arY+9FHRG2HHnrDM
         /Qp9YKqUUWJl3gpQ9ncAWSr47x/Res6qXjnJQghNId7FfqS7H56fJn63YiYxSteEeN
         5CHi+Rtu5SEEw==
Date:   Fri, 8 Apr 2022 10:11:09 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com, andrew@lunn.ch, jdamato@fastly.com
Subject: Re: [RFC net-next 1/2] net: page_pool: introduce ethtool stats
Message-ID: <Yk/uHf4/rccT4LsV@lore-desk>
References: <cover.1649350165.git.lorenzo@kernel.org>
 <ab9f8ae8a29f2c3acdb33fe7ade0691ff4a9494a.1649350165.git.lorenzo@kernel.org>
 <20220407203002.6d514e43@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bmHKEov++4BUfncJ"
Content-Disposition: inline
In-Reply-To: <20220407203002.6d514e43@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bmHKEov++4BUfncJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Apr 07, Jakub Kicinski wrote:
> On Thu,  7 Apr 2022 18:55:04 +0200 Lorenzo Bianconi wrote:
> > +void page_pool_ethtool_stats_get_strings(u8 *data)
>=20
> This needs to return the pointer to after the used area, so drivers can
> append more stats. Or make data double pointer and update it before
> returning.

ack, I will fix it in v2.

>=20
> > +{
> > +	static const struct {
> > +		u8 type;
> > +		char name[ETH_GSTRING_LEN];
> > +	} stats[PP_ETHTOOL_STATS_MAX] =3D {
> > +		{
> > +			.type =3D PP_ETHTOOL_ALLOC_FAST,
>=20
> Why enumerate the type? It's not used.

ack, I will fix it in v2.

Regards,
Lorenzo
>=20
> > +			.name =3D "rx_pp_alloc_fast"
> > +		}, {
> > +			.type =3D PP_ETHTOOL_ALLOC_SLOW,
> > +			.name =3D "rx_pp_alloc_slow"
> > +		}, {
> > +			.type =3D PP_ETHTOOL_ALLOC_SLOW_HIGH_ORDER,
> > +			.name =3D "rx_pp_alloc_slow_ho"
> > +		}, {
> > +			.type =3D PP_ETHTOOL_ALLOC_EMPTY,
> > +			.name =3D "rx_pp_alloc_empty"
> > +		}, {
> > +			.type =3D PP_ETHTOOL_ALLOC_REFILL,
> > +			.name =3D "rx_pp_alloc_refill"
> > +		}, {
> > +			.type =3D PP_ETHTOOL_ALLOC_WAIVE,
> > +			.name =3D "rx_pp_alloc_waive"
> > +		}, {
> > +			.type =3D PP_ETHTOOL_RECYCLE_CACHED,
> > +			.name =3D "rx_pp_recycle_cached"
> > +		}, {
> > +			.type =3D PP_ETHTOOL_RECYCLE_CACHE_FULL,
> > +			.name =3D "rx_pp_recycle_cache_full"
> > +		}, {
> > +			.type =3D PP_ETHTOOL_RECYCLE_RING,
> > +			.name =3D "rx_pp_recycle_ring"
> > +		}, {
> > +			.type =3D PP_ETHTOOL_RECYCLE_RING_FULL,
> > +			.name =3D "rx_pp_recycle_ring_full"
> > +		}, {
> > +			.type =3D PP_ETHTOOL_RECYCLE_RELEASED_REF,
> > +			.name =3D "rx_pp_recycle_released_ref"
> > +		},
> > +	};
> > +	int i;
> > +
> > +	for (i =3D 0; i < PP_ETHTOOL_STATS_MAX; i++) {
> > +		memcpy(data, stats[i].name, ETH_GSTRING_LEN);
> > +		data +=3D ETH_GSTRING_LEN;
> > +	}

--bmHKEov++4BUfncJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYk/uHQAKCRA6cBh0uS2t
rKsuAPoCbw+1r+fKHMZ5+9lWhcye/Y20RPDRamhSFg5pqkwVZAEAofiQKSLShV/Z
hipYQ0aJZIlyr2MbVWrUQVWl/hproQg=
=O2pW
-----END PGP SIGNATURE-----

--bmHKEov++4BUfncJ--
