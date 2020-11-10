Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C842AD812
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 14:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbgKJNyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 08:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgKJNyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 08:54:19 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A28AC0613CF;
        Tue, 10 Nov 2020 05:54:19 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605016457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rtk59NKVDDuDgZ5JurBrBN+PO3AoA1MD7trsIrojCXM=;
        b=u5x4PEMEPLyzGgIGWlI9++dwF7XL48DcFoZKF1RJVJE0uOAhv9DPebvOE13aviGreZDDw4
        wW+dl4gl7Vfsy8ww9xrbXde22R4gYOHm1R3wK8hl1L+R1hKWB9zh/WEHfEhqBjHyQ5sEac
        rnaPEXrawz5CaMUqVK/nihwf0qCF28QwSCDoMa2hpSRe7L66e7+igsbhRpZjTGEtWTQG/K
        Nye74SsQemNNHRoUKzUIR1Ml+rB2/f3bW2WsDjkqK3ouK8mbheqfOOfr6xmTZE7GrJdQiJ
        Ssfc/9KbKy+um81khhFcmzHb0tgfyDNtbN/ubPqOGbgmU/8S/YDXfY+GYWhchA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605016457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rtk59NKVDDuDgZ5JurBrBN+PO3AoA1MD7trsIrojCXM=;
        b=NorZWwvAN6+BKC2Dx3Z+pXndKaMRqzvk+ooNaCrO0FkP0XFkewtx7lVOk66BJjLDfUKYRy
        Gn47K37CDgYxiVDQ==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] MAINTAINERS: Add entry for Hirschmann Hellcreek Switch Driver
In-Reply-To: <20201110130059.emgojxcyu5j3lc73@skbuf>
References: <20201110071829.7467-1-kurt@linutronix.de> <20201110130059.emgojxcyu5j3lc73@skbuf>
Date:   Tue, 10 Nov 2020 14:54:16 +0100
Message-ID: <87y2j971x3.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue Nov 10 2020, Vladimir Oltean wrote:
> On Tue, Nov 10, 2020 at 08:18:29AM +0100, Kurt Kanzenbach wrote:
>> Add myself to cover the Hirschmann Hellcreek TSN Ethernet Switch Driver.
>>=20
>> Suggested-by: Andrew Lunn <andrew@lunn.ch>
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>>  MAINTAINERS | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>=20
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 2a0fde12b650..7fe936fc7e76 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -7897,6 +7897,15 @@ F:	include/linux/hippidevice.h
>>  F:	include/uapi/linux/if_hippi.h
>>  F:	net/802/hippi.c
>>=20=20
>> +HIRSCHMANN HELLCREEK ETHERNET SWITCH DRIVER
>> +M:	Kurt Kanzenbach <kurt@linutronix.de>
>> +L:	netdev@vger.kernel.org
>> +S:	Maintained
>
> Just want to make sure you're aware of the difference:
>
> 	   Supported:	Someone is actually paid to look after this.
> 	   Maintained:	Someone actually looks after it.

Yea, that's fine.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+qm4gACgkQeSpbgcuY
8KbeJBAAv7JR/VLVT0QFPAQMoiBHYJgILlBlP/dAKxqZXs2DMFOWtyDYDoJgOZRJ
gYcZAacfowxB5+4ulJDjozS2+gd1s4A+8Wx7SbpfsNujOm7cWp5czVV3cOYgDUI+
YltvJ0c5ST1ZOgHtnA04ARVxOKfQIaVAF8cCegqJOt7ydx/goUH2AzVP6d++brDS
VrmVhLwkmOyOUpFPBHbZGhI2qOmtRiKLAj+KMWQzUmpNCKWHuUf0fYBLQYjXxQ8d
lqGWUslD06KJ6namBepgDxdtXf9pHx1mHANa1DgZ8XgmeLpmz+JKDWCkfszOTGQ7
oBSyHXwmRQ1TBNlWltSphNQUj0trYONBXz3lRnxWlLCgyuXLKtb3PelOywVSFtuj
JE98TeOsdEo8PkhqpV7Q8DooIOhJIXfvJxrlT3lo2n33Bb0RNOa3NXcEpBI6CQSD
+ORVbp619sWBET1+Opbnk8kwaUBHxMOncHhwOkY9gKJSuVSv4Xb3weTDEoxd3x6t
gZHgJGWzvyHw/gESCWrQA/xBm/AGTPzfHaMInk99WrOw3tKKwpewGATz/z1J59nO
zkqG7tuVwzsWz7Tv6ayIPOcjSD1xfGsSLAVMwLj65A6Oio81wAHIOXwps2bC7J9f
YOqqAXiucVqxz4btr5rmAphU18/4wavAXJ3PlsRIqMG8uNkl/Gc=
=uiu+
-----END PGP SIGNATURE-----
--=-=-=--
