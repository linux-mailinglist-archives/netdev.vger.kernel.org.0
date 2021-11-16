Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67660452FBA
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 12:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhKPLGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 06:06:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51746 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbhKPLFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 06:05:30 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637060552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e10OOvD1u94xS1GIboSwL6Wuc+WCr9I2DZUFe4rpbtc=;
        b=FMvhaX4kB8DiRB3Y0+aRBO2m9ILwQaDzzDjIuuSP7ybiynoiE7y+6vlCC0ffCgB5whAKqe
        wji6zoUFSUOj7qtaa9jJO92IX6CGn+HzUND7MvTYKf6XXyNbgGmASYzWdxLBsVSwDrFbPE
        ExWt2gPdx9ads9cBqdWycGs8i4a9e4+EPfZXsHfAkll8oDNqcxB3X9Alz3AOBI8aFDgRyV
        g6W5S0uSIV5eq3mIgLYLAfR1J9MSXb66VHr4dXtSWLPCQTWdPF08FhwgCkgQwKLr8zFwON
        EV4gBz5D+so8mPYqvkD6Xs4bXDulCIvYPWbdfNNVtn9OA9BCfTGUBG15/DLnGw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637060552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e10OOvD1u94xS1GIboSwL6Wuc+WCr9I2DZUFe4rpbtc=;
        b=xrfnTvU+0HOOavO+mLbWCo6RkmxZo0uconkWrKQSXfBhww+JwGZuCctDNbyFBwDbkOsNpE
        QDV03R1dWmSrL9BQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: RFC: PTP Boundary Clock over UDPv4/UDPv6 on Linux bridge
In-Reply-To: <20211116102138.26vkpeh23el6akya@skbuf>
References: <871r3gbdxv.fsf@kurt> <20211116102138.26vkpeh23el6akya@skbuf>
Date:   Tue, 16 Nov 2021 12:02:31 +0100
Message-ID: <87y25o9xdk.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Nov 16 2021, Vladimir Oltean wrote:
> This should do the trick as well?
>
> /sbin/ebtables --table broute --append BROUTING --protocol 0x88F7 --jump DROP
>
> /sbin/ebtables --table broute --append BROUTING --protocol 0x0800 --ip-protocol udp --ip-destination-port 320 --jump DROP
> /sbin/ebtables --table broute --append BROUTING --protocol 0x0800 --ip-protocol udp --ip-destination-port 319 --jump DROP
>
> /sbin/ebtables --table broute --append BROUTING --protocol 0x86DD --ip6-protocol udp --ip6-destination-port 320 --jump DROP
> /sbin/ebtables --table broute --append BROUTING --protocol 0x86DD --ip6-protocol udp --ip6-destination-port 319 --jump DROP

After quick test, indeed it does. Thanks, problem solved.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGTj8cTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpgo2D/9ijxk4btdfvAuyAOy2VgeGlA78Ly1D
CKC8U6MlRW56YdY1u92mwKzJS7o2Bef3I8Lb2Axemg6WGpzIG7fMMlVd+Dfa39/v
957Z+XcwD50JsfARhDwQkpx841UN0N5QjFL2eHTIpZ1iIGv6++6rQcYv72jxUHpC
MopX8ahmqP6LkFMmoIc7oSCJJTGhjMCNGzbuBoRHddxYh+alT/v9EyZyx6WflCWT
w3wt2u8fVyIDty+SwD0Ktyvi9X9tbOY3yFjPU40KrXdvtUGnqFTT1IHQ5Kch7v8Z
mdydY23AkKcdT02GHiV+IylaAsUx2UUVSGbgLoWu8bXoxY92xDvjeFiGhdPcLbnV
RiMjeQdZ5AAdxaFDdLP45OHqhmnDNydp3gnRQizbNRdNgVuvy7JL4I2gnOYl0zuM
e/ZEWL0dyoaoTOwN/L87phQtykopion5VVyj8z0RZN/x0zxjiUS3Vnud3/Os34+9
J/ohMiiF0DJmWj+xtufuaCvz2EgvIDPiRYIm5oY+IMyM2gGkhpbauNKStQGFuP7x
tc5J/LHdcxatVxV8THPFzuM5dWS1U/pn/TCgDqmtVk6Fb0lJhn7bMVhf0jYJei/R
Vv0bHlVAj0XfQeu0xEnjHIczx2AnnI4UEa4txKxkWFnk8CuL4mahXdiUoN5sVhn/
e3xs4ArAMUKVUQ==
=hk+a
-----END PGP SIGNATURE-----
--=-=-=--
