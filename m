Return-Path: <netdev+bounces-6727-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A33B717A70
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFA31280290
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED1C946D;
	Wed, 31 May 2023 08:44:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3423C847C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:44:54 +0000 (UTC)
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D45BE53;
	Wed, 31 May 2023 01:44:40 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: lukma@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id AFE5F8474B;
	Wed, 31 May 2023 10:44:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1685522679;
	bh=FlJfbOAuWE0Kimn0KAZuuefo65nW4uiiiTQD+2ffN9A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jifomY7xiB6s7yv0x3DMFw1k7KXohFbnVGf5n+4jlRQawxmH9Gx0ubWPUwHhwXEhu
	 YQ69ILV1bmBdhj+v1yWq1CN+inuvuQCnc1x5bieE/98SYllCItXbowh1mqPDZ/VStd
	 AKpsOPjuE2IMIAEdzUVGBPERxuTUt0pXiO5/0w7ifxRp0bS1BXk8aZ/4Chw8VePAQs
	 zXdb91Hv1e/GOYkI5NO6odw0uguNHDaIKUzd2EzT5PNhrEMSsSAlO9y6a5nDXvfych
	 J5M+W5ifT84lRTecclbR5cz/FwH0UO/HEobbUw2M5WR6SS4D2gKVjU57FIky/mwlU2
	 AQD969k32406w==
Date: Wed, 31 May 2023 10:44:37 +0200
From: Lukasz Majewski <lukma@denx.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, Vivien Didelot
 <vivien.didelot@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <20230531104437.472c5804@wsk>
In-Reply-To: <b9950909-0fa3-46f9-a250-c4eef6ca1786@lunn.ch>
References: <20230530122621.2142192-1-lukma@denx.de>
	<ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
	<20230530160743.2c93a388@wsk>
	<e7696621-38a9-41a1-afdf-0864e115d796@lunn.ch>
	<20230530164025.7a6d6bbd@wsk>
	<b9950909-0fa3-46f9-a250-c4eef6ca1786@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/A8cWFBHU96VcTf/D=0ts6cY";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/A8cWFBHU96VcTf/D=0ts6cY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > > But as a result, don't expect EEE to actually work with any LTS
> > > kernel. =20
> >=20
> > Then, I think that it would be best to use the above "hack" until
> > your patch set is not reviewed and merged. After that, when
> > customer will mover forward with LTS kernel, I can test the EEE on
> > the proper HW. =20
>=20
> Just to be clear, Since EEE never really worked, i doubt these
> patchset will fulfil the stable rules. They are not minimal fixes, but
> pretty much a re-write.  So you will need to wait for the LTS released
> December 2023. Or you do your own backport.

I will backport (if requred) those patches to 6.x LTS.

>=20
> 	 Andrew


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/A8cWFBHU96VcTf/D=0ts6cY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmR3CPUACgkQAR8vZIA0
zr1CWgf9HeLhiPvWtZzp2ej970Q1uhgMlvRhYhl3sWM4vuyp4R+NfXoZHhXKmoMh
4NkMNU9sWaLapDJtwFUD53RmtF14WHVQbNLMzHdyTcsz49/pppgSUtkonSalWtwO
Joe5Jx5fSJyvmWaP3qGBKQ17K30QU0bgNWC0q3bet0isODpJxTv7fNxFqky3sJ67
Rw0aEklXmeLiEw4cUI/KuOvc6GVFBQUPc1TIagNg6UrFCvosC5ZOhhKfRYfETOuU
apeyShS+33Tm0GuIPXuJIA6H49Zpw8MW5SW9n0/r2NQh5+ttMFkhzn+hSXvTOXwZ
mJHQa5x8VvoUrSNXjr7uiXlW8zTNcA==
=Ez1H
-----END PGP SIGNATURE-----

--Sig_/A8cWFBHU96VcTf/D=0ts6cY--

