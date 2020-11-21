Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2840F2BC29B
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 00:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKUXJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 18:09:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgKUXJv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 18:09:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD2802080D;
        Sat, 21 Nov 2020 23:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606000191;
        bh=nqxz26mo8JnZraZoTA+dVPsiUYXHcIf5YCVE62ZYN94=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wzbhNd0xc2Uclu+5q4WL9lrNTrmkmh9DvdBNKkNPdW2hvftozpOakrxZb7dtPTwxW
         9nzsOlef/PAak10V93iMUtQZXGuXC5n8XE6zFkLX3n3O7T+0TvTaFnPFwouDmin6ht
         gugkceaixx/xa5pdeJToYWbAD7asvBV6UBxaBIXU=
Date:   Sat, 21 Nov 2020 15:09:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can-next 2020-11-20
Message-ID: <20201121150950.203869ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 14:32:53 +0100 Marc Kleine-Budde wrote:
> The first patch is by Yegor Yefremov and he improves the j1939 documentat=
on by
> adding tables for the CAN identifier and its fields.
>=20
> Then there are 8 patches by Oliver Hartkopp targeting the CAN driver
> infrastructure and drivers. These add support for optional DLC element to=
 the
> Classical CAN frame structure. See patch ea7800565a12 ("can: add optional=
 DLC
> element to Classical CAN frame structure") for details. Oliver's last pat=
ch
> adds len8_dlc support to several drivers. Stefan M=C3=A4tje provides a pa=
tch to add=20
> len8_dlc support to the esd_usb2 driver.
>=20
> The next patch is by Oliver Hartkopp, too and adds support for modificati=
on of
> Classical CAN DLCs to CAN GW sockets.
>=20
> The next 3 patches target the nxp,flexcan DT bindings. One patch by my ad=
ds the
> missing uint32 reference to the clock-frequency property. Joakim Zhang's
> patches fix the fsl,clk-source property and add the IMX_SC_R_CAN() macro =
to the
> imx firmware header file, which will be used in the flexcan driver later.
>=20
> Another patch by Joakim Zhang prepares the flexcan driver for SCU based
> stop-mode, by giving the existing, GPR based stop-mode, a _GPR postfix.
>=20
> The next 5 patches are by me, target the flexcan driver, and clean up the=
=20
> .ndo_open and .ndo_stop callbacks. These patches try to fix a sporadicall=
y=20
> hanging flexcan_close() during simultanious ifdown, sending of CAN messag=
es and
> probably open CAN bus. I was never aber to reproduce, but these seem to f=
ix the=20
> problem at the reporting user. As these changes are rather big, I'd like =
to=20
> mainline them via net-next/master.
>=20
> The next patches are by Jimmy Assarsson and Christer Beskow, they add sup=
port=20
> for new USB devices to the existing kvaser_usb driver.
>=20
> The last patch is by Kaixu Xia and simplifies the return in the
> mcp251xfd_chip_softreset() function in the mcp251xfd driver.

Great, this one finally got into patchwork correctly!

Pulled, thank you!
