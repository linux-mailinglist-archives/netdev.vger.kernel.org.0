Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3353E39D468
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 07:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhFGFmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 01:42:33 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38738 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGFmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 01:42:32 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1623044441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N8pZyvVPY3mTqdiHnrawXSAP16GfcMKyLKlLPorBcyM=;
        b=VWVk9auWYUUblbqAiku3lU7S2D7SoBjTjX0+wz/PV8VWMX5D1wqvZEqq4wPViFCkhOYtIA
        2tKT39CPO4imb6icfau2rmji2W2sb1XUMOHJTMalOaG2Z/AmEqD2X1hk/7Lix+4JvfCOKR
        LB+dfQfXEABdZOoI079v/xvUAZ2LYnJGA6K2ZYBP7uVEb8kc1iFPoQeBMhx7JhyxObC3gv
        ZJhsrYkJLjJmmD8W3oTM7o5y5UczdZNnEvaCe6+KvzVUIXJDIlL4BPZZVCKHI62MrhvwRw
        nqMWlQnB+smj4SW+a9uoIrvIzvBg8uzU5JbsKxI+KMZ0ImNyRKo3v45yr5V8yA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1623044441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N8pZyvVPY3mTqdiHnrawXSAP16GfcMKyLKlLPorBcyM=;
        b=27OooEwpKRFUH0CqARL6b4kp1qH6imbRKAjr4o7GDxcNLuZFbiStIZYeFRsLSYnlYhuDH+
        wt8I3YzzIXkDjzAQ==
To:     Zou Wei <zou_wei@huawei.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zou Wei <zou_wei@huawei.com>
Subject: Re: [PATCH -next] net: dsa: hellcreek: Use is_zero_ether_addr()
 instead of memcmp()
In-Reply-To: <1623034629-30384-1-git-send-email-zou_wei@huawei.com>
References: <1623034629-30384-1-git-send-email-zou_wei@huawei.com>
Date:   Mon, 07 Jun 2021 07:40:38 +0200
Message-ID: <87bl8iw7u1.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Jun 07 2021, Zou Wei wrote:
> Using is_zero_ether_addr() instead of directly use
> memcmp() to determine if the ethernet address is all
> zeros.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmC9sVYTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpusLD/91k5rEkgzPyZsn4CA9Cl8L9Hwg3jGK
h6vl+yZmgO/vDH+tz6vbwhXd4q6WjzYqVYQ8gbam1PFDLwHtlza2TvSffWcRwiLm
vicFGPawWipe4s8YD+V8dzqvnrH7ko1Oz3u3SPQjCaSbCTD6pIcT1OWET7ogN7je
A+xhTF4BJdbx9iAAdYH+fClR9ZTC631DqaX3tKaCrGQIISMBAeUNMq/uTSqxrY6j
ovr1qdGHv3bQxBnbt/ZQ4F5pmFTafNB5Kh7jPM/8Egg2GJGdmlgTq8fhRZs03Rjx
Boa6Sl9XGcjI9CtlyDPzBXz/Sv2gl6wb8amiMH0+jSFApJCC8jqn9uu83brq2Hv6
gXoK2c1M7/A57o5cVzY8SkmufWm//JCrBswQuF6sWKp+X+o1IHGJgqZYYtOF2TLk
Wlr1nD6alfG+N/OV65lPvYYazG8H5BnqbBd/q6dCfu6HoUoE8+/P17fjtpgp6RF4
zKLkIm2dI5tt74q2Vs3v4FRJPnfaJgEGvA17XD7tJGFVAp4y9O427nQVLxEiDHLm
ygL2sKDffh70Ze6COiUyS9RyRf9W6lhNE7BBaqx3ChDwVSLKRdjoAGg4zKCf4kAr
75XlPcLFYpkePtMwwbBC+7+Hj1JMPpgBvM22Q8oqitS3gmsyfeiLbbWSs8ZWJaU5
/cbVSTcd/T1NCQ==
=d84z
-----END PGP SIGNATURE-----
--=-=-=--
