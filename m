Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4889B49E8A9
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244413AbiA0RQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237863AbiA0RQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:16:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C8FC061714;
        Thu, 27 Jan 2022 09:16:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49C8861AF6;
        Thu, 27 Jan 2022 17:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC363C340E4;
        Thu, 27 Jan 2022 17:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643303816;
        bh=3sFJxFok/Vm/LJYDlprm0kpc3VVV7j3cv3+yv3y74tc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lRgNkVCXGYtS9/yVBxqt81L7KoXwjFl8Kxpt0mAadOFijduZpkvG6B2OrlC83ca0N
         K1mwC3rv7XJXEGNIBZCJsiULlfXxRu6QvNpbXnc9NmrxwARRL359qr8NZcqzBaqvDD
         g1KXUkFPNHCYX69BLh/w++PetyJY2fX/WIMv+KiFry6DxFpLLILybA118xe/IagYVe
         iZtXr4Oj/k4rPZDTy9woATJtIz6/pwaFz55ZYPmBPABRgPNrOEekCZQCvEAt7wGvRk
         ub/Y7RqWQu+052uUtGB+V0fw8Q7L7KnQcnJSpsnzT7IXdUf8Jn6iOXnngq8inlAz4v
         Mko0As2NX5EYA==
Date:   Thu, 27 Jan 2022 18:16:53 +0100
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
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH 3/7] i2c: cht-wc: Use generic_handle_irq_safe().
Message-ID: <YfLThZsBwAucs2vp@shikoro>
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
        Woojung Huh <woojung.huh@microchip.com>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
 <20220127113303.3012207-4-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ohdBGZcj3HIE2DHF"
Content-Disposition: inline
In-Reply-To: <20220127113303.3012207-4-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ohdBGZcj3HIE2DHF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 27, 2022 at 12:32:59PM +0100, Sebastian Andrzej Siewior wrote:
> Instead of manually disabling interrupts before invoking use
> generic_handle_irq() which can be invoked with enabled and disabled

generic_handle_irq_safe()

> interrupts.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Besides that:

Acked-by: Wolfram Sang <wsa@kernel.org>


--ohdBGZcj3HIE2DHF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmHy04QACgkQFA3kzBSg
KbbuBBAApe83Cdzr4jHFw/VgdFhkEaqQ9GyIOEbk07yeaTzSKFdMhAJ2mOYFSmix
BUdKMer4wLUbUw6p8Ogbzh8T5sTB5l36hfLUOFwoQ8dkHCciS+kpdE7oFh8CgudM
6a2YN8hRxy9pQpxiJhQr9VyLERzoaTsaBMs9wo/H/gbsl4BkmxwLhBGMJrt9MJC+
x/yIg6r5AmKf4ItMr320DU60tQac0el75+yYq57M6nNIA+PUYV0ZaAS1r1tGHJxM
nBFDUDrWEvfXHV/HNCl4Gw7FTyhFpSxe+H8RsNZHH76qgykMc+KeDnN8Qb4gfMFg
U9YRMu7Q6Azv8wpSgtDN+7bINtLAdkj7WywkyWbnLKTi/2nXFuCLXjff0zGbfP1K
V47ntKY5eoXyEw26FjkXkBTepxGJWy+gY/2c688nCaFAWVYcKxxs1+mGxqhnf2+M
/O6utGhd2xInMPSTRNEG0WnPOWMNcjUcBUV2kDprYuMJbSGaHklBB8SuZv7M9uOu
rdHSlJny2chnQBTZOj/ECP10oJXKjCCaSax8YHBuVd12F01wCmiTfx9s7F4SqIXU
2X0rqY3PhCOPgfptwL1RwkEPxl5MEygPZju7i+1X9dscmZLQeQ4nBdPIH9bUs9s+
Onbqlw/siGuuqSQ0qpvx5xxU0bchZ/Ra0dexsTEkSsgI509vNJQ=
=xbBq
-----END PGP SIGNATURE-----

--ohdBGZcj3HIE2DHF--
