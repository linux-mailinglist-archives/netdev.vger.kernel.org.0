Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EB71BFEDE
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgD3OlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgD3OlR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 10:41:17 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8044B2051A;
        Thu, 30 Apr 2020 14:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588257676;
        bh=92cGgpMyGwzjfMPM9fKoRNhdMxyr1X0XiiNEL8BUCvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aULrAGIqxerMM8pzTUsQSCkIxVzQa3/w4wv0r1nIeJRfBvYjomzk7lAhV4m4PLkOB
         xTMVaKhqigQIdVBSHXGUlGObikPPTuXGG/ARU1apGnMVjB1+X2EpVaGrJ7aT5gZUvM
         ifUpO69jFva6Ayoe5l8RSYAQaXRQeoKC0YPfwjOM=
Date:   Thu, 30 Apr 2020 15:41:14 +0100
From:   Mark Brown <broonie@kernel.org>
To:     linux-kernel@vger.kernel.org, Jules Irenge <jbi.octave@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] Lock warning cleanup
Message-ID: <20200430144114.GE4633@sirena.org.uk>
References: <0/2>
 <20200429225723.31258-1-jbi.octave@gmail.com>
 <158825658829.42351.8658305560393460400.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="10jrOL3x2xqLmOsH"
Content-Disposition: inline
In-Reply-To: <158825658829.42351.8658305560393460400.b4-ty@kernel.org>
X-Cookie: Sign here without admitting guilt.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--10jrOL3x2xqLmOsH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 30, 2020 at 03:23:17PM +0100, Mark Brown wrote:

> [1/2] cxgb4: Add missing annotation for service_ofldq()
>       commit: d7f27df50eea54fd00c26c5dda7bc12d2541e5e4

Sorry, I didn't register that this was part of a series when I
downloaded the mailbox - I'll drop that commit.  When sending small
cleanups like this to unrelated subsystems putting them in a series, it
makes it look like there's dependencies.  This is especially true if
you're not CCing the whole series to everyone, that's often a sign that
you can just separate the cleanups.

--10jrOL3x2xqLmOsH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl6q44kACgkQJNaLcl1U
h9DkMQf+NHuuw4Fg956blHltHgQpZ9IwIl6dSxPLRfO6ljfHi1BXmBSp4jLeVQTN
R+OY57NAxZ/XRPY+fJUaTmYty1wAtvds1Yd7EWQApLbz5jcn7ZVB3XNSMzgsaEQU
KOgwmtkDYquc7UBYtWxcjV5md9vN+ycAxZDqtef9Zk0j1J8DX4gAXKZlHkWTuGjx
AaCCE6G/JAj6vBfAvPmtoeEkkjcZ2x0Sz4WpQ6SReEKTHoS8Rf+bZCiJpo+HhHJw
AF7LTHGehuwOumxRIEjT9D405z83p9LTFjx9feIRtysJkYPVyUJcn5XeMCfuPPJp
Qh4oMcAU0GztMtj1Z1nwBFybTGhTqQ==
=orSp
-----END PGP SIGNATURE-----

--10jrOL3x2xqLmOsH--
