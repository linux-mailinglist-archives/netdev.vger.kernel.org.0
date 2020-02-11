Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E80159B99
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 22:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgBKVtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 16:49:21 -0500
Received: from mail.andi.de1.cc ([85.214.55.253]:45244 "EHLO mail.andi.de1.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbgBKVtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 16:49:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=kemnade.info; s=20180802; h=Content-Type:MIME-Version:References:
        In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1jBWyPqMrzGV+HgABFq6zy5XXPza8yinORW6h9VLx9o=; b=IQytAEHkFWeDt0l+Eixp3Mc8E
        FD8nT06U5+KhlqrSIhE5LA7e2YNmJ+8PuNxuytAwQexxw32EIjZIQeX4Ajc37jkTTKhmhOKkXNol5
        Kr3ts38EX4B811dW5iJwdpYrDiCshDcrUG0nX4/F+SXNiNgjrGAWhMQ2xIDP3wTle0KRM=;
Received: from p200300ccff0bd500e2cec3fffe93fc31.dip0.t-ipconnect.de ([2003:cc:ff0b:d500:e2ce:c3ff:fe93:fc31] helo=eeepc)
        by mail.andi.de1.cc with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <andreas@kemnade.info>)
        id 1j1dOj-0004Pf-Fl; Tue, 11 Feb 2020 22:48:49 +0100
Received: from [::1] (helo=localhost)
        by eeepc with esmtp (Exim 4.92)
        (envelope-from <andreas@kemnade.info>)
        id 1j1dOi-0003ve-P9; Tue, 11 Feb 2020 22:48:48 +0100
Date:   Tue, 11 Feb 2020 22:48:40 +0100
From:   Andreas Kemnade <andreas@kemnade.info>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Discussions about the Letux Kernel <letux-kernel@openphoenux.org>,
        Paul Cercueil <paul@crapouillou.net>,
        Paul Boddie <paul@boddie.org.uk>,
        Alex Smith <alex.smith@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andi Kleen <ak@linux.intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Petr =?UTF-8?Q?=C5=A0tetiar?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Stephen Boyd <swboyd@chromium.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        kernel@pyra-handheld.com
Subject: Re: [Letux-kernel] [PATCH 07/14] MIPS: DTS: CI20: fix PMU
 definitions for ACT8600
Message-ID: <20200211224840.40bf549d@kemnade.info>
In-Reply-To: <aa9725056a1d2bfb490a1c912f34302de0e27fad.1581457290.git.hns@goldelico.com>
References: <cover.1581457290.git.hns@goldelico.com>
        <aa9725056a1d2bfb490a1c912f34302de0e27fad.1581457290.git.hns@goldelico.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/tv7EBQvO_xk_m_DPrEdmChx"; protocol="application/pgp-signature"
X-Spam-Score: -1.0 (-)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/tv7EBQvO_xk_m_DPrEdmChx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Feb 2020 22:41:24 +0100
"H. Nikolaus Schaller" <hns@goldelico.com> wrote:

> There is a ACT8600 on the CI20 board and the bindings of the
> ACT8865 driver have changed without updating the CI20 device
> tree. Therefore the PMU can not be probed successfully and
> is running in power-on reset state.
>=20
> Fix DT to match the latest act8865-regulator bindings.
>=20
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
hmm, what about a Fixes: tag here? Sounds like a regression.

Regards,
Andreas

--Sig_/tv7EBQvO_xk_m_DPrEdmChx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEPIWxmAFyOaBcwCpFl4jFM1s/ye8FAl5DITkACgkQl4jFM1s/
ye+rRw/+LUooQ7fIDcxBsFY9+xZRq6snbWx9wkMgAycU5UuVyjUZEzYUizVNm8pT
FfSwVCGf0hHXaz+2Xnm8d6Igp0ii2IWf7LQmE+eoLOOPWeEGIN74eIWXZ+OkJcG8
33+weHfRRx5Lx0SpRKx8g6nIQbGPXs9fWYB3ZjJwei+9DelyNKUqTbJY5xbAxeP5
C6qzOVgO9Py459cXYEXH3HsmW6vATceC+wZQO737h0IF3rclYsdTtNjBhELIT4xG
EgirCfreDPbCn3Y6g2AnAjqk151ssuhEF/p2JWu8VeNIegpksj2BbIRvKG3uWXc6
1sG6EkJ+E8gCdDOhc500PeLdWVPCWk9h9m7w/KMAuCqEr00uY313ya0nfp7EpDSu
oznxzkbQoP1Sy+zUYoaMJ759HELay07sHqI9juk7sLX7DXYeOKdxsoqOk45hEN0o
jU67WS/h6GvsKUgRBKxX0NidVnIikg1/XiMLjBaPyF+Hwq6eq4VL7DTc/86+6u6h
Anv+s3/C0hWq/de/Wr95j+yHtQQy8DMZ73bo8IwaihXbvuaW3IcgWj+lhACwvOjD
nEyj+GAnnBERn7rhRVrGdYgF8Uyq7u9yjOt87EjSPOfRxsOBW4zLFRG8GRiFAmbF
PQtd/UwQ17zKvCf3dezqrXcfQ3rOs9nxHT33IRmzbcPx5hiPwaA=
=WkOg
-----END PGP SIGNATURE-----

--Sig_/tv7EBQvO_xk_m_DPrEdmChx--
