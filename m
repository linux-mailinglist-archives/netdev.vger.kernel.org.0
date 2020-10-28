Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D3029D56E
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgJ1WCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbgJ1WCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:02:24 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1AA824806;
        Wed, 28 Oct 2020 18:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603909500;
        bh=3FnfY0fopTr59guGzwZGYaUN3BeAH2JnTh3KcqqaSWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pB0UJvsTww9Cb4vodrmJCAzxjzi2PoTLOXTLTfQJYGLwxvuWCEzVoOUaK8yLQ0Gta
         qwHGdjLx0+1jeYb5jaTQhIgO808j+07gw0LBEOVFqyL1z9xBMRC6kzsqP/73fOiJhQ
         TN5Z4OEMNYJKBIk+RHT6NVXZyADftH5vwx0kaG0A=
Date:   Wed, 28 Oct 2020 18:24:54 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Guillaume Nault <gnault@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Russell King <linux@armlinux.org.uk>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] Fix wrong identifiers on kernel-doc markups
Message-ID: <20201028182454.GA16143@sirena.org.uk>
References: <cover.1603705472.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <cover.1603705472.git.mchehab+huawei@kernel.org>
X-Cookie: They just buzzed and buzzed...buzzed.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2020 at 10:47:35AM +0100, Mauro Carvalho Chehab wrote:
> Hi Mark/Jakub,
>=20
> As you requested, I'm resending the three -net patches
> from the /56 patch series I sent last Friday:

I was asking for you to do the same for the patches for my subsystems
rather than resend the net patches to me - in general it's better to
not to bundle things for multiple subsystems (or tangentially related
changes in general) together like this.  Splitting things up makes it
easier to find the relevant changes and means that automations that work
with patch serieses don't have to deal with things that span multiple
different trees when it's not required.

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+Zt3UACgkQJNaLcl1U
h9DjbAf/agKKFquaatNyS+9PsKXVvTKCZRLor3HaSfL2YuKiSVcuy9YH2azZEL+7
CCbmpjmpsEKeKsGJqSgklV0iTDhpmjSRHcG7hvBdFyC2oHAoQOgQvl1sQ7+itktr
Cjj6xWYMl9lBTxbdWXeI5m0cl3I+0LcJ5yB808GbpkpW6MoEUAyLvIOHBQjkfSMy
FQC5359kfk65bfQjyIcHE+sgVc0+8j4zks5blibAQarOmpv5vF+z7TYd3OUrsnxJ
KKZjxtwtTwzOQ7SRpz5NuX9gomuRDUNA0OTrsOQSMuxdYGlkPdeBlJoYnVNZZkD7
ZIkRA2RvEZIZQTo7Z5BUtHYi7AEikQ==
=a1MC
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
