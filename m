Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034C6307FA6
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhA1UZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231154AbhA1UYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 15:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA9DF64DDE;
        Thu, 28 Jan 2021 20:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611865424;
        bh=iO7ZSC72FkSO5msxnrNl3pzkNeuJI0KURaMGIetLQqA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=We7XJH0G5nMQ6fnPVASdW/lPKdJOtJIBANLe2NM+9ZNg2tu7HZkxijytP9xkxCd/v
         HdYLQ18qG5hTw7DJnaZt7ZvK6hfdq0Pe3J1d+vpVnh5pOuRPYXuWPHXwP1qcUbKxCU
         N7tIqaorTkPh2jZBx4BQcNfw2wej30nLdaTpyik3lekkdwSHBYrLQCLuX2nL285Cby
         Yvsx9SkR1fghrl4eLc8385w5hE+xvfQafo+4D3/H7RJoizRbS8fbyXbW2hyt4Wocn6
         6QZWwC/7rnjGOkvq8yVJqG95Yq0+F22vSwj7SJLwY6p/nKStoz510U/yhQgo5R41sk
         0q2hosLtkFK5A==
Date:   Thu, 28 Jan 2021 21:23:36 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Wolfram Sang <wolfram@the-dreams.de>,
        linux-hwmon@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Cleanup standard unit properties
Message-ID: <20210128202336.GA3094@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Wolfram Sang <wolfram@the-dreams.de>, linux-hwmon@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-watchdog@vger.kernel.org
References: <20210128194515.743252-1-robh@kernel.org>
 <20210128201614.GA162245@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20210128201614.GA162245@roeck-us.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 28, 2021 at 12:16:14PM -0800, Guenter Roeck wrote:
> On Thu, Jan 28, 2021 at 01:45:15PM -0600, Rob Herring wrote:
> > Properties with standard unit suffixes already have a type and don't ne=
ed
> > type definitions. They also default to a single entry, so 'maxItems: 1'
> > can be dropped.
> >=20
> > adi,ad5758 is an oddball which defined an enum of arrays. While a valid
> > schema, it is simpler as a whole to only define scalar constraints.

Acked-by: Wolfram Sang <wsa@kernel.org> # for I2C


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmATHUQACgkQFA3kzBSg
Kbb6dA//VS8eldi8uAa1mEf6ElM2KDOvyEFV2uyartRr0Y//54CMkLEmCIu16Whx
AKOzpk7OOfMUlETV22cBsCRRLyZuJ/rDqgkphiLtPuQUi2h1sj89grqSUBL5Kg8C
MzqNNOnqdbiISFKTgyfNM9cVOxPkbJ+3TrZHou8QfKKtl8x7SuE+Wr6+xYUpxC6x
ZBI7NC1taOe8tHTM6DdsGTVh+sclfzaUXgxmabZfzBXlNM2rhANaWTa2MB2unWqk
Lf/O8VVLc1f3NbfDS0UVafL6M3zbLrzBvlZWyBSHdo56y1P1ejpDzDl9PDQvzcNA
ed9JmdQO0Jh+C6yESODylcOONiiQuGl4s11pId4+UPjWe/YSlnrd4BjncNBMWjb2
2WDAvHWJxRt8Gh95EgIZIVSDExFpnsfw4s0QW8pUcEDh/SeADHkP/rCnT5pJ04oO
AA8gfbdb7DpGzPo7+1M4DGMqfHC9nNk20bpByc0g10tDLfpf+fov01NJS95Ph4ms
np4yxEtQ5cV4qGO+5Qm615C0xCcmsqpgmOe60USL3eb1N7FwjTX9/eCYxc61UOsK
jQt6iVQaeoOXwJppAkSmzLa1q6er4BpPJyEK58HC77cmvr9X4udR7WNQY0+nUqpI
0P7HBGXr9c2zQY0mVC86pc0EN8rjY/CIVrwn1RJ7f+D+CgI1Fno=
=/5B3
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
