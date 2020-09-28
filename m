Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E9E27A70B
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 07:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgI1FqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 01:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgI1FqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 01:46:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED842C0613CE;
        Sun, 27 Sep 2020 22:46:05 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601271964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A9eaFRIMoE0WeEdJ53JqY4q9jI4yipgGb6l9S8GlcS8=;
        b=sIzs58AzruwgZUJMijBXyQC/4ZH238GgkcpBckJJWD6o1GrwtQSrQPbkHcXRbbfp0sdu7B
        G9MsnpKS7UV/8487vce5FIxPpKZjlCnBlJFwHRPCdToHamRpneaT0YvgCk5tHwo5uh8Yl6
        PIbkwtxJsyZAUj2haTHmGteiTtzzjkrdbZq6h6q5ENzbbTlHrdTvY3wSLdBpnhKxQ8bjRP
        OW4ZbfAykuJCIN+yOIaq7N7n6jP8mUuVUOBiPYpddvVvsZuhGe2uEKcqYqbQyiCGcBweDc
        aE7h7+BNIVeRpa0SX02TvFt0T1HqBJWhc4oOWfG7DHcZIYL+by5qpXDWfbeGzg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601271964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A9eaFRIMoE0WeEdJ53JqY4q9jI4yipgGb6l9S8GlcS8=;
        b=FrCw4YN0pav3h7gyurYCoA/ypC/kzr8cyiwJyWn6dx6eJnXdZdZcmj1PqQGEPofsI75yQU
        LMVGTugUcj+4lWCA==
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] ptp: add stub function for ptp_get_msgtype()
In-Reply-To: <20200927080150.8479-1-yangbo.lu@nxp.com>
References: <20200927080150.8479-1-yangbo.lu@nxp.com>
Date:   Mon, 28 Sep 2020 07:46:03 +0200
Message-ID: <87imbya1yc.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sun Sep 27 2020, Yangbo Lu wrote:
> Added the missing stub function for ptp_get_msgtype().
>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: 036c508ba95e ("ptp: Add generic ptp message type function")
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Oh, my bad. Thanks for fixing it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9xeJsACgkQeSpbgcuY
8KZ2Sg/9HYtK+8W/h5Z24wmmt2IpN9XXT22eXxDiis6aE2fHYwTAP1/JIuLftsba
zQ+QvrOTxJ0BHhU2ysOjVECTyImRzbAm+b1ZjAM2RU7L/YBzarjhwXE4uYQgtmUc
cMLkDphhR6s+/mTQH9VBupbsXCLyvgJcNg2oNZXNtGqNwENqI2IzoH4tVTHyW5ep
EmDR/hX0GIHa+2tAGgM9XKQTprshvbP0HkwoBAxVTN5DEf10gfKQ6+xkHJ9fKQFm
kA1SWfTDttdOlzO3xYWzB4uPAbqRK1mAkpD045C/ktFv8ST7UECkljOElv6pJoP3
W8ac5Erd4AkwqILVSrwwaoA6AR4lpSv+df+c0ig9rMmAVknG3K3kAdBn3MAAG0GR
tYCEnk/Td2/7CItOcAuPNGtirwdRm0WyKaHtUbagQ1SNGf8gGzZVb8wdy6MDe7GQ
YrUd3t858zapqdNuvUy+0s/fgEToP/rXmKr0nsiyY+D+hmR5HIdJKPIZ06nBs+3K
5VTU6QOnnOLPkKRYrVSFnz43icY80X1kZU2WW/8X0MrPwjGUo/6GuKqzyZUuBhVl
mOV7gsbQvwVyo1RISXmwDwQ9xK4mv5A/6g9SUv9MQW8Q5qZpQIzagWAPIv6UT/Fw
1fP3aLYMLFS1SBzpR9pLm8yiejJwJeHNEijCsC/3H6Y+DNSgS2M=
=Zj3V
-----END PGP SIGNATURE-----
--=-=-=--
