Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8192838AE
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgJEPBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:01:48 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:37172 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgJEPBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 11:01:46 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3DF5F1C0B7C; Mon,  5 Oct 2020 17:01:43 +0200 (CEST)
Date:   Mon, 5 Oct 2020 17:01:42 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vinod Koul <vkoul@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-spi@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Another round of adding missing
 'additionalProperties'
Message-ID: <20201005150142.GA28675@duo.ucw.cz>
References: <20201002234143.3570746-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20201002234143.3570746-1-robh@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Another round of wack-a-mole. The json-schema default is additional
> unknown properties are allowed, but for DT all properties should be
> defined.

for leds:

Acked-by: Pavel Machek <pavel@ucw.cz>

I assume you apply it..?
								Pavel
							=09

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX3s1VgAKCRAw5/Bqldv6
8owIAKDAkiq29W/tD49n7es9bNcHQLqXywCfWHIfHZ6OrlZTPZUQgy45PCK/EKM=
=qVmv
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
