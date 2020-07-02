Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5151C2121ED
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 13:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgGBLP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 07:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgGBLP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 07:15:26 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39A572070C;
        Thu,  2 Jul 2020 11:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593688524;
        bh=T46/s05JJaZY2ZsHB2+vCYi4rc2Z76kKYeyjd9/b608=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gYGVYjx2o+x8wg68Phh08ojPd0/BADKrvWSBawDOYoPfijtZHJ8u0lX3jtYM9Xffv
         QDVI9AS8f47OCMoW7Q6Z0lofKG1JRc0mHxla4MXRXPpIWec/M02j21S73Ok0S1lDur
         VZmQf/hsuT3k/qSXB5KFReklPLuh7eO1OGar5s2g=
Date:   Thu, 2 Jul 2020 12:15:22 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>,
        lee.jones@linaro.org
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200702111522.GA4483@sirena.org.uk>
References: <s5h5zcistpb.wl-tiwai@suse.de>
 <20200527071733.GB52617@kroah.com>
 <20200629203317.GM5499@sirena.org.uk>
 <20200629225959.GF25301@ziepe.ca>
 <20200630103141.GA5272@sirena.org.uk>
 <20200630113245.GG25301@ziepe.ca>
 <936d8b1cbd7a598327e1b247441fa055d7083cb6.camel@linux.intel.com>
 <20200630172710.GJ25301@ziepe.ca>
 <20200701095049.GA5988@sirena.org.uk>
 <20200701233250.GP25301@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20200701233250.GP25301@ziepe.ca>
X-Cookie: I'm rated PG-34!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 01, 2020 at 08:32:50PM -0300, Jason Gunthorpe wrote:
> On Wed, Jul 01, 2020 at 10:50:49AM +0100, Mark Brown wrote:

> > Another part of this is that there's not a clean cut over between MMIO
> > and not using any hardware resources at all - for example a device might
> > be connected over I2C but use resources to distribute interrupts to
> > subdevices.

> How does the subdevice do anything if it only received an interrupt?

Via some bus that isn't memory mapped like I2C or SPI.

> That sounds rather more like virtual bus's use case..

These are very much physical devices often with distinct IPs in distinct
address ranges and so on, it's just that those addresses happen not to
be on buses it is sensible to memory map.

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl79wckACgkQJNaLcl1U
h9CHqwf9FtZW3uRoi7muHR8kqXkUw0BLi3DH3/wixl7IIJS7enYClmelX0TnUHCW
KCS2vc3hU1RKNFLComkzWs6rQoY8extTzFMvz56nHSoxzAY8oMDRyqiR1uRJB30l
FCbvGaZg/m/q0rMpsGG7prF17Kf5e3JzRTPMWR2mTeZARDpkftWeFwAPBeAqD2vv
YopwSL5iwcxzpxS7S8hhQP3oyLr+MXSgiSbhBt0uIfBtXrpJkuxGWQXOS/JePmUm
1M7S4XTtVOD0vtdG796x/LZfYQ8edWuKS6p+FfZhRES0y6t8j0OettPiWr+SC85c
e7AXbLy/51pqnBAJI8bAPjlGWzYiyw==
=vMGu
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
