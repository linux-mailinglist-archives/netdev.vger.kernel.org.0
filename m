Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86F0640161
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 08:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbiLBH4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 02:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiLBH4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 02:56:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB75AA8C1;
        Thu,  1 Dec 2022 23:54:41 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669967678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+T43LVSZmWOQ1RF7ipKsKvZ1M5eHXZPvbPsZyHip/NA=;
        b=aCzpmoBkn+mB6yJjgdm+Utp80tXSMw7l4Y/4kjuWkXW5bEzUoZZsnHKskdBuz3q4QzQMKj
        om0OdY0z0Z/mKBDEY5tOYkJN1xcN1c0xTkvlFqEKpKnI5P2RY96niRTnn3BVA4/0bNZzo2
        VZY/1F7KIhH8hf9wciuQmf75JadiDTxsmy88s0GGI2Tzn3i7d1fKDnJQTBiFYcrHWxHsax
        nLWdCmvfRVP6wjgLrFPSP0SYNGdXvzP2RB48uBIQHc5FPYu8c3h8YH2ZKZwlMul9T7M6Y+
        gFo3L5KPCn3KyJ2hYNnjJfe7ExGxV88yZHuYIP5gzjGtE7ZqL5dC506oo0ARng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669967678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+T43LVSZmWOQ1RF7ipKsKvZ1M5eHXZPvbPsZyHip/NA=;
        b=odU2KTjHHfxOG21/bwHDYx98vXVW7BqdAs1zhEJ4aNjoOfWBMDzblZ0KHgvUvZmEoqQiRR
        u0y3rgEMkbd0VECQ==
To:     Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        artem.chernyshev@red-soft.ru, Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v3 2/3] net: dsa: hellcreek: Check return value
In-Reply-To: <20221201140032.26746-2-artem.chernyshev@red-soft.ru>
References: <20221201140032.26746-1-artem.chernyshev@red-soft.ru>
 <20221201140032.26746-2-artem.chernyshev@red-soft.ru>
Date:   Fri, 02 Dec 2022 08:54:36 +0100
Message-ID: <87h6yes0jn.fsf@kurt>
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

On Thu Dec 01 2022, Artem Chernyshev wrote:
> Return NULL if we got unexpected value from skb_trim_rcsum()=20
                                              ^ pskb_trim_rcsum()
> in hellcreek_rcv()

For the next time, a change log should rather explain *why* a change is
made instead of *what* the patch is doing.

Other than that,

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmOJrzwTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgiZeEACZycYo7R3gBb9NfgWODxFrrXOgR6jI
svJW/OaEEDv+xaFP8OetWRR08gqlDaynBMLJSKUxOnJR9cF6eSUp0KkGy4kKHO3g
iCLEyJpmh7zum3b9vjXS9TA9ePHiWxIvkWgm7PTBDBSVwztadIf4H7S3UU8I2Mac
Gzjc69V+beYJBoEBfwa7o9OoPI0VQ2yYqmDMJQ9q8oyQVgc1XRaHQEPYj+GOhHvv
flNMC/uzeh8u2Ld8Rw5pzGZ7AO0DXCDpRIKdbnlLcMNysVJeMc9VqwIb0ifh7+4s
HHJo0C8AzZ9LkNVvNFtFKnj+Ge16Dvnb+16aqv6SmJXFuj//0QbwtYBWaMC6nYXG
4zPRcI+m/LhvwcbEsjXzuKWdHPOodxt7bnOLDQZvJOcmwZiEtj0nL8kdIeq0L418
0wFiAg5TWudB6xDyhqg2hP4wwsQ1wv5MN0gGSOQQvBaff48HxZdakmdK8aqiprkB
MKRJHBMUE8v6NEy8H7rKWcGH3EmJrqJ926hwPC4vQgAbnZ1tVPuP+xWUJPROmwNQ
omf811iOtGwUK0jBDmDG7tpQtuVHOsNHFcL8pFRnzeJ4WUEFxH2g2U+rZxuMyR85
uGd6c7PX0v2hOlPg92p44iX8rMxsONbFgmKNfK5FeH9He5WQfbJI1D69EjIpqPbr
57InUdUSyyEhSg==
=z5S+
-----END PGP SIGNATURE-----
--=-=-=--
