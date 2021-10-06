Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A541E424454
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 19:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbhJFReX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231617AbhJFReW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 13:34:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA90060F22;
        Wed,  6 Oct 2021 17:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633541550;
        bh=xoTeSecthPoIVCFE9eaK5YWgW5FqM8Wx1GaGkk8TILk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iIbYkjKXrup+H9Fn37cRW5UkrXPxi8XPCEh7pJPwELSWYkHM9P2RBvoyr8xSXQYq3
         OZUYyP8/0tbM5ndWjzDB3EhVUfZd9ZNshZPZEro1JQkGhGdPWogZfXEtpywQY4vGj7
         eAGd2gNPrs/+bx+28YK/h+h0YKJnxLmOfTKpkmpVR+ZtvwONSiZGMn/zUpzPojvM6S
         UQmGx3moCXZ7C2g5tPB2eC7jUjwCE+yE6HI0+9xlUQAZqIy3V9ttlHj81WvoeKzDBN
         4OoToLMnLBBmGUnLnb874Z3JkteR1r4l2WjeSTm/D7S/9j5ATxGC7Ij9qC1zkrTdyg
         lVn24l3nvK+LA==
Date:   Wed, 6 Oct 2021 18:32:26 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     davem@davemloft.net, michael.riesch@wolfvision.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, lgirdwood@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG RESEND] net: stmmac: dwmac-rk: Ethernet broken on rockpro64
 by commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
 pm_runtime_enable warnings")
Message-ID: <YV3dqmLefGVAjH2T@sirena.org.uk>
References: <YV3Hk2R4uDKbTy43@monolith.localdoman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6A6VXl3ajkDFtK+b"
Content-Disposition: inline
In-Reply-To: <YV3Hk2R4uDKbTy43@monolith.localdoman>
X-Cookie: A is for Apple.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6A6VXl3ajkDFtK+b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 06, 2021 at 04:58:11PM +0100, Alexandru Elisei wrote:
> Resending this because my previous email client inserted HTML into the em=
ail,
> which was then rejected by the linux-kernel@vger.kernel.org spam filter.
>=20
> After commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
> pm_runtime_enable warnings"), the network card on my rockpro64-v2 was left
> unable to get a DHCP lease from the network. The offending commit was fou=
nd by
> bisecting the kernel; I tried reverting the commit from v5.15-rc4 and the
> network card started working as expected.

I did end up glancing briefly at this (though no idea how I ended up
showing in get_maintainers...) - the revert dropped both the runtime PM
enables and the get/puts, I suspect the driver may need the get/puts
either where they are in the commit or at a level up.

--6A6VXl3ajkDFtK+b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFd3akACgkQJNaLcl1U
h9A+tAf/R80GdTYRa1orKc1W7WXATKEMT82qq11h/wdjVecfx/p0OGtKF6DGKXE5
fiDA0ZogMuvjFc0keAF/hwoPTvfYbKyxpXFVphdvUZgprmRbY2VXXnbAvVf/nkEz
an9dEsWf4CQiMa1ZlF0klMbQN/R8+CmnTlK7bJ8tz7sRXRZOPU5Gq+DYSYKs729h
UMCqB/oD6f+9MSIqCFu0ltirDRL6Gih9ZAGcbvluUKJjkqiTrbjXIpVNw6nqBFOt
3DZMTrgWyfHOyEFnRFeGD3yEb6zFCPC/IB/PZzHN01DFw7oC0jAFBQko+Jlijzur
DZF6KX1d84dhjWLO5WeS6ctqCQQKSA==
=8enb
-----END PGP SIGNATURE-----

--6A6VXl3ajkDFtK+b--
