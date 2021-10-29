Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B8843FC98
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhJ2Mso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbhJ2Msm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 08:48:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF31C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 05:46:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mgRGs-0004zm-FR; Fri, 29 Oct 2021 14:46:10 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-e533-710f-3fbf-10c2.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:e533:710f:3fbf:10c2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8BE4F6A0A18;
        Fri, 29 Oct 2021 12:46:09 +0000 (UTC)
Date:   Fri, 29 Oct 2021 14:46:08 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] can: netlink: report the CAN controller mode
 supported flags
Message-ID: <20211029124608.u7zbprvojifjpa7j@pengutronix.de>
References: <20211026121651.1814251-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mhl3n4o3vpb4z6wa"
Content-Disposition: inline
In-Reply-To: <20211026121651.1814251-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mhl3n4o3vpb4z6wa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.10.2021 21:16:51, Vincent Mailhol wrote:
> Because you already added the series to the testing branch of
> linux-can-next, I am only resending the last patch. Please let me know
> if you prefer me to resend the full series.

I'll include the other patches in my next pull request, no need to
repost them.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mhl3n4o3vpb4z6wa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF77Q4ACgkQqclaivrt
76k86Af9GW+WjXtpH9EV90A3ST+Iw1ADs+bMNcy7Nvc+gru4FeH9UUXjeCeHTj6L
RzrlzGa1XI49a3Bskya+ACiSZHAjEi+bqpCy2wOQb6suMMc74Syxt+l60Wn2ZK1J
6zILDS62mNFBqxonwCBLgLZKPAtcZbx2xLylw1tc0tliSaYqG+BmkQUYCMV9dD0q
zxZK/+g02VVWVqoTyRwbuQ7AOZa7VI5p+OZZROkeW6CFkp6fGZm1XHZPzTnYv0oG
otBJ2re4zSPuADjTC0Oup/WdgmlqQ+c1DqKkQ0jOv3C+kz5bLNntEqHSYtFPvk2A
vz0zIBrJX+07QhM4tTnBi7mpTfYy+w==
=hTMi
-----END PGP SIGNATURE-----

--mhl3n4o3vpb4z6wa--
