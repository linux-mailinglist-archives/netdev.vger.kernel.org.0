Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 112579AD1A
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 12:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388098AbfHWK2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 06:28:19 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:55448 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731002AbfHWK2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 06:28:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/E5JUjiVVTZL1/2NgiVKzh6rSDnh6yNikPOcBaHVxFQ=; b=NDsUSsnr95zSwKVYQ3WivbAxp
        nxEjNHJjq5bl9MbaBxUkWhwzEv1O1o6KoHcw7hVZs5QW/H3TE2kjXqHy454n/mkmfpizXc4yyP1kt
        uFOqkG0tZRE/NQJGuVEjlz4StMNKfsJ0+RYPJ369e4eA/gd7U+Nd8bRi8Q5FZ3oj/+jfs=;
Received: from [92.54.175.117] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i16no-0002jC-VF; Fri, 23 Aug 2019 10:28:16 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id A8203D02CD0; Fri, 23 Aug 2019 11:28:16 +0100 (BST)
Date:   Fri, 23 Aug 2019 11:28:16 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/5] spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE
 when it's not ours
Message-ID: <20190823102816.GN23391@sirena.co.uk>
References: <20190822211514.19288-1-olteanv@gmail.com>
 <20190822211514.19288-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SLfjTIIQuAzj8yil"
Content-Disposition: inline
In-Reply-To: <20190822211514.19288-3-olteanv@gmail.com>
X-Cookie: Don't SANFORIZE me!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SLfjTIIQuAzj8yil
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 23, 2019 at 12:15:11AM +0300, Vladimir Oltean wrote:
> The DSPI interrupt can be shared between two controllers at least on the
> LX2160A. In that case, the driver for one controller might misbehave and
> consume the other's interrupt. Fix this by actually checking if any of
> the bits in the status register have been asserted.

It would be better to have done this as the first patch before
the restructuring, that way we could send this as a fix - the
refactoring while good doesn't really fit with stable.

--SLfjTIIQuAzj8yil
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1fv78ACgkQJNaLcl1U
h9Cv4gf+PlempNcDKec7OiBxdWny+wFPRO1wq7OKtAEtzU2wFvuZYAjGYbCciUyw
cKlSUJ9T9Lg4Rq9PTM7CbmY3FobaqJyqTeZT6cADZE1QZoTJD78lQxB8XmJtRBu1
r8z6XPbgLbRnws9lzRQIDdRvdIX4DO9sFiY/M+9nbbMGbGbkYKbHNk5461pHEV45
c9lCEgHX62vJerrt0jxfomw50W8tEaqhZ9q6dg1zXwuXjXMmPBPQNnTkexYuco8L
PIfr5fq2cFMOH0hvXdim2H8spTU3tizQQlZS7NeXkaC8tgE4vBYibF1BYnoCfuos
AYL6TZxFXh9I5JM/fUCBs+qbLtbneg==
=lQOn
-----END PGP SIGNATURE-----

--SLfjTIIQuAzj8yil--
