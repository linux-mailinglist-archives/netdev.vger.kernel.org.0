Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B322B284CBD
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFN4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:56:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36764 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFN4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:56:34 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601992592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D6JiyNcrQkcT6CBbQIFCex9g10YVQmJvQSZBj/y05/Q=;
        b=N9H39h/BK+/ZFnTQjwNOreVwTgshQ1tMEt8UCHbvPyn8dpB7qCZwk85eFDvu5Lk4PHe/PD
        33/h54y+Rab1kS/uyGSGDq6Kt9JV43jZrYDhj1NSOqDUcfq1KBm5jvxLk4JnasZSIXxh2i
        Q35NfWOUsrdNaXxHmoP9nTI/DUUpmetKjsEXyEePUvQNOxwzkvHrmxoCuLxJvF3wb+jiGI
        QTCAIF3th0KZu9HfxYg+XMauu9L7jpLLrHa8PT6FtDdEwxMBOnNIo5dw+mdeAOYVT39iKF
        9epHBHSsJ/gVYXA8wVT1ppI3GZru8nMfgQQeHSrMyyCdEo2ByimVkMu4GI4lbw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601992592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D6JiyNcrQkcT6CBbQIFCex9g10YVQmJvQSZBj/y05/Q=;
        b=+lJ9KnVPj/zrrNZv/6JGWI95zyo69GxS3lkZVyFnpJPagdKztLMbzpzt6QFGtRfPyhTrFm
        6uERR5LPcbfvpqCQ==
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
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for hardware timestamping
In-Reply-To: <20201006133222.74w3r2jwwhq5uop5@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-5-kurt@linutronix.de> <20201004143000.blb3uxq3kwr6zp3z@skbuf> <87imbn98dd.fsf@kurt> <20201006072847.pjygwwtgq72ghsiq@skbuf> <87tuv77a83.fsf@kurt> <20201006133222.74w3r2jwwhq5uop5@skbuf>
Date:   Tue, 06 Oct 2020 15:56:31 +0200
Message-ID: <87r1qb790w.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Oct 06 2020, Vladimir Oltean wrote:
> On Tue, Oct 06, 2020 at 03:30:36PM +0200, Kurt Kanzenbach wrote:
>> That's the point. The user (or anybody else) cannot disable hardware
>> stamping, because it is always performed. So, why should it be allowed
>> to disable it even when it cannot be disabled?
>
> Because your driver's user can attach a PTP PHY to your switch port, and
> the network stack doesn't support multiple TX timestamps attached to the
> same skb. They'll want the TX timestamp from the PHY and not from your
> switch.

Yeah, sure. That use case makes sense. What's the problem exactly?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl98d48ACgkQeSpbgcuY
8Kb9jBAAiDNxsq4ctbpcEfanGcxuXOqN4hEONdCLtupm9T3ZFrOFzIkgWcxf+3Ow
76LaTd0P/E+ggeehhnwgh+Ee1C0970t7WOKE1sTn/i4vUZjjwX7IFRoShV2VIusL
5HJ5/S3pQZ3bRV8NvQ6JQebQwn2jFtAcWf0KswdJoM5Ejv1HsGR5kCUcxzxW0C5k
brewofOAI7WUTJE6cQEjxm/3TPa0flMRjp5h4uDdnASe18nnGQmZ9j29fzMQb3jf
2VBL7XoXzH3tIuUb2hFx/SHvy+nOudMxdZrd9S5z+HiVJbLZQeXQfJsh+xeNaI93
OxmmuUT2AD2dwZ0SuWADUcLWXi0l/22efUqpea4uZpUVKqncF9mtPHNc06Ayp1mr
12QZrI7F/FznCy0mXp7+Pw6ihFSZYTFwAR4W1vgJQBEo8ZmReqxBPUOvQWJJkVxz
vyFDgyYWigWBz0QykTl5rRYgDZiZEpDXEXgCitxwoRFoLT37FuN3jNXstNHpMsRJ
EJK9HZyyeDIg3ahjR7jTiKbDOfRntApUEK7rRpKvqcAgk9Z79i9PthHDnxR2gQc2
3cgOplkBadZoNnzy/M99K+hdTdj0fGHgeJZezdFOTAIce36Cp47eGPSJJzdWbcHM
SVv/TkcoC7G2xD09lJslr6sIwZA8hvhc8tNIzEFoDFSXXaW/7+g=
=sCyZ
-----END PGP SIGNATURE-----
--=-=-=--
