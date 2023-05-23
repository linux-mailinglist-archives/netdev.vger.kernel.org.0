Return-Path: <netdev+bounces-4528-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E76270D310
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13597281221
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2A11B8EB;
	Tue, 23 May 2023 05:06:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C69A4C60
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:06:14 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B9CFA
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 22:06:06 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 049C82260A;
	Tue, 23 May 2023 05:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1684818365; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qTLHhloMeb95WCMRCmZC5Fp92/vwLvcD+OdiaC9COZE=;
	b=trbd1JU/QZrtIGQfxOIl3HEnbNpTcIr/DIOY+P++DSYyB1eg0oLciVze0CbA75EA+6/Rej
	zGbI3mSK06CPgJAK/RuwO5fxWIIpi8dnytmjpZEDgqAotIVqyV76UFWqgH4O5gZ2OLrozU
	fSZS/v78s5Mh51upwLULLDRzmmyy370=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1684818365;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qTLHhloMeb95WCMRCmZC5Fp92/vwLvcD+OdiaC9COZE=;
	b=VGNbj8cTRioz1xwzER21FEDIJ+pjHVVPjUVlS8IrHJ3j7+X763zQt0+Van0oU78BMU/w8F
	d3JJF8WKVgPAc6Bw==
Received: from lion.mk-sys.cz (unknown [10.163.44.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id A886F2C141;
	Tue, 23 May 2023 05:06:04 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
	id 7829460410; Tue, 23 May 2023 07:06:04 +0200 (CEST)
Date: Tue, 23 May 2023 07:06:04 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: netdev@vger.kernel.org,
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Subject: Re: [PATCH ethtool v2, 1/1] netlink/rss: move variable declaration
 out of the for loop
Message-ID: <20230523050604.h7qlqdop2fxxcejy@lion.mk-sys.cz>
References: <20230522175401.1232921-1-dario.binacchi@amarulasolutions.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ac7j2y6yursv73xw"
Content-Disposition: inline
In-Reply-To: <20230522175401.1232921-1-dario.binacchi@amarulasolutions.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--ac7j2y6yursv73xw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 22, 2023 at 07:54:01PM +0200, Dario Binacchi wrote:
> The patch fixes this compilation error:
>=20
> netlink/rss.c: In function 'rss_reply_cb':
> netlink/rss.c:166:3: error: 'for' loop initial declarations are only allo=
wed in C99 mode
>    for (unsigned int i =3D 0; i < get_count(hash_funcs); i++) {
>    ^
> netlink/rss.c:166:3: note: use option -std=3Dc99 or -std=3Dgnu99 to compi=
le your code
>=20
> The project doesn't really need a C99 compiler, so let's move the variable
> declaration outside the for loop.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> ---

To be honest, I'm rather surprised that this would be the only C99
feature in ethtool code, I thought that e.g. the named struct
initializers also require C99.

Anyway, with kernel explicitly declaring C11 as the standard to use
since 5.18, it would IMHO make more sense to do the same in ethtool so
that developers do not need to keep in mind that they cannot use
language features they are used to from kernel. What do you think?

Michal

--ac7j2y6yursv73xw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmRsSbcACgkQ538sG/LR
dpU1kAgAldmWxh2F4wO8GEAj5qClJud65COrN2gP2ffV+DIOtMSJN7+efkDArFxR
3k/8YEA80i70D36yribxZFabcUR317LV4jYoTbNzMNYb1lT5vHbnaju4/rc1+NwR
sM29CTtttXj3WQKj9qP3q9kOUDTB+kgcTkokh/YtqEM5WaeyS9JUDEyO8zK58WAM
Sccge9Dnzo9OhIem5RWuISr5FSyL/7KQiYYtDUmfAdjcXvEc6f17Jm9W7M4mY4il
Wq3Y/yxV7JAM8TMTl69okHgk5Lx6h8+ns1c1mmOmG1InJNrFLbwuBtWDo546/qTM
CyTH/ytPAgVIDEwn9WgfQ0IEkN5g2w==
=uKlK
-----END PGP SIGNATURE-----

--ac7j2y6yursv73xw--

