Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924C6282A52
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 13:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgJDLAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 07:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDLAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 07:00:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98842C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 04:00:31 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601809227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oa0/8JuNQcAFuQjAuc3NrQ3B/JNMC/05QMGeEVWQaPg=;
        b=tbRJsRzn+zQpz4NLi7pR3LFjNKQzAcPR3TWWwITRpJfZu6VqZEq9Xm7SwYwFblbS31WLUf
        Ly+zc1kmdlat4JwNabYF2PyJSBRcF+1ixIeUOPOFuKVHDKHOkwVonQj+1tqH+/VMTrmBpG
        ARm+OUg9pq3ZUK5xQY+5NQTrH8SS1lmswv/mF3alcRieFkiYkhow2kKNyU5SQFQ9HuWHsE
        MWAe+hRUxX1AD9tkC+dhHGcO6Mvu+XYvkq+lonOXJ5a+jzvGAXSeYcomSADSRcidlvZosQ
        UIqKC1uIhwKbKH9mVgTlV0jR29H85bhBxLR9EHI+NG/tTrl8JwLDNbRx2d4qhQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601809227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oa0/8JuNQcAFuQjAuc3NrQ3B/JNMC/05QMGeEVWQaPg=;
        b=TeOviVDwgPu2C0ZczYqzQowrtq7mgbYRZVk7ftlFbXR8BybkYxEyCmZyNULZ1H2/PloI3y
        g1zBIVtp7syLm/Bg==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] dt-bindings: net: dsa: b53: Fix full duplex in example
In-Reply-To: <e62b8072-ab7a-ce6d-1ac1-7fcb1b28081d@gmail.com>
References: <20201003093051.7242-1-kurt@linutronix.de> <20201003093051.7242-2-kurt@linutronix.de> <e62b8072-ab7a-ce6d-1ac1-7fcb1b28081d@gmail.com>
Date:   Sun, 04 Oct 2020 13:00:16 +0200
Message-ID: <87y2kmmf27.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat Oct 03 2020, Florian Fainelli wrote:
> On 10/3/2020 2:30 AM, Kurt Kanzenbach wrote:
>> There is no such property as duplex-full. It's called full-duplex. Leadi=
ng to
>> reduced speed when using the example as base for a real device tree.
>
> Doh, thanks for correcting this. Would you want to make this a YAML=20
> binding at some point? I can take care of it if you do not have time to=20
> do it.

Actually I have started to convert the DSA bindings to YAML, but ran out
of time very quickly. Unfortunately the b53 wasn't one of them I've
converted already. So, you can go ahead.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl95q0AACgkQeSpbgcuY
8Kak9g/8CHlclLB7I+w8cVjxgncyU5cEAd2sQXXIzt7SWo1f5WsN/MOPGdBvc/A8
L2wJcowegVhp/SDTOsxlzups7+ezqUZ8Vls6A3xbF4Jh2ePKwt06L+o6Giw4D0xs
/9BaymHg43KwUE7iOPN6pKZRmZGLcRvqpUHYt8ixVowOLofC5lZrYDr77s3eWWN4
x0ntfIbpP/jgpBTxntMzMSqzQcCJOXU2XZbRKSeux6XCP0jaT8RstluWDuxTlzF5
4sxKeYHoZh63hHP+t1RtYm6k6nFC/+a/sO4gix2cY6LWKsPTGCNe/0ss9lTXTtpa
vPWPvMBdtc8sojRTU1qLeB1YSoVBzb2YhgWJ5RlVe2JeK1LoOOPsgjvjG4gTByIN
iJuVPMV9tXQ7PierjqwsZDtO9A/ew5zKVXPogtCSDKVS3xjfaxKe8mXhRzJoj3R7
HHp5/Ih6ErdO4EugPlQVSjhckmVQpLNTVzIEZ3XpGjRjvMaMkBdsgoFg5q/iYyH4
6lVCRKSjhMf92DZgw+K/MQRUBIWqKBarEuJDu5wGyW3veps5NCNDHth1tdWMa32x
oaULwIfHb/m3m5gw56Yqmi2SMK0Yt35YE3L0GFuptfgkhp7xPtJHWzUhol4vOaRT
6iFpdrqIzCFFCP+Wt05h9jdf+lGIo4WzJQIMujAhSNvEbv0a+xQ=
=fBNU
-----END PGP SIGNATURE-----
--=-=-=--
