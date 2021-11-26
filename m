Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6330045E99A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 09:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359687AbhKZIvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 03:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353607AbhKZIth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 03:49:37 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370F1C0613F8;
        Fri, 26 Nov 2021 00:42:37 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637916154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yNh4aCr4IL6K/pgHRZGXhsZ1J1OW0Y2Kyk5lrEgPnrM=;
        b=gX6L7S3bTKfta0vpsxaOAbfOum5vd/4xruYWQyBWJK2gmwKIu5EETQVfKeR7qT/hvYDj+1
        CuIt58t+wzZM6G5myNE9h1jOfodPQCeJWA0OeNzw7nIz6jToE6B3lE7/5EDmOUFl1DRSgk
        bNg6fexN7vao8142BIyX/KhLvdCt+/IoXHOanUUuxQrRQcma+Vn1v8j81GpUM9/tX4GD5o
        moftbqHtdBNG5ZYiABjYqcVmp6oE+nqwxc/3MlusQvd6pwH9vCAkSfpmXfn5/3mMMgMz2W
        1Z2/n1DYLSYv2lTGbdyM3R16wKtRT4cIPUPTEpZWQAXfZM2TVpi2vbOoOTbcUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637916154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yNh4aCr4IL6K/pgHRZGXhsZ1J1OW0Y2Kyk5lrEgPnrM=;
        b=TUqWospzPe3yzo+HssBgt835kk44PqzSRBaQ3Xi0Wm6P6oOSmo6FWY71JsFt3Q27VM6QoM
        J4K22AkMxhiLJ2BA==
To:     Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] net: dsa: b53: Expose PTP timestamping ioctls to
 userspace
In-Reply-To: <20211125170518.socgptqrhrds2vl3@skbuf>
References: <20211104133204.19757-8-martin.kaistra@linutronix.de>
 <20211104174251.GB32548@hoboy.vegasvil.org>
 <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
 <20211105141319.GA16456@hoboy.vegasvil.org>
 <20211105142833.nv56zd5bqrkyjepd@skbuf>
 <20211106001804.GA24062@hoboy.vegasvil.org>
 <20211106003606.qvfkitgyzoutznlw@skbuf>
 <20211107140534.GB18693@hoboy.vegasvil.org>
 <20211107142703.tid4l4onr6y2gxic@skbuf>
 <20211108144824.GD7170@hoboy.vegasvil.org>
 <20211125170518.socgptqrhrds2vl3@skbuf>
Date:   Fri, 26 Nov 2021 09:42:32 +0100
Message-ID: <87r1b3nw93.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Nov 25 2021, Vladimir Oltean wrote:
> On Mon, Nov 08, 2021 at 06:48:24AM -0800, Richard Cochran wrote:
>> On Sun, Nov 07, 2021 at 04:27:03PM +0200, Vladimir Oltean wrote:
>> > On Sun, Nov 07, 2021 at 06:05:34AM -0800, Richard Cochran wrote:
>> > >         switch (cfg.rx_filter) {
>> > >         case HWTSTAMP_FILTER_NONE:
>> > >                 break;
>> > >         case HWTSTAMP_FILTER_ALL:
>> > >         case HWTSTAMP_FILTER_SOME:
>> > >         case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
>> > >         case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
>> > >         case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
>> > >         case HWTSTAMP_FILTER_NTP_ALL:
>> > >         case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
>> > >         case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
>> > >         case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
>> > >         case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
>> > >         case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
>> > >         case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
>> > >         case HWTSTAMP_FILTER_PTP_V2_EVENT:
>> > >         case HWTSTAMP_FILTER_PTP_V2_SYNC:
>> > >         case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
>> > >                 cfg.rx_filter =3D HWTSTAMP_FILTER_PTP_V2_EVENT;
>> > >                 break;
>> > >         default:
>> > >                 mutex_unlock(&ocelot->ptp_lock);
>> > >                 return -ERANGE;
>> > >         }
>> > >=20
>> > > That is essentially an upgrade to HWTSTAMP_FILTER_PTP_V2_EVENT.  The
>> > > change from ALL to HWTSTAMP_FILTER_PTP_V2_EVENT is probably a simple
>> > > oversight, and the driver can be easily fixed.
>> > >=20
>> > > Thanks,
>> > > Richard
>> >=20
>> > It's essentially the same pattern as what Martin is introducing for b5=
3.
>>=20
>> Uh, no it isn't.  The present patch has:
>>=20
>> +       case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
>> +       case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
>> +       case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
>> +       case HWTSTAMP_FILTER_PTP_V2_EVENT:
>> +       case HWTSTAMP_FILTER_PTP_V2_SYNC:
>> +       case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
>> +       case HWTSTAMP_FILTER_ALL:
>> +               config->rx_filter =3D HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
>>=20
>> There is an important difference between
>> HWTSTAMP_FILTER_PTP_V2_L2_EVENT and HWTSTAMP_FILTER_PTP_V2_EVENT
>>=20
>> Notice the "L2" in there.
>
> Richard, when the request is PTP_V2_EVENT and the response is
> PTP_V2_L2_EVENT, is that an upgrade or a downgrade?

It is a downgrade, isn't it?

> PTP_V2_EVENT also includes PTP_V2_L4_EVENT.

Yes, exactly.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGgnfkTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpkjDD/9PrG0P2FpPBYVGVcXKqf0U9DAega6e
gZyBl7ltwQ/7XDM4pMufdWatfpS9NerY/wcR2GYeFA1+Lk8DRn4B58wrUeyZQVhO
s+m2wrVwdympql/NdsDVwTYQmqC/Gq9471hslyi99j5CiEMQAm57P7FZd3PqYKXj
FZjAna815Kc/sg9gZr24ECwMgy598hySaY/pCysrxbSi4kLpUZHRHk/lN7ih88lw
slbLnDblKAYWPSqM2fyfoAVIROXhvdW/njUV/IyEofSdxLLi5ZdXS7RQXl9leg1y
Luu0HG/KRat8+oYQu+R8b+iPe6UVC4WIaUSiyk6QLT0LboCH9EL7lemiBS1Gkt4i
TXfvSSPA6htKnlGOTk7QWGuv5kgtm1gWcqlLvyEj1iBMSD1QcDW7weN4/cyHgO3e
q30nDTidEyPfTAx0qMj3c0J3To5X0dfvQrS4vFuVnWwvINJzJoKDnZ8k4CrWk72R
o9PjPPbJFAN+um7fNP9OqeKzEDbbqp7r8msIQ/HXmfkgndKplCDisJcRxKhxns7N
RDav3lt8v4wjJC0PSSsFdystoWtDVD6k0RzdACAPAMS0rkJof2IBDIhaPz7QnqJh
H9RWQZIexioL0oTRPYmBaB4r0e3F+R/6KJ5ywtMyMpkDRO8nCBWgvnvU1im9hBru
MOcsg6E+duE5QA==
=M6Cd
-----END PGP SIGNATURE-----
--=-=-=--
