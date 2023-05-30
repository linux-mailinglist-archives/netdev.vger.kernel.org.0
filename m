Return-Path: <netdev+bounces-6396-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B139471624C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:41:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76E2F280EF6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9161209B6;
	Tue, 30 May 2023 13:40:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECE8209B4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:40:51 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3967C7;
	Tue, 30 May 2023 06:40:49 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 8FA1185AFF;
	Tue, 30 May 2023 15:40:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685454048;
	bh=4ht2We8f1claOdvdhDQilzNRObJEAdMBzQcfVV2owqE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RWspHQiU4sG3NHEaTQE1jHkej5VWknk7Z7RmN+oYIDNF8yGMaY7YkR4kvRf6YFlIm
	 DYb0z1p0JAPXy1DYkqiF79XyCW0nSO8BNesOSsvST4eKKuafjvepQsAQnFffBfkqU0
	 FKZJrjJI2RX3qKN+z/d+5a+aX9LeKqsBzEX/3cqXlhCM5PeE1XMY5H0+v98a5mK39H
	 vfV7wFoNZG56y7ljSASlmcIKzZXMtvI42gPyjuqwSdLqd4N6d6f6ZAI7B7MXHiBkpI
	 hMcJ3yOWH7P8g43k2W1YCjvoXJ8rGjvt8kJnbUv7ego4OSZx4oiyer5NQEMWW7pkGV
	 WOI6VLJnTxU2Q==
Date: Tue, 30 May 2023 15:40:39 +0200
From: Lukasz Majewski <lukma@denx.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@armlinux.org.uk>, Vivien Didelot
 <vivien.didelot@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <20230530154039.4552e08a@wsk>
In-Reply-To: <32aa2c0f-e284-4c5e-ba13-a2ea7783c202@lunn.ch>
References: <20230530122621.2142192-1-lukma@denx.de>
	<32aa2c0f-e284-4c5e-ba13-a2ea7783c202@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FC.0YCTsDox9nDTL+GXCJt_";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/FC.0YCTsDox9nDTL+GXCJt_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Tue, May 30, 2023 at 02:26:21PM +0200, Lukasz Majewski wrote:
> > One can disable in device tree advertising of EEE capabilities of
> > PHY when 'eee-broken-100tx' property is present in DTS.
> >=20
> > With DSA switch it also may happen that one would need to disable
> > EEE due to some network issues. =20
>=20
> Is EEE actually broken in the MAC/PHY combination?
>=20

Problem is that when I connect on this project some non-manageable
switches (which by default have EEE enabled), then I observe very rare
and sporadic link loss and reconnection.

Disabling EEE solves the problem.

> You should not be using this DT option for configuration. It is there
> because there is some hardware which is truly broken, and needs EEE
> turned off.

Yes, I do think that the above sentence sums up my use case.

>=20
> If EEE does work, but you need to turn it off because of latency etc,
> then please use ethtool.
>=20

Yes, correct - it is possible to disable the EEE with=20

ethtool --set-eee lan2 eee off

However, as I've stated in the mail, I cannot re-enable EEE once
disabled with:

ethtool --set-eee lan2 eee on

ethtool --show-eee lan2
EEE Settings for lan2:
        EEE status: not supported


As the capability register shows value of 0.

>      Andrew,




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/FC.0YCTsDox9nDTL+GXCJt_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmR1/NcACgkQAR8vZIA0
zr0GvggAjt81H60n+birvOLZdVBaJfZhBAgQVh+IoGqF83lSqI6vf41gA7NDneTt
+d2Pyhsc/5MLxct0OLUIUjWkYfsZ76ZfgzH25Xh11ErWc+8HTxyeAoqiKb+03FVn
reFMKWdPyrP7s+o4xwTepaWTBq18+p8gCC8JrsS2eBNVSpzo9QyvJf6G38pdMR23
oksuGqWPEXq9WMUB/1eP3u793E/aVmVE3rV8ySfLWVsfkqnjwsi6RNpWY861o6Eb
1IgSjPP3VlFtsdaRQhL7kfh0kUoHb6GtQS39y1sJKF6/S+qWBLFyKzzdtQ08Pkyv
0+VzQ3WCmHFohsvcoCwqtAvLyShNUQ==
=Dw46
-----END PGP SIGNATURE-----

--Sig_/FC.0YCTsDox9nDTL+GXCJt_--

