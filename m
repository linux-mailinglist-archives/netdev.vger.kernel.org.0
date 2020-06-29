Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C26920DF8C
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389532AbgF2Uht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389516AbgF2Uhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 16:37:38 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BEAC206C0;
        Mon, 29 Jun 2020 20:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593463057;
        bh=A4qAEegdjdQF8sCEmQmfqgvlXcb7Q9mSn6ORmJRVuCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wJxETq24q/IH4x86y58c6ypIbomeeuhOtJm3NmGD6GBjkCxRwx9OtlydfMX4u/uJs
         ECzx/4oubZgluqZaTi0E+vGtNaa0Pgt/cvtWDYvdUBdfpllzpJfq3PkyJvfoHmMqGY
         cGHP+MZgy1982CN7bA6mY8zUldXRTeTaEuZF7mpc=
Date:   Mon, 29 Jun 2020 21:37:35 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 11/12] ASoC: SOF: Create client driver for IPC test
Message-ID: <20200629203735.GN5499@sirena.org.uk>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-12-jeffrey.t.kirsher@intel.com>
 <20200520125611.GI31189@ziepe.ca>
 <b51ee1d61dbfbb8914d29338918ba49bff1b4b75.camel@linux.intel.com>
 <20200528001207.GR744@ziepe.ca>
 <d44a50f6a8af0162a5ff1a6d483adebf16d11256.camel@linux.intel.com>
 <20200528104545.GA3115014@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LvAn5G4Ewe70kJ1i"
Content-Disposition: inline
In-Reply-To: <20200528104545.GA3115014@kroah.com>
X-Cookie: Real programs don't eat cache.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LvAn5G4Ewe70kJ1i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 28, 2020 at 12:45:45PM +0200, Greg KH wrote:
> On Wed, May 27, 2020 at 06:40:05PM -0700, Ranjani Sridharan wrote:

> > Is your expectation that with the above changes, we should not be
> > needing the MODULE_ALIAS() in the driver?

> Yes, it should not be needed if you did everything properly in
> mod_devicetable.h

It will also need a MODULE_DEVICE_TABLE() on _virtbus_id_table[] -
MODULE_ALIAS() is functioning as a single entry one of those.

--LvAn5G4Ewe70kJ1i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl76UQ4ACgkQJNaLcl1U
h9BWAAf/fRxdGsXNZnoBwgtAPs2zyhokytXeuAyzCVRg9clh0PNlvvgPTMgQePc5
XPp7Cku1999W0UXEAnSoXnLNBoW+7lmH4OpreZMXzTO7PaIHCdlcccVC5k/jk2rR
lywNHnVyMUqm6p09DYc8utJyCE6xwtXjRegSAKpRVsj5gnfjMW9NvTjrlbxyTaWB
lRQTgF9QTgbK1Dlvn50cs4pcDQ8SfyzeJ4C4AnJmXBA2LCYC6rtJD8ugQBfk4Ufh
l0HnlUl/4cVtXCqRyuXAISz2xlgfoOhjtKvUN7MD15WSzn9InWSiiVVbfjRc5Ful
Ggx7NtT4i2whG6ED0af4oUY7m7j5GA==
=x4u3
-----END PGP SIGNATURE-----

--LvAn5G4Ewe70kJ1i--
