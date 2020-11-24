Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663692C1F3F
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 09:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgKXIAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 03:00:10 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41482 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729968AbgKXIAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 03:00:07 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606204805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OhwY0QXiIXW2Xr1ysp2Ryo8IDYhMVVP6Az0a2joxhDs=;
        b=pJsGBGMkuEN4QOiQRuMV4H3Z5XSs5veA7eIpOXeQkRQwsp47qO9p2r8SthswtNKdulLNpZ
        BGy1ofO8tIqi5GxbzXu41nBz8x62JThZnb/QKgRqS71f7JU+NdJmq3vkIiICa96ngY8cfq
        yERHxQttCgFMdKZJ+GF5c0/hsDunssnyajIrICfi5QytlOpPbBPKH0hx3y1uYxeXI1E1jA
        5qKCaSI0nYVTH4bAOPeGGrteyPukX0p50EKCTok+m7vbG3f+C/TEDHQusj44g8PSJRR5ek
        l7bgQNuwzmJt1qFl3H/sfM56chiLTqKrViL3Iw8Ikoj3pUCkIH91voSZSf1HAA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606204805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OhwY0QXiIXW2Xr1ysp2Ryo8IDYhMVVP6Az0a2joxhDs=;
        b=ju2nCPq/Qwp4zdXQJ+XybY9lxgthDgw4dfe/sHYJEp/GtXvyPJxEnqye8aMHa36opYZuFu
        0uTT+i3lvh0AmQCA==
To:     Christian Eggers <ceggers@arri.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christian Eggers <ceggers@arri.de>
Subject: Re: [PATCH net-next v2 1/3] net: phy: dp83640: use new PTP_MSGTYPE_SYNC define
In-Reply-To: <20201124074418.2609-2-ceggers@arri.de>
References: <20201124074418.2609-1-ceggers@arri.de> <20201124074418.2609-2-ceggers@arri.de>
Date:   Tue, 24 Nov 2020 09:00:02 +0100
Message-ID: <87wnybrxq5.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Nov 24 2020, Christian Eggers wrote:
> Replace use of magic number with recently introduced define.
>
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+8vYIACgkQeSpbgcuY
8KZnjRAAjg6MhtqwixZqSvtDIrTVUqUcMJIe1mYHawAyPcKL38YLNu+e8bxoOw3Y
LBsJPPor5hpn4IcsKQpX5LZ3Mk8v+Sa+aW9EUTBQFCzn55LXD4V3ehc4Y/fCv7Qe
4coL80bvE5KjsH26yL2nnx7iR72Oc0SkOKKlEE4kI4ExJHvUt70WSlJm//0GKGCP
nOxP3SUm6y7X1w/ULhZ39tRI1GJ4n4u2rpwXG7bXynhJCzP3Sq3U4w5h7Vph30KR
mcbNjBbKMPw0Wx2dj6QAlI/CsSCQFB/LWdnAw6EX9ZMoSBGBils9XwS9iVRv91Fc
zoLroeeHLjnyLISlDyuZX69e1tCDFoE246rtZA2/mdpIq9STota4CWLUwwMDFusT
92kwq2j87XKNgkqVLsUw1HPuzxUzANbcjUv2vus2xEW/tlmafjijTjNC6Kw80X2J
l2Ux3GKwkI3ZClT0LjNXk97lWle7dR2DlKoMYVtRdG+DnsdfI0uqdQNfGg+/JzOb
8+kSOH5FO+fOgtD72gejVjVDQwJf+bXVLZ6kXVSb41KpCHvG9XFPQF+gwFcUfhhI
bQvYirCsNW/T/CZeqCp0lzvvsqwBPbXE1hpYm1rc6Z6Tw7LgeURg+zgWn4hLllim
2LsQQPzo6f8Y4x+WK85U+h3oqbMgfEsmLQ70R+ZnG0mxs2DyCS8=
=P6d7
-----END PGP SIGNATURE-----
--=-=-=--
