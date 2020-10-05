Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7285228304B
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 08:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgJEGOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 02:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgJEGOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 02:14:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ADDC0613CE;
        Sun,  4 Oct 2020 23:14:32 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601878470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vMU4E8sDuXXKfLR81j2vp/9okWJ1wi2vlEdx+O5fKXw=;
        b=45xAOsHg3KUy8lU8CnAwoaagLxZeIWtAUCBsIBZGpyasUgIN1FyEM6xCMsUOEp3cqAyRpe
        GZfjkInMJjxzquXCMFdKQo2VwD1DG5s/iwLrx3h7UnG3q9NlvawlguUhnkGkxo6VKwEuMK
        xaxs8KjdF0/adgXnyeyGhCXr7amKRTLl3UfDBwjo4CqdlnXeZMCdd5CiVutuXYrDqpO5OF
        rjBv5pc8UOQyM9pu+U0Y1GQlRBnEDW9H/Lq/7hbDPUpfefGwx9ywJPWhJzaZzpy9E0FE1E
        wQRfdptDxX6VV9yYs7aALOtZ7CxksSvPtVGk0HkUA4isv1X7RUH96FiWHj+hhQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601878470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vMU4E8sDuXXKfLR81j2vp/9okWJ1wi2vlEdx+O5fKXw=;
        b=mZ2LdqX7hF0Q/YlR0Ujdc2OYgJV8TAJYC5R+NQ4q0JKEKzkhGg6N+jVZRF4e2h6bxJfE1p
        uwASjFJRGrQLFPBw==
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
Subject: Re: [PATCH net-next v6 1/7] net: dsa: Add tag handling for Hirschmann Hellcreek switches
In-Reply-To: <20201004115649.i5w7r4djxwpnjx5w@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-2-kurt@linutronix.de> <20201004115649.i5w7r4djxwpnjx5w@skbuf>
Date:   Mon, 05 Oct 2020 08:14:29 +0200
Message-ID: <87imbptd16.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sun Oct 04 2020, Vladimir Oltean wrote:
> On Sun, Oct 04, 2020 at 01:29:05PM +0200, Kurt Kanzenbach wrote:
>> +static const struct dsa_device_ops hellcreek_netdev_ops = {
>> +	.name	  = "hellcreek",
>> +	.proto	  = DSA_TAG_PROTO_HELLCREEK,
>> +	.xmit	  = hellcreek_xmit,
>> +	.rcv	  = hellcreek_rcv,
>> +	.overhead = HELLCREEK_TAG_LEN,
>
> After the changes in "Generic adjustment for flow dissector in DSA":
> https://patchwork.ozlabs.org/project/netdev/list/?series=204347&state=*
> you might want to set ".tail_tag = true" (see patch 07/15), either now
> or later.
>
> Either way,
>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Added it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl96ucUACgkQeSpbgcuY
8KZ8Bw//VvZLSyPAK4qKR/nhN4LVdAQgw72bbKlVEVj4GDU3b0hxKwsDtiy66kqX
IrdJ2FzUHAl3o1Uc5T5kX6zIasRA0V7lrLl+37uGDXJ3UX4e4fq8B72/GcQDXpeZ
XEJskgr5x8X8ixV+kTBp4u3reQDgZqBlCHGzpuhQdHyajkLCPVQvLoTiF8BgX7ps
MdSYnscoAjebdjPsr6pFQ1/nJGTt/EcHZ3f60uvv7Em4pt1DMiD0nmd1B/5sLWSb
3aRpFjM4xdemC73XQ4wve2B+rIuGevui7Du57h2eEgGOQeUiproZt8sV/+GW7a+z
QVTEAur2UjzwvACrlJh0shw9PY5tdQDlnt36bxfyP1+JFpZqK/TL0u2WD+o/y9LT
Sw0cpfIJyLYnyqaiwjaeqgtwulGLHXIezKDsUdCCkBydzBIdBMuoPklsDZgVn+of
ZwjV4PK/hgDGp4i8l7YrlN02fuVRJgtplZO3DDP8KhyJq8Bgm9oZf0yJghIWm4Ui
CFv3xhleQ7n3FfcJT4MQgZtqYlMypnldzh11sxO+iiShv1ppEy9bYeYhPnfVho2W
WZs4iKN7RwuolA4sfVQcrxeCdRTT2Hn3n72q6HMpaW6vd9dfmSTg0WSVHnoZHkUH
zCFfjfrS5xNS2lQBcuQfX4U+sI6DCTJ7YpL5qkKZTJXhVaYEdtw=
=G5b8
-----END PGP SIGNATURE-----
--=-=-=--
