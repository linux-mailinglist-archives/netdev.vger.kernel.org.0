Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F1F2ECAE6
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 08:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbhAGHVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 02:21:13 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41892 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbhAGHVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 02:21:12 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610004030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vNRhTOy8vmR7v1GX8zAuyJROMeXWSYY/BOB1XonfImQ=;
        b=Qt6skmY8WjX0mXwWlGbEs489joXmaZQnNIf1W47KGMJq1WQxzcaq67mtmnldxkqIWjHyjZ
        IeFu1lOyv+NtwjDOlQTRbB13D1Us2KjuhFWF5VlNwo5GjdAlcWzjZP9zRTAnem/aSqrwD6
        sH7W9Jyb3iz28QGnG0LmzSjxB1ZoZSb3O48sFAg2ucfYIu7zfE1Hw/IBivg9piktO+oIHB
        Gq7CG/c4fdHiNCHOW9h/7YyBz/UWW53XpwZhkJCn6fDXLrpV8xcIbwU2P+4GvYjClfgN8Y
        n1wZpEg2ojnNGdasdBJbnIkUGt0vd5pbiOrORaLEgegBnIW7bhRZ3CgpemlOsw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610004030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vNRhTOy8vmR7v1GX8zAuyJROMeXWSYY/BOB1XonfImQ=;
        b=sf7TSXnRR1xRogjhbhWbPFszIec1AdWCrJ9ND0FFVu+9lgnOEIRLyJ7L4jfozOhNcjSYbc
        BSN7vP2X7VHvxDDg==
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: dsa: fix led_classdev build errors
In-Reply-To: <20210106021815.31796-1-rdunlap@infradead.org>
References: <20210106021815.31796-1-rdunlap@infradead.org>
Date:   Thu, 07 Jan 2021 08:20:29 +0100
Message-ID: <87eeixw6v6.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Jan 05 2021, Randy Dunlap wrote:
> Fix build errors when LEDS_CLASS=m and NET_DSA_HIRSCHMANN_HELLCREEK=y.
> This limits the latter to =m when LEDS_CLASS=m.
>
> microblaze-linux-ld: drivers/net/dsa/hirschmann/hellcreek_ptp.o: in function `hellcreek_ptp_setup':
> (.text+0xf80): undefined reference to `led_classdev_register_ext'
> microblaze-linux-ld: (.text+0xf94): undefined reference to `led_classdev_register_ext'
> microblaze-linux-ld: drivers/net/dsa/hirschmann/hellcreek_ptp.o: in function `hellcreek_ptp_free':
> (.text+0x1018): undefined reference to `led_classdev_unregister'
> microblaze-linux-ld: (.text+0x1024): undefined reference to `led_classdev_unregister'
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: lore.kernel.org/r/202101060655.iUvMJqS2-lkp@intel.com
> Cc: Kurt Kanzenbach <kurt@linutronix.de>
> Cc: netdev@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>

Fixes: 7d9ee2e8ff15 ("net: dsa: hellcreek: Add PTP status LEDs")
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl/2tj0ACgkQeSpbgcuY
8KblaA//QjU9XsxK9jcAIaljLq1gvl4dFlPEKfTXK7EqERQj49A+skHkRYO9BDR3
ijPMgm6wt2cmMXWPx4tApaf+iwEps+ZRTuZ6AU5EKyGB/+FhYif5c9jmCI2FZ4OG
YlI04Ic+AV4JwuO8Ta95yepyqmkFtUcc9F0FKKzi8Z1uJRXcMq1B3IQUOZm8UsMN
YXdNMLFYHYVjFdFqnXG9SQmboCecD4VJ5qOlucYu3YdQtgoGkjsrqCe7Jhw/Ye16
B8YZlxDiqKA/AHbMg/LpQulri1WiDjec/7GrAbLF0aa4mizGLag2kURcz39dL7wN
/AGRyzTwS4obtpuVcjOUB6z4J4vbhi0GhebhPo40RNhVeiMwwMvyXdlBgQn14Qpr
GAgvNRzffRDa2V2CBwODqs/4WFPZJjs63PXpnz6fDjFhoXMnjsU3hDIDHiwHIxah
2Rzw1ZJoDkujSKJQpasG6HTXmFSa1xgUyoK2arONDaXwg+iwQLSdqkRMudp9x467
pmlQ53T/6a6TFRbkyYBqnf1vHt3mteucKJpG/N4R+03yFS7+PWJHhBIQc0yVIEP9
K/rImGFsSBxo8ybfw9XWvN24NA1DGcuVUvrtwp95YE60mjqH2k/5LhQfElP4xmJ0
U5cEb64fVzzP+0/QiPdrxQyTsz4x1KmieFYgvli5w7SPPVad0e0=
=I9yy
-----END PGP SIGNATURE-----
--=-=-=--
