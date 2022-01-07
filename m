Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72242487A0E
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239649AbiAGQBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiAGQBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 11:01:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DC3C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 08:01:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E65660C05
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 16:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E97BC36AEB;
        Fri,  7 Jan 2022 16:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641571297;
        bh=OVZzfYgiFE/7UY0v96h6tnQvfmzhbKYX9mv1ojM/0F8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rcg0KlG4PSrhcLtXluI81s3Tus/OQRsNTK8Z9vdYk/1Je0foxwNLWnmN0S/bBRupC
         JWNruY4vSg0hDSBqngWdYQ3Vzm13cl+mp22DY0Da2xyduYnykpP9kIS5nNo67uPTmr
         /HF3dWYIReBxjxPbhIvOHq2k+3Of0E9yYpJHBVnlHmdskwCShXDIygqXscGjUtr2Kk
         isIJsIhEiQSbhpXzUpsgQITl6+MH9suVqg1vrMGvJ6V8NakqIWATYdGNt6e4OqeoTO
         +yDiKeisyJ+1revp6mZBf1B+A7lklS1jo2L9g4jq/YOPF0D1Ep4iVdHpWNsaG3xPue
         Dm+fgeDGXb+xQ==
Date:   Fri, 7 Jan 2022 16:01:33 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next] ptp: don't include ptp_clock_kernel.h in spi.h
Message-ID: <Ydhj3QP2VxXIWfZq@sirena.org.uk>
References: <20220107155645.806985-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DljSJS7d+2SRvBkz"
Content-Disposition: inline
In-Reply-To: <20220107155645.806985-1-kuba@kernel.org>
X-Cookie: teamwork, n.:
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DljSJS7d+2SRvBkz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 07, 2022 at 07:56:45AM -0800, Jakub Kicinski wrote:
> Commit b42faeee718c ("spi: Add a PTP system timestamp
> to the transfer structure") added an include of ptp_clock_kernel.h
> to spi.h for struct ptp_system_timestamp but a forward declaration
> is enough. Let's use that to limit the number of objects we have
> to rebuild every time we touch networking headers.

Nack, this is a purely SPI patch and should go via SPI (and you've not
even bothered to fix the subject line).  It's already in my queue with
that fixed.

--DljSJS7d+2SRvBkz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHYY9wACgkQJNaLcl1U
h9Bo1Qf/ZFzxHYglSLNYtHS6o+/XIbw+8JtM9g1l5uKFL1KiYti362MYqVJMOlmV
gEgivvqtEzWz9tr/EQj6aFhhcVeT6fzWtfUMmlCIHorTv2PgF1TiwtXG+b2j8XPN
oJbxxxtH70vzD7d15hkT/3BXTqdxfEJcsyPVrRK29IUmHx8nN+S3+86ewid0EGJA
rK8Cpulv7khBHWmzpoD+ngI1QsG44Mp9TUYb1QsvmTgNZE2aS0dOztW8SOz6ygsS
sINPaXIazY3FIi0Y2BQ6FuDVZKTtdBlnJTwKf+oE2fOyTbMdCkVY5SDfrYKs3eXj
i30ORVxUTBf62Ll9kCdaq96TS9JEDg==
=xkOh
-----END PGP SIGNATURE-----

--DljSJS7d+2SRvBkz--
