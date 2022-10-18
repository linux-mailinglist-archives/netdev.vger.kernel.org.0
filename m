Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2AB60289A
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiJRJob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiJRJoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:44:30 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE115184;
        Tue, 18 Oct 2022 02:44:19 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 79C851C09D9; Tue, 18 Oct 2022 11:44:18 +0200 (CEST)
Date:   Tue, 18 Oct 2022 11:44:15 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, vinicius.gomes@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 22/34] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Message-ID: <20221018094415.GF1264@duo.ucw.cz>
References: <20221009222129.1218277-1-sashal@kernel.org>
 <20221009222129.1218277-22-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wtjvnLv0o8UUzur2"
Content-Disposition: inline
In-Reply-To: <20221009222129.1218277-22-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wtjvnLv0o8UUzur2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit 18cdd2f0998a4967b1fff4c43ed9aef049e42c39 ]
>=20
> Since the writer-side lock is taken here, we do not need to open an RCU
> read-side critical section, instead we can use rtnl_dereference() to
> tell lockdep we are serialized with concurrent writes.

This is cleanup, not a bugfix. We should not have it in 5.10.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--wtjvnLv0o8UUzur2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY051bwAKCRAw5/Bqldv6
8mFDAJ9h8/xb8eW8Jrda9CW7bgcnznO8rwCfREz7MwDjrpiv8lCN79IxHx+Tk5U=
=LVaB
-----END PGP SIGNATURE-----

--wtjvnLv0o8UUzur2--
