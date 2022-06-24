Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305FB559FD8
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 20:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiFXRfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 13:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiFXRfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 13:35:52 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140BE5DF10;
        Fri, 24 Jun 2022 10:35:52 -0700 (PDT)
Received: from mercury (dyndsl-095-033-155-155.ewe-ip-backbone.de [95.33.155.155])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id E58D7660180A;
        Fri, 24 Jun 2022 18:35:49 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1656092150;
        bh=+EH0iTD2RyXg6NOT3T8bkKi66cDg0fDsvnolznRjMug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jm5EGJA/RuRH9YqY0fPGHC1HCqGAsZ1gDSMdoZJ57JKdwOr6EZb7H065XaIibTYF1
         rQ66T2FvvCJzDIcFPdjQTeKt03K/ObDHktixAJwQwVS2x71Gi3I01UFDmkLN5FuQn5
         pvTWRrG8vvCueAhrjfAjNXkyrdeur2Y+cgg2sTHFw0c7wC1odNHZQyI1QnehPCozOF
         FXTdAbJZnO0I1bmAt+aaWsRTDrlVe5eVL1E4MOktBkMQdxjlVFLgsHchavDxXolsn/
         FFF0Rjt1qFJ+O3nimK0kim8bXvrK59IPC1cU4eKVcVUR4nZBuRmOuE9lCqWXdWkZEJ
         pW/yIcDD/dznQ==
Received: by mercury (Postfix, from userid 1000)
        id 39FC510605AA; Fri, 24 Jun 2022 19:35:47 +0200 (CEST)
Date:   Fri, 24 Jun 2022 19:35:47 +0200
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
Message-ID: <20220624173547.ccads2mikb4np5wz@mercury.elektranox.org>
References: <20220623162850.245608-1-sebastian.reichel@collabora.com>
 <20220623162850.245608-2-sebastian.reichel@collabora.com>
 <YrWdnQKVbJR+NrfH@lunn.ch>
 <20220624162956.vn4b3va5cz2agvrb@mercury.elektranox.org>
 <YrXryvTpnSIOyUTD@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qenzcnj3phman7qo"
Content-Disposition: inline
In-Reply-To: <YrXryvTpnSIOyUTD@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qenzcnj3phman7qo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 24, 2022 at 06:52:26PM +0200, Andrew Lunn wrote:
> > > So it seems to me you are changing the documented default. You cannot
> > > do that, this is ABI.
> >=20
> > Right. I suppose we either need a disable value or an extra property. I
> > can add support for supplying (-1) from DT. Does that sounds ok to
> > everyone?
>=20
> I'm missing the big picture.
>=20
> Does the hardware you are adding not support delays? If so, rather
> than using the defaults, don't do anything. And if a value is
> supplied, -EINVAL?

The Rockchip hardware supports enabling/disabling delays and
configuring a delay value of 0x00-0x7f. For the RK3588 evaluation
board the RX delay should be disabled.

-- Sebastian

--qenzcnj3phman7qo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmK19e8ACgkQ2O7X88g7
+ppYMA/+N8W88aXHTf0j/BzfDjaK+JD9zY4pvt14NYf4ry3+ZxpQzE2tbKB+UJHN
UXnEGt+ZMn42ouBQ9tV71fpAfMsW3sz6Oz9InLHW6u5m7AxBUC+QJlOxyvsO2gGh
pca/jDy/kMDvkAlzm59JwkvjGNV0Ykdg1zkQGiCzmGIYM0GSXRxEGAi+aSBSvFZU
ey+pshbPGq9EKVUpIj7S9bWLdHxfWjFnH6N0KhlWB+u/BgUZR7fYT16nXUa2wFfv
1g8BU0D42Nn5QzCx6PCfzlB79fH13C7ms+x32iVdd4OKVLaG+qHiTkr1uQ53hTFZ
UrBy+xP5GFZFW4oGyqWLSEs2u3fB9A4f2KB3JABKQ4DEn5/repN6SjBZpx1rCFJP
cKR26TLZAGfbL2YXVYg+5sCH/87/B8g42t8WZFo7T8AdiIBnPe1iC5rJGtqhTJ7w
9F1eKoqhI1Y5VBEWNftQ1EWwKMqyIkQPgw/n1AoTdxZjkRdMr9xgGKPPp09aZTq8
ZKj7tgoaIoQ5QHkmSHpAzeo3tyoRbnt+LggqcdaGeBzpCrQUEk/5bHp+T4IIy5BN
B7jy0vHA4guncxII1K+Sjsp0eii7Of++/exoH3mWenm5As68R3miJvCNvvI7yssh
6cRjUzXV/PpQJq7MpzzZpGJYEcQptzgQm6JcTDTU1ShCnTURRBU=
=pr4F
-----END PGP SIGNATURE-----

--qenzcnj3phman7qo--
