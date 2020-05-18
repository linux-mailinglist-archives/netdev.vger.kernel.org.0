Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357551D73FC
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgERJ0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:26:09 -0400
Received: from www.zeus03.de ([194.117.254.33]:58850 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgERJ0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 05:26:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=A/gIwIbzzT3voFbwbkkGYk2914xt
        750bCNgjeYYwG4U=; b=DCLJDuGd6Lj3/JoYClXSkMfsnu44ooFH2veTmmfv58wE
        Si1yB4o9j576NoXHeOMDvheD6Dr1yNYrnlSL+R3Lmh3UeMWIMMFRo5bEnSwsXfXg
        WqcDVFPiSnoAfAzBzHAPQPIt0iYnusl46GnymUdlLqyVApFvd3skUS+/Johvh5E=
Received: (qmail 947633 invoked from network); 18 May 2020 11:26:05 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 18 May 2020 11:26:05 +0200
X-UD-Smtp-Session: l3s3148p1@WxWOwOilRKEgAwDPXwfCAIWBZdj99x2z
Date:   Mon, 18 May 2020 11:26:01 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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
Message-ID: <20200518092601.GA3268@ninjato>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200515171031.GB19423@ninjato>
 <CA+V-a8t6rPs4s8uMCpBQEAUvwsVn7Cte-vX3z2atWRhy_RFLQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <CA+V-a8t6rPs4s8uMCpBQEAUvwsVn7Cte-vX3z2atWRhy_RFLQw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > However, both versions (with and without automatic transmission) are
> > described with the same "renesas,iic-r8a7742" compatible. Is it possible
> > to detect the reduced variant at runtime somehow?
> >
> I couldn't find anything the manual that would be useful to detect at run=
time.
>=20
> > My concern is that the peculiarity of this SoC might be forgotten if we
> > describe it like this and ever add "automatic transmissions" somewhen.
> >
> Agreed.

Well, I guess reading from a register which is supposed to not be there
on the modified IP core is too hackish.

Leaves us with a seperate compatible entry for it?


--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7CVKUACgkQFA3kzBSg
KbYDCA//fNp372/9fj/gtObfrZa0TxllW2uISdUH112lOK1XJS+XSvLkHbsTH9Gt
x29LZpIF2R6xhl3wAQsARCEvWQ+ln6mhtYwIR6NBgmH/FrJ64ck0J1TW/MIBBP9/
ljAi8HjzIwg5lS/u8iw7qJQBehFNjk7PMTye7G09CjQTq9VRn2fZoAdlu3jqQci9
0KUneHGduxQA1r7hK2wl5xPH423IyaUGqhXvPSRyzfZu0fUaINAE/LIfstX41YiU
Wj9lcT8gDQeNGwhRPhvokRqv2q9sFJZ4oT3mrpbtKjICEGQxRVqZbSw7XqjE+ntl
Lkgi68z1RFja7drjGHXqRR7P7R+AT2vuD+S411fObxpl81GIhUTHKhcK7GC7fs5N
QrSWGqP+gFSgoU54062r33GLSjH9jNl2xjQlNwafJHzkHisIEH6DYA/3QDf6CdPB
OWqn8VNfeZKf+RTsJ+0pHuq4CLhBLDLLllhx1htpb/h1WUM8j8Y7OM3k1ltoJs4Y
3HOpjHGVBWln/xYbGQwqQbZm/IhEDRIgOvU1IeaHQIXLJSj022gTD8DDEr5DQMd9
hi7sPPL1StfvLKyJPeSTl3pfxumunmztsbFNCKpYpF7B4hbEyOL266sguAUoc+GZ
qD4du02x1/QSMlilqkZaLWYWuExQToKLu/u1TTDVLDzpXr0WNNM=
=+frY
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
