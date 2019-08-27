Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD179F221
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbfH0SNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:13:22 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:41136 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbfH0SNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:13:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pkM+sr3lP0C6AVZjZJyAdt0csnEWF4HAF/OR4wC4dA8=; b=uYHaoADu28XXgB9P698M+li7O
        CrdLDtChW3Jn5eoz2w8zwlEeR5HItQbWbS4OX0UKL0Icx0dTDx4toEVQ41Op0k1ZGBCUt1mrPjGcW
        Bz70h6Z/RM/KhYR2EQNvIPZSVbiKln5iy7F6nc5/L/F21Yktvdq4M4ZbW7LigJXKM6CJs=;
Received: from 92.41.142.151.threembb.co.uk ([92.41.142.151] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i2fy3-0000sz-A7; Tue, 27 Aug 2019 18:13:19 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 6E1B4D02CE6; Tue, 27 Aug 2019 19:13:18 +0100 (BST)
Date:   Tue, 27 Aug 2019 19:13:18 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH v2 5/5] ARM: dts: ls1021a-tsn: Use the DSPI controller in
 poll mode
Message-ID: <20190827181318.GG23391@sirena.co.uk>
References: <20190822211514.19288-1-olteanv@gmail.com>
 <20190822211514.19288-6-olteanv@gmail.com>
 <CA+h21hqWGDCfTg813W1WaXFnRsMdE30WnaXw5TJvpkSp0-w5JA@mail.gmail.com>
 <20190827180502.GF23391@sirena.co.uk>
 <CA+h21hr3qmTG1LyWsEp+hZZW2NJFtg9Dh1k6SXVDd+A_YSQjjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Qtzb1h6tVL0ohdDu"
Content-Disposition: inline
In-Reply-To: <CA+h21hr3qmTG1LyWsEp+hZZW2NJFtg9Dh1k6SXVDd+A_YSQjjw@mail.gmail.com>
X-Cookie: Don't SANFORIZE me!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Qtzb1h6tVL0ohdDu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 27, 2019 at 09:06:14PM +0300, Vladimir Oltean wrote:
> On Tue, 27 Aug 2019 at 21:05, Mark Brown <broonie@kernel.org> wrote:
> > On Mon, Aug 26, 2019 at 04:10:51PM +0300, Vladimir Oltean wrote:

> > > I noticed you skipped applying this patch, and I'm not sure that Shawn
> > > will review it/take it.
> > > Do you have a better suggestion how I can achieve putting the DSPI
> > > driver in poll mode for this board? A Kconfig option maybe?

> > DT changes go through the relevant platform trees, not the
> > subsystem trees, so it's not something I'd expect to apply.

> But at least is it something that you expect to see done through a
> device tree change?

Well, it's not ideal - if it performs better all the time the
driver should probably just do it unconditionally.  If there's
some threashold where it tends to perform better then the driver
should check for that but IIRC it sounds like the interrupt just
isn't at all helpful here.

--Qtzb1h6tVL0ohdDu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1lcr0ACgkQJNaLcl1U
h9DiNQf44uUy1o+vPwfy6IZd76tgLRc0F21kMaHMJBkX9RYaQ3/YV3E4t0iaFjE/
3o4DF69ZkIXWQOirPQM73xvOUmU/06qCJCjU+QJAukVjKFdT2dgXLDBic+043CTR
I0I3OZH8QJiFmPodSkHgFmI0mKIagD21X1187YWrKtZ5WJ8VzWaJS8IamAMKgj2+
hiNrp/TYthXpJ3MBoY8eYJVD+EuyqaDHkHoPE+2yYePl2YPmkjTwVjR1Mbge3Sbt
pTFH4xoDnHTAiH6EYQI2YnpEKCUVK/FwK/lpCTBLUfUVhAuxJSGyqvHeSqYMDMJD
HFuQ6G6plEMXcfwYUX5gStzzs8UE
=pCt+
-----END PGP SIGNATURE-----

--Qtzb1h6tVL0ohdDu--
