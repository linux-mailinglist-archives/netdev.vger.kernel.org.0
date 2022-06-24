Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DFF55A267
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 22:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiFXUPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 16:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiFXUPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 16:15:43 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AA57C51D;
        Fri, 24 Jun 2022 13:15:42 -0700 (PDT)
Received: from mercury (unknown [185.209.196.172])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 959386601808;
        Fri, 24 Jun 2022 21:15:40 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1656101740;
        bh=GpAStSocz9lTo4DkTi0C7A6H/fVwnZse9iHSV9jIL6E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UARKbgWUWJpTXhOwqSnZxG7rtO0pnaOLGY3kIThlm9KsE1QrF0LoO726zV3Bt7QMF
         62KLuD/EQxJbzNlf4OtN+dxsnT2a2nk/7HRGmqEwX9iTZkXO9E0VCV2me0LvQGrKsM
         qzoOg2efmDGjlLcHdZzJmwRsEtEusd+VGSkH8rYMhRj6G4C6QCdINthorMYpze69NC
         UOd2R2xg2c/pVjJ2rjnT2dM9v/3Fdx/wdLfbs0IiKRIszdliy4E6rR3ShjaK2fMd89
         QoQ7zzFyTnSbA+6geJI/qI3MhhGXgckhPLgYvoav8t+YtpVu+3w91ycwtFPCfgggqb
         Iufsi/CG8XRKw==
Received: by mercury (Postfix, from userid 1000)
        id 02A62106042E; Fri, 24 Jun 2022 22:15:38 +0200 (CEST)
Date:   Fri, 24 Jun 2022 22:15:37 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
Subject: Re: [PATCH 1/3] net: ethernet: stmmac: dwmac-rk: Disable delayline
 if it is invalid
Message-ID: <20220624201537.l7p6aoquvvadmpei@mercury.elektranox.org>
References: <20220623162850.245608-1-sebastian.reichel@collabora.com>
 <20220623162850.245608-2-sebastian.reichel@collabora.com>
 <YrWdnQKVbJR+NrfH@lunn.ch>
 <20220624162956.vn4b3va5cz2agvrb@mercury.elektranox.org>
 <YrXryvTpnSIOyUTD@lunn.ch>
 <20220624173547.ccads2mikb4np5wz@mercury.elektranox.org>
 <YrX2ROe3a5Qeot4z@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bro7bpagl7rdad74"
Content-Disposition: inline
In-Reply-To: <YrX2ROe3a5Qeot4z@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bro7bpagl7rdad74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 24, 2022 at 07:37:08PM +0200, Andrew Lunn wrote:
> > The Rockchip hardware supports enabling/disabling delays and
> > configuring a delay value of 0x00-0x7f. For the RK3588 evaluation
> > board the RX delay should be disabled.
>=20
> So you can just put 0 in DT then.

My understanding is, that there is a difference between
enabled delay with a delay value of 0 and delay fully
disabled. But I could not find any details aboout this
in the datasheet unfortunately.

-- Sebastian

--bro7bpagl7rdad74
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmK2G2YACgkQ2O7X88g7
+pqiDBAAlk7O7wwRXuOqcc29+asjR935JyooapTz0/VVhPhvB/6GCdzPe+hjAiVM
jp/e5b5sSROLIa/D5xorSyrqGiL72TfDr4eA3CMmJBUn7rhQDm5uVY57Zstk3yQC
625CGU2H7bT3QsdlX/9agbhutJySsKLKlhpN+NxQEafV4PsQKf4JaXIVcPYW9iZv
t9dYk9OzH8dLWI58hCPoQ/URaLfuMF8hdcnhmpGrfVPOGDmr6IGN7YuhDd83NYAc
074UFePwOLI+dP8CM8fqcT059RQQzlAK+EBHWDvhJWyLqF3fybyqCVs0vIqz/Fd3
b6EjVVrhBe005qCepl/zwsObhBTLCy8UxcZbb38sHA2T/T6c5y6/QDzurc/AFtTa
3iLPe4AW1RiFh515Wn32oypp4+mfcMVGQEioQ+azrieHvJstZ2p5bX8VMhvVd3wt
xk+lY9L7Jvhn4J/apiOzFL6EVYOkXtw/YD/Jvdn/pr2h4aHSp1OSAjz8dzxPo2Yx
GftN+89VwJYYN52403EyBsXBs0OsKs9aCk5Ks+FCzrRF3fDrvZkABj7CVkUMeKtb
5nCJufxtR6YxlbUvS+zdfHApByVAjGF09yNcpF54xPLPDKiyRFU8lReuSmDKe7+j
w4saKJ9oAWg6ltDgM+X5CjpoO+VbfYlZjzP95IDfRq2AwGu0s7s=
=bqc1
-----END PGP SIGNATURE-----

--bro7bpagl7rdad74--
