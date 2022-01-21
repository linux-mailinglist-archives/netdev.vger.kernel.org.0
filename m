Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463B6495E1D
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 12:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350157AbiAULFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 06:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344558AbiAULFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 06:05:30 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0F8C061574;
        Fri, 21 Jan 2022 03:05:29 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1642763125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KLRb5xJzxFHLcKrBvp3pfZFjXpfTPsBPVrCH8A4ssKQ=;
        b=WMIAymUVUlW+QGDaJKyPk7zXwOg4W9DCQaubrp3qkApyAy4Ib1qKwE3RPxEsuXORfVqR1A
        VmMli3PG4MeMlC6JA82dL9dpb92TVEPFmnIiSEpxaKxZUdBmBPjr76MYHzn5JwXRn9iJ52
        80cTeLfuhGMWbZBu/n3JqaFuPq9VCVfQIXrh2939eKn9eMQjGaxFhUmLfVLFxYQJfT6AsX
        Wzkt0ELvfmAZDb/J8zEHGWmT76sOfsmuBn7FfSZjVw32QupBQvc3nWigmySKZ98YFerzNr
        mlqbeL0k+J6e9VlVzE88CN30syYVkZSrsbbO4DBKQJy+ZO+dx237bY3/ban6/Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1642763125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KLRb5xJzxFHLcKrBvp3pfZFjXpfTPsBPVrCH8A4ssKQ=;
        b=hai56KVHQp0sdmHQ3qGVI7hz0hOa0XMbxW4Id/UYxjFq/w+zx4lUl1WJRPGKX3slCqsB+G
        /BlZSGOSzG1s0ODA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
In-Reply-To: <20220120164832.xdebp5vykib6h6dp@skbuf>
References: <20220103232555.19791-4-richardcochran@gmail.com>
 <20220120164832.xdebp5vykib6h6dp@skbuf>
Date:   Fri, 21 Jan 2022 12:05:22 +0100
Message-ID: <878rv9nybx.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Jan 20 2022, Vladimir Oltean wrote:
> Hi Richard,
>
> On Mon, Jan 03, 2022 at 03:25:54PM -0800, Richard Cochran wrote:
>> Make the sysfs knob writable, and add checks in the ioctl and time
>> stamping paths to respect the currently selected time stamping layer.
>>=20
>> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
>> ---
>
> Could we think of a more flexible solution? Your proposal would not
> allow a packet to have multiple hwtstamps, and maybe that would be
> interesting for some use cases (hardware testing, mostly).

One use case i can think of for having multiple hwtimestamps per packet
is crosstimestamping. Some devices such as hellcreek have multiple PHCs
and allow generation of such crosstimestamps.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmHqk3ITHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgj2KD/9xKPSjG5Meu41W5JxlbxJLt1P33xMi
rmjhsYUDUpzWRCZIJchOiuPuCQ1a3EmYyRrPiGkpRXbdSL93+YE/05/G+3Cmz9Tc
EFJ23F74NfdEP+ubg8l8X0qtO9ePielMkevfD/gSsbutQvZGWQbA6U8efhAnN5D7
Cf6edCE7YTDnrE+aiDKJz1JImn1KRFs/+Wd92+a6my0Kdln4yNWYTGqZvLqkEIns
mPwlXzz/kVsYv4KgkPjbBtzbdBgEEZ34w2YHt02Euft0Gvo+6kPppjMOmhyTxt0F
pIv1u0NQUUVNpL4d0ns5qCjJXR1z1Htzm9qMzWZAcVdd++ndiqDJPZEHTXfHcvfp
NGCL4ZGzLHK8XHAOA6/VCB5F5//Il1riFZgDGt0reXyGin0m/Vo+IDctbHzCHRcL
kF4DiFenXcm2WtJT5onROZahheBf6WXS5x50B/ELRaFlsM5M/3hDAfCUImyPGoXu
AIcHsmLRr/e7kRbhzlOqeKZ9EQKkwxZiCm22fSJMaE1MO6bIP0NpCeMIs62lF1p7
MspFfQVYNSmT4R5r0d32LSCyfGnTf2vqNIXzYrupaYwY07PsgmWFomgtdyJ5/zr1
kmVcpVPFkxKrWOncDRsCHyxgaMb3sPsS4v8NGIihyCK4APqJXwMDBvg1SU4zIibx
pssz8CYN6Hm10w==
=CBRU
-----END PGP SIGNATURE-----
--=-=-=--
