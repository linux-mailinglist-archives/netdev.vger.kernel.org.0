Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFC345086C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbhKOPeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:34:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236719AbhKOPdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 10:33:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4278563212;
        Mon, 15 Nov 2021 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636990242;
        bh=8XoL+Ikkp+UiQCwAF2fR0hsh2hPoC6nkuXKsFj8Ke6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c5IWYzAI9rmakPDUZ05vSErJ66cE+baCDmNjCJjdP3NNcWu2TuP1zZaGmckrFCtWp
         O414uhjrfq5BCTBteQ+Umuvnmmgqghifjjuw38X5AkS3Q+DjgDTAuhkwEFgmqG5HyN
         u8+rQsK4wvNU4o1iHmdhZJXQNpVtjRJT3SpjmKR3RlJ09ollWWuHqgpeOKILgyQ28o
         Biran/J4NwCPRXFZrmRY4sJh/3IEC/1kwljSmbtXD6C6QI3BP+jA59Kfr2G/Cmncvy
         zWT3/jfHK0NJJZ258EKDR3aOEMhuRrI7GLU7HTnyKeV64LV/0hsJmzKMoYHlrXjWqa
         CY4gfJ+wN3j3Q==
Date:   Mon, 15 Nov 2021 16:30:39 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>, zev@bewilderbeest.net,
        robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org,
        brendanhiggins@google.com, benh@kernel.crashing.org,
        joel@jms.id.au, andrew@aj.id.au, avifishman70@gmail.com,
        tmaimon77@gmail.com, tali.perry1@gmail.com, venture@google.com,
        yuenn@google.com, benjaminfair@google.com, jk@codeconstruct.com.au,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/6] MCTP I2C driver
Message-ID: <YZJ9H4eM/M7OXVN0@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        patchwork-bot+netdevbpf@kernel.org,
        Matt Johnston <matt@codeconstruct.com.au>, zev@bewilderbeest.net,
        robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org,
        brendanhiggins@google.com, benh@kernel.crashing.org, joel@jms.id.au,
        andrew@aj.id.au, avifishman70@gmail.com, tmaimon77@gmail.com,
        tali.perry1@gmail.com, venture@google.com, yuenn@google.com,
        benjaminfair@google.com, jk@codeconstruct.com.au,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
References: <20211115024926.205385-1-matt@codeconstruct.com.au>
 <163698601142.19991.3686735228078461111.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eRxy3H0oCy728e+K"
Content-Disposition: inline
In-Reply-To: <163698601142.19991.3686735228078461111.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eRxy3H0oCy728e+K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> This series was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:

NACK. Please revert. Besides the driver in net, it modifies the I2C core
code. This has not been acked by the I2C maintainer (in this case me).
So, please don't pull this in via the net tree. The question raised here
(extending SMBus calls to 255 byte) is complicated because we need ABI
backwards compatibility.


--eRxy3H0oCy728e+K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmGSfR8ACgkQFA3kzBSg
KbacqBAAqZ84qtLwwyREg6zMlaeQlM8gdgS9bKi7XXf5hsQ8ATVnHVQ5dqNP6WyQ
6NOw7zA22nsqzyKXHpm4WxewPz0E3QD4iNyrBaVKse3qIXJS16+ANcfmxOrm0GhL
pEllnhDer81kJwXVBUrC3fzatGcM2thiWiIba3VSdP2O+cemdetu6seNFo4VTgXx
lv1DDdgjqbhT+oHxntSvxkQt2cJeY4b+9CrRhV5o5N3MKnwOp8mZa4fzt5fZHn2k
c47X3oB8QebWHj5xjQxnL0Ms+ytqX+8L5fmzDazX+N0dHgvPmIdRA1R3xxZ5SfAJ
gIp5buJkirvRH+RWqLLN4I4aNlm2xlxU+kBcYT87/e553TWy/4tr7rdx/+SLYKpu
SFG0+X/Z12xLFmSCD8SBvQWbLml08n2Lc6tJOqrrXpopHDwaRyzNh+jrhT6octKL
HNhLTMtzPmjh8O70dWSLdQTGbXQcuT5qyPvuY0IwQ+tguZLVpM+t3lsBpt72RDrD
7mm8wl9C0af7PetM4zWX8HIGSVuwKm8aEIAqhIQ0ONi/IEHxou6Psz2A3E061yo8
xC3TUETj3WhWdBboByQ7q00NTWPEj5La6nSSb8Oi5Oc0PwpQfKFyfjrX8JrOgQVn
nycG6assjzWRunTH3CWbBBGfcVxTj837DmArmn3R1h92VduzHJE=
=SVLh
-----END PGP SIGNATURE-----

--eRxy3H0oCy728e+K--
