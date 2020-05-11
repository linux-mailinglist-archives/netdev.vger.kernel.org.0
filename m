Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607221CDF3C
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgEKPjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730084AbgEKPjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:39:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B81C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:39:54 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jYAX3-0005sH-85; Mon, 11 May 2020 17:39:53 +0200
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jYAX2-0006hk-Sw; Mon, 11 May 2020 17:39:52 +0200
Date:   Mon, 11 May 2020 17:39:52 +0200
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: Re: [PATCH v3 4/5] ksz: Add Microchip KSZ8863 SMI/SPI based driver
 support
Message-ID: <20200511153952.GM20451@pengutronix.de>
References: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
 <20200508154343.6074-5-m.grzeschik@pengutronix.de>
 <20200509165656.GB362499@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wKTlTxfx0Fr6BT7S"
Content-Disposition: inline
In-Reply-To: <20200509165656.GB362499@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:38:45 up 81 days, 23:09, 117 users,  load average: 0.08, 0.18,
 0.17
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wKTlTxfx0Fr6BT7S
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 09, 2020 at 06:56:56PM +0200, Andrew Lunn wrote:
>On Fri, May 08, 2020 at 05:43:42PM +0200, Michael Grzeschik wrote:
>> Add KSZ88X3 driver support. We add support for the KXZ88X3 three port
>> switches using the Microchip SMI Interface. They are currently only
>> supported using the MDIO-Bitbang Interface. Which is making use of the
>> mdio_ll_read/write functions. The patch uses the common functions
>> from the ksz8795 driver.
>
>This patch is pretty hard to review. It is huge, and making multiple
>changes all at once.

Indeed, that is a big one.

>Please break it up into a number of smaller changes.

I will create smaller patches for v4.

Michael

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--wKTlTxfx0Fr6BT7S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAl65ccgACgkQC+njFXoe
LGS0eA/9FJKXKZJPdIUXwoHqyyX85pN8rbc2IBsGBl8JmcIN+2aE5MR35J6jXVqE
/dWKB9tNTrEfJZkrWDdxvt5mBWBOd+eL2kYnG9fGVAfQpS03jR6xD8PqWTU8Yzbn
63pZ+N3cpo2FhNonqHjPLh4kgyajTp7ai9wdVVct42SeSNAY35XL4anI2AM4H/A6
YnEvQbu0Cx10T/Os8qof9lD/bC2JyyabcVo1k22tPFpS/Qtj3y3/v4JtcFQoHuaA
xBXi4l22td2HHHjk0JiAKNu3aaXwbMhRMlFrjn57W3CwE/891ppQM9Y6cuza6gks
+oLgQ1G9kdWZFAn3piktnaLe16wvyZsoZJ5DtYJsUHIXiNqB7OC0SIVxTxbrUNKp
IN71uAhKQvlb6tRqVrzuETJ3TlhSLmpoo8iIwfJHZRzn/FvSN3pYmZQgMIGgYTzr
mQJ61qTd1gGsvgVAfnrDX8CX7+9Ts8NBfTvY5B7FjfWvplk+HkFbwZCBiSMAbP5f
G0zl6XLVe2odkDeeMhg+YC8xQS5uqkTlb1189CqmbaHx3tTTRO74p+3MQA8rEAKZ
r7vhJ5J4Kvp2KEJesHT0vRCNJWza17pOzfZ6pkW+Y06wOS1Xfp5UZaoFja4agSWQ
0hiXydKjKXDEb1pLxoTUuUyug3xGFaaeUT+grQIYyiDaqPyaAnw=
=+BRt
-----END PGP SIGNATURE-----

--wKTlTxfx0Fr6BT7S--
