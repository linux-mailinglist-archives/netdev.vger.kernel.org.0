Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB6F3CEB48
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbfJGR6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728081AbfJGR6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 13:58:34 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BC7E20684;
        Mon,  7 Oct 2019 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570471113;
        bh=xEwQHPlqXaHNbxmpbtQW2ZV2D287UcBmfyfJ091CUzY=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=CeFAWCSaNNAUeWSP1r74bd/S7UtlGHl1gI3UqiEce8mYH0SkXLZhfgKYQ+0om0+W9
         sDxu1st3KHJAR3JEbY09IbhYQ02OcKrsTbZTZhZqMn+HWA4f7HBTEzNdNY3XTWP7hZ
         wRvv77uApjxALMXA+4FcQLgSw8KGOeySF+4folfA=
Date:   Mon, 7 Oct 2019 19:58:31 +0200
From:   Maxime Ripard <mripard@kernel.org>
To:     Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH 0/5] Add bluetooth support for Orange Pi 3
Message-ID: <20191007175831.2r2thebie6hxmxym@gilmour>
References: <20190823103139.17687-1-megous@megous.com>
 <20191007141153.7b76t4ntdzdojj5m@core.my.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qhahocbwdlja2oay"
Content-Disposition: inline
In-Reply-To: <20191007141153.7b76t4ntdzdojj5m@core.my.home>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qhahocbwdlja2oay
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 07, 2019 at 04:11:53PM +0200, Ond=C5=99ej Jirman wrote:
> Hi Maxime,
>
> On Fri, Aug 23, 2019 at 12:31:34PM +0200, megous hlavni wrote:
> > From: Ondrej Jirman <megous@megous.com>
> >
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
>
> Please consider the DTS patches for 5.5.

Can  you resend them? I don't have access to my old mailbox anymore

Maxime

--qhahocbwdlja2oay
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXZt8xwAKCRDj7w1vZxhR
xab8AQCoq16pTHJEpC+5lsSAtxuOg5ykvT6nmBObbhL8FtoOTwD+NpvLfhLVo3aM
lI/68DRVnpx1ziS2dwVHXdvmQooJ9Qw=
=TYcE
-----END PGP SIGNATURE-----

--qhahocbwdlja2oay--
