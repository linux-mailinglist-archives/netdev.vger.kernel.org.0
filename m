Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51CBD99EAB
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 20:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732742AbfHVSVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 14:21:49 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:52204 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfHVSVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 14:21:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Resent-To:
        Resent-Message-ID:Resent-Date:Resent-From:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Sender:
        Resent-Cc:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
        List-Owner:List-Archive; bh=rrMRoDUoFIzRligDCD6l+cGG8OCJYmuN1e5r0s0RK60=; b=K
        dVjmt4KUm9S5SkBOIhQ+6xxrYnYUsLiq0AOWiZ2tUm+jeLHMTt2Zv3tyAbkRFydlZLdWDsVDxFVG2
        CGdFaet0aMOLYyuYyXTVe1BVt/ZKRyHnn6uQwx/7mJxNEkAq7qOPBB1Pstxsk5HL3x5v0pFIvLKzL
        P6crv8WyWHC/hoxc=;
Received: from 92.40.26.78.threembb.co.uk ([92.40.26.78] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i0riU-0007d2-6B; Thu, 22 Aug 2019 18:21:46 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 328C4D02CB0; Thu, 22 Aug 2019 19:21:45 +0100 (BST)
Date:   Thu, 22 Aug 2019 18:38:46 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-spi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH spi for-5.4 3/5] spi: spi-fsl-dspi: Use poll mode in case
 the platform IRQ is missing
Message-ID: <20190822173846.GA24020@sirena.co.uk>
References: <20190818182600.3047-1-olteanv@gmail.com>
 <20190818182600.3047-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20190818182600.3047-4-olteanv@gmail.com>
X-Cookie: I just had a NOSE JOB!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 18, 2019 at 09:25:58PM +0300, Vladimir Oltean wrote:
> On platforms like LS1021A which use TCFQ mode, an interrupt needs to be
> processed after each byte is TXed/RXed. I tried to make the DSPI
> implementation on this SoC operate in other, more efficient modes (EOQ,
> DMA) but it looks like it simply isn't possible.

This doesn't apply against current code (I guess due to your cleanup
series), please check and resend.

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1e0yYACgkQJNaLcl1U
h9AFmQf8D5Hb+Q/mrXvp1IGUl8mX3fimwGOyB0PKBjy55JhqF+9D9cP267sDeH4X
e9KOiLuQwASl9W/HRwOUAlw8kkq48mo3T20cdQ9BsoLAOf44RLf5WhKK+CQ+B+X0
BmFgdA2yIfAfBKTP0Gpse5Ow8Y3ueCuV+3yyyuDy7uXYvNlFQ2QkyWIq74AuRO6K
xK8mHj1M5dcg0YW/FGaRJ7zc4tI9UlOrlgqEx+0EgU6yM3Jxld36l+Rto5nUvr4v
V0ZoB+T4bbO/fw6mp6+x0wGqVYwsyZZ3jyfjJor+3XFDdz8bLT0bCBflgewThjzZ
2lRScmn82sShWw2HnkFfVv9mdSikTA==
=RUOQ
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
