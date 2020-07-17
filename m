Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E71223AF7
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 13:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGQL72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 07:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbgGQL70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 07:59:26 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C01032065D;
        Fri, 17 Jul 2020 11:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594987166;
        bh=IBC0fxfS9D7A/ESzV86wlZOweut+yTh9ShR/uTQtWsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l3he7Zb25ylwXTM+e0bCR6vU9eGg6EbkNVm+2ZjuZJklUHo0TgJywhDGe6XZm1pB+
         WWjgpTpBmhJVa9E5E8uFYvmf/cGv3uAUeOHIgU3RcuPY82Yneo4mqNrDBHWDWUxM15
         DmmiA+K8Q86iYdDD1GMBM4uHo9m9kYvctKGCRmLw=
Date:   Fri, 17 Jul 2020 12:59:15 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 14/20] dt-bindings: spi: renesas,sh-msiof: Add r8a774e1
 support
Message-ID: <20200717115915.GD4316@sirena.org.uk>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-15-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EP0wieDxd4TSJjHq"
Content-Disposition: inline
In-Reply-To: <1594811350-14066-15-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Cookie: No other warranty expressed or implied.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--EP0wieDxd4TSJjHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 15, 2020 at 12:09:04PM +0100, Lad Prabhakar wrote:
> Document RZ/G2H (R8A774E1) SoC bindings.

Please in future could you split things like this up into per subsystem
serieses?  That's a more normal approach and avoids the huge threads and
CC lists.

--EP0wieDxd4TSJjHq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl8RkpIACgkQJNaLcl1U
h9C49gf/eW/cjPlYI1cbSfRXBxXem11Bis/Eyf7JldTeF1+MuH3As7rZdLb/Echg
mYjYxsQ/gYm2DjC32f3rK+qY8Enzqz3k2jl7qJZ8R+pPEtfW9+ZrDHFAUyuE/Bwb
sG+qKb/lwZ3KgqIO85RfL9b5WGktXWg26M182qVbBIZTGYRysCksSaUN6fxSKfwN
icZD/vNKlJ9tJcfFxsjKl37Ti8ipK6ht46YI880NPw/lVkl7aFbJOsHY3LHW2JkR
qTH281KenQZDUUXHaIqusmXvyMhns1zbIhsZxaZ9txJFNZX43TK1krvBVznJYK20
K3YSdEJoHNWVwjPSdMbWIO1iOR9SSQ==
=3N6n
-----END PGP SIGNATURE-----

--EP0wieDxd4TSJjHq--
