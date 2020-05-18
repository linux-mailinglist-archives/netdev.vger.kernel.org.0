Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519A31D7474
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgERJxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:53:54 -0400
Received: from www.zeus03.de ([194.117.254.33]:42286 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgERJxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 05:53:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=tWy351Cz2/z7fXwTCOyDDiSu6hjr
        980CFFvM0OKGk38=; b=jqk4ArJDRxXqaeJw1Vpf9ulT1kZDMeu4DIzOpjJzCvE2
        wvB9i/7zTdSeP0How3mts5qapHlXWscy6SIEYk78S4lkkLFCB1CahZGvwbdhXQgF
        6Tii5CHShIWLXovOWew7WtvUsyjnotdyeOQp24IWs/WhM1WPJxe49hpDG0y7agA=
Received: (qmail 956985 invoked from network); 18 May 2020 11:53:51 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 18 May 2020 11:53:51 +0200
X-UD-Smtp-Session: l3s3148p1@IRbaI+mlWqEgAwDPXwfCAIWBZdj99x2z
Date:   Mon, 18 May 2020 11:53:50 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 03/17] ARM: dts: r8a7742: Add I2C and IIC support
Message-ID: <20200518095350.GC3268@ninjato>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200515171031.GB19423@ninjato>
 <CA+V-a8t6rPs4s8uMCpBQEAUvwsVn7Cte-vX3z2atWRhy_RFLQw@mail.gmail.com>
 <20200518092601.GA3268@ninjato>
 <CA+V-a8sTm8YEP2Upu1t6tb6YMpaANFRnnLVW=1TXP2LpVMvrNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <CA+V-a8sTm8YEP2Upu1t6tb6YMpaANFRnnLVW=1TXP2LpVMvrNw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Prabhakar,

> > Leaves us with a seperate compatible entry for it?
> >
> Sounds okay to me, how about "renesas,iic-no-dvfs" ? So that this
> could be used on all the SoC's which don't support DVFS.

Well, the feature missing is used for DVFS, but its name is "automatic
transmission". So, I'd rather suggest "-no-auto" as suffix. Also, there
are already quite some IIC variants out there, so plain "iic" won't
catch them all. My suggestion would be "renesas,rcar-gen2-iic-no-auto".

All the best,

   Wolfram


--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7CWy4ACgkQFA3kzBSg
KbY21A/+LnXTyKG+293IxrWXi/gU0QJTwPG+JnavrPQRzBtcR++VcmR14KtLyt+s
5b/feT4np2zYFEoZZiIEe9iF3n0jytbbHfoU9lesoAzcZ2wl3w9hz1CFxuQb8w1z
siHP9wYNG1OIMAU6TP5GNDGCz6MOOXcBGd3+2PfbEyess8uhvYbqnZwS8dVJlQRW
A10GHfrZnH8n1Imj+QES9uFwFZ2ZAc2zEI/j5gVUXRZQOGMKy3McofQUWd4803eX
lTxAUPEytqOzqVGED7P3aP0HpEmG49eXcVZfa/7p5I2kSaT56G99Wl5zgBvdTjYn
pPU+yOV1a1E/O4S3zLIaLQIliOLhoyKCohnYSwWu0J0KqHdsRQHLg8Zh58wadWPu
GA1mTWlacYbLvzEoSKdc5bO7pjvm4BjiENPC/FClf8dlvvpletAQmLy6jcKDGkNL
AUqaoR8+leyj3LZgCh1P4IS5SlpcG3U99SEqT/S05ukXQDA19dowNA4KLiVSk9ir
YqtLlTczGeRALCwe9RVBNVZ/in0V7q5e7vQU1P52/JTqQB7mpnagh9q1tkSDFfHP
aNAfA08qiu3I7zJM6nJIxCr3pOGxguWgDt8gBia0V2cmnuYYnsxVUDrk0GS9dFZ6
DKzDRwrElLhKpxx7b1Y7cFI592Q47s6Jd4ggh9Z+NxWRh12e/9c=
=p+7Y
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
