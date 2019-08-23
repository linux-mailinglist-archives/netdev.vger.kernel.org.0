Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 057B39ADBC
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 12:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390815AbfHWK7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 06:59:52 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:51996 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732355AbfHWK7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 06:59:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QLB5UFuQ/ItKVT2UZlQr3SNMsbxmspPVb3tCU0HM6rA=; b=QTtFPtDeUrMIZlnwk8EcWAY2i
        K+31488q9SqSJ8a0ScUhWUp0vqT93xYsR4gcKzLxO0MxslgksD96oHYWkPvC2X6YrbI8/mtnR+CUt
        qZ29ZRFxtfLkr64OhE4U276cOKH6WxClbwcDKeaUrMfrJ/HQWfgDImnwQmnyI6Ut/qTnc=;
Received: from [92.54.175.117] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i17IL-0002vd-JQ; Fri, 23 Aug 2019 10:59:49 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 4D498D02BF1; Fri, 23 Aug 2019 11:59:49 +0100 (BST)
Date:   Fri, 23 Aug 2019 11:59:49 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE
 when it's not ours
Message-ID: <20190823105949.GQ23391@sirena.co.uk>
References: <20190822211514.19288-1-olteanv@gmail.com>
 <20190822211514.19288-3-olteanv@gmail.com>
 <20190823102816.GN23391@sirena.co.uk>
 <CA+h21hoUfbW8Gpyfa+a-vqVp_qARYoq1_eyFfZFh-5USNGNE2g@mail.gmail.com>
 <20190823105044.GO23391@sirena.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9ToWwKEyhugL+MAz"
Content-Disposition: inline
In-Reply-To: <20190823105044.GO23391@sirena.co.uk>
X-Cookie: Don't SANFORIZE me!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9ToWwKEyhugL+MAz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 23, 2019 at 11:50:44AM +0100, Mark Brown wrote:
> On Fri, Aug 23, 2019 at 01:30:27PM +0300, Vladimir Oltean wrote:

> > Did you see this?
> > https://lkml.org/lkml/2019/8/22/1542

> I'm not online enough to readily follow that link right now, I
> did apply another patch for a similar issue though.  If that's
> a different version of the same change please don't do that,
> sending multiple conflicting versions of the same thing creates
> conflicts and makes everything harder to work with.

Oh, I guess this was due to there being an existing refactoring
in -next that meant the fix wouldn't apply directly.  I sorted
that out now I think, but in general the same thing applies -
it's better to put fixes before anything else in the series,
it'll flag up when reviewing.

--9ToWwKEyhugL+MAz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1fxyQACgkQJNaLcl1U
h9DqNwf/QNh0rvN7VFuAHpO+9fAuH2a16emof71uPK515M62lfJjwg0Q29hWXiuS
Operl313jrRdaddOr+bqos+xnevzFqwrcP8f5klFa7Nmofx0La8XaIk9lbrn+FKd
erNLzFHeq+Ot9Oe+NYGSoCS1NigyIFpmm017334bJ2Z/dqBEBUWj8PPSVzeUKqvG
xCjBsN/sCThnstMDwhmQA6uTP8FIu+Q+iLOSjM3jP5qRV03+M7m2o+QOAbVFZpKb
0Ls4dA70Cma3t0i0B8ZT1/NODz2A8Tm2HW3kFnjDH+LxtmpGNyvYqfvD+JOQiFRD
n++9Eg+abR59AW6YMBxsNiIzFdWBFQ==
=4GBH
-----END PGP SIGNATURE-----

--9ToWwKEyhugL+MAz--
