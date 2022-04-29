Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17976514669
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 12:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357290AbiD2KTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 06:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357291AbiD2KTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 06:19:04 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD014BB93
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 03:15:43 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651227341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zVznKpzHajBTKBk7sBq2rEPxOXycGpl/maeVjIM3uWw=;
        b=POF/WKIukCXntGnS40RxZEw5si9f+sEJgb3OK83kc9TbEfnkKCmoqffdicqKJavhuC27fc
        O2ObZIyb8dhkWpgTaiM+eXDZ6B5HfF6606NiOHmxiTIdW12G/vnvZrPQ3XF8SvRT4mRiwp
        E+80zr8C74j7GpTEuKbBxEHDf1+u/KeiR9nTHaUox20cbqtRWvOGT0RQtNQ0ED8Gfdtm4O
        Umkg0fwYjlL5kEgDASSQat4xRN4kYOgczCekNyiHEkA3ZermvRJVgU+10xguBKjije+WoT
        sVT2Z7kZij4oDvVJygKHE2II7PnaUkeZlhVTuoDgMt/uCPURHMCw6iZVPvgjfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651227341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zVznKpzHajBTKBk7sBq2rEPxOXycGpl/maeVjIM3uWw=;
        b=hmWMMrF2TBCbVTYu9eUAd717o0taIeqj9i5LAHgC7BYJMk1EcEAr7w9iM4v5l3zqHIdDtP
        nzSHfjtowLgIrUDw==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
In-Reply-To: <20220429093845.tyzwcwppsgbjbw2s@skbuf>
References: <20220428204839.1720129-1-vladimir.oltean@nxp.com>
 <87v8usiemh.fsf@kurt> <20220429093845.tyzwcwppsgbjbw2s@skbuf>
Date:   Fri, 29 Apr 2022 12:15:39 +0200
Message-ID: <87h76ci4ac.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri Apr 29 2022, Vladimir Oltean wrote:
> Hi Kurt,
>
> Thanks for reviewing.
>
> On Fri, Apr 29, 2022 at 08:32:22AM +0200, Kurt Kanzenbach wrote:
>> Hi Vladimir,
>>=20
>> On Thu Apr 28 2022, Vladimir Oltean wrote:
>> > The Felix VSC9959 switch in NXP LS1028A supports the tc-gate action
>> > which enforced time-based access control per stream. A stream as seen =
by
>> > this switch is identified by {MAC DA, VID}.
>> >
>> > We use the standard forwarding selftest topology with 2 host interfaces
>> > and 2 switch interfaces. The host ports must require timestamping non-=
IP
>> > packets and supporting tc-etf offload, for isochron to work. The
>> > isochron program monitors network sync status (ptp4l, phc2sys) and
>> > deterministically transmits packets to the switch such that the tc-gate
>> > action either (a) always accepts them based on its schedule, or
>> > (b) always drops them.
>> >
>> > I tried to keep as much of the logic that isn't specific to the NXP
>> > LS1028A in a new tsn_lib.sh, for future reuse. This covers
>> > synchronization using ptp4l and phc2sys, and isochron.
>>=20
>> For running this selftest `isochron` tool is required. That's neither
>> packaged on Linux distributions or available in the kernel source. I
>> guess, it has to be built from your Github account/repository?
>
> This is slightly inconvenient, yes. But for this selftest in particular,
> a more specialized setup is required anyway, as it only runs on an NXP
> LS1028A based board. So I guess it's only the smaller of several
> inconveniences?

The thing is, you already moved common parts to a library. So, future
TSN selftests for other devices, switches, NIC(s) may come around and reuse
isochron.

>
> A few years ago when I decided to work on isochron, I searched for an
> application for detailed network latency testing and I couldn't find
> one. I don't think the situation has improved a lot since then.

It didn't :/.

> If isochron is useful for a larger audience, I can look into what I
> can do about distribution. It's license-compatible with the kernel,
> but it's a large-ish program to just toss into
> tools/testing/selftests/, plus I still commit rather frequently to it,
> and I'd probably annoy the crap out of everyone if I move its
> development to netdev@vger.kernel.org.

I agree. Nevertheless, having a standardized tool for this kind latency
testing would be nice. For instance, cyclictest is also not part of the
kernel, but packaged for all major Linux distributions.

>> > +# Tunables
>> > +UTC_TAI_OFFSET=3D37
>>=20
>> Why do you need the UTC to TAI offset? isochron could just use CLOCK_TAI
>> as clockid for the task scheduling.
>
> isochron indeed works in CLOCK_TAI (this is done so that all timestamps
> are chronologically ordered when everything is synchronized).
>
> However, not all the input it has to work with is in CLOCK_TAI. For
> example, software PTP timestamps are collected by the kernel using
> __net_timestamp() -> ktime_get_real(), and that is in CLOCK_REALTIME
> domain. So user space converts the CLOCK_REALTIME timestamps to
> CLOCK_TAI by factoring in the UTC-to-TAI offset.
>
> I am not in love with specifying this offset via a tunable script value
> either. The isochron program has the ability to detect the kernel's TAI
> offset and run with that, but sadly, phc2sys in non-automatic mode wants
> the "-O" argument to be supplied externally. So regardless, I have to
> come up with an offset to give to phc2sys which it will apply when
> disciplining the PHC. So I figured why not just supply 37, the current
> value.

OK, makes sense. I just wondering whether there's a better solution to
specifying that 37.

>> > +	isochron rcv \
>> > +		--interface ${if_name} \
>> > +		--sched-priority 98 \
>> > +		--sched-rr \
>>=20
>> Why SCHED_RR?
>
> Because it's not SCHED_OTHER? Why not SCHED_RR?

I was more thinking of SCHED_FIFO. RR performs round robin with a fixed
time slice (100ms). Is that what you want?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmJrussTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgs5+EACR1b0NIEK9B3RIzvWPc9xWYxYFgn44
Q/TbU5i4gNqQbOZpaVxcGVPNb3y8x65lAUaKyHX5m3eU/Ulfba2zstpoZt2fakzB
DgtoYtGvr2unsPHapeGQASw8+ULzqFSTHLNsOv8nEFPDhdUxNzsj2wQrD+LIXUyX
Zfmwz9psc3nbqNEgpp+TOeqPSluMVjg/7QyCyqF38vB95GqMV0Bcg4O1cl4r1kyE
hu/UNgejRf92fpBiGJQeqm40bpOtMQoB4HWf5FfQafRk/83HP47+i/Q5mQPpXMQg
84BEcPr1+SgzOj6Gk+FFHML56OdPoQ5oK8alImJQfNK1eT/DGBCYJO4HW/AfX2K5
1uy8IFb2fd/XZJeNTfOKPU9GqCgCdmZRDMoqUGzyOeegApZJz4hByh366zZcmQzp
k3j03AdM0Ta/UVKs/v1ly7u9Kjd5RlHMAt534O/zN3ZwvPKLW8KQn9HmF2caeIXl
wvwrMqK+j6gFRMKtKXzejbL4awh5w026vZM3nuy8XYoCKKxAcOIfCNjsjByztzdw
O6Rtee7qIGS4ukpva5SugsxB1Da0RdzMPxxngmlUgKoEynr3gQnVZ1l9xl4fdN58
Nw+I8luF22rc5rlDMfMRFMXVxqhafXh2Blw0xwmm+IKNdd5dXG6OfG14TyGNCiMz
GuSAIj0BueWAfw==
=+tbx
-----END PGP SIGNATURE-----
--=-=-=--
