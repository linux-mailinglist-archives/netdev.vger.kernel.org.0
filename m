Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D7444AB3C
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 11:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242460AbhKIKN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 05:13:28 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35134 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242349AbhKIKN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 05:13:27 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636452640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1HnMyv5K4HcUpzy/iFVT4s1y0ITpaZ1fAf53D1M5kOE=;
        b=hTWgvmHG1WGd25opox1jFbjusUDzhJdX2pzbhM6v/53NeT3WLbDMbnZ9l0crs5mE6t4S0T
        BdyxwHBXH+LJlrKdgpeRFBkS2xxInElYdHTVNtLaMkFouMfUQIGdzILP+LE0/em4EZFHO+
        bWdOb4rbYVkgAAgAOD4cEnZL/UVvN9X9zdgTgpoCQmBleujDwKde6iGXCWPUZTmZZNMVsU
        36OOhR4XqiNwsWOjDX39pZbTMqliHbNviCR8yYNZC7EUGfjAeHXvmNfee3fAYRXrAoMTsq
        fApspFNyIXNsQzWbw+P3s5yBHahO72oF/sBqrsFHdYEFdM5LFjqThNhNgaZnmQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636452640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1HnMyv5K4HcUpzy/iFVT4s1y0ITpaZ1fAf53D1M5kOE=;
        b=kLzu9YpTEdHgupTsQ2imkiOzok3JS1cAJGd91YBGtT4Mu4pXKaNYsmrgKAk5wPspoBcqxf
        jg+2n6UI/kHUtWCA==
To:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     martin.kaistra@linutronix.de,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/7] net: dsa: b53: Add BroadSync HD register
 definitions
In-Reply-To: <20211109095013.27829-2-martin.kaistra@linutronix.de>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-2-martin.kaistra@linutronix.de>
Date:   Tue, 09 Nov 2021 11:10:39 +0100
Message-ID: <87wnlh1vxc.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Martin,

On Tue Nov 09 2021, Martin Kaistra wrote:
> From: Kurt Kanzenbach <kurt@linutronix.de>
>
> Add register definitions for the BroadSync HD features of
> BCM53128. These will be used to enable PTP support.
>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
> ---
>  drivers/net/dsa/b53/b53_regs.h | 71 ++++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
>
> diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_reg=
s.h
> index b2c539a42154..0deb11a7c9cd 100644
> --- a/drivers/net/dsa/b53/b53_regs.h
> +++ b/drivers/net/dsa/b53/b53_regs.h
> @@ -50,6 +50,12 @@
>  /* Jumbo Frame Registers */
>  #define B53_JUMBO_PAGE			0x40
>=20=20
> +/* BroadSync HD Register Page */
> +#define B53_BROADSYNC_PAGE		0x90
> +
> +/* Traffic Remarking Register Page */
> +#define B53_TRAFFICREMARKING_PAGE	0x91

That's not used anywhere and could be removed.

Note: The subject prefix for the patches should be net-next to indicate
the tree which you are targeting. See

 https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#how-do-i=
-indicate-which-tree-net-vs-net-next-my-patch-should-be-in

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGKSR8THGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpp5gEACyXXigcK2I/5shm/0JaMHlTR4CXx3i
EnKBUw/by7dBUIoulqQeGU2v/lJOBHZCdCArPCvc3lXdawBZ1oNroFxKwqSHJ3+Q
fs9P3ffneHu3BDrVISS/EVIhXZEqohraJjVnlSyI5RXygGbSkNHkhS1qYYMbjNFm
AkSkhvM0X7PYq3+tKz1F4Fzb+LwOnpRVQ/iqfyFEcANUBUf7Nq6XeCmB8N5gazK2
Hr4haR7LS2SYlLP/LgBphZaqTl7r28hWCZ/Y9PCFe+HdbFYhpKmzwoY1+ZgcIWvg
hl+Yfq8oKB/i0TiGXWhuEem7/xYdqgI5XqcxratZx8eUgW78OgEi6Z+WEyZrMx+Z
7XeWN6eHkd8vH1sMsI15t19HWfMFt2M6nGLrJs5azg47fd7Pw3fouWgE70CxMB9/
1VxyAEfuN5x/A69f+VPpMpDDVMpTuO+U9krGfRUq2Pj3P67mXfB4pLoTLaEc8ze5
jaZMzxQuSYHbY3nEANHWjoeBc63u1uvKle+PMNlKnt/D3vqybcIr3NwYEos4q6NL
hoLQetjgzjSYY01SfI+OL60TK1o6v5oaE50B2mQ118A3RrxWlQkifjePLIgpM/nx
35y3GL5OQTjhnoIQS4bYwota9eIhC5sZ7uNRNJxZwQtgub8ISPx/UPNhy8tKVbj2
40r9n5jEsxmcgg==
=9vvy
-----END PGP SIGNATURE-----
--=-=-=--
