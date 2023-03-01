Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EB86A67C6
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 07:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjCAGvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 01:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCAGvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 01:51:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38232BF0B;
        Tue, 28 Feb 2023 22:51:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4181E6122A;
        Wed,  1 Mar 2023 06:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A05C4339C;
        Wed,  1 Mar 2023 06:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677653466;
        bh=wLkMLeYVg39jdoFtmeKF2FCB/B7Xc+Wq5sqDU7iNotE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K6zPgqPXp0Y/xc6BNFauRluIJdCwb/LyhjQGczc8UAQjdfDrVq7TDLD8Z+JUpE8eZ
         JauC8OTwrKIDBxyRnr+oJu5MBMqa3IE8Kv4Tnolf8trZ5HYoy5brjp4M0gUsz8EWpd
         IB5MZ8KKWdzy9qaDY8/a4eknGirTNYqM5RBlLtHe0dLJ2oEskAoTXT2nGEkKQqLsmk
         JBQaH3j5kWnD/uxWHykDuz3l41G1SHdOiFRZiY8CMJYwXotYYaDjYiIRPCfmGNj49C
         PhTtdM0hG6W0TyYq75VzkwaRurIgKjI4kB0B9nqZq6LNgWLqEWQu7jkibtk8u7Nu41
         XhgJmkSju5LVA==
Date:   Wed, 1 Mar 2023 07:51:03 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Kalle Valo <kvalo@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix SPI and I2C bus node names in examples
Message-ID: <Y/7112o60iSJKBmd@ninjato>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Kalle Valo <kvalo@kernel.org>, Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
References: <20230228215433.3944508-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YR5VkbtgaV6fwHXL"
Content-Disposition: inline
In-Reply-To: <20230228215433.3944508-1-robh@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--YR5VkbtgaV6fwHXL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

4:33PM -0600, Rob Herring wrote:
> SPI and I2C bus node names are expected to be "spi" or "i2c",
> respectively, with nothing else, a unit-address, or a '-N' index. A
> pattern of 'spi0' or 'i2c0' or similar has crept in. Fix all these
> cases. Mostly scripted with the following commands:
>=20
> git grep -l '\si2c[0-9] {' Documentation/devicetree/ | xargs sed -i -e 's=
/i2c[0-9] {/i2c {/'
> git grep -l '\sspi[0-9] {' Documentation/devicetree/ | xargs sed -i -e 's=
/spi[0-9] {/spi {/'
>=20
> With this, a few errors in examples were exposed and fixed.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>

Acked-by: Wolfram Sang <wsa@kernel.org>


--YR5VkbtgaV6fwHXL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmP+9dcACgkQFA3kzBSg
KbarOQ//WCC+R6Fe2lHHwZbZ4vmS2d/Rlz7qLlnduMr+4h9rcgknAchlVnbv0OUy
Fu8SgebyBTX19WTXbUTyILzN7IsxLxzvTesJDhfIB5n9o7uIe3V0ZiX1R1SWsyV8
GVbUGpJFSmhar2duHPida9xvf98Cww8v3KSoWNPHSaea5+w2oXluLm6jhQPrA1pR
1I5WdUeWduWgwX/xDPJ0eeCEW4UxRawpGgCeMo/Ip/JZRwixnNDX1BJZsNIqJBDU
gcZq4glZHY/Gwlo9gHGZwG8Nn+pWo8dsv+zcytJfhGjqb/k3NqsZ9YUvkbGb/pQ1
RvEGvrA/KichSvbyfcBv02QcG5e6Fo4wk4879wTK8EGIN7RCnZyQCPRNzDogCcG4
nYyGcj22Fvv2lWoon/Gg2MGIBhGvYyZXttD185ZkCYWpRKKGFGIa6jdwuMexfNwx
VyuM7+HONLuKvO4+l1plMFAqBLy1Ex6kQDN4iDuZVVYA4Vcy2NyaQndehGUVTfrn
OXu+lKVm9gNAKSlXTGXVQE04Bb2nMfp0B9PSYxvGxX3P2IJ6f68m/1LYH+kG4vaM
kuFXDcSwYXIp++xhlMhHdyTKm5VTE0MX6wm9PEKjJ+fri1lohTa3mdUvaMzcosho
MT0d2HrmQMXy+rAJoc7GlgEV5vd4O2sx9hACz8tahPmILpAkHGg=
=TVnc
-----END PGP SIGNATURE-----

--YR5VkbtgaV6fwHXL--
