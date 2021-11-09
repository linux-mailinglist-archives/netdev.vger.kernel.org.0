Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F8044AFBB
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbhKIOuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:50:15 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36600 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhKIOuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 09:50:15 -0500
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636469247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=my3Sq2GxcHarOIeboyqYV38k/8EAQpknRRdSAQw/6Kw=;
        b=ji9/LLavr/D+jfw74jza0ix0qq6aUgASeiWAPg+yazflUDWV27JC+JqW4bEKVB0t9BDLlo
        niofonePu6XrImbQwHBs/NK10kQERS3Uuh+w+nHf/+84oB94GJv5xITvpXowKxHfjlg6cB
        9jaKCZSJHC2wt7arIHr1tnKP2hsFraJ0PmT2S0QqKQ4iTPRREThtwE/YBHun8GVtYcKDNX
        949j1hniYNTbomqiRNsPUNVp0VV55sFrklYvZshbyFybJiEM+UvwUgX9GNwqpeKJMZcxn0
        jrokGIBGih6/utL1+5CIa+qoq8W/aa36hyq9FVtQ5DnRcTIZt7UableCr9DpjQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636469247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=my3Sq2GxcHarOIeboyqYV38k/8EAQpknRRdSAQw/6Kw=;
        b=tD9K8m1grP4/5SkjocmDU3Mxa18F5p2rDhaWae87sQBGW0aSy5pjiHgEt060gOJfBXY4iL
        lZQeSGGa18P7L5CA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net] net: stmmac: allow a tc-taprio base-time of zero
In-Reply-To: <20211109103504.ahl2djymnevsbhoj@skbuf>
References: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
 <87bl2t3fkq.fsf@kurt> <20211109103504.ahl2djymnevsbhoj@skbuf>
Date:   Tue, 09 Nov 2021 15:47:26 +0100
Message-ID: <87h7cl1j41.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue Nov 09 2021, Vladimir Oltean wrote:
> On Tue, Nov 09, 2021 at 09:20:53AM +0100, Kurt Kanzenbach wrote:
>> Hi Vladimir,
>>=20
>> On Mon Nov 08 2021, Vladimir Oltean wrote:
>> > Commit fe28c53ed71d ("net: stmmac: fix taprio configuration when
>> > base_time is in the past") allowed some base time values in the past,
>> > but apparently not all, the base-time value of 0 (Jan 1st 1970) is sti=
ll
>> > explicitly denied by the driver.
>> >
>> > Remove the bogus check.
>> >
>> > Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler=
 API")
>> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>=20
>> I've experienced the same problem and wanted to send a patch for
>> it. Thanks!
>>=20
>> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
>
> Cool. So you had that patch queued up? What other stmmac patches do you
> have queued up? :).

I'm experiencing some problems with XDP using this driver. We're
currently investigating.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJSBAEBCgA8FiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGKif4eHGt1cnQua2Fu
emVuYmFjaEBsaW51dHJvbml4LmRlAAoJEHkqW4HLmPCmzxgP/0XguZxeRKAZTsrh
KEiq22SJMzz3TtNz0OqvOVJWep4m5GFn4IuQFMr3V7L5yk4wfZF6aPflnHC9TzkA
XlWaS4jvjojV5+FkcUvJKx9IM4ZzcRCDGyLGffgngkwNwgORKey9RE+01SOz6ae0
OkERyseSiYZ4Q+ckd7ZcCsmvEOK+i3JkddOqEHtevRPaaevFYKyir7oBFHsSZTzO
Xvii7a/K9iIuj4Ex4RfK5g/oKtGIyChKhhRGDRSocpr6yMH/6Fhdumx4n3SDZdE/
Nbq9Dwjabk3KeZdByHcF2oMAjzYgUTemSbm7bgvyxpsOxReDylewNzuOMw5b27M1
VlFi1Rqu7SntRpqjV46DdWBi3AIAtDqsvZ+Z5wRzyncvmIriJPKXuOjHOlNua4Ab
qAKTHXN3zl1pvl1andzfVoBFuL6fM7+wR65M0d9XpPsRddLaM0t2Q+8IEqY6Vfq0
s3d4bhadvY4bJ6iHJcA40aDDwq3jIpukBEfipNKjOAzrkq7qKR7PEFDmqRk4iRoT
WmnKP4X9LsmYO97znragDFPzmvJrXq+hyh7BkkZuNm38gmWVt5YfDbRAMqpEB6qP
8OuOqtU/KItulB5U7XkRRQ2bTNUqxFW6aV/TqIAyd/z9xKX/2YqKpmSxqK3myjNd
RtiuTk1EKATLOnUlQ+WMj7RRCiS7
=XpiJ
-----END PGP SIGNATURE-----
--=-=-=--
