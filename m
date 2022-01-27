Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588BE49E889
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244385AbiA0RLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:11:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44374 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244378AbiA0RLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:11:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48EFA61ACA;
        Thu, 27 Jan 2022 17:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE239C340E8;
        Thu, 27 Jan 2022 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643303480;
        bh=bfU+KoqrwUxbW6GHxJ2Kly53zgCDNamg4i4wXRZ0FDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q7XwlbXto8IXJzKhgujjUoiENDbr8hi/oFnC2SoJ+cR/00wx8Pl22dsaxu/ClL6y5
         +szXc7iQ1yeRmznRtNk4wiAc+nmABws2i0pYfa4kz0CsMmjfkOsxxVOxr7Ws9TYRue
         TRvaG7YHB9ufZiSmH6rZ6Fi0LqemyNVfxZyu94CVeuT31ezJRyiJTcSbKLMhdtby1m
         XyqQP3iQgZMNIVGaNOu6t0QNBrNNgPiu8ebTK3Ridkx8rBJa3fYH7VtbMb9R8iXwVc
         9YXx8uGxh4/5K30h611dwjWZdPHwstw6zVj3Kgr4liFqj9+Gk6cAC/YbDW/hqcBoCz
         3HxqGW1iUBZBw==
Date:   Thu, 27 Jan 2022 18:11:16 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Michael Below <below@judiz.de>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH 2/7] i2c: core: Use generic_handle_irq_safe() in
 i2c_handle_smbus_host_notify().
Message-ID: <YfLSNNDVtAFx1P9u@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Michael Below <below@judiz.de>,
        Salvatore Bonaccorso <carnil@debian.org>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
 <20220127113303.3012207-3-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Tote0/I6gsw1g9Hy"
Content-Disposition: inline
In-Reply-To: <20220127113303.3012207-3-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Tote0/I6gsw1g9Hy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 27, 2022 at 12:32:58PM +0100, Sebastian Andrzej Siewior wrote:
> The i2c-i801 driver invokes i2c_handle_smbus_host_notify() from his
> interrupt service routine. On PREEMPT_RT i2c-i801's handler is forced
> threaded with enabled interrupts which leads to a warning by
> handle_irq_event_percpu() assuming that irq_default_primary_handler()
> enabled interrupts.
>=20
> i2c-i801's interrupt handler can't be made non-threaded because the
> interrupt line is shared with other devices.
>=20
> Use generic_handle_irq_safe() which can invoked with disabled and enabled
> interrupts.
>=20
> Reported-by: Michael Below <below@judiz.de>
> Link: https://bugs.debian.org/1002537
> Cc: Salvatore Bonaccorso <carnil@debian.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

I guess you want this to go together with patch 1, so:

Acked-by: Wolfram Sang <wsa@kernel.org>

I agree with adding the kernel bugzilla entry at least:

https://bugzilla.kernel.org/show_bug.cgi?id=3D202453

Probably the others which Oleksandr metioned, too.

--Tote0/I6gsw1g9Hy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmHy0jQACgkQFA3kzBSg
KbYF0w/+OqNuksglO0/K1veCj0S4r5AKF+9L/Je8+51hxkfVPXaASw8QBtWXEZC0
AcMCb214DRxTXFl+lIT44Y+BRht09eKKFj3BN6eFi26ROn6kiLs4RwU8vyEM2JoZ
vgwUs1+qGgOa9CAw5nY1x/DO+8nyJeNrzX0FNIrbjMsKCbFjBNPKdyARdSRqackX
sxg/DoBd3kAtWaQoedAMl4WyEYHGx5GV6WB1nLsk0Uzr2oF1+0yx5iApJf6OdXot
5j1vM/7RUr4dDftefslKzATo8sLvH9FhQeyfbHYpnqnssYjHHIc6iaLwH8m93jQB
CVrgihGYW+4sqxHzdgPYiZHNLxct8WnTb0KblrLc21su9ZpZN9DtM3ySShj+Ok0/
lhUQijKmWpx0U/QTJZ3Smyk0s+Eg87iBFL+rIzPUF0Se8vNybRpYVeNAWWZDM0nN
R/vkF2ZUKAEBxnZtL6Scr9eu2REC95bQtJ5LYNYRgH+3y7L5uMIDUGcb1UZBVXTK
++20+4nO9oCG8HE8RJLJmI2ULo2HrkQ293ROjwMzgLqxgL+C+Llu4bfkTI1MwjQd
2ZZ3qLdRwQakXceVfOuIH0bNeBdzFIuR6Q5eE+NJpD2R8DeToIt7j+rUTnWSjgcL
MOlt3i6hTrTxKfp6LF81bI0z1AetI7I1JmDvdvR4Zu76s2ZPj1E=
=0Whn
-----END PGP SIGNATURE-----

--Tote0/I6gsw1g9Hy--
