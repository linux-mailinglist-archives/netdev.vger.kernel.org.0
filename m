Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907A522BDEC
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 08:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgGXGH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 02:07:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35594 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGXGH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 02:07:27 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595570845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i3UqHhhND85wx1Y7ueYU05hWXc1LpKz+O9Nq2V2qPGs=;
        b=arxCywgCVY04h7n5VbiRyF0LPejvcq37AwOHNEOoAZaqnjvEP2iMaTW4Y7sEGMDNlFpsZn
        zqBkGx2wS9jxgAH81hDAfScoj0DxdzqbQ668J2zQ+ca6q1cIHMCAb+p88NdumrYA3FXw13
        e+NNeiDXOdH0sNwvdK5gp/3pBzV5FJspUl9mRQGCP/CSvR0JUfiVndK1n3iekwD9w2dF3d
        UAhOwPmJhFMuOzHLIkKChK+LPZlQmFEiGgT3QZJMMcGVOYaZnetAMZ0rKf/b7hNiy6ZaJX
        Rek5wvfr7iGqIw2Jii4HxnRfGRGNDnuthkGKnDR5kBE1Ef9svGgkfG3GL/fTDg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595570845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i3UqHhhND85wx1Y7ueYU05hWXc1LpKz+O9Nq2V2qPGs=;
        b=r/6DGqd2NiZrM+ZHEBJlh8iG0Yw4a2kvFFzVgQeZyoIFJuv6g6BAmbk10JdqhWd9gDf6l4
        1nO/dFRzWcMeJWCw==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 2/2] net: dsa: mv88e6xxx: Use generic ptp header parsing function
In-Reply-To: <20200723171150.GC2975@hoboy>
References: <20200723074946.14253-1-kurt@linutronix.de> <20200723074946.14253-3-kurt@linutronix.de> <20200723171150.GC2975@hoboy>
Date:   Fri, 24 Jul 2020 08:07:25 +0200
Message-ID: <87tuxx30pu.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Thu Jul 23 2020, Richard Cochran wrote:
> On Thu, Jul 23, 2020 at 09:49:46AM +0200, Kurt Kanzenbach wrote:
>> @@ -26,6 +26,7 @@ config NET_DSA_MV88E6XXX_PTP
>>  	depends on NET_DSA_MV88E6XXX_GLOBAL2
>>  	depends on PTP_1588_CLOCK
>>  	imply NETWORK_PHY_TIMESTAMPING
>> +	select NET_PTP_CLASSIFY
>
> Hm, PTP_1588_CLOCK already selects NET_PTP_CLASSIFY,
>
>   config PTP_1588_CLOCK
> 	tristate "PTP clock support"
> 	depends on NET && POSIX_TIMERS
> 	select PPS
> 	select NET_PTP_CLASSIFY
>
> and so I expect that the 'select' in NET_DSA_MV88E6XXX_PTP isn't
> needed.  What am I missing?

OK, didn't noticed that.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8aep0ACgkQeSpbgcuY
8KafHQ/+Le1awl6MFnceMBbsrf6fElFJfjWvdJd2AwGGmoKe8Xufc6m7laC7MNhs
6ufR9vYLdqECoEfP5Lo8IFIMD6mAPqhMp9Co8xXFuR6mafwl6XcGb3K0qv7kubm8
bIq7Ik0WtlgmH22F7Nof1UOj3JpLiwc/qGsn6ZbEvWWQj2/J1VapzE1EwySIfX2m
HwfHdCyBjf0NYFlfzv0Uy/HdFT0xa/N668eYXNDl2c1hsJWcJ5kKGtGDTpfefmNw
jBjKvT8GDw28v9wHkZZMDhDINNFnHffkJOSo2F9Ryp9pdsS3M0zujMuno+4iQC1h
5GrAVki1nL+ga2PJsTvHFknqBiRM4l7oje0LmRLG3hagWFMn4MdZBLXJacs5vql7
i6Nrl/Ci9XutuXxKnFNNqQ7VXy1LsGwwfNl6lJW41Q7wrN318m1Uj4u5N10S/EPD
zFWXOsdLXeO2vnlV4PxfbcWCoZTAHpgXPWUU3DmwPOBFIdFhT6akfrDNtTpfaUfv
Y+PLoM2lAdyR5JMiIL0KlJSyIDb85RGorRFTlUvKowACCjbFMS5f3mQt4T7N+rVj
S7nIk1El24qvcQbKmgq2kH2CJ4EFLRL/LSgwARb48gQ7A+deqQbDS4nWykDE1raX
8dc/I7+7JCUuz7Pp/UW1HwJ11YZd/LFLKNkD+39IZipkZ7ITd7A=
=Y5KK
-----END PGP SIGNATURE-----
--=-=-=--
