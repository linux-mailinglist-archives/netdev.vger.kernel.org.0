Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1DF20DE04
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387685AbgF2UVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733231AbgF2UVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 16:21:50 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C2A520656;
        Mon, 29 Jun 2020 20:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593462110;
        bh=Wm+YESFJcpViZAr4qYBsI74xigVMywcJeqqC9gzvxeI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TUpETRWboHnTBwcDMrfnza+BQZPI7s5C8lPLGNNYZZijNJ42CY/x3L3jDFPx95d14
         3zm25PK4YMR9gsbbGSkOC+yWujyjavvJ4inPLDDtTHArO99kWYcRM81xMMu56dslAO
         0tuHRtoahjaj0bWoxjqiFGFI5hIft8DUs2Q+KFOg=
Date:   Mon, 29 Jun 2020 21:21:47 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200629202147.GL5499@sirena.org.uk>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
 <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200523062351.GD3156699@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kkRamCq5m5VQq0L6"
Content-Disposition: inline
In-Reply-To: <20200523062351.GD3156699@kroah.com>
X-Cookie: Real programs don't eat cache.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kkRamCq5m5VQq0L6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 23, 2020 at 08:23:51AM +0200, Greg KH wrote:

> Then fix that problem there.  The audio card should not be being created
> as a platform device, as that is not what it is.  And even if it was,
> the probe should not complete, it should clean up after itself and error
> out.

To be clear ASoC sound cards are physical devices which exist in the
real world.

> That's not a driver core issue, sounds like a subsystem error handling
> issue that needs to be resolved.

It's not a subsystem issue, it's an issue with the half baked support
for enumerating modern audio hardware on ACPI systems.  Unfortunately
we have to enumerate hardware based on having data tables instantiated
via DMI information for the system which doesn't work well with a
generic kernel like Linux, on Windows they're per-machine custom
drivers.  There is some effort at putting some of the data into ACPI
tables on newer systems which is helping a lot but it's partial.

--kkRamCq5m5VQq0L6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl76TVsACgkQJNaLcl1U
h9CQrgf7BpeSXqlMlGzmpfyBgHml15ESL9g0bxg68JHwjagQzM7YUOfJuRngm9EG
8f02Did+AcKCWWsBBqM149B7limSXwFRwpevkEjRr537mBurrykkdmrg1kaoa7ns
9smrJCToelUsTzpF/ZPR5p8fTJlpdGigeBPlNrNmkfQfFVVIhoYv48IFrL7pOcmP
zCsox1mNHSoEY6uOI+4z7VIR+CgPYKqSiOzcYWL+0SRRRthg1V5ZGmOVlQkI+I57
s8Q/s18HNWc0myEjxyvuftHUes1wLAGXQY/H33UkX+mXCCfHYLhKkhxRdFym4eLf
s008ZvzdSdMY/uuAP6HkCp/DacLdXA==
=Uiek
-----END PGP SIGNATURE-----

--kkRamCq5m5VQq0L6--
