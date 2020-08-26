Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C610B252BAD
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 12:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgHZKuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 06:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728754AbgHZKt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 06:49:56 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96C69206EB;
        Wed, 26 Aug 2020 10:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598438996;
        bh=TqPevqx6D2J7PXGgLZWIHZHYHYk8i8daoX9CkV8jVM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2sgsrLL8+6Se7RV01jW3bbRE2mvcZfKUPxov22vTodcl7jsNoAEyoN0nVtDuiV9Uy
         YbCjL5vyGCjtkW9Gxm5wwLDgAmsvpiB284grpS1ZcdGjsR1BQyldPXZ4OTsLiXQNpw
         4Ie/fRL6Whnaa9pcDNOXdoOByiDooJoftVzQm78I=
Date:   Wed, 26 Aug 2020 11:49:19 +0100
From:   Mark Brown <broonie@kernel.org>
To:     syzbot <syzbot+fbe34b643e462f65e542@syzkaller.appspotmail.com>
Cc:     alsa-devel@alsa-project.org, asmadeus@codewreck.org,
        daniel.baluta@nxp.com, davem@davemloft.net, ericvh@gmail.com,
        kuba@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org, perex@perex.cz,
        rminnich@sandia.gov, syzkaller-bugs@googlegroups.com,
        tiwai@suse.com, v9fs-developer@lists.sourceforge.net
Subject: Re: INFO: task can't die in p9_fd_close
Message-ID: <20200826104919.GE4965@sirena.org.uk>
References: <000000000000ca0c6805adc56a38@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
Content-Disposition: inline
In-Reply-To: <000000000000ca0c6805adc56a38@google.com>
X-Cookie: Should I do my BOBBIE VINTON medley?
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ryJZkp9/svQ58syV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 26, 2020 at 03:38:15AM -0700, syzbot wrote:

> console output: https://syzkaller.appspot.com/x/log.txt?x=3D10615b36900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da61d44f28687f=
508
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dfbe34b643e462f6=
5e542
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D15920a05900=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D13a78539900000
>=20
> The issue was bisected to:
>=20
> commit af3acca3e35c01920fe476f730dca7345d0a48df
> Author: Daniel Baluta <daniel.baluta@nxp.com>
> Date:   Tue Feb 20 12:53:10 2018 +0000
>=20
>     ASoC: ak5558: Fix style for SPDX identifier

This bisection is clearly not accurate, I'm guessing the bug is
intermittent and it was just luck that landed it on this commit.

--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl9GPi8ACgkQJNaLcl1U
h9DyfAf8C2paLbOwHHdDVOi687LcmeI2dZuyjT7chCNm5YaFacrU8e5nRF/fnG6y
G350XTQP7ygvtDz3oeIoEzMn8bJa7Xzeo03wiNm2JrUiMFRT6/S77JOk5g1d75xv
tVwBelb7UdHY869OzQLeLc7exArpn9SsuSpRXkwqrY3EO4Ki/ZwwQPgOPrtYNdLM
x1gX63pYxXoLCaHV3QHnselGfBIcz551NPsJJFowk4+ztuCDvaCp1pCYQpfaA+mS
RU3Ttf+3q8xnCtvFF/Fz8deIGx9sXK9SMlc/uLC9GwhuP57oJ3G3O+JKLiaD9ONf
rdK9/4syv9inh3Wwk3n22yqnKN96hw==
=g5nP
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
