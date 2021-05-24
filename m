Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEC038E261
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 10:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbhEXIhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 04:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232313AbhEXIhC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 04:37:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B6296113B;
        Mon, 24 May 2021 08:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621845334;
        bh=eyOkigzaxEfEyVPW6lOGCJQ5TpDX+0nDIvNy8L+JZRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uyW2ddc1hee7xicNgwjik5O9GSjGsVKD7QXCF83dzEVuPNnbRDS7tVp/gRaQZCGRB
         rVxZB5xG0UuISW6+fdJNEvZllQlCRlBz7YAds11OpQ5WvOATSaZY2aUoV+6vNN7ISi
         vJfVJqTcxHxDyGetQd0tZeSgHqQbSZVIE8JSpgsZuzlX5CFPFaiQYI6STssXFejjvW
         PuCm4bFfmuDpQeiF1/jyZssXrwo935ndSWYVuOfgc8t2ijgjjG2h1jrkWy8l89aZ2h
         E92LXsehnEhyW/tswraMfHrI6JpRb5DS0Gura/2NaxFx1ERWTdma8OX7LTugfHEjkH
         1on7tG6iFqvIw==
Date:   Mon, 24 May 2021 09:35:29 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-spi@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v3 net-next 1/2] net: dsa: sja1105: send multiple
 spi_messages instead of using cs_change
Message-ID: <20210524083529.GA4318@sirena.org.uk>
References: <20210520211657.3451036-1-olteanv@gmail.com>
 <20210520211657.3451036-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20210520211657.3451036-2-olteanv@gmail.com>
X-Cookie: What!?  Me worry?
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 21, 2021 at 12:16:56AM +0300, Vladimir Oltean wrote:

> The fact of the matter is that spi_max_message_size() has an ambiguous
> meaning if any non-final transfer has cs_change = true.

This is not the case, spi_message_max_size() is a limit on the size of a
spi_message.

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCrZU0ACgkQJNaLcl1U
h9DuvQf/U2rSnmWuHCmyEEWe2JzTJhUqvJsVNCGeel7EAVYxWJAiTKLtKKea1PiH
XRsRxr3x2xqcRgicg2mtWVP0zwE6pPiEBC6w6bbmOWu0IQcu24B1i5qEMTrDLm6T
AaN14pIJIZwgEomkWrRyr86vfIpbkwC9c/UArH8qp2UDtC1TeeI7+wt4kkRtoDF1
QoDXrB6Vgt6VmWpbuTYr2j8Oarwm5UJgz51gL7+55bB+Xbl2vlKVfeF+sMqXDP4o
kbDYUt/s94F8NcThdUn/EmqP9m+wDGI6eCGxARgL+CmtxKZjPCdrml6AVw9jHLoY
JchmKXDeg4bZv+C9IZnj6cjeEMGA4g==
=0p4y
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
