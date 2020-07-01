Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0462C210894
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 11:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgGAJuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 05:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729289AbgGAJuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 05:50:52 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F7352073E;
        Wed,  1 Jul 2020 09:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593597051;
        bh=VvqJTlhuMbTdt8wSftp0Di3tg/lwpM7IrDFvrIoWYdc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vd49mohwq3SN/NFd++xTh7KZ+2Mg1fEjYdmRwTAPauyK+jJvDfDQp1gdKNrS2tmqQ
         JRMSTPn/VQvqmJ3IiPggijHv8yMAlFtb+sNSK45st1fAd3dWylx12P/0OM22myJwHD
         fKy9UW8Xm2IrXpDIUPQI/vIqrVVRQElf+GRC/tiM=
Date:   Wed, 1 Jul 2020 10:50:49 +0100
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
Message-ID: <20200701095049.GA5988@sirena.org.uk>
References: <20200524063519.GB1369260@kroah.com>
 <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
 <s5h5zcistpb.wl-tiwai@suse.de>
 <20200527071733.GB52617@kroah.com>
 <20200629203317.GM5499@sirena.org.uk>
 <20200629225959.GF25301@ziepe.ca>
 <20200630103141.GA5272@sirena.org.uk>
 <20200630113245.GG25301@ziepe.ca>
 <936d8b1cbd7a598327e1b247441fa055d7083cb6.camel@linux.intel.com>
 <20200630172710.GJ25301@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20200630172710.GJ25301@ziepe.ca>
X-Cookie: You've been Berkeley'ed!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 30, 2020 at 02:27:10PM -0300, Jason Gunthorpe wrote:

> I wonder if SW_MFD might me more apt though? Based on Mark's remarks
> current MFD is 'hw' MFD where the created platform_devices expect a
> MMIO pass through, while this is a MFD a device-specific SW
> interfacing layer.

Another part of this is that there's not a clean cut over between MMIO
and not using any hardware resources at all - for example a device might
be connected over I2C but use resources to distribute interrupts to
subdevices.

> MFD really is the best name for this kind of functionality,
> understanding how it is different from the current MFD might also help
> justify why it exists and give it a name.

Right, it's not clear what we're doing here.

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl78XHgACgkQJNaLcl1U
h9DowAf/VY4gNXd+JS5NRt3cQBZC88UrHySu3g84FplrhB+KHinCrjk9Iv5pwkbo
GyWY/kiHEZrxw0FxPsG3Bmkii4aJP72ETVQNao6+EmxHEABbmRSKAvHczMlVZD7A
YQKGV9Bq515hExa5zRJx57l6bUeIIqBCemh7xD7O/YxjIOkn1QczzeLTlGgsWXUh
XHH7ePa8cyDkrFPW83QUR7mQleRLQTTLgW47i92kmEGVlT60xnMwYVzZtp5kjHbr
XhvjpUa84lXfc+0oBsl5mwma6DYMx+AKVhr+JTiQtTyFEgHVTo6XXK4Vw6CA/oDa
Ho6UJlYf9VZ6dlbY06SxSN8S2QEM/w==
=gH+H
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
