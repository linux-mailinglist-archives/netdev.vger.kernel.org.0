Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A93C22D59F
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 09:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgGYHCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 03:02:22 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42848 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgGYHCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 03:02:22 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595660540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yptN0zJhNFdhUHhD2jECvgn65xMx3wbcq7OuSFx4rjU=;
        b=2K7kJtmmLGvmYTpmyVuz7bL2jOofIR5y/fGzmK4R8PSy28uWwTqnyvdHvGtohSMHBHGwhZ
        DZXJaT2Krmgzx25t/0UsoCiiUq5xh+kxQ8FnSbcE0QC0F+1H5aZuMvNy0n7pAc3mmzEhhn
        l/dZH+ZWCxfEyVxZSfRPJKZnYKpqdGhVg3yFakFiSWdCDyi6edWHth1cxNq2zDKb5sBSab
        XSiMlGg0ZP/WHu67SwVK7cKlfBk/K6/W9qVWoIgA2t5POD/oMgKr/y0TsQhGxrA/BRSUE6
        3/EFdbZ+H80QIn3/T8SRb5/wpbpbYfO8YmjQ99RjxG38pxGFoDp9axBpriBK5g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595660540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yptN0zJhNFdhUHhD2jECvgn65xMx3wbcq7OuSFx4rjU=;
        b=UPsPbCdncT3P1Wi6JosR1rKAtIpdSMnh5r+svRWT2YwL42Wr7zHANOH0gOUsL4Y0ZSVjVI
        CCLGDu4zc6pQKfBw==
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, bigeasy@linutronix.de,
        richardcochran@gmail.com, kamil.alkhouri@hs-offenburg.de,
        ilias.apalodimas@linaro.org, olteanv@gmail.com
Subject: Re: [PATCH v2 0/8] Hirschmann Hellcreek DSA driver
In-Reply-To: <20200724.164725.2267540815357576064.davem@davemloft.net>
References: <20200723081714.16005-1-kurt@linutronix.de> <20200723093339.7f2b6e27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <87wo2t30v9.fsf@kurt> <20200724.164725.2267540815357576064.davem@davemloft.net>
Date:   Sat, 25 Jul 2020 09:02:06 +0200
Message-ID: <874kpwnklt.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Fri Jul 24 2020, David Miller wrote:
> Please never submit patches for serious review when the dependencies
> haven't landed in the target tree yet.
>
> That makes so much wasted work for us and other reviewers.
>
> Thank you.
>

OK, noted. Sorry for that.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8b2O4ACgkQeSpbgcuY
8KaAhA//Wn4wX46BAVF2a89qkj1k2ZaLFufJK5UBWA2TOCp2AocQVMlaNRppGBIH
HAlTgaHUziXziB+w2OnMk+O3EOUrGUTmPovLpJFqi8Vrk9TQRYU0s2HOiVx7n8F9
XHK5gTvJbMmMtcDsuhk3sISjBaGt4OvAPwktb66jf/27Q7d5AAvz5W9pvcf+Pf/O
SjZjCbZ6XjDoMXQYykLppYed4Tc2cWqcs5x+DUUpuSxqu2bwPH4BDN+a+u3v+7x7
fsEgHXnCtd07fYA8OrNPi7tS2LBOwbeLgRO1kGloxfKGTsU+lVQPSBIikiabFhtD
6uluKZ2NLWRMf7pASGy+PRHCM0HSttYY8LtrtHVDT9PhT+mMzhG503+tusjGX23Q
MoZaYZWx84yBaTz1UDMFCZW1mSDiqf/RNOjhQotlNwB1lfzi8Oa8zV6TMXzevHU7
1x8vtqPxxiqdmKGS8gpaOJ3WQvq8fddRqqbEOLJZxRPCIsoiII0aSiMA9N4mUqAq
zVvq0wujA2PPqvMoVrqWepBR1r4D9rbkyOjcSKIyIamXLHnYSvyV4rPiuTHoCc3+
1OXdrI9vbtrmqnsKuEMXYSmYoqQVM7Z211dnM/g6lOl0mimm/x5KGmLZv+GJDcsc
ur5zIkzTOqnlr2lhj6i59HDWr4812GVIG6Oaq+kcp7Z2eTGhTJQ=
=Ncmj
-----END PGP SIGNATURE-----
--=-=-=--
