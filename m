Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00C128ADCA
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 07:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgJLFiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 01:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgJLFiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 01:38:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21B2C0613CE;
        Sun, 11 Oct 2020 22:38:09 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602481088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WLEceUZkq4DyJTbDblgRq1oLbfxs2FunDxKz231d6Y8=;
        b=oT0fTymk9iUgvzfIVOpfdDugST9Xh1Y7vdZbAT8HFt+fkK5R4ki7pv3uUFGjLG7oo7JVKF
        Co3J5mFfJ4wfFBWcdR14fEMYPqPGmkp1WfOEeegdtv/4EA8UGvjYKJqUX7opWC4qv9BPhh
        FjzSts5hiSdGRVsAdSTHtsX2o7SHe7O169aIo7CbAdprqCwDCo3xrCq8sXwIpVb5dUj0nm
        TQJHd99Hd6NNQcUSTIx0EMOciXX862S1f3BBGDK0DnBplr5RUErK4IwM8z3JOxC4pGMJbQ
        RHvCKxBf83iAhX59xfphVeNrASjPpW/rJQ3TF02U6huucNVGy8WbV5P7ZG9U4A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602481088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WLEceUZkq4DyJTbDblgRq1oLbfxs2FunDxKz231d6Y8=;
        b=RMCXHF6R2oE3BQsPGdNALD963gsBrbvRVmrShvVIIpWHxtTJAZ3Nisrah/T1kgX0J/jpys
        XK8aCKONys6YtqAA==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20201011153055.gottyzqv4hv3qaxv@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-3-kurt@linutronix.de> <20201004125601.aceiu4hdhrawea5z@skbuf> <87lfgj997g.fsf@kurt> <20201006092017.znfuwvye25vsu4z7@skbuf> <878scj8xxr.fsf@kurt> <20201006113237.73rzvw34anilqh4d@skbuf> <87wo037ajr.fsf@kurt> <20201006135631.73rm3gka7r7krwca@skbuf> <87362lt08b.fsf@kurt> <20201011153055.gottyzqv4hv3qaxv@skbuf>
Date:   Mon, 12 Oct 2020 07:37:53 +0200
Message-ID: <87r1q4f1hq.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sun Oct 11 2020, Vladimir Oltean wrote:
> On Sun, Oct 11, 2020 at 02:29:08PM +0200, Kurt Kanzenbach wrote:
>> On Tue Oct 06 2020, Vladimir Oltean wrote:
>> > It would be interesting to see if you could simply turn off VLAN
>> > awareness in standalone mode, and still use unique pvids per port.
>>
>> That doesn't work, just tested. When VLAN awareness is disabled,
>> everything is switched regardless of VLAN tags and table.
>
> That's strange, do you happen to know where things are going wrong?

No I don't. I'll clarify with the hardware engineer.

> I would expect:
> - port VLAN awareness is disabled, so any packet is classified to the
>   port-based VLAN
> - the port-based VLAN is a private VLAN whose membership includes only
>   that port, plus the CPU port
> - the switch does not forward packets towards a port that is not member
>   of the packets' classified VLAN

Me, too.

> When VLAN awareness is disabled, are you able to cause packet drops by
> deleting the pvid of the ingress port? Therefore, can you confirm that
> lan1 is not a member of lan0's pvid, but the switch still forwards the
> packets to it?

Will test.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+D67EACgkQeSpbgcuY
8KYI/g/9GFaeZzkhfnDmitgCUqIkmy24C6c25fQxMLBwtSvtPd2Me1PPKG2CVGQ6
7cKD1eM6A36awKtjkF5QnpobTglwhrZlQuBMt6cC6d2nAjkDNcdkU0nLfJEmkI8Y
fzC+ZrvNiBMwe6OBYpVW0lhX7cxzy9Zt4vTPUGBAQAkBqRtSlo4QSUGGZgKdaQB6
MeBDbFq61aJE4akBKt1V5XtYH/bQU2ooHqoKDPVMb2QcAo8eEADSTKmzkgH1x8it
ZL8CJMN+Dgv8Vr6cblRIUJmHtSGek06HMgh1gdaj1tjvXMApProtc2HpjZ5ckbuV
/i+q6ZOEayGxiosP0TYjqJ7W4JAmai7Ywkhkn1He7G+F31eL2RtF5mfVsYYFj5Ci
Pyhqw1JDDi9eEQrl8IfeWcvJ5IjvPJhvd5TIBYIbYxpOIAZIc/Sy4ffpvzdGFQFh
kZDCyguVJMzduFjmCrnUKK3wD76vEpWgRSpDTOgC2VG/JWHb70EkYwnrsNt8SH9W
CSQ8mBZeCenCO6zUKCHK9JnkUq4Yoj3O1JiGJtZEwPidtqqD7EYkPEIhhVoagmTQ
37mVZmdzYM3o1rYkZchqss8Ohwz0IUr8+8hv7f4dH+84W+CF/5PeH+QwTzLih1mq
WhTmwfLBgneArljWCqJCowXp+hQYEpnBpiBJDDWn0PdI5vQVJO0=
=7bdk
-----END PGP SIGNATURE-----
--=-=-=--
