Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D4230EDD7
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbhBDHzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbhBDHzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 02:55:21 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE200C0613ED
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 23:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1612425279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6LFSJ7hPs/+x69XDL8Dkhthryw46ar40UZkpUsbgM+4=;
        b=QCc2ezau4Tpj9OFt10cQvGE5LhZwJ9BKxQYJMXMGRqOl610Aq1Wtm6tz1j0LU2iDNUZpbI
        eZFYggzcHBdghNp3+tnjBG1r5qGLH9Dk72rAYDbVIXlhdqI7LQCqKPl7ZUZ0ijEYh91VMv
        XNaQOCiZDnYP4pKoQd3jIv32OZ1sMxM=
From:   Sven Eckelmann <sven@narfation.org>
To:     Simon Wunderlich <sw@simonwunderlich.de>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 2/4] batman-adv: Update copyright years for 2021
Date:   Thu, 04 Feb 2021 08:54:33 +0100
Message-ID: <3636307.aAJz7UTs6F@ripper>
In-Reply-To: <20210203163506.4b4dbff0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210202174037.7081-1-sw@simonwunderlich.de> <20210202174037.7081-3-sw@simonwunderlich.de> <20210203163506.4b4dbff0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2733018.9YGKfJurXy"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2733018.9YGKfJurXy
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: Simon Wunderlich <sw@simonwunderlich.de>, Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 2/4] batman-adv: Update copyright years for 2021
Date: Thu, 04 Feb 2021 08:54:33 +0100
Message-ID: <3636307.aAJz7UTs6F@ripper>
In-Reply-To: <20210203163506.4b4dbff0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210202174037.7081-1-sw@simonwunderlich.de> <20210202174037.7081-3-sw@simonwunderlich.de> <20210203163506.4b4dbff0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>

On Thursday, 4 February 2021 01:35:06 CET Jakub Kicinski wrote:
[...]
> Is this how copyright works? I'm not a layer, but I thought it was
> supposed to reflect changes done to given file in a given year.

<irony>Because we all know that the first thing a person is doing when 
submitting a change is to update the copyright year.</irony>

So we have either the option to:

* not update it at all (as in many kernel sources)
* don't have it listed explicitly (as seen in other kernel sources)
* update it once a year

I personally like to have a simple solution so I don't have to deal with this 
kind of details while doing interesting things. The current "solution"
was to handle the copyright notices year for the whole project as one entity - 
once per year and then ignore it for the rest of the year.

And I would also prefer not to start a discussion about the differences 
between the inalienable German Urheberrecht, pre 1989 anglo-american 
copyright, post 1989 anglo american copyright and other copyright like laws.

Kind regards,
	Sven


--nextPart2733018.9YGKfJurXy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmAbqDkACgkQXYcKB8Em
e0Yzhg/8C3UCwdVrki9UaPjFtfuSZz3l3/9o473xkvDgc0BvE+bHsPz+St2Zwdb9
pCSrGYfk+3iGJMxUXruIQikS+khBDfDk14r+vgLzDfCSZbIsFlPU0B84VbVdmkVL
KpIf8fmBKzQ7JXNnzT3xYt99Tp0lTHAK/yMvNI7uLWTzzcOkA6uM7i1Ci4d/i4dB
z1zzcfkmMYHS4/Oq2RGCrTT0tchZgaL7mHUBUaxUnXQOJLseqvgwr+x8woPZvnN/
EAXMJlmpmNmHVIGroQWkxmqSsTOsXSol7IhjA6n1yl5XrPnM8jLl5IAV32nBtkzb
5DmcBvfbycwnCNFGJN5Me07B+n86K1XO3lud9xDEj/5JHByhs+fmkxjGR/b0yhzL
yHdvJtecth3PoKvYcIOtp0TGQmsuh3R1N6rqUdKra0TP9DF+xS8N9sRZvKWmc6CI
HcdSrd9p7NQ0DNb/uq520w8lyhIsKN+iNbT5IWnUWecrGKSFcj/LIqRj9gYSISmI
5cNTIBzNKfyzGWbDsk0RUwHUGePxhMqslcsLmhN2seWzaG8au/y7DMI7qEkI+Kxd
Zrdj53Ko7w42AQ+8BoyfVbtnyKoOksyZAQKjomgqCwHdUlFJgxfmbgf1xlQNoEkl
Fr8Mn6qHDUlhUS1ZffrDWJ5w8fNBcG7dBvAoMl9qv7i2X9TJXro=
=Xh1S
-----END PGP SIGNATURE-----

--nextPart2733018.9YGKfJurXy--



