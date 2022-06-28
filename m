Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEDE55CB93
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245647AbiF1KCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344698AbiF1KCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:02:23 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0801A2E9ED;
        Tue, 28 Jun 2022 03:01:56 -0700 (PDT)
Received: from mercury (dyndsl-095-033-152-169.ewe-ip-backbone.de [95.33.152.169])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id AC26566015BF;
        Tue, 28 Jun 2022 11:01:54 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1656410514;
        bh=B+3J166mE7yKiVnjSIyWp3uT7KdPeBK+33FGGWy9RJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M8saON4JHL9YGPUFK1egyrxL/8I/qsYZXe6LxdIs3ftZ5nLVb6f2GxpvYQYI1gwXE
         Er8Li0/WGkZydvB3Qk+R21aLPz2KZjEa6eNgiMKI3M9PCTptid9HYSTA4v0K3RiT2a
         Wf3GfKywmOT0WhMh4JB0oY1imBpu9Ec7LZr3NlfxSzqqSyExNPROSxXYtxGUtP7PXQ
         16+dtthw8a12V5kqJcR2MSWd+obty7RK9U+4z6eAkllpVo1zcElPZwtUoL8j7vabIh
         tCNs1KxSZUZcERzPF8Lu3fgWl/NKynNBUwfyCOPO9CXGLn4coDOwYj7SuJwa1PIIo+
         TrMiFE8+UMOMQ==
Received: by mercury (Postfix, from userid 1000)
        id A946E106069D; Tue, 28 Jun 2022 12:01:52 +0200 (CEST)
Date:   Tue, 28 Jun 2022 12:01:52 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
Subject: Re: [PATCHv2 1/2] net: ethernet: stmmac: dwmac-rk: Add gmac support
 for rk3588
Message-ID: <20220628100152.hpugcvxtqdq7pfic@mercury.elektranox.org>
References: <20220627170747.137386-1-sebastian.reichel@collabora.com>
 <20220627170747.137386-2-sebastian.reichel@collabora.com>
 <7314b028-3cda-d70c-80a1-25750235a907@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c2yjj25avm3cvkmr"
Content-Disposition: inline
In-Reply-To: <7314b028-3cda-d70c-80a1-25750235a907@linaro.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--c2yjj25avm3cvkmr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,

On Tue, Jun 28, 2022 at 10:55:04AM +0200, Krzysztof Kozlowski wrote:
> On 27/06/2022 19:07, Sebastian Reichel wrote:
> > From: David Wu <david.wu@rock-chips.com>
> >=20
> > Add constants and callback functions for the dwmac on RK3588 soc.
> > As can be seen, the base structure is the same, only registers
> > and the bits in them moved slightly.
> >=20
> > Signed-off-by: David Wu <david.wu@rock-chips.com>
> > [rebase, squash fixes]
> > Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> > ---
> > Krzysztof asked what "php" means. The answer is: The datasheet
> > calls the referenced syscon area "PHP_GRF" with GRF meaning
> > "general register file". PHP is never written out in the datasheet,
> > but is the name of a subsystem in the SoC which contains the ethernet
> > controllers, USB and SATA with it's own MMU and power domain.
>=20
> Maybe there was a typo and name is PPH? Like some kind of short cut of
> "peripheral"?

Maybe, but then it is consistent throughout the datasheet and the
vendor kernel. There is a few hundred instances of PHP_ in the
datasheet and PPH is only found for Displayport PHYs (DPPHY).

-- Sebastian

--c2yjj25avm3cvkmr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmK60YgACgkQ2O7X88g7
+poNGA//fEqVCXbx8RU3oSYO8REyv6/VZBK5mmbgFGTRgfx6saGdL23ygwT5CwJV
ONdL3BuHUBeSIOEVCe9HaTiE4LezWtdmNijAQm5dV47TIOyA2LYyoXtW+uYpWcc8
G0Mv547WfztVhClFCP+EjNuP/krXiNOaQU+JsvtFEzGK3t2RiPzCzFqMCkDke4F1
xE7Oz9UAgiFCFDxwKZdON1hP1rTYYBSKqiWT+6HuWY/kwSOPJxMK5/AQhKoEm9lC
j3yPpI82w4lN1E643IdJ/OWmiQb7NFLJ3RL2BgNiy/RQ8UyrlXaNCn557KX+tD6A
DFIIMVBmsjMwMxqb5tUanEydIH6I93vTBhKwRcztmJ6Gl6XZF0CuKXy5FqrhIABy
nYmb2Bonj9wU0SGoOYd4OX6nrCZ/nwbjHLO+xBxgKdX5s109WOJL0VX637p6mTmZ
XhweYOjZZGu+Or741RxiIfjoUjGKpbElbAbKApM7BaDmqO5VWhcZakq8oJ4TtH66
B4Otqi/5YJJLmyizWNZsfJHI7K7rvB+pc4L896Ve77SXJZaePzA/9/zr7X45h+rW
KfSiiP82YulVWYNXRNX5A1pMqOx8AG2P4R11IDZ3FnI+wVzDsAuz51IWFSk6q6XF
NLHlLM70E9ZoVWIR9MDF6AenyA2iTNqgMVoN7GlynUCi8x5yqGg=
=lyNm
-----END PGP SIGNATURE-----

--c2yjj25avm3cvkmr--
