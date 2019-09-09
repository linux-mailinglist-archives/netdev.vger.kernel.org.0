Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A048FAD64D
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 12:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfIIKGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 06:06:24 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:54168 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729534AbfIIKGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 06:06:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fkpQ/WnJG4BHTDw2UZJG4B9CDF+LMucc4j8mJ3xRKZQ=; b=NH71n7TTQD3MpNfIzitbOvNlG
        A67cXE07Kf5Zgy2SSuXhFJQUc0GHUSFBTUMb1QZwqqWeEK4SS64JJoRZrfNrm/Q7KABblRoog6Wvn
        8x2UFhb8reEg3ZdW4+uGXuflGZ7OTL5gxFcXtZjdV7l8aqUtZrZ+K+1uYC7I/L1+p9Ax4=;
Received: from [148.69.85.38] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i7GYt-0001qX-9q; Mon, 09 Sep 2019 10:06:19 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 4C05FD02D18; Mon,  9 Sep 2019 11:06:18 +0100 (BST)
Date:   Mon, 9 Sep 2019 11:06:18 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-spi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Deterministic SPI latency with NXP DSPI driver
Message-ID: <20190909100618.GC2036@sirena.org.uk>
References: <20190905010114.26718-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
Content-Disposition: inline
In-Reply-To: <20190905010114.26718-1-olteanv@gmail.com>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 05, 2019 at 04:01:10AM +0300, Vladimir Oltean wrote:

> This patchset proposes an interface from the SPI subsystem for
> software timestamping SPI transfers. There is a default implementation
> provided in the core, as well as a mechanism for SPI slave drivers to
> check which byte was in fact timestamped post-facto. The patchset also
> adds the first user of this interface (the NXP DSPI driver in TCFQ mode).

I think this is about as good as we're going to get but we're
very near the merge window now so I'll leave this until after the
merge window is done in case there's more review comments before
applying.  I need to reread the implementation code a bit as
well, it looked fine on a first scan through but it's possible I
might spot something later.

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl12JBkACgkQJNaLcl1U
h9A12AgAgjBaLkxqsVW5TL56eMjLxX9dEojMe22QzVUBeRfLcXLRQ0M/5AJqvzf4
AEmOsHlPLqh/SKRoVfOa4Xr2h/Zaiz6wzCcvsLxe3B9P7MYg0/9kyHiDEjGExuq4
X1r18hLuMKsWjBmrWoojtSGlQd5pbpmRdVPDseF+ved5Gp4S78KKx2gDZxYGuiy6
JB9LDRvsELfSndCxCJAC6s5BTb4uSmlVOB4gyzWR31XZXtNwIT4lz0eLUlaI0UBW
ckxeMzTSeBRrQ5vQMm/1ZwjYh7hdhQYlWn3minuDj5FWwgVj754fdoi/2+rW7FaU
27xyj6cr4VIcQXWmU3DylfAbe+qE8Q==
=eS/Q
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--
