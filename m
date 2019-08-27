Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA7D9F25E
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbfH0ScN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:32:13 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:44536 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfH0ScN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:32:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KR1dloJvEf8PAMuU0DB8AHwUdRF837NGwIDbIYsEPbI=; b=n6UUDDIFHWzFr+km8rGIu3scH
        18/G/IkOhuUlUUWaRWI3jvO2n0Na0prDvZwajHqG9L2Elf+vSJp3UFDXhulSJIlhGXNFAvSgPc5aS
        zWO6ttcEnaa9okNHQqgBbkjDN0WWtM5oRKl6k0nDgyJvubr4GWRLaXDOial+y7xlghVDo=;
Received: from 92.41.142.151.threembb.co.uk ([92.41.142.151] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i2gGI-0000vz-GW; Tue, 27 Aug 2019 18:32:11 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 439CED02CE6; Tue, 27 Aug 2019 19:31:54 +0100 (BST)
Date:   Tue, 27 Aug 2019 19:31:54 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH v2 5/5] ARM: dts: ls1021a-tsn: Use the DSPI controller in
 poll mode
Message-ID: <20190827183154.GI23391@sirena.co.uk>
References: <20190822211514.19288-1-olteanv@gmail.com>
 <20190822211514.19288-6-olteanv@gmail.com>
 <CA+h21hqWGDCfTg813W1WaXFnRsMdE30WnaXw5TJvpkSp0-w5JA@mail.gmail.com>
 <20190827180502.GF23391@sirena.co.uk>
 <CA+h21hr3qmTG1LyWsEp+hZZW2NJFtg9Dh1k6SXVDd+A_YSQjjw@mail.gmail.com>
 <20190827181318.GG23391@sirena.co.uk>
 <CA+h21hqMVdsUjBdtiHKtKGpyvuaOf25tc4h-GdDEBQqa3EB7tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gIORF5nGxIt+AP0s"
Content-Disposition: inline
In-Reply-To: <CA+h21hqMVdsUjBdtiHKtKGpyvuaOf25tc4h-GdDEBQqa3EB7tw@mail.gmail.com>
X-Cookie: Don't SANFORIZE me!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gIORF5nGxIt+AP0s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 27, 2019 at 09:16:39PM +0300, Vladimir Oltean wrote:

> I can't seem to find any situation where it performs worse. Hence my
> question on whether it's a better idea to condition this behavior on a
> Kconfig option rather than a DT blob which may or may not be in sync.

If it's unconditionally worse then it shouldn't even be a Kconfig
option, just make the driver just never use the interrupt.

--gIORF5nGxIt+AP0s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1ldxkACgkQJNaLcl1U
h9ARswf6A+M4PLUEgqtq4LS9LU7LpH/qbPKXT1byjJNJOzZJhiaNOdOfiQUXTpHH
bipXfDjoA+Bq5QZyp0VX6qO8heo7sSdZzmNKx3wnydsKCGck5e3Ste7Yru5PY2sn
r9pdyH1nFG5BSfaxxx4fDzBArcNXJM0fo2lVxpwk4tNuviBMKON55SrJ8maV1Krm
1Tut3wZxZC7UtS5GQE6TDTGpSRSKjEMLNodsZYLRcbh+FimChm5jEHHegB4hLv4b
o9+IhSlpp+NHkSCoYN2kQmEEi03g95O4mbHSqonF3mpmM4qXQuGsM8brK+UoRgpe
koyv59Xv//Wv79iCrMHH3tiK8FCRKg==
=OKu8
-----END PGP SIGNATURE-----

--gIORF5nGxIt+AP0s--
