Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728574AB2A1
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 23:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345331AbiBFWZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 17:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238398AbiBFWZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 17:25:10 -0500
X-Greylist: delayed 469 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 14:25:08 PST
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C0DC061348;
        Sun,  6 Feb 2022 14:25:08 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8173C1C0B79; Sun,  6 Feb 2022 23:17:16 +0100 (CET)
Date:   Sun, 6 Feb 2022 23:17:15 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@netfilter.org, davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 3/7] netfilter: nf_conntrack_netbios_ns: fix
 helper module alias
Message-ID: <20220206221715.GA19323@duo.ucw.cz>
References: <20220203203651.5158-1-sashal@kernel.org>
 <20220203203651.5158-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20220203203651.5158-3-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Florian Westphal <fw@strlen.de>
>=20
> [ Upstream commit 0e906607b9c5ee22312c9af4d8adb45c617ea38a ]
>=20
> The helper gets registered as 'netbios-ns', not netbios_ns.
> Intentionally not adding a fixes-tag because i don't want this to go to
> stable. This wasn't noticed for a very long time so no so no need to risk
> regressions.

Commit log says this is not severe and probably should wait...

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYgBI6wAKCRAw5/Bqldv6
8iTtAJ94GJRrOT2RWUPA+LE7nd/0u7f6ZgCfabTxYSTEjKxvzPMx/qjGHfKIvOQ=
=esSg
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
