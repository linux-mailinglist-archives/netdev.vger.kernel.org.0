Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA9135F614
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349474AbhDNOVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348303AbhDNOVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 10:21:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2632861019;
        Wed, 14 Apr 2021 14:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618410038;
        bh=DykQO4BQxTHccj2c0RU/3WhmZd1h8XFYW7G9mDIAu20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PSuRbnLqSceeRXtJOmVbK2ImrfOgaaxVevo2l0FliVCtz6IapYN6ta3q8ZDOxTOyf
         9PIh4JXcGsdm3oUf474ro0pblftH6gjuJ/70YDYDFYQJDbFzyXiuVd9mRbyCMGOgmH
         W1Ssg8FbNI9Ym7O4ohirhw+9mVR24wEb6/gxCBFENBF0ivN7OHSIe5ohF7HvBz12at
         ThwiA9XHnPqXvtRSSC0NzL3LZ8I/BHrmxQ3NaY9oPLFMjiAzEVjmXKqiwUN6h0mxL4
         yJsnj4ZhMGGXIkmgdrFy0jJPJlSR+bSdf9RRa302+2rabt7hxc5S8hOnvT+H5HDwFq
         3hq79rq5V6MYw==
Date:   Wed, 14 Apr 2021 15:20:16 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Nico Pache <npache@redhat.com>
Cc:     linux-kernel@vger.kernel.org, brendanhiggins@google.com,
        gregkh@linuxfoundation.org, linux-ext4@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        linux-m68k@lists.linux-m68k.org, geert@linux-m68k.org,
        tytso@mit.edu, mathew.j.martineau@linux.intel.com,
        davem@davemloft.net, davidgow@google.com,
        skhan@linuxfoundation.org, mptcp@lists.linux.dev
Subject: Re: [PATCH v2 1/6] kunit: ASoC: topology: adhear to KUNIT formatting
 standard
Message-ID: <20210414142016.GE4535@sirena.org.uk>
References: <cover.1618388989.git.npache@redhat.com>
 <dcf79e592f9a7e14483dde32ac561f6af2632e50.1618388989.git.npache@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="imjhCm/Pyz7Rq5F2"
Content-Disposition: inline
In-Reply-To: <dcf79e592f9a7e14483dde32ac561f6af2632e50.1618388989.git.npache@redhat.com>
X-Cookie: George Orwell was an optimist.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--imjhCm/Pyz7Rq5F2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 14, 2021 at 04:58:04AM -0400, Nico Pache wrote:
> Drop 'S' from end of SND_SOC_TOPOLOGY_KUNIT_TESTS inorder to adhear to
>  the KUNIT *_KUNIT_TEST config name format.

Please submit patches using subject lines reflecting the style for the
subsystem, this makes it easier for people to identify relevant patches.
Look at what existing commits in the area you're changing are doing and
make sure your subject lines visually resemble what they're doing.
There's no need to resubmit to fix this alone.

--imjhCm/Pyz7Rq5F2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmB2+h8ACgkQJNaLcl1U
h9C5ygf/f+BNG8PCz0e3sGq/F/lIAmu23fPiN7lzXIQ/7/mdT3MwGiTHu9temsXL
0d99SUvGT3MUczcKW+6Vj6faDQZGBXKBsKMW7rOq5h7Ns2tvw5MyvWwSYhHLj/Zt
Ojkg3tN7GXemTVGC+TZyHVqWgh2q2wWvqJHeNzKY/9WPDcQo5BqoHlvO0xm9iF+L
w3XI2y5+R6HulHM9PNNH18x3QiPWrjIjDAn2INWfPuPsAwu9+GpPf16ZK6CusCmZ
ugX0b36XCpwrS2aNmb6SrjAA7GiQGnNXTZZ290lLhaN+ams3aM2pCePDkPjQU5EI
ASor0godC7IdsihlvPd4BHIRP07Sdw==
=U3R8
-----END PGP SIGNATURE-----

--imjhCm/Pyz7Rq5F2--
