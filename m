Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35BDAA33AF
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfH3JVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727328AbfH3JVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 05:21:08 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 301FB23426;
        Fri, 30 Aug 2019 09:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567156867;
        bh=3GufUtVPDW9HriFeClZCJbc5zRagccTM02azG30ED2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bGyZtmRs0b4Fxnur3ZChQTe3ktJskBmByqsK+yxfB7FdIL+Uh06hPDvKO2tBvxUs2
         vLV9cE1Ubcz2f8fnnb2TSe3PgjfSXD+6sU67fjRkl13gI1sm+JyGlBeKHDPGcq2ROY
         YXJsOb4xjBWPyFkTwemYMp+Iq9qfKXZ+68kxV7x8=
Date:   Fri, 30 Aug 2019 11:21:04 +0200
From:   Maxime Ripard <mripard@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     megous@megous.com, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: [RESEND PATCH 0/5] Add bluetooth support for Orange Pi 3
Message-ID: <20190830092104.odipmbflounqpffo@flea>
References: <20190823103139.17687-1-megous@megous.com>
 <5524D5E9-FA82-4244-A91F-78CF1C3FB3FB@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zvsfua4pdi5vswnn"
Content-Disposition: inline
In-Reply-To: <5524D5E9-FA82-4244-A91F-78CF1C3FB3FB@holtmann.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zvsfua4pdi5vswnn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Marcel,

On Fri, Aug 30, 2019 at 09:53:16AM +0200, Marcel Holtmann wrote:
> > (Resend to add missing lists, sorry for the noise.)
> >
> > This series implements bluetooth support for Xunlong Orange Pi 3 board.
> >
> > The board uses AP6256 WiFi/BT 5.0 chip.
> >
> > Summary of changes:
> >
> > - add more delay to let initialize the chip
> > - let the kernel detect firmware file path
> > - add new compatible and update dt-bindings
> > - update Orange Pi 3 / H6 DTS
> >
> > Please take a look.
> >
> > thank you and regards,
> >  Ondrej Jirman
> >
> > Ondrej Jirman (5):
> >  dt-bindings: net: Add compatible for BCM4345C5 bluetooth device
> >  bluetooth: bcm: Add support for loading firmware for BCM4345C5
> >  bluetooth: hci_bcm: Give more time to come out of reset
> >  arm64: dts: allwinner: h6: Add pin configs for uart1
> >  arm64: dts: allwinner: orange-pi-3: Enable UART1 / Bluetooth
> >
> > .../bindings/net/broadcom-bluetooth.txt       |  1 +
> > .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 19 +++++++++++++++++++
> > arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi  | 10 ++++++++++
> > drivers/bluetooth/btbcm.c                     |  3 +++
> > drivers/bluetooth/hci_bcm.c                   |  3 ++-
> > 5 files changed, 35 insertions(+), 1 deletion(-)
>
> all 5 patches have been applied to bluetooth-next tree.

The DTS patches (last 2) should go through the arm-soc tree, can you
drop them?

Thanks!
Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--zvsfua4pdi5vswnn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXWjqgAAKCRDj7w1vZxhR
xV8CAP417aV0QNmWtbn2xiBjkD9flY36PSlMOjyVjsX2zxv2GgEAyCygOXXu4S1z
X+AQg5RIlPCGhi8UpGGBfw2i1qEr5gQ=
=bUKu
-----END PGP SIGNATURE-----

--zvsfua4pdi5vswnn--
